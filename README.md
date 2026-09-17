# NovaWallet Mobile — Send & Save

A Flutter take-home for the **FirstBank Digital Factory** — Frontend Engineer, Mobile (Flutter).

> Status: complete take-home implementation with persistent offline sync,
> generated mappable models, local notifications, English and Hausa localization,
> and automated unit/widget/integration coverage.

---

## Scenario

**FirstBank NovaPay** is a fictional digital-first financial super-app for the
Nigerian and West African mass market, bringing five modules under one login:
NovaWallet (e-wallet, P2P transfers, bills, airtime/data), NovaSave (goal-based
micro-savings), NovaLend (micro-loans / BNPL), NovaBiz (QR/POS-lite collection),
and a diaspora remittance corridor.

This app covers **two NovaPay journeys**: sending money from NovaWallet and
contributing to a NovaSave goal. There is no real backend — it is faked locally.
The core of the task is graceful behavior when the network is unreliable, since
many real NovaPay users are on low-end Android devices with patchy connectivity.

### Operating context

Amounts in Naira (₦), stored as integer **kobo** to avoid floating-point drift;
tiered KYC via BVN/NIN; settlement over NIBSS NIP; a USSD channel (`*894#`) for
low-connectivity users; and compliance touchpoints with CBN guidelines and the
Nigeria Data Protection Act (NDPA 2023).

---

## Functional requirements

| Screen / Feature   | Requirement |
| ------------------ | ----------- |
| Wallet home        | Balance in ₦ (from a kobo integer), scrollable recent-transactions list, pull-to-refresh. |
| Send Money         | Recipient → amount → confirm flow. Generates an idempotency key per attempt so a retried send can't double-process. |
| NovaSave goal      | Create a savings goal (name, target amount, target date), contribute, see progress as a bar/percentage. |
| Offline behavior   | If offline on "Send"/"Contribute", the action is queued locally and shown as *"Pending — will send when back online"* — not lost or silently retried in a loop. |
| Sync on reconnect  | When connectivity returns, queued actions replay **exactly once** each (no duplicates, even after an app restart). |

## Hard constraints

- Money enters as integer **kobo**; every display and sum must be exact — no floating-point drift.
- A queued action must **survive an app restart** while offline and must not send twice on reconnect.
- App must remain usable with **screen readers / accessibility services** on: proper `Semantics`, and text respects system font-scale without breaking layout.
- Large lists use `ListView.builder` (or equivalent) — no eager full-list builds.
- No sensitive data in plain `SharedPreferences` — use **secure storage**.

## Stretch goals

Local notification on successful queued-send sync · localization scaffold
(English + a Nigerian language) · golden tests for wallet home · biometric-
confirmation stub for sends above a threshold.

---

## Getting started

This project contains 3 flavors: `development`, `staging`, `production`.

```sh
# Development
flutter run --flavor development --target lib/main_development.dart

# Staging
flutter run --flavor staging --target lib/main_staging.dart

# Production
flutter run --flavor production --target lib/main_production.dart
```

Targeted toolchain: **Flutter 3.44.x / Dart 3.12.x**.

## Running tests

```sh
very_good test --coverage --test-randomize-ordering-seed random
```

For the highest-value restart/reconnect proof, run:

```sh
flutter test integration_test/offline_queue_test.dart -d <device>
```

## Architecture and sync guarantee

The app uses feature-first clean architecture: presentation Cubits depend on
domain use cases/interfaces, while Drift and the fake transport stay in the data
layer. `QueueCubit` is the sole orchestrator for queue state transitions.

Each tap creates one UUID v4 idempotency key. Drift persists the key, payload,
and status (`pending → sending → confirmed`, with a failed recovery path). On a
cold boot or reconnect, the replay use case first asks the fake backend whether
every interrupted `sending` key was accepted. It confirms known keys instead of
resubmitting them; only unknown keys are submitted. The backend itself also
deduplicates keys. These two layers protect the kill-mid-flight case.

All money is integer kobo until `formatKobo` renders it. The fixture backend is
at `assets/mock/fake_backend.json`; a matching test fixture is in
`test/fixtures/fake_backend.json`. Notifications are best-effort and never block
a successful transaction. There are no auth tokens in SharedPreferences.

## Working with translations

Follows the [official Flutter i18n guide][internationalization_link] using
[ARB files][arb_documentation_link] under `lib/l10n/arb`. Add strings to
`app_en.arb`, then regenerate:

```sh
flutter gen-l10n --arb-dir="lib/l10n/arb"
```

[internationalization_link]: https://docs.flutter.dev/ui/internationalization
[arb_documentation_link]: https://github.com/google/app-resource-bundle
[very_good_cli_link]: https://github.com/VeryGoodOpenSource/very_good_cli
