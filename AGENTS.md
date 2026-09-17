# AGENTS.md — NovaWallet

Project-specific rules for Codex. Read this before touching any file.
Full rationale for every decision lives in `docs/ARCHITECTURE.md`.

---

## Project overview

Flutter take-home: **Send Money** + **NovaSave contribution** with an offline queue
that survives an app restart and replays each action **exactly once** on reconnect.
The queue correctness is the primary grading criterion — UI polish is secondary.

Stack: Flutter 3.44.1 · Dart 3.12.1 · Bloc/Cubit · Drift (SQLite) · go_router

---

## Architecture: feature-first clean architecture

```
lib/src/
  core/          # cross-cutting infra (queue, network, utils)
  features/      # wallet_home | send_money | nova_save
  shared/        # widgets, theme, router
```

Each feature has its own `data/ domain/ presentation/` vertical.
Nothing imports across feature boundaries.

**Dependency direction — enforced, no exceptions:**
```
presentation → domain ← data
```
- Features import `core/queue/domain` interfaces only — never `core/queue/data`.
- Data layer maps to domain entities. Domain never imports data or presentation.
- Presentation never instantiates repository implementations directly.

---

## Kobo / ₦ rules — zero tolerance

- `lib/src/core/utils/kobo_formatter.dart` contains the **only** `/ 100` in the codebase.
- All amounts are `int` (kobo) end-to-end. No `double` for money.
- Savings progress ratio: integer arithmetic until the widget render boundary.
- Never write `amount / 100.0`, `contribution / target * 100`, or any inline float math on amounts.

---

## Offline queue — non-negotiable invariants

- One `idempotencyKey` (UUID v4) per user-initiated tap. Never regenerated on rebuild or retry.
- State machine: `pending → sending → confirmed` / `sending → failed → sending`.
- `QueueCubit` owns every transition. Feature cubits call use cases — never `FakeApiClient` directly.
- On cold boot, `ReplayQueueUseCase` reconciles `sending` items with the fake backend
  **before** resubmitting — prevents the kill-mid-flight double-send.
- `FakeApiClient` enforces idempotency server-side (duplicate key → "already processed").

---

## Navigation

- `GoRouter` declared once in `lib/src/shared/router/app_router.dart`.
- Routes: `/` → WalletHomePage, `/send` → SendMoneyPage, `/nova-save` → NovaSavePage.
- Feature pages are router-unaware — they receive callbacks; the router builder provides them via closure.
- Never call `context.go` or `context.push` inside a feature page or cubit.

---

## State management

Bloc/Cubit throughout. No Provider, no Riverpod.
- `QueueCubit` — queue persistence and replay orchestration (testable without widgets).
- `WalletHomeCubit`, `SendMoneyCubit`, `SavingsGoalCubit` — screen-level state.
- Dependency injection: plain factory functions in `*_injections.dart`, no `get_it`.

---

## Packages

### Why these versions are pinned

| Package | Constraint | Reason for ceiling |
|---|---|---|
| `drift` | `>=2.33.0 <2.34.6` | `drift_dev >=2.34.6` needs `analyzer >=13.0.0` — conflicts with `bloc_test ^10.0.0` + `flutter_test` on Flutter 3.44.1 |
| `drift_dev` | `>=2.33.0 <2.34.6` | Same — must match drift version |
| `build_runner` | `^2.15.1` | `>=2.15.2` needs `meta ^1.18.3`; Flutter 3.44.1 pins `meta` at 1.18.0 |

**Do not bump these ceilings** without running `flutter pub get` and verifying resolution.

### Full dependency list

**Runtime:** `bloc`, `flutter_bloc`, `flutter_localizations`, `intl`,
`drift`, `drift_flutter`, `connectivity_plus`, `uuid`, `equatable`, `go_router`

**Dev:** `bloc_test`, `mocktail`, `bloc_lint`, `very_good_analysis`,
`drift_dev`, `build_runner`, `fake_async`, `bdd_widget_test`

### What was deliberately excluded

- `flutter_secure_storage` — queue rows aren't credentials; Drift DB is sufficient
- `freezed` — `equatable` + manual `copyWith` is clearer for live interview narration
- `get_it` / `injectable` — manual constructor injection is more readable in a take-home

---

## Localization

- Config: `l10n.yaml` → output at `lib/l10n/gen/app_localizations.dart`
- All UI strings and Semantics labels go in `lib/l10n/arb/app_en.arb`
- Dynamic ₦ amounts go through `kobo_formatter.dart` at the widget layer — not ARB
- Generated files in `lib/l10n/gen/` are excluded from analysis (see `analysis_options.yaml`)
- `app_es.arb` is a stub — do not translate it

---

## Gherkin / BDD tests (`bdd_widget_test`)

`.feature` files live next to the widget test they describe:
```
test/
  widget/
    features/
      send_money/
        send_money.feature       # Gherkin scenarios
        send_money_test.dart     # generated — do not edit manually
        steps/                   # step definitions live here
      nova_save/
        nova_save.feature
        nova_save_test.dart
        steps/
```

Workflow:
1. Write or update a `.feature` file.
2. Run `dart run build_runner build` — generates the `*_test.dart` file.
3. Run `flutter test` to execute.

Feature files use standard Gherkin (`Feature:`, `Scenario:`, `Given/When/Then`).
Generated `*_test.dart` files are committed but never edited by hand.
Step definitions in `steps/` are plain Dart functions — one file per feature is enough.

Example scenario (send money):
```gherkin
Feature: Send Money

  Scenario: Queues a transfer while offline
    Given the device is offline
    And the wallet balance is 500000 kobo
    When I send 10000 kobo to recipient "ACC-001"
    Then the queue contains 1 pending item
    And the idempotency key is not regenerated on screen rebuild
```

---

## Commands

```bash
# Install / refresh packages
flutter pub get

# Drift code generation + Gherkin test generation (run after any schema or .feature change)
dart run build_runner build --delete-conflicting-outputs

# All unit + widget tests
flutter test

# The highest-value test — exactly-once replay proof
flutter test integration_test/offline_queue_test.dart -d <device>

# Lint
flutter analyze
```

---

## Test priorities

1. `integration_test/offline_queue_test.dart` — queue survives restart, replays exactly once. If red, nothing ships.
2. `test/unit/core/utils/kobo_formatter_test.dart` — boundary values (0, 1, 100, 99999 kobo).
3. `test/unit/core/queue/` — use case unit tests with mocked repository.
4. `test/widget/features/send_money/send_money.feature` — Gherkin: idempotency key not regenerated on rebuild.
5. `test/widget/features/nova_save/nova_save.feature` — Gherkin: progress % correct at target boundary.

---

## What NOT to build

- More than one stretch goal (notifications, biometric stub, golden tests).
- Custom animations or a full design system.
- Multi-currency support.
- Any UI polish before the queue integration test is green.
