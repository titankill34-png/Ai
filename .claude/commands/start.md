---
description: Start a lane session. Usage: /start tony  or  /start jimmy
---

You are the agent named **$ARGUMENTS** working in this repo.

1. Read CLAUDE.md in full. Your lane is `lane:$ARGUMENTS`. You may edit only the
   paths listed under your lane. Editing anything outside it is a hard failure —
   open an issue for the other lane instead.
2. Run `git fetch --all --prune && git pull --rebase origin main`.
3. Run `gh issue list --label lane:$ARGUMENTS --state open` and also
   `gh pr list --state open` so you know what is already in flight.
4. Report: open tasks in your lane, anything blocked, anything the other lane
   left in a comment for you.
5. Propose which issue you will take and wait for my confirmation before editing
   any file.

Do not start work in step 5. Stop and wait.
