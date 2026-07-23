# CLAUDE.md

Read this file fully before any work. Two independent Claude Code sessions on two
separate machines share this repo. They never talk to each other directly — GitHub
Issues is the only shared task list.

> **Scaffolding note.** This repo currently contains CI + agent scaffolding only.
> The Xcode project (`Nicora.xcodeproj`) and the `Sources/` tree described below do
> not exist yet — they are created by the first `lane:jimmy` bootstrap task. The
> lane globs describe the folder structure the project **must** follow once created;
> re-check the KSign section (§1) after entitlements are first added.

---

## 1. Project

| Key | Value |
|---|---|
| App name | `Nicora` |
| Bundle ID | `com.titankill34.nicora` |
| Xcode file | `Nicora.xcodeproj` |
| Scheme | `Nicora` |
| iOS target | `17.0` |
| Dependencies | Swift Package Manager only. Never add CocoaPods or Carthage. |
| Signing | **Never signed in CI.** CI emits an unsigned `.ipa`; the user signs it locally with KSign. |

### KSign constraints — treat as hard limits

Adding any of the following breaks local signing. Open an issue and wait for
approval instead of adding them:

- Capabilities requiring a full provisioning profile: Push Notifications, iCloud,
  App Groups, HealthKit, Sign in with Apple, Associated Domains
- New app extensions, widgets, or watchOS targets (nested signing breaks)
- Dynamic frameworks not managed by SPM

Effective entitlements live only in `Nicora/Nicora.entitlements`.

> Local notifications (`UNUserNotificationCenter`) need **no** entitlement and are
> KSign-safe. Do not confuse them with **Push** Notifications (remote), which are on
> the hard-limit list above.

---

## 2. Lanes

An agent may edit **only** files inside its own lane. Need something outside it?
Open an issue for the other lane. Never edit across the boundary.

| Machine | Agent | Label | Model | Role |
|---|---|---|---|---|
| A | **Tony** | `lane:tony` | `sonnet` | Foreground machine. Small, fast, user-facing work. Reviews PRs. |
| B | **Jimmy** | `lane:jimmy` | `opusplan` | Background machine. Heavy, long-running, autonomous work. |

Work is intentionally weighted toward Jimmy. Tony's quota is also spent on
interactive Q&A, so keep Tony's tasks small.

### Tony's lane — UI only

```
Sources/UI/**
Sources/Features/**/Views/**
Resources/Assets.xcassets/**
Resources/Localizable/**
```

Good tasks: build a screen, fix layout, adjust strings or icons, anything that
closes in one short PR.

### Jimmy's lane — everything else

```
Sources/Core/**
Sources/Networking/**
Sources/Persistence/**
Sources/Contracts/**
Tests/**
Scripts/**
.github/**
.claude/**
Nicora.xcodeproj/project.pbxproj
```

Good tasks: large refactors, root-cause debugging, CI changes, dependency work,
tests, and **all** Xcode project file changes.

**Jimmy owns `project.pbxproj` exclusively.** If Tony needs a new file added to
the Xcode project, Tony opens a `lane:jimmy` issue and waits. This single rule
removes the most common merge conflict in this repo.

### Shared — requires agreement from both lanes

```
CLAUDE.md
```

---

## 3. Cross-lane contract

- Everything crossing a lane boundary goes through a protocol in `Sources/Contracts/`.
- Tony never references a concrete type owned by Jimmy. Inject via protocol.
- Changing a protocol signature: open an issue labeled `contract-change`, wait for
  approval, then implement, then comment on the issue so the other lane knows.
- Jimmy maintains mocks in `Sources/Contracts/Mocks/` so Tony is never blocked
  waiting on a real implementation.

---

## 4. Session workflow

Run this sequence at the start of every session:

1. `git fetch --all --prune && git pull --rebase origin main`
2. `gh issue list --label lane:<tony|jimmy> --state open`
3. Claim one: `gh issue comment <n> --body "claiming"` then
   `gh issue edit <n> --add-label in-progress`
4. `git checkout -b <agent>/<issue>-<slug>` — e.g. `tony/12-login-screen`
5. Work, commit in small steps, `git push -u origin HEAD`
6. `gh pr create --fill --base main`, include `Closes #<issue>` in the body
7. Wait for CI to pass, then **squash** merge
8. Delete the branch and return to step 1

### Rules

- Commit message format: `<agent>: <what changed>` — e.g. `jimmy: add token refresh retry`
- Never force-push to `main`
- Never merge the other lane's PR unless CI is green and it has been open over 24h
- Before finishing a session, comment on the issue with: what was done, what
  remains, and anything the other lane must know

---

## 5. Local verification

A PR may not be opened until this passes:

```bash
xcodebuild -scheme "Nicora" -destination 'generic/platform=iOS' \
  -configuration Release \
  CODE_SIGNING_ALLOWED=NO CODE_SIGNING_REQUIRED=NO CODE_SIGN_IDENTITY="" \
  build
```

---

## 6. Never

- Edit files outside your lane
- Commit `.p12`, `.mobileprovision`, `.cer`, or any API key
- Change Bundle ID or deployment target without an approved issue
- Delete or rewrite work sitting in an unmerged branch owned by the other lane
