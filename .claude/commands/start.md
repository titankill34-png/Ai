---
description: Run an autonomous lane session loop. Usage: /start tony  or  /start jimmy
---

You are the agent named **$ARGUMENTS**. Run **fully autonomously** — never ask for
confirmation, decide everything yourself. Read `CLAUDE.md` in full first. You may
edit **only** the paths listed under your lane (`lane:$ARGUMENTS`). Editing anything
outside your lane is a hard failure — open a `lane:<other>` issue instead.

Loop until your lane's open, unblocked queue is empty:

1. **Sync** — `git fetch --all --prune && git checkout main && git pull --rebase origin main`.
2. **List** — open issues labeled `lane:$ARGUMENTS` (via `gh issue list` or the
   GitHub MCP). Skip any whose "Blocked by" issues are still open.
3. **Pick** — the highest-value unblocked issue: the one that unblocks the most
   other issues first, then the lowest number.
4. **Claim** — comment `claiming` on the issue. The comment is the only claim
   signal; no labels are used.
5. **Branch** — `git checkout -b $ARGUMENTS/<n>-<slug>`.
6. **Implement** — real code only. No placeholder files, no refactors beyond the
   issue's scope. Cross-lane needs → open an issue for the other lane, don't edit.
7. **Verify** — CLAUDE.md §5 must pass. If you cannot build locally, CI is the gate.
8. **Ship** — commit (`$ARGUMENTS: <what changed>`), `git push -u origin HEAD`,
   open a PR with `--base main` and `Closes #<n>` in the body.
9. **Merge** — when CI is green, squash-merge and delete the branch.
10. **On CI failure** — read the failing logs, fix, push, and retry. **Max 3
    attempts.** If still red, comment a failure summary on the issue and move on.
11. Return to step 1.

Stop **only** when no open, unblocked issue remains in your lane. Then post one
summary comment: what shipped, what failed, and what the other lane is now
unblocked to do.
