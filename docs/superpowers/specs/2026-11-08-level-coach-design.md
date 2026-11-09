# Level Coach: design brainstorm

**Status:** Draft v0.3, 2026-11-09. Brainstorm output plus Brendon's decisions from two rounds
(§0). Not yet an approved design: nothing gets built until Brendon approves this document and
the companion note `2026-11-08-coach-agent-architecture.md`. After approval the next step is an
implementation plan (Superpowers `writing-plans`), not code.

**Game:** World of Warcraft: Forever (Blizzard's permanent vanilla-based "Classic+" branch,
launched 2026-11-04, level cap 60).

---

## 0. Decisions so far (2026-11-08)

Brendon answered the first round of questions. These are now constraints, not options:

| Topic | Decision |
|---|---|
| Approach | A (static coach) now, with B1 (Claude Code on the existing subscription, no API key) designed in. The "agent server" shape is explored in `2026-11-08-coach-agent-architecture.md`. |
| First character | Undead Affliction Warlock. All v1 content targets it. A pre-prepared 1-60 guide distilled from current Forever sources lives in `docs/guides/undead-affliction-warlock.md` and seeds the data files. |
| Other addons | None installed yet. Recommendations for a leveling warlock are in the guide document. Level Coach stays a checklist and does not do routing. |
| Licensing | No preference yet. Default: original text, linked sources, compatibly licensed data only. |
| Distribution | Personal use while the concept is worked out. No CurseForge packaging, no library vendoring beyond what the UI needs. |
| Machines | Game on Windows. Development on Linux. The addon is deployed to the Windows PC; the coach runs on Linux. |
| Lua tooling | Not installed. Lua tests run from pytest through `lupa`, which embeds Lua 5.1 (verified 2026-11-08: `lupa` 2.8 exposes `lupa.lua51` and ships Linux and Windows wheels). No separate Lua install needed. |
| Bridge between machines | **GitHub.** A separate private repository (`level_coach_sync`) carries the export and the coach's overlay, because `level_coach` is public. Dropbox is the fallback. Details in the architecture note. |
| Hardcore | Out of scope. No Hardcore items and no safety profile in the interview. |
| Coach proposals | Three trust tiers. `info` items (derived from the character's own state and shipped data) auto-accept; `suggest` and `plan` items wait for `/lc accept`. |

## 1. Intent

Brendon is a brand-new WoW player on a brand-new version of the game. The pain: constantly
alt-tabbing out to leveling-guide websites. The wish: an in-game assistant that reads the
character's real state (level, class, zone, quests, skills, gold...) and shows a short
checklist of what to do *now*, for *this* character, given *their* goals. It starts by asking
what the player wants out of the game, builds an initial plan, and keeps revising that plan
as the character progresses.

The central framing decision from this brainstorm: **Level Coach is a coach, not a GPS.**
Routing addons (RestedXP, Zygor, Questie) already answer "which quest next, and where".
Level Coach answers the other question players tab out for: "what should I be taking care
of at this level that I would otherwise have to look up", in the player's own terms (goals),
with items that tick themselves off when the game state proves they are done.

## 2. Context and findings

### 2.1 WoW Forever facts that shape the design

- Launched Nov 4, 2026 as a third branch alongside Modern WoW and Classic. Vanilla setting,
  level cap 60, no flying, no level scaling. Rulesets (Normal, PvP, RP; Hardcore later)
  replace realm selection.
- It is *not* 2019 Classic. Blizzard describes new quests, zones, dungeons, raids and
  systems. Fan sites count 1,000+ new quests and nine new five-player dungeons spanning
  levels 13 to 60; talents start at level 10; mounts follow a TBC-style model (the riding
  skill grants the mount); there is an account-wide "Legacy" perk tree; itemization and
  classes were revised. (Fan-site details are unverified; Blizzard's own article is the
  authoritative source.)
- **Consequence 1:** Classic-era leveling knowledge is a partially wrong map. Every guide
  item, whether written by a human or an AI, needs Forever-specific verification.
- **Consequence 2:** Guide content for Forever is being written *this week*. Any LLM's
  training data predates the game. An AI that "knows Forever" does not exist; it would need
  grounding in live sources, and it would still be guessing about things nobody has
  documented yet.
- **Consequence 3:** Everyone is a new player right now. A coach that explains *why*
  ("set your hearth here because...") is valuable to veterans too, not just to Brendon.

### 2.2 The addon sandbox: hard constraints

- WoW addons are Lua 5.1 running in a sandbox with **no network, no filesystem, no OS
  access**. An addon cannot call a web API. This is a wall, not a hurdle.
- Data gets *in* only through files loaded at UI load time (the addon folder's `.lua`/`.xml`
  files and SavedVariables), both read at login or `/reload`. Data gets *out* only through
  SavedVariables, written at logout or `/reload`.
- Therefore any AI or network component must live **outside the game**, and its output
  reaches the addon only as a file the player picks up with a `/reload`. TradeSkillMaster's
  desktop app works exactly this way: it writes an `AppData.lua` into a helper addon folder,
  and the addon reads it on the next load.
- Forever runs the **modern (12.x-era) API** with TOC `## Interface: 16001` (game version
  1.60.1). Classic Era addons (`11509`) do not simply work. Forever-only builds can ship as
  `Name_Forever.toc` or `Name_Camelot.toc`. Old globals like `GetSpellInfo` and
  `GetItemInfo` are replaced by `C_Spell` and `C_Item`; the combat log is largely closed to
  addons (irrelevant to us); Midnight-era combat restrictions apply (mostly irrelevant: we
  read quest, level, zone and skill state, none of which is combat-protected, to be verified
  in the client).
- Gameplay automation is against the Terms of Service. Level Coach only reads state and
  displays information.

### 2.3 What already exists, and the gap

| Addon | What it does | Status on Forever | Relationship to Level Coach |
|---|---|---|---|
| Questie | Quest objectives on the map, quest database | Supported since Questie 12.0.1 ("initial" support) | Complementary. Possible data source if its license allows. |
| RestedXP | Step-by-step speed-leveling routes 1-60 | Free addon works; levels 1-20 free, paid routes beyond | Complementary routing layer. We do not compete on routes. |
| Zygor | Hand-holding step routes (paid) | Planned for launch; shipping unconfirmed | Same as above. |
| GuideMaster | Free, open-source guide addon (claimed) | Unknown | Study for UI patterns. |
| Azeroth Auto Pilot | Retail routing; shut down end of Shadowlands, successor Azeroth Pilot Reloaded | Not applicable | Historical reference. |

**The gap:** none of these do goal-based, state-aware, per-level **checklists with
explanations**. They tell you where to go next. Nobody tells you "at 20 you should: train
these abilities, pick up your class quest, consider this dungeon because you said you want
to tank for friends, move your hearth, and keep your cloth for First Aid".

### 2.4 What the client can tell us about the character

Readable with confidence on the modern API (function names to verify in the Forever client;
the Atraeau dev-environment repo generates an API reference from the client's own export,
which is the fastest way to check):

- **Identity:** level, XP and rested XP, class, race, faction, name, ruleset.
- **Location:** zone and subzone text, map ID (`C_Map.GetBestMapForUnit`), map position
  (`C_Map.GetPlayerMapPosition`, nil inside instances), hearth location (`GetBindLocation`).
- **Quests:** current log (`C_QuestLog`), completed-quest flags
  (`C_QuestLog.IsQuestFlaggedCompleted`, `C_QuestLog.GetAllCompletedQuestIDs`).
- **Abilities:** known spells (`IsPlayerSpell`, `C_Spell`), talents (talent API flavor
  to be determined), riding skill.
- **Skills and professions:** vanilla-style skill lines versus retail `GetProfessions`,
  whichever Forever exposes; weapon skills if Forever kept them.
- **Economy and inventory:** gold, bag count and slots, equipped items
  (`GetInventoryItemLink`), item details via `C_Item`.
- **Social:** group or raid membership, guild.
- **Reputation**, and total **play time** (`RequestTimePlayed`).

Not directly readable: known flight paths (only while the taxi map is open, so we record
them when the player opens it), dungeon completion (infer from quest completion and zone
visits), mob levels (only for the current target, which is enough for scout mode, §5.8).

Events to react to: `PLAYER_ENTERING_WORLD`, `PLAYER_LEVEL_UP`, `ZONE_CHANGED_NEW_AREA`,
`QUEST_TURNED_IN`, `QUEST_LOG_UPDATE`, `SPELLS_CHANGED`, `SKILL_LINES_CHANGED`,
`PLAYER_MONEY`, `BAG_UPDATE_DELAYED`, `HEARTHSTONE_BOUND`, `TAXIMAP_OPENED`,
`GROUP_ROSTER_UPDATE`, and `PLAYER_REGEN_ENABLED` to defer UI work until out of combat.

### 2.5 API facts from community references (gathered 2026-11-08)

Digest in `docs/research/2026-11-08-addons-and-api.md`. All of it is "reported", none of it
Blizzard-documented, so Phase 0 probes each item in the live client.

- **Client identity.** Interface `16001`, game version 1.60.1, API family "Mainline 12.1.5".
  Confirm with `/dump select(4, GetBuildInfo())`. Forever's internal game-type name is
  "Camelot": `WOW_PROJECT_CAMELOT` (18 on build 70338) exists next to `WOW_PROJECT_MAINLINE`
  (1), so detect Forever with `WOW_PROJECT_ID == WOW_PROJECT_CAMELOT` behind a nil guard, never
  with a Classic check. `C_GameRules.GetForeverExperiencePreset()` doubles as a capability probe.
- **TOC.** `## Interface: 16001`; a Forever-only file can be `Name_Camelot.toc` or
  `Name_Forever.toc`, or a shared TOC can use `[AllowLoadGameType camelot]`. Level Coach is
  Forever-only, so a single TOC with the interface line is enough.
- **Removed globals we would have reached for.** `GetSpellInfo` becomes `C_Spell.GetSpellInfo`
  (returns a table, nil until loaded; request with `C_Spell.RequestLoadSpellData` and listen
  for `SPELL_DATA_LOAD_RESULT`); `GetItemInfo` becomes `C_Item.GetItemInfo` (same async
  pattern with `ITEM_DATA_LOAD_RESULT`); talents live on `C_Traits`; `GetAddOnMetadata`
  becomes `C_AddOns.GetAddOnMetadata`; `GetNumSkillLines` is gone with no replacement named,
  so the skill-line detector (First Aid, professions) must be probed in Phase 0 and may need
  the retail profession functions.
- **Secret values.** Midnight's combat restrictions apply: unit health, names and some
  booleans can be "secret" in combat; arithmetic or comparison on them throws. Level Coach
  reads out-of-combat state, so the rule is simply: refresh the panel on
  `PLAYER_REGEN_ENABLED`, guard anything unit-derived with `issecretvalue`, and never touch the
  combat log (registering `COMBAT_LOG_EVENT_UNFILTERED` throws).
- **SavedVariables.** Loaded after the addon's files and before that addon's `ADDON_LOADED`;
  create and read the DB inside `ADDON_LOADED`, do a final write on `PLAYER_LOGOUT`. A beta
  build had a restore bug; retest on live.
- **Protected calls fail silently** (no error, `pcall` does not help). Relevant to us:
  `C_SuperTrack.SetSuperTrackedUserWaypoint` is protected, but `C_Map.SetUserWaypoint` with a
  `UiMapPoint` works, which gives Level Coach a built-in map pin for every "where" without
  TomTom. TomTom stays an optional nicety.
- **Libraries.** AceDB's region lookup broke on Forever (`GetCurrentRegion()` returned an
  unknown id). One more reason the core avoids Ace3; if AceGUI is ever vendored, vendor only it.
- **Lua.** Modified 5.1: no `goto`, no bitwise operators (use `bit.*`), no `os`, `io`,
  `require` or `loadfile`; the TOC is the module loader; every file starts
  `local addonName, ns = ...`. Named frames are globals, so prefix them.
- **Policy.** Blizzard requires addons to be free with no premium tier or hidden code. Level
  Coach is free and open; the coach runs outside the game and is personal tooling.

## 3. Goals, non-goals, anti-goals

### Goals (v1)

1. **First run interview.** Three to six in-game questions produce a goal profile and an
   initial plan. Re-offered at milestone levels (10, 20, 30, 40, 50) or on demand.
2. **Always-current checklist.** Sections Now / Soon / Overdue / Done, re-evaluated on
   every relevant state change. Items auto-complete whenever the game state can prove it.
3. **Every item explains itself.** A one-line title, a "why" expansion, a "where" with an
   optional waypoint (TomTom if present), and a copyable source link.
4. **Content is data, not code.** Guide items live as YAML in the repo and compile to Lua.
   Fixing a wrong item is a data pull request. AI-assisted authoring happens at dev time.
5. **Breadcrumbs.** The addon records what the player did, at which level, where, and
   exports it via SavedVariables. The first character's playthrough seeds guide data for
   alts and for the community, with zero copyright exposure.
6. **Zero configuration, zero network, zero cost** to run.

### Non-goals (v1)

- Quest-by-quest routing and arrows. Use RestedXP, Zygor or Questie; integrate, do not
  compete.
- Real-time AI chat inside the game. Impossible in the sandbox.
- Covering every class, race and goal combination on day one. Go deep on Brendon's own
  character first; breadth comes from data contributions.
- Endgame guidance beyond "prepare for 60" items.

### Anti-goals (never)

- Anything that automates gameplay or reads protected data.
- An API key, or any secret, in the addon folder or in SavedVariables. Both are plain text
  and routinely get zipped, synced and uploaded.
- Guide text copied from Wowhead or paid guides. Write original summaries, link sources,
  and reuse only compatibly licensed data (for example CC BY-SA wiki content with
  attribution; check Questie's license before touching its database).
- Confidently wrong instructions. Items that have not been verified in Forever are marked
  as unverified in the UI.

## 4. Approaches considered

### A. Static Coach (recommended for v1)

A data-driven addon with no network component. Guide items are authored as YAML, validated
and compiled to Lua tables by a Python tool, and shipped inside the addon. Personalization
is rules-based: the goal profile plus class, race, faction and level select and rank items.
Completion detection runs against live game state.

- **Pros:** works on day one; zero cost and zero setup for the player; fully testable
  offline (pure-Lua engine, Python build tool); no hallucination risk; publishable on
  CurseForge or Wago; the authoring loop (notice a gap in game, edit YAML, rebuild,
  `/reload`) is minutes long.
- **Cons:** content authoring is the whole job. One person cannot cover every class in
  week one. Mitigated by scope (milestones, not routes), by breadcrumbs (§5.8), and by
  AI-assisted authoring at dev time.

### B. Static Coach plus an out-of-game AI companion (v2 path)

Everything in A, plus a Python companion that runs between play sessions: it reads the
addon's SavedVariables export (character snapshot, checked and skipped items, notes),
researches with web sources, and writes a plan overlay file into the addon folder. The
player types `/reload` and the overlay merges into the checklist.

Two flavors:

- **B1. Claude Code skill in this repo.** `/coach` (or a plain prompt) reads the export,
  does the research with web search, proposes the overlay, Brendon reviews, it writes the
  file. No API key: it runs on the existing Claude Code subscription. Zero extra software.
- **B2. Standalone Python app.** Same job via the Anthropic Python SDK, so it can run
  without Claude Code open, or ship to other players (who then need their own key).

- **Pros:** genuine personalization from real play data; the research happens where
  research is possible (outside the game); the human stays in the loop before anything
  reaches the UI.
- **Cons:** `/reload` round trip; LLM knowledge of Forever is thin, so grounding and
  review are mandatory; B2 adds key handling, cost, and a second codebase.

### C. AI-first thin client (not recommended now)

The companion generates the entire plan per character; the addon only renders it.

- **Pros:** maximum flexibility; minimal in-game logic.
- **Cons:** every item is an unverified LLM claim about a four-day-old game; nothing works
  without the companion and a key; the reload loop becomes the primary UX; untestable
  content; not publishable to other players without them paying per plan.

### Trade-off summary

| | A. Static Coach | B. A + companion | C. AI-first |
|---|---|---|---|
| Works offline, day one | Yes | Yes (A core) | No |
| Player setup | None | Python or Claude Code | Python + API key |
| Content accuracy | Curated, verifiable | Curated + reviewed proposals | Unverified by default |
| Personalization depth | Goal profile + rules | Adds play-history reasoning | Maximum |
| Authoring burden | High (the whole job) | Lower (AI drafts, human verifies) | Lowest |
| Publishable to others | Yes | Yes (companion optional) | Hard |
| Running cost | None | Subscription (B1) or cents per update (B2) | Per plan |

### Recommendation

**Build A, with the overlay-file seam designed in from the start so B is purely additive.**
Start B1 as soon as A produces an export worth reading, because it also solves A's biggest
cost: AI-drafted, human-verified content. Skip C.

**Decision (2026-11-08):** confirmed by Brendon, with B1 as the companion flavor.

## 5. Proposed design (Approach A, B-ready)

### 5.1 Player experience

**First login with the addon.** A small wizard frame opens:

1. "What do you want most from this character?" Reach 60 efficiently / Experience the
   story and new content / Run dungeons with friends / Prepare for raiding at 60 / Learn
   the game at my own pace.
2. "How much guidance?" Milestones and reminders only / Also suggest which zone to be in.
3. "Professions?" Make gold / Craft my own gear / Skip for now.
4. "Dungeons?" Every dungeon at level / When convenient / Avoid.
5. "PvP interest?" Yes / No. (Hidden unless the ruleset is PvP or the goal mentions it.)
6. "Typical session length?" Under an hour / One to three hours / Longer.

Answers become the **goal profile**. The plan appears immediately.

**Daily loop.** The checklist panel sits where the player docks it. Items tick themselves
off (train abilities, learn a profession, complete a class quest, set hearth) or get ticked
manually. Expanding an item shows why it matters and where to go. A level-up re-evaluates
the plan and briefly highlights what changed.

**Plan updates over time.** Three mechanisms, in order of arrival:

1. Automatic re-evaluation on state changes (level, zone, quests, skills, gold, group).
2. A one- or two-question check-in at milestone levels ("Still aiming for raid prep?
   Anything changed?"), plus skip / snooze / "not for me" on any item, which feed back into
   ranking.
3. New data: addon updates (shipped YAML), and later the companion's overlay file.

### 5.2 Plan model

```
GoalProfile  + CharacterSnapshot  ->  Engine.evaluate(data)  ->  Checklist
(interview)    (State.lua, live)       (pure Lua, testable)      Now / Soon / Overdue / Done
```

- **Now:** items whose level window includes the current level, filtered by class, race,
  faction, ruleset and goals, ranked by priority and by zone proximity.
- **Soon:** items opening within the next five levels, as a preview.
- **Overdue:** items whose window has passed, still undone and still achievable (a missed
  class quest). Shown with a warning, never silently dropped.
- **Done:** collapsed; auto-completed or manually checked, with the detection reason.

### 5.3 Content data model

Authored in YAML (human-friendly, diffable, PR-able), compiled to Lua by `tools/build_data.py`.

```yaml
- id: warrior-defensive-stance
  title: Complete the Defensive Stance quest
  why: >
    At level 10 your class trainer offers a short quest chain that unlocks Defensive
    Stance. You need it to tank dungeons, and it is easy to miss if you leave the
    starting region.
  level: {min: 10, max: 60}      # window; after max it goes to Overdue if undone
  classes: [WARRIOR]
  factions: [Alliance, Horde]
  goals: [any]                   # or [dungeons, raid-prep, ...]
  priority: high
  where:
    Alliance: {zone: Elwynn Forest, npc: Lyria Du Lac, waypoint: [43.6, 65.6]}
    Horde:    {zone: Durotar, npc: Thun'grim Firegaze, waypoint: [47.6, 11.8]}
  done_when: {spell_known: 71}   # Defensive Stance
  verified: {forever: false, by: null, date: null}   # shows "unverified" in UI until true
  sources:
    - https://warcraft.wiki.gg/wiki/...
```

(Values above are illustrative placeholders from Classic, not verified Forever data.)

Supporting tables: zones (faction, level band, neighbors, flight masters), dungeons (level
band, entrance zone, notable quests), class trainers and spell level-ups, profession
tiers, and the goal profile schema.

### 5.4 Completion detectors

Each `done_when` is one of a small set of detectors implemented once in Lua:

| Detector | Source | Example |
|---|---|---|
| `quest_complete: id` | `C_QuestLog.IsQuestFlaggedCompleted` | Class quest done |
| `spell_known: id` | `IsPlayerSpell` / `C_Spell` | Trained a rank, learned riding |
| `skill_line: {name, min}` | Skill-line or profession API (to be probed; `GetNumSkillLines` is gone) | First Aid at 75 |
| `level_at_least: n` | `UnitLevel` | Window gating |
| `bind_location: zone` | `GetBindLocation` | Hearth moved |
| `has_item: id` | Bag scan via `C_Item` | Bought bags, carrying a Hearthstone |
| `money_at_least: copper` | `GetMoney` | Saving for riding skill |
| `zone_visited: mapID` | Recorded by the addon | Discovered a hub |
| `taxi_known: node` | Recorded on `TAXIMAP_OPENED` | Flight path learned |
| `manual` | Player click | "Read the dungeon's boss notes" |

Unknown or failing detectors degrade to `manual` instead of erroring.

### 5.5 Architecture and repository layout

```
level_coach/
  LevelCoach/                    # the addon (what gets zipped and installed)
    LevelCoach.toc               # ## Interface: 16001
    Libs/                        # vendored libraries, if any (see 5.6)
    Core/
      Init.lua                   # addon table, SavedVariables defaults, slash commands
      State.lua                  # WoW API -> plain CharacterSnapshot table
      Detectors.lua              # done_when implementations
      Engine.lua                 # pure Lua: (snapshot, goals, data) -> checklist
      Goals.lua                  # interview flow and goal profile
      Breadcrumbs.lua            # scout mode recorder (5.8)
    Data/
      Items.lua                  # GENERATED from data/*.yaml, do not edit
      Zones.lua                  # GENERATED
      Overlay.lua                # accepted coach items (the B seam); empty by default
      Overlay.pending.lua        # coach proposals, copied in from the private sync repo;
                                 # info tier auto-applies, others wait for /lc accept
    UI/
      Panel.lua                  # checklist frame
      Wizard.lua                 # interview frame
      Minimap.lua                # button, optional
  data/                          # YAML source of truth for guide content
    items/*.yaml  zones.yaml  dungeons.yaml  schema.json
  tools/                         # Python, Brendon's home turf
    build_data.py                # YAML -> Lua, with validation
    export_reader.py             # parse SavedVariables for the companion / analysis
    (coach.py)                   # v2 companion, B2 flavor
  tests/
    lua/                         # Engine and Detectors specs, executed through lupa (Lua 5.1)
    python/                      # pytest for the tools, plus the runner for tests/lua
  docs/superpowers/specs/        # this document and its successors
  .github/workflows/ci.yml       # luacheck + lua tests + pytest + build + package zip
```

Design rules that make this testable:

- `Engine.lua` and `Detectors.lua` never call the WoW API directly. `State.lua` produces a
  plain table; detectors receive that table. Tests feed hand-written snapshots.
- Run Lua tests on **Lua 5.1** (the client's dialect) through `lupa.lua51` from pytest, so one
  `pytest` run covers both languages and nothing extra is installed on either machine.
- `Data/*.lua` are build outputs. CI fails if they are out of date with `data/`.

### 5.6 Libraries and compatibility

- **TOC:** `## Interface: 16001`, bumped after client patches. Players may need "Load out
  of date AddOns" after a patch until we bump.
- **Ace3 / LibDBIcon / LibDataBroker:** in use by at least one Forever addon, so they load,
  but exact Forever-tested versions are unverified. Default: **no framework for the core**
  (plain frames keep the dependency surface tiny); add `LibDBIcon` for the minimap button
  and `AceGUI` only if the wizard gets complicated.
- **Waypoints:** the built-in user waypoint (`C_Map.SetUserWaypoint`) is the default "where"
  pin, so every item can place a pin with no dependency. **TomTom** (Forever file exists, v4.3.13
  of Oct 24) is used for the follow arrow when present.
- **Packaging:** BigWigs packager (the standard GitHub Action) produces CurseForge/Wago
  zips and handles library pulls if we vendor via `.pkgmeta`.
- **Dev loop (Linux dev, Windows game):** the repo is cloned on the Windows PC too, with
  `Interface/AddOns/LevelCoach` as an NTFS junction to the clone's `LevelCoach/` folder. After
  a push from Linux, a one-click `git pull` on Windows and `/reload` in game picks up the
  change. Guides show the Forever flavor folder as `_forever_` (it was `_classic_beta_` during
  beta); confirm in the live install. Install BugSack and BugGrabber for error capture.

### 5.7 UI sketch

```
+-- Level Coach ---------------------------------------- [gear] [-] +
| Lv 14 Warrior . The Barrens . Goal: Learn the game                 |
+--------------------------------------------------------------------+
| NOW                                                                |
| [x] Train new abilities at your class trainer          auto        |
| [ ] Set your hearth in Crossroads                      [pin] why?  |
| [ ] Buy bags until all four slots are filled           why?        |
| [ ] Class quest: Defensive Stance (from level 10)      [pin] why?  |
| SOON (15-19)                                                       |
|  .  Wailing Caverns is in range for your dungeon goal              |
|  .  First Aid: Journeyman at 125 skill                             |
| OVERDUE                                                            |
| [!] Nothing. Nice.                                                 |
+--------------------------------------------------------------------+
  /lc           toggle panel        /lc setup   redo the interview
  /lc skip <n>  hide an item        /lc export  flag a snapshot for the companion
```

(Illustrative content, not verified Forever data.)

### 5.8 Breadcrumbs (scout mode) and the SavedVariables export

The addon records, per character, a compact event log: level-ups (where, play time),
zone entries, quests accepted and turned in (ID, level, zone), trainers visited, flight
paths learned, hearth changes, dungeon entries, target mob levels per zone. It also stores
the goal profile, manual checks, skips and snoozes.

Uses:

- **For alts:** "my Warrior did X at level 14 in the Barrens" becomes a draft item.
- **For content authoring:** `tools/export_reader.py` turns the log into YAML drafts to
  review. This is how one person covers more than one class over time.
- **For the companion (B):** the same file is the companion's input.

Privacy: everything stays local. The export contains character name and play data; the
companion only sends what the player allows, and B1 keeps it on Brendon's machine.

## 6. The AI and API-key question

**Inside the game: no.** The sandbox has no network. No key can be used from Lua, and no
amount of cleverness changes that. The question is only whether an AI runs *beside* the
game.

**Where it would live, and what it would do (Approach B):**

1. Read the SavedVariables export after a session.
2. Research the next level band with live web sources, because the model's own knowledge
   of Forever is unreliable (the game is days old).
3. Propose plan overlay items and plain-language notes ("you skipped both dungeons in your
   range; if the goal is still dungeons-with-friends, Wailing Caverns is the next window").
4. The coach commits `Overlay.pending.lua` to the private sync repo; the Windows watcher copies
   it into the addon folder. `info` items apply on load; Brendon promotes the rest in game with
   `/lc accept`.
5. `/reload` in game.

**Key handling, if B2 (standalone Python) is chosen:**

- Use the official `anthropic` Python SDK. Credentials come from `ANTHROPIC_API_KEY` in the
  environment or an `ant auth login` profile. Never from a file in the WoW folder, never in
  SavedVariables, never committed to this repo.
- Default model per Anthropic's current guidance: `claude-opus-5-5` (list price 4 USD per
  million input tokens, 20 USD per million output tokens). A plan update that sends roughly
  20k tokens of snapshot and sources and gets back roughly 3k tokens of plan costs on the
  order of 0.15 USD. A leveling journey of thirty updates is a few dollars.
- Enable web search grounding and ask the model to cite sources per item; the addon shows
  the source link, and the `verified` flag stays false until a human confirms in game.

**B1 (Claude Code skill) needs no key at all** and is the faster route to the same value,
because Brendon already runs Claude Code against this repo. It also makes the AI the content
author's assistant rather than the player's dependency, which is where it is most reliable
right now.

**Recommendation:** no runtime AI in v1. Design the overlay seam and the export in v1. Do
B1 first when the export exists; consider B2 only if the companion should run for other
players without Claude Code.

## 7. Risks and mitigations

| Risk | Mitigation |
|---|---|
| Forever API differs from expectations (skill lines, talents, quest APIs) | Phase 0 spike probes the client; detectors degrade to manual; Atraeau's generated API reference as lookup |
| Interface number bumps break loading after patches | CI builds a release on tag; bump TOC promptly; document "Load out of date AddOns" |
| Content is wrong or stale for Forever | `verified` flag per item, visible in UI; sources linked; breadcrumbs provide ground truth; fast data-fix loop |
| Authoring burden overwhelms one person | Milestones not routes; start with Brendon's class and faction; breadcrumb-to-YAML drafts; AI-assisted drafting with human verification |
| Copyright or license problems from reusing guide data | Original text only; attribute CC BY-SA sources; check Questie's license before any reuse |
| Players confuse Level Coach with a routing addon | Positioning and README: "works alongside RestedXP / Questie"; optional zone hints only |
| Scope creep toward in-game AI | This document's anti-goals; the sandbox makes it moot anyway |

## 8. Open questions

Rounds one and two (approach, character, routing addons, companion flavor, licensing,
distribution, dev setup, bridge, Hardcore, acceptance policy) are answered; see §0. Remaining:

1. **Goal profile and ruleset.** The interview answers for this character (§5.1), so the first
   dataset is ranked for the way Brendon actually plays. Proposed defaults, to confirm or edit:
   main aim "Learn the game at my own pace" with "Experience the story and new content" second;
   guidance "milestones plus zone suggestions" until a routing addon is installed; professions
   "Tailoring and Enchanting" (the guides' default for a warlock); dungeons "when convenient";
   PvP "no"; sessions "one to three hours". Ruleset (Normal, PvP or RP) is not yet known and
   decides whether PvP items appear at all.
2. **Approval.** This document and the architecture note, so the implementation plan can be
   written.

## 9. Roadmap sketch (phases, not a plan)

- **Phase 0, spike (hours):** a `## Interface: 16001` addon that prints level, zone, map
  ID, completed-quest count, known-spell count and skill lines to chat. Probe the API
  names in §2.4. Throwaway; it only answers questions.
- **Phase 1, engine and data (days):** YAML schema, `build_data.py` with validation and
  tests, `Engine.lua` and `Detectors.lua` with Lua tests via lupa, a first dataset for the
  Undead Affliction Warlock covering levels 1 to 20, seeded from the guide document.
- **Phase 2, UI (days):** checklist panel, interview wizard, slash commands, SavedVariables,
  TomTom hook. First real use in game.
- **Phase 3, breadcrumbs (days):** recorder, export, `export_reader.py` producing YAML
  drafts. Extend data to 60 as Brendon levels.
- **Phase 4, companion B1 (days):** the `/coach` skill, the file bridge, then the daemon,
  as laid out in `2026-11-08-coach-agent-architecture.md`. Proposals land in
  `Overlay.pending.lua` and are accepted in game.
- **Later:** B2 if other players want the companion; CurseForge release; Legacy-system
  awareness for alts.

## 10. Sources

- Blizzard, "WoW: Forever, What's New and What Feels Familiar":
  https://news.blizzard.com/en-us/article/24315821/wow-foreverwhats-new-and-what-feels-familiar
- Windows Central on the Nov 4 launch:
  https://www.windowscentral.com/gaming/blizzard/blizzard-confirms-world-of-warcraft-forever-is-the-biggest-launch-in-wow-history-beating-wrath-of-the-lich-king-is-wow-retail-cooked
- Warcraft Wiki, World of Warcraft: Forever: https://warcraft.wiki.gg/wiki/World_of_Warcraft:_Forever
- Mobalytics, WoW Forever explained: https://mobalytics.gg/wow-forever/guides/wow-forever-explained
- WoW Forever addon API cheat sheet (Interface 16001, C_Spell, C_Item):
  https://wowforeverguides.com/addons/api-cheatsheet and https://wowforeverguides.com/addons/developers
- Atraeau/WoW-Addons, Forever addon dev environment with generated API reference:
  https://github.com/Atraeau/WoW-Addons
- Questie repository (Forever TOC present): https://github.com/Questie/Questie
- Addon sandbox restrictions: https://wow-midnight-addon-template.vercel.app/security/
- Midnight addon changes: https://www.wowhead.com/news/addon-changes-for-midnight-launch-ending-soon-with-release-candidate-coming-380133
- Warcraft Wiki API reference: https://warcraft.wiki.gg/wiki/World_of_Warcraft_API
- TradeSkillMaster desktop app (file-sideload pattern): https://www.tradeskillmaster.com/app
- RestedXP on Forever: https://kami-labs.fr/en/wow-forever/restedxp-wow-forever-guide-leveling/
- Forever addon compatibility lists: https://endgametools.com/en/wow-forever/news/wow-forever-addons
  and https://forevermastery.com/en/addons/forever-compatibility
- Superpowers (brainstorming process followed here): https://github.com/obra/superpowers
