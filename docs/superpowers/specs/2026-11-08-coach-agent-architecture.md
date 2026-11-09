# Level Coach: coach agent architecture (approach B1)

**Status:** Draft v0.2, 2026-11-09. Companion to `2026-11-08-level-coach-design.md`. Explores the
"agent server" idea Brendon raised and settles its shape. Awaiting approval before any build.

**Decisions this builds on (Brendon, 2026-11-08 and 2026-11-09):** approach B1 (Claude Code on
the existing subscription, no separate API key); personal use only for now; game on a Windows PC,
development on Linux; first character an Undead Affliction Warlock; **GitHub as the bridge between
the machines, Dropbox as the fallback**; **no Hardcore**; **trivial coach proposals auto-accept**.

---

## 1. The one shape the sandbox allows

The addon cannot open a socket, read a file at runtime, or run a program. So an "agent server
that communicates with the addon" can only communicate through files, and only at two moments:

- **Addon to coach:** WoW writes the addon's SavedVariables file on `/reload` and on logout.
- **Coach to addon:** WoW reads the addon folder's `.lua` files at login and on `/reload`.

Everything below is one loop. The bridge is a git repository, so every hop is a commit:

```
 Windows gaming PC                      GitHub (private repo)             Linux dev box
 +------------------------------+       +----------------------+        +----------------------------+
 | WoW: Forever + LevelCoach    |       | level_coach_sync     |        | coach daemon (Python)      |
 |  writes SavedVariables    ---+--+    |  export/             |  <-----+- git fetch every minute    |
 |  on /reload or logout        |  |    |   LevelCoach.lua     |        |  new export? parse (lupa)  |
 |                              |  +--> |   snapshot.json      |        |  run: claude -p "/coach"   |
 | watcher.ps1                  |       |  overlay/            |        |  validate, tier, commit    |
 |  copy export, commit, push --+-----> |   Overlay.pending.lua| <------+- push                      |
 |  pull every minute,          |       |  briefings/          |        |                            |
 |  copy overlay into addon  <--+-----< |   2026-11-09T21.md   |        | (later: GitHub Actions     |
 |  reads Data/*.lua on reload  |       +----------------------+        |  runs the same job)        |
 +------------------------------+                                       +----------------------------+
```

The player-visible cost is the **two-reload cycle**: one `/reload` publishes the export, the coach
needs a minute or two, and any later `/reload` or login receives the result. The addon cannot
learn that a result is ready; it only sees the file on the next load. The design makes this
acceptable by running the coach after *every* export, so the next login always has the freshest
plan, and by auto-applying the trivial tier so most updates need no decision at all.

## 2. Why GitHub, and why a separate private repository

Brendon suggested syncing through GitHub. It is the right call for this setup:

- Git is already required on the Windows PC to deploy the addon (`git pull` into a clone that is
  junctioned into `Interface\AddOns`). One mechanism instead of two.
- The export history becomes a **play journal**: every commit is "character at level N in zone Z
  with these items done". That is the breadcrumb timeline the design wants, for free, with diffs.
- Any Claude Code session can run `/coach` by cloning: the Linux box, a cloud session, a phone.
- GitHub Actions can later run the coach so the Linux box need not be on (Phase C).
- No third-party sync client, no binary blobs, everything is text and reviewable.

Costs: a git credential on the game PC (scope it to the sync repo); a commit per export (fine in a
repo that holds nothing else); seconds of push and pull latency; two writers who must never share
a path.

**Privacy.** `brendonhall/level_coach` is **public** (checked 2026-11-09). The export is a play log
with character name, ruleset, level, zones, quests and goals. Not secret, but not for a public
repository. So the bridge is a **separate private repo, `level_coach_sync`**, holding only
`export/`, `overlay/` and `briefings/`. The alternative, making `level_coach` private, would make
publishing the addon later a history-surgery job. Rejected.

**Ownership rule.** `export/**` is written only by the Windows watcher. `overlay/**` and
`briefings/**` are written only by the coach. No shared files means no merge conflicts; both
sides still `git pull --rebase` before every push.

**Dropbox fallback.** Same three directories inside a Dropbox folder; the Windows script loses its
git steps and keeps its two copies; the daemon watches the local Dropbox folder instead of
fetching. Switching costs an afternoon and the addon does not change.

## 3. Windows side: `watcher.ps1`

A PowerShell script registered as a scheduled task that starts at logon. It has three jobs:

1. **Publish exports.** Watch
   `<WoW>\_forever_\WTF\Account\<ACCOUNT>\SavedVariables\LevelCoach.lua` with a
   `FileSystemWatcher`. On change, wait until the file size has been stable for two seconds (WoW
   writes the file whole, but the watcher fires early), copy it to
   `<sync clone>\export\LevelCoach.lua`, and if `git diff --quiet` reports a change, commit as
   `export: <char> L<level> <zone> <timestamp>` and push after `git pull --rebase`.
2. **Receive overlays.** Every sixty seconds `git pull --rebase` in the sync clone. If
   `overlay\Overlay.pending.lua` changed, copy it to
   `<WoW>\_forever_\Interface\AddOns\LevelCoach\Data\Overlay.pending.lua`. This is the one file
   that crosses from the sync repo into the addon folder; everything else in the addon folder
   comes from the code repo clone.
3. **Deploy code.** On the same timer, `git pull --ff-only` in the code repo clone. Because the
   addon folder is an NTFS junction into that clone, a push from Linux is live after the next
   `/reload`.

Credential: Git Credential Manager signed in to GitHub, or an SSH deploy key with write access to
the sync repo only. Never a token with access to everything. The flavor folder name (`_forever_`
per launch guides, `_classic_beta_` during beta) is confirmed from the Battle.net launcher's
"Show in Explorer" before the script is written.

## 4. Linux side: the daemon

```
every 60 s: git fetch in the sync clone
  -> new commit touching export/? pull it
  -> parse export/LevelCoach.lua with lupa (Lua 5.1 in-process, empty environment, size cap;
     the file must be a single table assignment, nothing else executes)
  -> write export/snapshot.json: level, class, race, ruleset, zone, goals, completed and skipped
     items, breadcrumbs since the previous run, explicit "sync requested" flag
  -> decide: run only on a new level band, a new zone, changed goals, an explicit request, or
     24 hours since the last run; otherwise commit snapshot.json and stop
  -> run Claude Code headless from the code repo root, so CLAUDE.md and .claude/skills load:
       claude -p "/coach <sync>/export/snapshot.json" --output-format json \
         --permission-mode dontAsk --permission-prompts none \
         --allowedTools "Read,WebSearch,WebFetch(domain:<allowlist>),Edit(//<sync>/overlay/**),Edit(//<sync>/briefings/**)"
  -> validate overlay/Overlay.pending.lua (section 5); on failure keep the previous file and log
  -> commit "coach: <n> items (<i> info, <s> suggest, <p> plan)" with the briefing, pull --rebase, push
```

Rules: at most a few runs per hour; keep the last N briefings; every failure leaves the previous
overlay in place; recognize the "Login expired" result and notify rather than retry; never give
the coach a Bash tool or a write path outside `overlay/` and `briefings/`.

## 5. Acceptance policy: trust tiers

Decision (2026-11-09): trivial proposals auto-accept. "Trivial" is defined mechanically, not by
judgment, so the daemon's validator and the addon can both enforce it:

| Tier | What it may contain | Examples | Treatment in game |
|---|---|---|---|
| `info` | Only facts derived from the character's own state plus the shipped data: existing item IDs, detectors over current state, numbers from the snapshot. No URLs, no free-text `where`. | "Corruption rank 3 is available at your trainer." "Ruins of Lordaeron is now in your level range." "You have 95 of the 100 gold for riding." | **Auto-accepted** on load, shown with a small coach tag. `/lc trust none` turns this off. |
| `suggest` | A new checklist item with web-sourced content: a quest, an item, a dungeon, a zone move. Must carry a source URL and `verified: false`. | "The Orb of Soran'ruk quest in the Barrens rewards a strong caster weapon at 20." | Pending in a "Proposed by your coach" section until `/lc accept <n>` or `/lc accept all`. |
| `plan` | Anything that re-ranks, hides or rewrites existing items or changes goal weights. Must carry a one-line rationale. | "Move Scarlet Monastery ahead of Razorfen Kraul: it is next to your home city and matches your dungeons goal." | Pending and highlighted, with the before and after shown. |

The validator demotes any `info` item that contains a URL or free text to `suggest`, and rejects
the whole overlay if an item lacks a tier. The addon re-checks tiers on load, because the overlay
is data that arrived from outside the sandbox. Pending items expire when the character levels
past their window; expired items are reported back in the next export so the coach learns.

## 6. The `/coach` skill

Lives in the code repo at `.claude/skills/coach/SKILL.md`, so it works from the daemon, from a
GitHub Action, and interactively in any Claude Code session on the repo.

- **Input:** path to `snapshot.json`; the code repo's `data/` YAML; the current pending overlay.
- **Steps:** read the snapshot; compute the level band and what is overdue; check active goals;
  research only the gaps (next band, missed class quests, dungeons in range, zone move) against
  the guide-site allowlist; write items in the project schema with `why`, `where`, `trust`, a
  source URL for web-derived items and `verified: false`; write a short Markdown briefing.
- **Output:** `overlay/Overlay.pending.lua` and `briefings/<timestamp>.md`. Nothing else.

Headless facts this relies on, from the Claude Code docs (checked 2026-11-08):

- `claude -p "/coach ..."` is the documented way to invoke a project skill non-interactively;
  CLAUDE.md, skills and hooks load in `-p` mode (not with `--bare`).
- `--allowedTools` takes rule syntax such as `Edit(//abs/path/**)` and `WebFetch(domain:x)`;
  `--permission-mode dontAsk` denies anything not pre-approved instead of hanging;
  `--permission-prompts none` tells the model not to retry denied actions.
- `--output-format json` returns the result, session id and metadata for logging.
- `--dangerously-skip-permissions` is documented for isolated containers only; a daemon that
  reads the web does not qualify.

## 7. Authentication and terms

- The subscription login is the default credential for Pro and Max users, and `-p` mode uses it.
  For an unattended daemon, `claude setup-token` issues a one-year OAuth token for CI and scripts.
- `ANTHROPIC_API_KEY` outranks the login whenever it is set, and in `-p` mode it is always used
  when present. The daemon runs with that variable unset.
- The docs say third-party products may not offer claude.ai login or rate limits, including
  agents built on the Claude Agent SDK, and must use API keys. They do not state whether a
  person's own local automation under their own login is covered. Read the usage policy before
  the daemon runs unattended; if Level Coach is ever shared, the companion becomes B2 with keys.
- A login can expire; the daemon treats "Login expired" as a notification, not a retry.
- The Python Agent SDK is documented with an API key only, so the daemon shells out to `claude -p`.
- For Phase C, confirm in the Claude Code GitHub Actions documentation that the official action
  accepts a `setup-token` OAuth token for a personal repository before storing one as a secret.

## 8. Failure modes

| Situation | Behavior |
|---|---|
| Daemon, Linux box or GitHub unreachable | Nothing changes in game; the static plan continues; the panel shows the age of the last coach update |
| Export half-written when the watcher fires | Size-stable wait, then the Lua parse must succeed before commit; otherwise retry on the next change |
| Push rejected (other side pushed first) | `git pull --rebase`, retry once; the ownership rule makes the rebase trivial |
| Coach output fails validation | Not committed; logged; previous pending file kept |
| Overlay older than the character's state | Addon hides items whose window has passed and reports them as expired in the next export |
| Player never reloads | Export never updates and the coach never runs; the addon suggests `/reload` on level-up and at logout |
| Research finds nothing new | Empty overlay plus a briefing saying so; no reload nag |
| Login expired | Daemon logs and notifies; no retries until re-login |

## 9. Phases

- **Phase A, manual coach.** Private sync repo, `watcher.ps1`, addon export. Brendon runs
  `/coach` interactively in Claude Code on Linux and reads the briefing. Proves the value and
  tunes the skill before any automation exists.
- **Phase B, daemon.** The fetch loop, lupa parser, validator, tiers, `/lc accept` and
  `/lc trust` in the addon.
- **Phase C, GitHub Actions runner.** The same job triggered by a push to `export/**`, so the
  Linux box need not be on. Terms check first (section 7).
- **Phase D, optional.** Dropbox fallback if git on the game PC becomes a chore.

## 10. Open questions

1. Resolved 2026-11-09: the Linux box is on while Brendon plays, so Phase B (daemon) is the path
   and Phase C (GitHub Actions) is optional.
2. Working assumption: a separate private sync repository (`level_coach_sync`) rather than
   making this repo private. Say so if you prefer otherwise before Phase 3 creates it.

## Sources

- Claude Code headless mode: https://code.claude.com/docs/en/headless
- Permission modes and rules: https://code.claude.com/docs/en/permission-modes and
  https://code.claude.com/docs/en/permissions
- Authentication and long-lived tokens: https://code.claude.com/docs/en/authentication
- Agent SDK overview and quickstart: https://code.claude.com/docs/en/agent-sdk/overview and
  https://code.claude.com/docs/en/agent-sdk/quickstart
- Claude Code on Windows: https://code.claude.com/docs/en/setup
- Scheduled tasks and limitations: https://code.claude.com/docs/en/scheduled-tasks
- TradeSkillMaster desktop app (file-sideload precedent): https://www.tradeskillmaster.com/app
