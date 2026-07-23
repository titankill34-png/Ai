# Nicora — build status

_Auto-maintained by the `lane:jimmy` agent. Updated at the end of every task._

**Last updated:** 2026-07-23 (describes `main` @ `844d391`)

| Field | Value |
|---|---|
| Mainline branch | `main` (feature branches are squash-merged and deleted) |
| `main` HEAD | `844d391` — `jimmy: compile Sources/UI into the Nicora target + wire app root (#35)` |
| Open issues — `lane:jimmy` | **0** |
| Open issues — `lane:tony` | **0** |
| Open issues — total | **0** |
| Open PRs | **0** |
| Xcode target compiles? | **Yes** — `Nicora` archives and unit tests pass in CI (no local `xcodebuild`; CI on macOS is the gate) |
| Latest release `.ipa` | [`Nicora-0.0.0-512e84d.ipa`](https://github.com/titankill34-png/Ai/releases/download/build-19/Nicora-0.0.0-512e84d.ipa) (release [`build-19`](https://github.com/titankill34-png/Ai/releases/tag/build-19), unsigned) |

## Last CI result (`main`)

| Workflow | Run | Commit | Result |
|---|---|---|---|
| `build-ipa.yml` (archive → unsigned `.ipa`) | #34 | `844d391` | ✅ success |
| `tests.yml` (`xcodebuild test` on simulator) | #20 | `844d391` | ▶ re-running post-merge; PR #35's `test` check passed on the same tree |

## App state

- `NicoraApp` launches into `RootTabView` (Home / Log / Stats / History / Settings), backed by a single SwiftData `ModelContainer`.
- Engines are injected as Contracts protocols (`IntervalProviding` / `StatsProviding` / `SmokeLogStoring`); only the app entry references the concrete `IntervalEngine` / `StatsEngine` / `SmokeLogStore`.
- All 15 `Sources/UI/**` files are compiled into the `Nicora` target.

## Notes

- The latest release `.ipa` (`build-19`, commit `512e84d`) **predates the UI integration** (#35). Cut a fresh release with `build-ipa.yml -f make_release=true` on `main` to publish an `.ipa` that includes the tab-bar UI.
- Labels `contract-change` / `in-progress` are intentionally not used (claiming is by issue comment). Label colors on `lane:tony`/`lane:jimmy`/`task` were left at GitHub defaults — see PR #1 for the `gh label create` one-liners.
