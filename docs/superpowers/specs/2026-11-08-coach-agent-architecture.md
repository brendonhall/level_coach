# Level Coach: coach agent architecture (approach B1)

**Status:** Draft v0, 2026-11-08. Companion to `2026-11-08-level-coach-design.md`. Explores the
"agent server" idea Brendon raised and recommends a shape. Not approved yet.

**Decisions this builds on (Brendon, 2026-11-08):** approach B1 (Claude Code on the existing
subscription, no separate API key); personal use only for now; game runs on a Windows PC;
development happens on a Linux box; first character is an Undead Affliction Warlock.

---

## 1. The one shape the sandbox allows

The addon cannot open a socket, read a file at runtime, or run a program. So an "agent server
that communicates with the addon" can only communicate through files, and only at two moments:

- **Addon to coach:** WoW writes the addon's SavedVariables file on `/reload` and on logout.
- **Coach to addon:** WoW reads the addon folder's `.lua` files at login and on `/reload`.

Every architecture below is the same loop with different plumbing:

```
  Windows gaming PC                                  Linux dev box
  +-----------------------------+                    +-----------------------------------+
  | WoW: Forever                |                    | coach daemon (Python)             |
  |  LevelCoach addon           |                    |  1. notice a new export           |
  |   writes SavedVariables  ---+--> bridge folder --+-> 2. parse snapshot, decide       |
  |   on /reload or logout      |   (Dropbox,        |  3. run: claude -p "/coach ..."   |
  |                             |    Syncthing,      |     subscription login,           |
  |   reads Data/*.lua       <--+--  or SMB share) <-+-- 4. write Overlay.pending.lua    |
  |   on login or /reload       |                    |     after validation              |
  +-----------------------------+                    +-----------------------------------+
         ^ /lc accept promotes pending items in game
```

The player-visible cost is the **two-reload cycle**: one `/reload` to publish the export, a
wait, then any later `/reload` or login to receive the result. There is no way for the addon
to learn that a result is ready; it only sees the file on the next load. The design below
makes that acceptable by running the coach after *every* export, so the next login always has
the freshest plan without anyone asking for it.

## 2. Where the coach runs: four options

| Option | Shape | Pros | Cons |
|---|---|---|---|
| **O1. Coach on the Windows PC** | Claude Code installed natively on Windows; a PowerShell or Python watcher runs `claude -p` there | No cross-machine plumbing; files are local | Second Claude Code login to maintain; Windows scripting; the repo must be cloned there anyway for the addon, so this is less bad than it sounds |
| **O2. Linux reads the WoW folder directly** | Share the WoW folder over SMB (or SSH) and mount it on Linux; watcher polls it | Everything stays on the dev box; lowest latency | Both machines must be on; inotify does not work over SMB, so poll; half-written files must be handled |
| **O3. Sync-folder bridge** (recommended) | A small Windows script copies the export into a synced folder (Dropbox or Syncthing) and copies results back; Linux watches the synced folder | Decoupled; survives either machine being off; Dropbox also makes O4 possible for free; Syncthing keeps everything on the LAN | Sync latency of a few seconds; Dropbox puts play data in the cloud |
| **O4. Cloud coach** | A Claude Code cloud session or scheduled task reads the export through the Dropbox connector and writes the overlay back | No daemon anywhere; runs while both PCs are off | Scheduled tasks are coarse (hourly at best); play data in the cloud; another moving part to debug |

**Recommendation:** O3, with Dropbox if it already runs on both machines (it is connected to
Claude in this workspace, which suggests yes), otherwise Syncthing. Keep O2 as the fallback for
LAN-only setups. Skip O1 so the gaming PC stays a plain game box. Keep O4 as an optional
later experiment, not a dependency.

### Windows side of the bridge (O3)

A ten-line PowerShell script, registered as a scheduled task that runs at logon:

1. Watch `World of Warcraft\<flavor>\WTF\Account\<ACCOUNT>\SavedVariables\LevelCoach.lua`
   with a `FileSystemWatcher` (or poll every 30 seconds; WoW writes rarely).
2. On change, wait until the file size is stable, then copy it to
   `<bridge>\export\LevelCoach.lua`.
3. Watch `<bridge>\overlay\Overlay.pending.lua` and copy it into
   `Interface\AddOns\LevelCoach\Data\Overlay.pending.lua`.

Why a copy script and not NTFS junctions: a junction would have to point at the whole
SavedVariables folder (every addon's data) or at a directory inside the addon, and both make the
Dropbox client and WoW's own write-then-rename behavior harder to reason about. Copying two named
files is explicit and easy to debug. The flavor folder name for Forever on disk is still to be
confirmed in the live client (`_forever_` is what most guides show; `_classic_beta_` during beta).

## 3. The daemon (Python, on Linux)

```
watch bridge/export/LevelCoach.lua
  -> debounce, then parse it with lupa (Lua 5.1 in-process, sandboxed, no libraries)
  -> build snapshot.json: level, class, race, zone, goals, completed items, skipped items,
     breadcrumbs since the last run, and any explicit "sync requested" flag
  -> decide: run the coach only if something meaningful changed (new level band, new zone,
     changed goals, explicit request, or N days since last run); otherwise exit
  -> run Claude Code headless from the repo root so CLAUDE.md and .claude/skills load:
       claude -p "/coach snapshot.json" --output-format json \
         --permission-mode dontAsk --permission-prompts none \
         --allowedTools "Read,WebSearch,WebFetch(domain:...),Edit(//<bridge>/overlay/**)"
  -> validate the produced Overlay.pending.lua with lupa before publishing it:
       parses as a single table literal; only known item fields; no function calls;
       every item has a source URL and verified=false; size under a cap
  -> copy to bridge/overlay/ only if validation passes; log the briefing and the result JSON
```

Design rules:

- **The coach proposes, the player disposes.** The daemon never writes `Overlay.lua`. It writes
  `Overlay.pending.lua`. The addon loads both files, shows pending items in a "Proposed by your
  coach" section, and `/lc accept` (per item or all) promotes them into SavedVariables. Review
  happens in game, where the context is, with no terminal involved.
- **Data in, data out.** The coach's only write permission is the overlay directory. It gets no
  Bash tool. Fetched web pages are untrusted input; the permission rules and the validator are
  the defense against a page that tries to steer the model.
- **Idempotent and boring.** Rate-limit to a few runs per hour, keep the last N briefings, and
  make every failure leave the previous overlay in place. If the daemon is down, the static plan
  in the addon keeps working.

## 4. The `/coach` skill

Lives in this repo at `.claude/skills/coach/SKILL.md`, so it works both from the daemon and
interactively in any Claude Code session on the repo. Its contract:

- **Input:** path to `snapshot.json`; the repo's `data/` YAML; the current `Overlay.pending.lua`
  if any.
- **Steps:** read the snapshot; compute the level band and what is overdue; check which goals
  are active; research only the gaps (next band, missed class quests, dungeons in range, zone
  move) against an allowlist of guide domains; write items in the project's schema with a
  `why`, a `where`, a source URL and `verified: false`; write a short Markdown briefing.
- **Output:** `Overlay.pending.lua` and `briefing.md`. Nothing else.

Headless facts this relies on, from the Claude Code docs (checked 2026-11-08):

- `claude -p "/coach ..."` is the documented way to invoke a project skill non-interactively;
  CLAUDE.md, skills and hooks load in `-p` mode (not with `--bare`).
- `--allowedTools` takes rule syntax such as `Edit(//abs/path/**)` and `WebFetch(domain:x)`;
  `--permission-mode dontAsk` denies anything not pre-approved instead of hanging;
  `--permission-prompts none` tells the model not to retry denied actions.
- `--output-format json` returns the result, session id and metadata for logging.
- `--dangerously-skip-permissions` is documented for isolated containers only; it is not
  appropriate for a daemon that reads the web.

## 5. Authentication and terms

- The subscription login is the default credential for Pro and Max users, and `-p` mode uses it.
  For an unattended daemon, `claude setup-token` issues a one-year OAuth token that the daemon
  can hold in its environment.
- `ANTHROPIC_API_KEY` outranks the login whenever it is set, and in `-p` mode it is always used
  when present. The daemon must run with that variable unset.
- The docs say third-party products may not offer claude.ai login or rate limits, including
  agents built on the Claude Agent SDK, and must use API keys. They do not state whether a
  person's own local automation under their own login is covered. This is a gray area to read
  up on before the daemon runs unattended; if Level Coach is ever shared with other players, the
  companion becomes B2 with API keys.
- A login can expire. The daemon should recognize the "Login expired" result and notify rather
  than retry.
- The Python Agent SDK (`claude-agent-sdk`) is documented with an API key; the docs do not say
  it accepts the local login. That is why the daemon shells out to `claude -p` instead.

## 6. Failure modes and UX

| Situation | Behavior |
|---|---|
| Daemon or bridge down | Nothing changes in game; static plan continues; the panel shows the age of the last coach update |
| Coach output fails validation | Not published; logged; previous pending file kept |
| Overlay older than the character's state (player leveled past it) | Addon marks the pending section as stale and hides items whose window has passed |
| Player never reloads | Export never updates; the coach never runs; the addon can suggest `/reload` on level-up or at logout time |
| Research finds nothing new | Coach writes an empty overlay and a briefing saying so; no reload nag |

## 7. Phases

- **Phase A, manual coach.** Bridge in place; Brendon runs `/coach` interactively in Claude Code
  on the Linux box and reviews the briefing. Proves the value and tunes the skill before any
  automation exists.
- **Phase B, daemon.** Watcher, validator, pending overlay, `/lc accept` in the addon.
- **Phase C, optional.** Cloud scheduled coach via Dropbox, if the daemon ever feels like a chore.

## 8. Open questions

1. Dropbox or Syncthing for the bridge? (Dropbox if it is already on both machines.)
2. Should low-risk proposals (for example "train new rank of Corruption") auto-accept, or does
   everything go through `/lc accept`? Default: everything, until trust is earned.
3. Is the Windows PC usually on with the sync client running while Brendon plays? (Yes is
   implied, but the Linux box also needs to be on for the coach to run.)

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
