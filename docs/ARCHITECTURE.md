# NovaWallet — Architecture & Decision Reference

> Read this before adding a file, picking a package, or touching the queue path.
> Every section answers a recurring decision so it doesn't get re-litigated mid-build.

---

## 1 — Structure: feature-first clean architecture

Each user-facing feature owns its full vertical stack. Cross-cutting infrastructure
lives in `core/`. Nothing imports across feature boundaries.

```
lib/
  src/
    core/
      network/
        fake_api_client.dart        # HTTP stub; enforces idempotency server-side
      utils/
        kobo_formatter.dart         # THE ONE kobo→naira function (see §4)
      queue/                        # shared by all features — offline queue infra
        data/
          datasources/queue_local_datasource.dart
          models/queue_item_model.dart
          repositories/queue_repository_impl.dart
        domain/
          entities/queue_item.dart
          entities/transaction_type.dart   # enum: send | saveContribution
          entities/queue_status.dart       # enum: pending | sending | confirmed | failed
          repositories/queue_repository.dart        # abstract
          usecases/enqueue_transaction_usecase.dart
          usecases/replay_queue_usecase.dart
        presentation/
          cubit/queue_cubit.dart
          cubit/queue_state.dart
        queue_injections.dart

    features/
      wallet_home/
        data/ domain/ presentation/
        wallet_home_injections.dart
      send_money/
        data/ domain/ presentation/
        send_money_injections.dart
      nova_save/
        data/ domain/ presentation/
        nova_save_injections.dart

    shared/
      widgets/
      theme/app_theme.dart
      router/app_router.dart              # GoRouter: /, /send, /nova-save

  app/view/app.dart
  bootstrap.dart
  l10n/arb/app_en.arb
```

---

## 2 — Dependency direction (the rule that keeps layers honest)

```
presentation  →  domain  ←  data
```

- Features import `core/queue/domain` interfaces — never `core/queue/data`.
- Data layer imports domain entities for mapping — never the reverse.
- Presentation never instantiates repository implementations directly.

Violation = wrong direction. Move the import, don't work around it.

---

## 3 — Offline queue: state machine & exactly-once guarantee

### State machine
```
pending → sending → confirmed
                 ↘ failed → (bounded exponential backoff) → sending
```

`QueueCubit` owns every transition. Feature cubits enqueue via their use case;
they never call `FakeApiClient` directly.

### Exactly-once (two layers — both required)

**Layer 1 — server-side idempotency:**
`FakeApiClient` keys on `idempotencyKey`. A duplicate key returns "already processed"
without a second write. This is the NIP-rail pattern.

**Layer 2 — boot reconciliation:**
On cold start, `ReplayQueueUseCase` reconciles every `sending` item with the fake
backend via its key *before* resubmitting. Prevents the kill-mid-flight double-send:
app killed after backend accepts → restarts → naive retry would double-send without this.

**Idempotency key lifecycle:**
One UUID per user-initiated tap. Reused across all retries of *that* attempt.
Never regenerated on cubit rebuild or retry button press.

### The key integration test (highest-value test in the project)
```
queue action → kill app mid-sending → restart → reconnect
→ assert: backend received exactly 1 write, UI state = confirmed
```
This test lives in `integration_test/offline_queue_test.dart`.
If it's red, nothing else ships.

---

## 4 — Kobo / ₦ correctness rules

**One function, one place:** `lib/src/core/utils/kobo_formatter.dart`
```dart
String formatKobo(int kobo) { ... }   // the only place / 100 lives
```

- No `/  100.0` inline anywhere else in the codebase.
- Savings progress: `currentKobo / targetKobo` stays **integer division** until the
  render boundary. Never accumulate or compare as `double`.
- Sums, balances, transaction amounts: kobo integers end-to-end.
- Formatting (the `₦` string) happens only at the widget layer.

This is also the canonical AI-wrong-output example for `AI_USAGE.md`:
a plausible AI suggestion of `contribution / target * 100` using doubles would
introduce drift at non-round amounts.

---

## 5 — State management: why Bloc/Cubit

Bloc/Cubit was chosen over Provider/Riverpod for one reason: the queue's state
transitions are explicit, named, and auditable as Cubit emissions. In a live
interview, you can point to the exact state class and narrate every transition.
`QueueCubit` is testable without pumping a single widget — `QueueRepository` is
mocked via `mocktail`, `bloc_test` drives the cubit in isolation.

Feature cubits (`SendMoneyCubit`, `SavingsGoalCubit`) depend on `QueueCubit`
rather than touching the fake transport directly, keeping the replay guarantee
in one place instead of duplicated per flow.

---

## 6 — Navigation (go_router)

Router is declared in `lib/src/shared/router/app_router.dart` and passed to
`MaterialApp.router` in `app.dart`. Three named routes:

```dart
// route names
/           → WalletHomePage
/send       → SendMoneyPage
/nova-save  → NovaSavePage
```

`GoRouter` instance is created once in `app_router.dart`; no per-screen `context.go`
wiring outside of that file. Feature pages are unaware of the router — they receive
callbacks (e.g. `onSendTap`) that `app_router.dart`'s builder provides via closure.

---

## 7 — Connectivity detection

`connectivity_plus` events + a ping to `FakeApiClient.health()`.
Interface-up alone is not enough — the brief explicitly calls this out.
Detection lives in `QueueCubit`; no feature cubit polls connectivity independently.

---

## 8 — Dependency injection (no framework)

Each feature has a `*_injections.dart` — a plain factory function:
```dart
// send_money_injections.dart
SendMoneyCubit createSendMoneyCubit(QueueRepository repo) =>
    SendMoneyCubit(SendMoneyUseCase(EnqueueTransactionUseCase(repo)));
```
`app.dart` creates one `QueueRepositoryImpl` and passes it to every factory.
No `get_it`, no `injectable` — manual wiring is readable in a live walkthrough.

---

## 9 — Localization

`l10n.yaml` is configured. Output: `lib/l10n/gen/app_localizations.dart`.

- All UI strings go in `lib/l10n/arb/app_en.arb`.
- Accessibility labels for every `Semantics` wrapper go here too.
- Dynamic ₦ amounts go through `kobo_formatter.dart` at widget layer — not ARB.
- `app_es.arb` stays as a stub (pipeline proof, not translation).

---

## 10 — Test plan

```
test/
  unit/
    core/
      utils/kobo_formatter_test.dart          # 0, 1, 100, 99999 kobo
    core/queue/
      domain/usecases/
        enqueue_transaction_test.dart
        replay_queue_test.dart
      data/repositories/queue_repository_test.dart   # mocktail datasource
  widget/
    features/
      send_money/
        send_money.feature      # Gherkin: idempotency key not regen'd on rebuild
        send_money_test.dart    # generated by build_runner — do not edit
        steps/                  # step definitions (plain Dart)
      nova_save/
        nova_save.feature       # Gherkin: progress % exact at target boundary
        nova_save_test.dart     # generated
        steps/
  helpers/
    pump_app.dart               # extend existing helper with QueueCubit context

integration_test/
  offline_queue_test.dart       # queue → kill mid-sending → restart → reconnect
                                # assert: exactly 1 backend write, UI = confirmed
```

Widget tests are authored as Gherkin `.feature` files; `bdd_widget_test` + `build_runner`
generate the `*_test.dart`. Edit the `.feature` — never the generated file.
Integration tests use Flutter SDK's `integration_test` directly (no extra package).

---

## 11 — Packages (resolved against Flutter 3.44.1 / Dart 3.12.1)


### Runtime
| Package | Constraint | Resolved | Why |
|---|---|---|---|
| `drift` | `>=2.33.0 <2.34.6` | 2.34.4 | Type-safe SQLite for queue persistence |
| `drift_flutter` | `^0.3.1` | 0.3.1 | Flutter-specific drift setup |
| `connectivity_plus` | `^7.3.1` | 7.3.1 | Interface-up events |
| `uuid` | `^4.6.0` | 4.6.0 | Idempotency key generation |
| `equatable` | `^3.0.0` | 3.0.0 | Value equality for entities + states |
| `go_router` | `^18.0.1` | 18.0.1 | Declarative routing between the 3 screens |

### Dev
| Package | Constraint | Resolved | Why |
|---|---|---|---|
| `drift_dev` | `>=2.33.0 <2.34.6` | 2.34.0 | Drift code gen |
| `build_runner` | `^2.15.1` | 2.15.1 | Runs drift_dev + bdd_widget_test codegen |
| `fake_async` | `^1.3.3` | 1.3.3 | Test queue timing |
| `bdd_widget_test` | `^2.1.4` | 2.1.4 | Generates widget tests from Gherkin `.feature` files |

**Why the drift ceiling at 2.34.6:**
`drift_dev >=2.34.6` requires `analyzer >=13.0.0`, which conflicts with
`bloc_test ^10.0.0` + `flutter_test` on Flutter 3.44.1.

**Why build_runner ceiling at 2.15.2:**
`build_runner >=2.15.2` requires `meta ^1.18.3`; Flutter 3.44.1 pins `meta` at 1.18.0.

Do not bump these ceilings without verifying `flutter pub get` still resolves.

---

## 12 — What was deliberately NOT added

| Package | Reason |
|---|---|
| `flutter_secure_storage` | Queue rows aren't credentials; Drift DB is sufficient |
| `freezed` | `equatable` + manual `copyWith` is clearer for live narration |
| `get_it` / `injectable` | Manual injection is more readable in a take-home interview |

---

## 13 — Milestone order

1. `pubspec.yaml` + `lib/src/` folder skeleton ✅
2. Drift DB + `QueueLocalDatasource` + `FakeApiClient` with idempotency
3. Queue domain entities + repository interface + use cases (unit tests)
4. `QueueCubit` + replay orchestration → **integration test green before step 5**
5. `wallet_home`, `send_money`, `nova_save` screens wired to cubits
6. Accessibility pass (Semantics + 1.3×/2.0× font scale)
7. Gherkin `.feature` files for Send + Save → run `build_runner` → widget tests green
8. `app_en.arb` strings + `AI_USAGE.md` + README

**Hard stop:** if step 4's integration test hasn't started by hour 30, drop to
tests + docs. A proven queue with thin UI beats a polished UI on an unproven queue.
