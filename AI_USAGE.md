# AI usage and engineering judgment

I used Codex to audit the brief, identify gaps in the scaffold, propose code
structure, and run the Flutter test/analyzer loop. I retained responsibility for
the architecture, package compatibility, generated-code review, and tests.

Prompts and outcomes:

- “Audit this Flutter take-home against every rubric item.” This exposed the
  missing restart-safe queue, fake backend, integration test, and AI usage file.
- “Design a replay-safe offline queue using an idempotency key.” The useful part
  was modelling `pending -> sending -> confirmed/failed`; I added cold-start
  reconciliation against the backend before any resubmission.
- “Add local notifications and accessibility polish.” This led to an injected
  notification service so a platform/plugin failure cannot affect a transaction.

An AI-generated queue design was risky: it suggested retrying every `sending`
row on app launch. If the process died after the backend accepted the transfer,
that could duplicate a payment. The implementation instead asks the backend
whether that idempotency key was already processed, marks it confirmed when it
was, and has an integration test asserting the backend write count remains one.

Another common unsafe suggestion was formatting Naira using doubles in screen
widgets. NovaWallet keeps amounts as integer kobo and uses the one formatter in
`lib/src/core/utils/kobo_formatter.dart` for display.
