# Level Coach: implementation plan, Phase 0 (API probe) and Phase 1 (engine and data)

> For agentic workers: REQUIRED SUB-SKILL: Use superpowers:executing-plans (or
> superpowers:subagent-driven-development if that execution method is chosen). Steps are
> checkboxes; tick them as you go. Follow the TDD order in each task.

**Execution status (2026-11-09, native):** Tasks 1, 2, 5 to 12 implemented and green (70 tests,
luacheck clean, data check current). Task 3 and Task 4 wait for Brendon at the game PC: the deploy
page and the probe-results template exist, the probe has not run. Task 11's in-game check and
Task 12's first CI run are also pending the game PC and the next push. A whole-branch review found
ten issues, all fixed in the follow-up commit.

**Goal:** a WoW: Forever addon whose pure-Lua engine turns a character snapshot plus a goal
profile into a Now / Soon / Overdue / Done checklist from YAML-authored guide data, with the
data pipeline, tests and CI in place, and the live client's API probed first.

**Architecture:** `LevelCoach/` is the addon (Lua 5.1, Interface 16001). `Core/Engine.lua` and
`Core/Detectors.lua` never call the WoW API; `Core/State.lua` builds a plain snapshot table from
it. Guide content lives as YAML under `data/` and is compiled to `LevelCoach/Data/*.lua` by
`tools/build_data.py`. Tests run from pytest, with Lua executed in-process through `lupa`.

**Tech stack:** Lua 5.1 (WoW client), Python 3.11+ (`lupa`, `PyYAML`, `jsonschema`, `pytest`),
GitHub Actions (pytest, `build_data.py --check`, luacheck).

**Spec:** `docs/superpowers/specs/2026-11-08-level-coach-design.md` (design) and
`docs/superpowers/specs/2026-11-08-coach-agent-architecture.md` (companion).

**Global constraints (from the spec):**
- Addon TOC declares `## Interface: 16001`; every Lua file starts `local addonName, ns = ...`.
- Engine and Detectors take plain tables only; unknown detector types return `nil`, never error.
- Checklist sections: `now`, `soon` (opens within 5 levels), `overdue` (window passed, undone),
  `done`. Priority order `high`, `normal`, `low`; within a priority, items in the current zone first.
- Every data item carries `verified: {forever: false}` until a human confirms it in game.
- No secrets anywhere in the addon folder or SavedVariables. No combat-log registration.
- Target character: Undead (race file name `Scourge`) Warlock, Horde, PvP ruleset. Goal defaults
  as in the design doc §0.

**Review focus (likely failures, each with the task that tests it):**
- Forever renamed or renumbered spells (Bane of Agony, Healthstone ranks): spell IDs are
  probed by name before use (Task 2) and the data build rejects an item whose ID lacks a probe
  note (Task 6).
- An item with no class filter leaking to every class, or a Horde item showing to Alliance:
  applicability tests in Task 8.
- Overdue items vanishing instead of surfacing: Task 8 test `overdue_surfaces_missed_class_quest`.
- A YAML typo producing a broken Lua file that kills the addon at load: Task 6 generates and
  Task 7 compiles every generated file through `loadstring` in the test harness.
- Detector called with data the client cannot provide (secret values, missing API): Task 9 uses
  `pcall` around every API call and the engine treats `nil` as "manual".

---

## Phase 0: scaffolding and the API probe

### Task 1: Repository scaffolding and Python toolchain

**Files:**
- Create: `pyproject.toml`, `.gitignore`, `.luacheckrc`, `tests/python/__init__.py`,
  `tests/python/test_smoke.py`, `docs/dev/setup.md`
- Test: `tests/python/test_smoke.py`

**Interfaces:** Produces the `lupa.lua51` runtime fixture used by every later Lua test
(`tests/python/conftest.py` is added in Task 7).

- [ ] **Step 1: write the failing test.** `tests/python/test_smoke.py`:
  ```python
  def test_lua51_runtime_available():
      from lupa.lua51 import LuaRuntime
      rt = LuaRuntime()
      assert rt.eval("_VERSION") == "Lua 5.1"
  ```
- [ ] **Step 2: run it, expect failure.** `python -m pytest -q` fails with `ModuleNotFoundError: lupa`.
- [ ] **Step 3: implement.** `pyproject.toml`:
  ```toml
  [project]
  name = "level-coach-tools"
  version = "0.0.1"
  requires-python = ">=3.11"
  dependencies = ["lupa>=2.8", "PyYAML>=6.0", "jsonschema>=4.20"]
  [project.optional-dependencies]
  dev = ["pytest>=8"]
  [tool.pytest.ini_options]
  testpaths = ["tests/python"]
  [tool.setuptools]
  packages = ["tools"]
  ```
  Add an empty `tools/__init__.py`. `.gitignore`: `.venv/`, `__pycache__/`, `*.pyc`, `.pytest_cache/`,
  `LevelCoach/Data/Overlay.pending.lua` is **not** ignored (it ships empty). `.luacheckrc`:
  ```lua
  std = "lua51"
  max_line_length = 120
  globals = { "LevelCoachDB", "LevelCoachCharDB", "SLASH_LEVELCOACH1", "SlashCmdList" }
  read_globals = { "CreateFrame", "UIParent", "C_Map", "C_QuestLog", "C_Spell", "C_Item",
    "C_Container", "C_Timer", "C_AddOns", "C_GameRules", "C_Traits", "UnitLevel", "UnitClass",
    "UnitRace", "UnitFactionGroup", "UnitName", "UnitXP", "UnitXPMax", "GetXPExhaustion",
    "GetMoney", "GetBindLocation", "GetZoneText", "GetSubZoneText", "GetRealZoneText",
    "GetRealmName", "GetBuildInfo", "IsPlayerSpell", "IsSpellKnown", "GetNumSkillLines",
    "GetSkillLineInfo", "GetProfessions", "GetProfessionInfo", "InCombatLockdown",
    "DEFAULT_CHAT_FRAME", "WOW_PROJECT_ID", "WOW_PROJECT_CAMELOT", "issecretvalue",
    "GetTime", "date", "time", "RequestTimePlayed", "NumTaxiNodes", "TaxiNodeName",
    "GetInventoryItemLink", "GetInventoryItemID", "wipe", "strsplit", "tinsert", "format" }
  ```
  `docs/dev/setup.md`: Linux setup (`python -m venv .venv && . .venv/bin/activate && pip install -e .[dev]`,
  `pytest`), the Windows deploy steps written in Task 3, and the note that no Lua install is needed.
- [ ] **Step 4: run it, expect pass.** `pip install -e .[dev] && python -m pytest -q` prints `1 passed`.
- [ ] **Step 5: commit.** `git add -A && git commit -m "feat: python toolchain with embedded Lua 5.1 for tests"`

### Task 2: Probe addon that reports the live Forever API

**Files:**
- Create: `LevelCoach/LevelCoach.toc`, `LevelCoach/Core/Init.lua`, `LevelCoach/Core/Probe.lua`
- Test: `tests/python/test_probe_syntax.py`

**Interfaces:** Produces `ns.Probe.run()` (prints and stores results) and the SavedVariables
global `LevelCoachDB` with `LevelCoachDB.probe` as a table of `{name = value}` strings. Later
tasks read `docs/research/api-probe.md`, written from this output in Task 4.

- [ ] **Step 1: write the failing test.** `tests/python/test_probe_syntax.py` compiles every file
  listed in the TOC with `loadstring` (no execution) and asserts the TOC declares 16001:
  ```python
  import re, pathlib
  from lupa.lua51 import LuaRuntime
  ROOT = pathlib.Path(__file__).resolve().parents[2] / "LevelCoach"

  def toc_files():
      toc = (ROOT / "LevelCoach.toc").read_text().splitlines()
      assert "## Interface: 16001" in toc
      return [ROOT / line.strip().replace("\\", "/") for line in toc
              if line.strip() and not line.startswith("#")]

  def test_every_toc_file_compiles():
      rt = LuaRuntime()
      load = rt.eval("function(src, name) local f, err = loadstring(src, name); assert(f, err); return true end")
      files = toc_files()
      assert files, "TOC lists no files"
      for path in files:
          assert path.exists(), path
          assert load(path.read_text(encoding="utf-8"), "=" + path.name)
  ```
- [ ] **Step 2: run it, expect failure.** `python -m pytest -q tests/python/test_probe_syntax.py`
  fails with `FileNotFoundError` on the TOC.
- [ ] **Step 3: implement.** `LevelCoach/LevelCoach.toc`:
  ```
  ## Interface: 16001
  ## Title: Level Coach
  ## Notes: A leveling coach: goal-based checklists from your character's real state.
  ## Author: Brendon Hall
  ## Version: 0.0.1
  ## SavedVariables: LevelCoachDB
  ## SavedVariablesPerCharacter: LevelCoachCharDB
  ## IconTexture: Interface\Icons\INV_Misc_Book_09
  Core\Init.lua
  Core\Probe.lua
  ```
  `Core/Init.lua` creates `ns.frame`, registers `ADDON_LOADED` and `PLAYER_LOGIN`, initializes
  `LevelCoachDB = LevelCoachDB or {}` and `LevelCoachCharDB = LevelCoachCharDB or {}` inside
  `ADDON_LOADED` (never at file scope), defines `ns.print(msg)` via
  `DEFAULT_CHAT_FRAME:AddMessage("|cff7fbfffLevel Coach|r " .. tostring(msg))`, and registers
  `/lc` with subcommand `probe` calling `ns.Probe.run()`. One frame, one `OnEvent`, a handler
  table keyed by event name.
  `Core/Probe.lua` exposes `ns.Probe.run()`. Every call is wrapped:
  ```lua
  local function try(label, fn)
    local ok, a, b, c = pcall(fn)
    local text = ok and table.concat({ tostring(a), tostring(b), tostring(c) }, " ") or ("ERR " .. tostring(a))
    LevelCoachDB.probe[label] = text
    ns.print(label .. " = " .. text)
  end
  ```
  and the probe list is, in this order: build (`select(4, GetBuildInfo())`, `WOW_PROJECT_ID`,
  `WOW_PROJECT_CAMELOT`, `type(C_GameRules and C_GameRules.GetForeverExperiencePreset)`,
  `C_GameRules.GetActiveGameMode()`, `GetRealmName()`); identity (`UnitLevel("player")`,
  `UnitClass("player")`, `UnitRace("player")`, `UnitFactionGroup("player")`); location
  (`GetZoneText()`, `GetSubZoneText()`, `C_Map.GetBestMapForUnit("player")`, and
  `C_Map.GetPlayerMapPosition(mapID, "player"):GetXY()`); quests
  (`C_QuestLog.GetNumQuestLogEntries()`, `#C_QuestLog.GetAllCompletedQuestIDs()`,
  `C_QuestLog.GetTitleForQuestID(id)` for each candidate ID in `ns.Probe.questIDs`);
  spells (`IsPlayerSpell(id)` and `C_Spell.GetSpellInfo(id).name` for each ID in
  `ns.Probe.spellIDs`); skills (`type(GetNumSkillLines)`, `type(GetSkillLineInfo)`,
  `type(GetProfessions)`, and if `GetNumSkillLines` exists, every skill line name and rank);
  talents (`type(C_Traits)`, `type(C_ClassTalents)`, `type(C_SpecializationInfo)`); economy
  (`GetMoney()`, `GetBindLocation()`, `GetXPExhaustion()`, `C_Container.GetContainerNumSlots(0)`);
  waypoints (`type(C_Map.SetUserWaypoint)`, `C_Map.CanSetUserWaypointOnMap(mapID)`); misc
  (`type(issecretvalue)`, `type(RequestTimePlayed)`, `type(NumTaxiNodes)`).
  Candidate IDs, all marked **verify** in the data: `ns.Probe.spellIDs = { 686, 348, 172, 702,
  688, 1454, 980, 5782, 1120, 6201, 697, 755, 689, 704, 5697, 693, 712, 706, 698, 1490, 691,
  5784, 687 }` (Classic IDs for Shadow Bolt, Immolate, Corruption, Curse of Weakness, Summon Imp,
  Life Tap, Curse of Agony, Fear, Drain Soul, Create Healthstone, Summon Voidwalker, Health Funnel,
  Drain Life, Curse of Recklessness, Unending Breath, Create Soulstone, Summon Succubus, Demon
  Armor, Ritual of Summoning, Curse of the Elements, Summon Felhunter, Summon Felsteed, Demon Skin).
  `ns.Probe.questIDs = { 1470, 1740, 1798 }` (Classic IDs believed to be Halgar's Summons,
  Devourer of Souls, Seeking Strahad). The probe also registers `TAXIMAP_OPENED` and stores
  `NumTaxiNodes()` plus each `TaxiNodeName(i)` into `LevelCoachDB.probe.taxi`.
- [ ] **Step 4: run it, expect pass.** `python -m pytest -q` prints `2 passed`.
- [ ] **Step 5: commit.** `git add -A && git commit -m "feat: probe addon that reports the live Forever API"`

### Task 3: Windows deploy path and probe run

**Files:**
- Create: `docs/dev/windows-deploy.md`
- Modify: `docs/dev/setup.md` (link the new page)

**Interfaces:** Produces the deploy procedure every later in-game check uses.

- [ ] **Step 1: write the page.** Steps, each verifiable by Brendon on the game PC:
  1. Open the install folder from the Battle.net launcher (gear icon, "Show in Explorer") and
     note the Forever flavor folder name (`_forever_` expected). Record it in the page.
  2. Install Git for Windows if absent; `git clone https://github.com/brendonhall/level_coach.git C:\dev\level_coach`.
  3. In an elevated prompt or with Developer Mode on:
     `mklink /J "<WoW>\_forever_\Interface\AddOns\LevelCoach" "C:\dev\level_coach\LevelCoach"`.
  4. Start the client. At character select, open AddOns and confirm Level Coach is listed and
     enabled; tick "Load out of date AddOns" only if it shows as out of date.
  5. Install BugSack and BugGrabber (Forever files) so Lua errors are visible.
  6. Log in, run `/lc probe`, open the taxi map once at a flight master, then `/reload`.
  7. Copy `<WoW>\_forever_\WTF\Account\<ACCOUNT>\SavedVariables\LevelCoach.lua` to
     `docs/research/probe/LevelCoach.lua` in the clone, commit on a branch and push, or paste the
     chat output into a new issue.
  Update path: `git pull` in `C:\dev\level_coach`, then `/reload` in game.
- [ ] **Step 2: verify.** Brendon follows the page once. The expected result is the probe output
  in chat plus the SavedVariables file in the repo. Failures become edits to the page.
- [ ] **Step 3: commit.** `git add -A && git commit -m "docs: windows deploy path and probe procedure"`

### Task 4: Record probe results and fix the detector contract

**Files:**
- Create: `docs/research/api-probe.md`
- Modify: `docs/superpowers/specs/2026-11-08-level-coach-design.md` §2.4 and §5.4 (only where
  the probe contradicts them)

**Interfaces:** Produces the confirmed function names and spell and quest IDs consumed by
Tasks 6, 9 and 10. Format: one table per probe section with columns `probe`, `result`, `use in
State.lua`.

- [ ] **Step 1: transcribe** `LevelCoachDB.probe` into the table. Mark each candidate spell ID
  `confirmed <name>` or `renumbered` and each quest ID `confirmed <title>` or `unknown`.
- [ ] **Step 2: decide** the skill-line detector: if `GetNumSkillLines` exists, use it; else if
  `GetProfessions` exists, use `GetProfessionInfo`; else `skill_line` detectors return `nil`
  (manual) and the design doc says so.
- [ ] **Step 3: commit.** `git add -A && git commit -m "docs: record Forever API probe results"`

---

## Phase 1: engine and data pipeline

### Task 5: Data schema

**Files:**
- Create: `data/schema/item.schema.json`, `data/schema/zone.schema.json`,
  `data/schema/dungeon.schema.json`, `data/schema/goals.schema.json`
- Test: `tests/python/test_schema.py`

**Interfaces:** Produces the JSON Schemas consumed by `build_data.py` (Task 6) and the field
names the Engine reads (Task 9): `id`, `title`, `why`, `kind`, `level.min`, `level.max`,
`classes`, `races`, `factions`, `goals`, `tags`, `priority`, `where`, `done_when`, `verified`,
`sources`.

- [ ] **Step 1: write the failing test.**
  ```python
  import json, pathlib, pytest, jsonschema
  SCHEMA = pathlib.Path("data/schema")

  def load(name): return json.loads((SCHEMA / name).read_text())

  VALID_ITEM = {
      "id": "warlock-voidwalker-quest", "title": "Do the Voidwalker quest: Halgar's Summons",
      "why": "Your tank for ten levels. Take the Brill version, not Orgrimmar's.",
      "kind": "quest", "level": {"min": 10, "max": 60},
      "classes": ["WARLOCK"], "races": ["Scourge"], "factions": ["Horde"], "goals": ["any"],
      "tags": [], "priority": "high",
      "where": {"zone": "Tirisfal Glades", "npc": "Halgar", "waypoint": [61.6, 52.4]},
      "done_when": {"type": "spell_known", "id": 697, "verify": "probe: name must be Summon Voidwalker"},
      "verified": {"forever": False}, "sources": ["https://www.warcrafttavern.com/forever/guides/warlock-leveling/"],
  }

  def test_valid_item_passes():
      jsonschema.validate(VALID_ITEM, load("item.schema.json"))

  @pytest.mark.parametrize("field", ["id", "title", "why", "level", "done_when", "verified", "sources"])
  def test_missing_required_field_fails(field):
      bad = {k: v for k, v in VALID_ITEM.items() if k != field}
      with pytest.raises(jsonschema.ValidationError):
          jsonschema.validate(bad, load("item.schema.json"))

  def test_unknown_detector_type_fails():
      bad = dict(VALID_ITEM, done_when={"type": "telepathy"})
      with pytest.raises(jsonschema.ValidationError):
          jsonschema.validate(bad, load("item.schema.json"))

  def test_level_max_below_min_fails():
      bad = dict(VALID_ITEM, level={"min": 20, "max": 10})
      with pytest.raises(jsonschema.ValidationError):
          jsonschema.validate(bad, load("item.schema.json"))
  ```
- [ ] **Step 2: run it, expect failure.** `FileNotFoundError: data/schema/item.schema.json`.
- [ ] **Step 3: implement.** `item.schema.json` (draft 2020-12): required
  `["id","title","why","kind","level","done_when","verified","sources"]`; `id` pattern
  `^[a-z0-9-]+$`; `kind` enum `train, quest, item, zone, dungeon, gold, habit, setup, talent, profession`;
  `level` object with integer `min` and `max` 1 to 60 (the min-less-than-max rule is enforced in
  `build_data.py`, since JSON Schema cannot compare fields: the test above still passes because
  the build step validates it; see Task 6, and keep the test but move it there if it proves
  awkward); `classes` items enum of the nine class tokens in upper case; `races` enum of race
  file names (`Scourge`, `Orc`, `Troll`, `Tauren`, `Human`, `Dwarf`, `Gnome`, `NightElf`,
  `Skyborne`); `factions` enum `Horde`, `Alliance`; `goals` strings; `tags` strings (`pvp`,
  `new-player`, `dungeon`, `gold`); `priority` enum `high`, `normal`, `low` default `normal`;
  `where` object `{zone, npc, waypoint: [x, y], mapID}` all optional; `done_when` a `oneOf` over:
  `quest_complete {id}`, `spell_known {id}`, `skill_line {name, min}`, `level_at_least {n}`,
  `bind_location {zone}`, `has_item {id}`, `money_at_least {copper}`, `zone_visited {zone}`,
  `taxi_known {node}`, `manual {}`, `any_of {of: [...]}`, `all_of {of: [...]}`, each allowing an
  optional `verify` string; `verified` object `{forever: boolean, by, date}`; `sources` array of
  URIs, at least one. `zone.schema.json`: `name`, `faction` enum `Horde, Alliance, Contested`,
  `level {min,max}`, `continent`, `mapID` (optional), `hubs []`, `new` boolean.
  `dungeon.schema.json`: `name`, `level {min,max}`, `zone`, `new`, `access` string,
  `horde_quests_from []`. `goals.schema.json`: the interview answer enums from the design doc §5.1.
- [ ] **Step 4: run it, expect pass.** `python -m pytest -q tests/python/test_schema.py` prints
  `10 passed` (one of them via the build-time rule noted above; adjust the test location if needed).
- [ ] **Step 5: commit.** `git add -A && git commit -m "feat: JSON schemas for guide data"`

### Task 6: `build_data.py`, YAML to Lua

**Files:**
- Create: `tools/build_data.py`, `data/items/.gitkeep`, `data/zones.yaml`, `data/dungeons.yaml`
- Test: `tests/python/test_build_data.py`

**Interfaces:** Consumes Task 5 schemas. Produces `build(data_dir, out_dir) -> list[Path]` and
`render_lua(name: str, value) -> str`, plus the CLI `python -m tools.build_data [--check]`.
Generated files: `LevelCoach/Data/Items.lua`, `Zones.lua`, `Dungeons.lua`, each of the form
`local _, ns = ...; ns.Data = ns.Data or {}; ns.Data.<Name> = { ... }` with keys sorted so
output is deterministic.

- [ ] **Step 1: write the failing test.**
  ```python
  from tools.build_data import render_lua, build, BuildError
  import pytest, textwrap

  def test_render_lua_is_deterministic_and_escapes():
      out = render_lua("Items", [{"id": "a", "title": 'say "hi"\\n', "level": {"min": 1, "max": 5}, "tags": []}])
      assert out.startswith("local _, ns = ...\nns.Data = ns.Data or {}\nns.Data.Items = {")
      assert '"say \\"hi\\"\\\\n"' in out            # quotes and backslashes escaped
      assert out.index('["id"]') < out.index('["level"]') < out.index('["tags"]')  # sorted keys
      assert "{}" in out                             # empty list renders as empty table

  def test_build_rejects_invalid_item(tmp_path):
      (tmp_path / "items").mkdir()
      (tmp_path / "items" / "bad.yaml").write_text("- id: bad\n  title: x\n")
      (tmp_path / "zones.yaml").write_text("[]")
      (tmp_path / "dungeons.yaml").write_text("[]")
      with pytest.raises(BuildError, match="bad.yaml"):
          build(tmp_path, tmp_path / "out")

  def test_build_rejects_duplicate_ids_and_level_order(tmp_path, valid_item_yaml):
      (tmp_path / "items").mkdir()
      (tmp_path / "items" / "a.yaml").write_text(valid_item_yaml + valid_item_yaml)
      (tmp_path / "zones.yaml").write_text("[]"); (tmp_path / "dungeons.yaml").write_text("[]")
      with pytest.raises(BuildError, match="duplicate id"):
          build(tmp_path, tmp_path / "out")

  def test_build_requires_verify_note_on_numeric_detectors(tmp_path, valid_item_yaml):
      yaml_text = valid_item_yaml.replace('verify: "probe: name must be Summon Voidwalker"', "")
      (tmp_path / "items").mkdir(); (tmp_path / "items" / "a.yaml").write_text(yaml_text)
      (tmp_path / "zones.yaml").write_text("[]"); (tmp_path / "dungeons.yaml").write_text("[]")
      with pytest.raises(BuildError, match="verify"):
          build(tmp_path, tmp_path / "out")

  def test_generated_lua_compiles(tmp_path, valid_item_yaml, lua):
      (tmp_path / "items").mkdir(); (tmp_path / "items" / "a.yaml").write_text(valid_item_yaml)
      (tmp_path / "zones.yaml").write_text("[]"); (tmp_path / "dungeons.yaml").write_text("[]")
      for path in build(tmp_path, tmp_path / "out"):
          lua.compile(path.read_text(), "=" + path.name)
  ```
  The `valid_item_yaml` fixture is the Task 5 item as YAML; `lua` is the Task 7 fixture (write
  a minimal local version now: `LuaRuntime().eval("function(s, n) assert(loadstring(s, n)) end")`).
- [ ] **Step 2: run it, expect failure.** `ModuleNotFoundError: tools.build_data`.
- [ ] **Step 3: implement** `tools/build_data.py`: `BuildError(Exception)`; `load_yaml(path)`;
  `validate(kind, obj, path)` with `jsonschema.Draft202012Validator`; extra rules: unique `id`
  across all item files, `level.min <= level.max`, every `done_when` with a numeric `id` carries
  a `verify` note until `verified.forever` is true; `render_lua` emits strings with
  `json.dumps`-style escaping converted to Lua (escape `\\`, `"`, newlines), numbers as-is,
  booleans, lists as `{ v1, v2 }`, dicts as `{ ["k"] = v }` with sorted keys, indentation two
  spaces; `build()` returns written paths; `--check` renders to memory and exits 1 if any
  on-disk file differs (CI uses this).
- [ ] **Step 4: run it, expect pass.** `python -m pytest -q` passes; `python -m tools.build_data`
  writes three files under `LevelCoach/Data/`; `python -m tools.build_data --check` exits 0.
- [ ] **Step 5: add the generated files to the TOC** after `Core\Init.lua`:
  `Data\Items.lua`, `Data\Zones.lua`, `Data\Dungeons.lua`, `Data\Overlay.lua`,
  `Data\Overlay.pending.lua`; create the two Overlay stubs by hand
  (`local _, ns = ...; ns.Data = ns.Data or {}; ns.Data.Overlay = {}` and `...OverlayPending = {}`).
- [ ] **Step 6: commit.** `git add -A && git commit -m "feat: YAML to Lua data build with validation"`

### Task 7: Lua test harness through lupa

**Files:**
- Create: `tests/python/conftest.py`, `tests/lua/wow_stub.lua`
- Test: `tests/python/test_harness.py`

**Interfaces:** Produces the pytest fixture `lua` with methods `compile(src, name)`,
`load_addon_file(relpath)` (runs a file with `addonName, ns` varargs against the shared `ns`),
`ns` (the namespace table), `table(obj)` (recursive Python to Lua conversion via
`rt.table_from(obj, recursive=True)`), and `rt` (the raw runtime). `wow_stub.lua` defines the
few globals the Core files touch at load time (`CreateFrame` returning a frame-like table with
`RegisterEvent`, `SetScript`, `UnregisterEvent`; `DEFAULT_CHAT_FRAME.AddMessage` appending to a
`_G.CHAT` list; `SlashCmdList = {}`; `C_Timer.After` calling immediately; `GetTime`).

- [ ] **Step 1: write the failing test.**
  ```python
  def test_load_addon_file_shares_namespace(lua):
      lua.load_addon_file("Core/Init.lua")
      assert lua.ns.print is not None
      lua.ns.print("hello")
      assert "hello" in lua.rt.globals().CHAT[1]

  def test_table_conversion_round_trip(lua):
      t = lua.table({"level": 14, "spells": {"686": True}, "tags": ["pvp"]})
      assert t.level == 14 and t.tags[1] == "pvp"
  ```
- [ ] **Step 2: run it, expect failure.** `fixture 'lua' not found`.
- [ ] **Step 3: implement** `conftest.py`:
  ```python
  import pathlib, pytest
  from lupa.lua51 import LuaRuntime
  ROOT = pathlib.Path(__file__).resolve().parents[2]

  class Lua:
      def __init__(self):
          self.rt = LuaRuntime(unpack_returned_tuples=True)
          self._load = self.rt.eval("function(src, name) local f, e = loadstring(src, name); assert(f, e); return f end")
          self.rt.execute((ROOT / "tests/lua/wow_stub.lua").read_text(encoding="utf-8"))
          self.ns = self.rt.table()
      def compile(self, src, name): return self._load(src, name)
      def load_addon_file(self, relpath):
          src = (ROOT / "LevelCoach" / relpath).read_text(encoding="utf-8")
          return self._load(src, "=" + relpath)("LevelCoach", self.ns)
      def table(self, obj): return self.rt.table_from(obj, recursive=True)

  @pytest.fixture
  def lua(): return Lua()
  ```
  Note: `Init.lua` must tolerate the stub (no `UIParent` use at load; `ADDON_LOADED` handling
  only inside the event handler). Keys in `table()` dicts are strings; detectors therefore
  index spell sets with `tostring(id)`, and `State.lua` (Task 11) stores them the same way.
- [ ] **Step 4: run it, expect pass.** `python -m pytest -q` passes (the Task 6 test now uses this fixture).
- [ ] **Step 5: commit.** `git add -A && git commit -m "feat: Lua test harness via lupa with WoW stubs"`

### Task 8: Detectors

**Files:**
- Create: `LevelCoach/Core/Detectors.lua`
- Modify: `LevelCoach/LevelCoach.toc` (add `Core\Detectors.lua` after the Data files)
- Test: `tests/python/test_detectors.py`

**Interfaces:** Produces `ns.Detectors.check(done_when, snapshot) -> true | false | nil`.
Consumes the snapshot shape (strings as keys for ID sets):
```
snapshot = { level, class, race, faction, ruleset, zone, subzone, mapID, money, bindLocation,
  spells = { ["686"] = true }, questsCompleted = { ["1470"] = true }, skills = { ["First Aid"] = 75 },
  items = { ["6948"] = 1 }, zonesVisited = { ["The Barrens"] = true }, taxiNodes = { ["Brill, Tirisfal Glades"] = true },
  manualDone = { ["item-id"] = true }, skipped = {}, snoozedUntil = {} }
```

- [ ] **Step 1: write the failing test.**
  ```python
  import pytest
  SNAP = {"level": 14, "money": 9500, "bindLocation": "Brill", "zone": "Silverpine Forest",
          "spells": {"697": True}, "questsCompleted": {"1470": True}, "skills": {"First Aid": 75},
          "items": {"6948": 1}, "zonesVisited": {"Tirisfal Glades": True}, "taxiNodes": {"Brill, Tirisfal Glades": True}}

  @pytest.fixture
  def check(lua):
      lua.load_addon_file("Core/Detectors.lua")
      return lambda dw, snap=SNAP: lua.ns.Detectors.check(lua.table(dw), lua.table(snap))

  @pytest.mark.parametrize("dw,expected", [
      ({"type": "spell_known", "id": 697}, True), ({"type": "spell_known", "id": 712}, False),
      ({"type": "quest_complete", "id": 1470}, True), ({"type": "quest_complete", "id": 1740}, False),
      ({"type": "skill_line", "name": "First Aid", "min": 75}, True),
      ({"type": "skill_line", "name": "First Aid", "min": 76}, False),
      ({"type": "skill_line", "name": "Cooking", "min": 1}, False),
      ({"type": "level_at_least", "n": 14}, True), ({"type": "level_at_least", "n": 15}, False),
      ({"type": "bind_location", "zone": "Brill"}, True), ({"type": "bind_location", "zone": "Crossroads"}, False),
      ({"type": "has_item", "id": 6948}, True), ({"type": "money_at_least", "copper": 9500}, True),
      ({"type": "money_at_least", "copper": 9501}, False),
      ({"type": "zone_visited", "zone": "Tirisfal Glades"}, True),
      ({"type": "taxi_known", "node": "Brill, Tirisfal Glades"}, True),
      ({"type": "any_of", "of": [{"type": "spell_known", "id": 1}, {"type": "level_at_least", "n": 1}]}, True),
      ({"type": "all_of", "of": [{"type": "spell_known", "id": 1}, {"type": "level_at_least", "n": 1}]}, False),
  ])
  def test_detectors(check, dw, expected):
      assert check(dw) == expected

  def test_unknown_type_returns_nil_not_error(check):
      assert check({"type": "telepathy"}) is None

  def test_manual_returns_nil(check):
      assert check({"type": "manual"}) is None

  def test_missing_snapshot_section_returns_nil(check):
      assert check({"type": "spell_known", "id": 697}, snap={"level": 14}) is None
  ```
- [ ] **Step 2: run it, expect failure.** `attempt to index field 'Detectors' (a nil value)`.
- [ ] **Step 3: implement** `Detectors.lua`: a table `handlers` keyed by type; each handler
  receives `(dw, snap)` and returns a boolean, or `nil` when the section it needs is absent;
  `any_of` returns true if any child is true, `nil` if all children are nil, else false;
  `all_of` returns false on any false, `nil` on any nil, else true; `check` looks up
  `handlers[dw.type]` and returns `nil` for unknown types. Set lookups use `tostring(dw.id)`.
- [ ] **Step 4: run it, expect pass.** `python -m pytest -q tests/python/test_detectors.py` passes.
- [ ] **Step 5: commit.** `git add -A && git commit -m "feat: completion detectors over the character snapshot"`

### Task 9: Engine

**Files:**
- Create: `LevelCoach/Core/Engine.lua`
- Modify: `LevelCoach/LevelCoach.toc` (add `Core\Engine.lua` after `Core\Detectors.lua`)
- Test: `tests/python/test_engine.py`

**Interfaces:** Consumes `ns.Detectors.check` and `ns.Data.Items`. Produces
`ns.Engine.evaluate(snapshot, goals, items) -> { now = {...}, soon = {...}, overdue = {...}, done = {...} }`
where each entry is `{ item = <item>, status = "now"|"soon"|"overdue"|"done", reason = <string> }`
and `ns.Engine.applies(item, snapshot, goals) -> boolean`. `goals` is the goal profile table
`{ aim = "learn", secondary = "story", guidance = "zones", professions = "craft", dungeons = "convenient",
battlegrounds = false, session = "medium", pvpRuleset = true }`.

- [ ] **Step 1: write the failing test.**
  ```python
  import pytest
  def item(**kw):
      base = {"id": kw.get("id", "x"), "title": "t", "why": "w", "kind": "train", "level": {"min": 10, "max": 60},
              "priority": "normal", "goals": ["any"], "tags": [], "done_when": {"type": "manual"}, "verified": {"forever": False}, "sources": ["u"]}
      base.update(kw); return base
  GOALS = {"aim": "learn", "dungeons": "convenient", "battlegrounds": False, "pvpRuleset": True}
  SNAP = {"level": 14, "class": "WARLOCK", "race": "Scourge", "faction": "Horde", "zone": "Silverpine Forest",
          "spells": {}, "questsCompleted": {}, "skills": {}, "items": {}, "manualDone": {}, "skipped": {}, "snoozedUntil": {}}

  @pytest.fixture
  def engine(lua):
      lua.load_addon_file("Core/Detectors.lua"); lua.load_addon_file("Core/Engine.lua")
      def run(items, snap=SNAP, goals=GOALS):
          r = lua.ns.Engine.evaluate(lua.table(snap), lua.table(goals), lua.table(items))
          return {k: [(e.item.id, e.status) for e in r[k].values()] for k in ("now", "soon", "overdue", "done")}
      return run

  def test_sections_by_level_window(engine):
      r = engine([item(id="now", level={"min": 10, "max": 20}), item(id="soon", level={"min": 18, "max": 30}),
                  item(id="far", level={"min": 30, "max": 40}), item(id="late", level={"min": 5, "max": 12})])
      assert ("now", "now") in r["now"] and ("soon", "soon") in r["soon"]
      assert ("late", "overdue") in r["overdue"] and all("far" not in ids for ids in r.values() for ids in [ [i for i, _ in ids] ])

  def test_overdue_surfaces_missed_class_quest(engine):
      r = engine([item(id="vw", kind="quest", level={"min": 10, "max": 12}, classes=["WARLOCK"])])
      assert r["overdue"] == [("vw", "overdue")]

  def test_detector_completion_moves_to_done(engine):
      snap = dict(SNAP, spells={"697": True})
      r = engine([item(id="vw", done_when={"type": "spell_known", "id": 697})], snap=snap)
      assert r["done"] == [("vw", "done")]

  def test_class_race_faction_filters(engine):
      r = engine([item(id="mage", classes=["MAGE"]), item(id="orc", races=["Orc"]), item(id="ally", factions=["Alliance"]), item(id="ok", classes=["WARLOCK"], factions=["Horde"])])
      assert [i for i, _ in r["now"]] == ["ok"]

  def test_pvp_tag_needs_pvp_ruleset_or_goal(engine):
      items = [item(id="pvp", tags=["pvp"])]
      assert [i for i, _ in engine(items)["now"]] == ["pvp"]
      assert engine(items, goals=dict(GOALS, pvpRuleset=False))["now"] == []

  def test_ranking_priority_then_current_zone(engine):
      items = [item(id="low", priority="low"), item(id="here", priority="normal", where={"zone": "Silverpine Forest"}),
               item(id="there", priority="normal", where={"zone": "The Barrens"}), item(id="hi", priority="high")]
      assert [i for i, _ in engine(items)["now"]] == ["hi", "here", "there", "low"]

  def test_manual_done_skipped_and_snoozed(engine):
      snap = dict(SNAP, manualDone={"a": True}, skipped={"b": True}, snoozedUntil={"c": 9e12})
      r = engine([item(id="a"), item(id="b"), item(id="c"), item(id="d")], snap=snap)
      assert r["done"] == [("a", "done")] and [i for i, _ in r["now"]] == ["d"]
  ```
- [ ] **Step 2: run it, expect failure.** `attempt to index field 'Engine' (a nil value)`.
- [ ] **Step 3: implement** `Engine.lua`: `applies` checks class, race, faction lists (absent or
  empty means all), `goals` list (`any` or intersection with the active goal tags derived from
  the profile: `aim`, `secondary`, `"dungeons"` when `dungeons ~= "avoid"`, `"pvp"` when
  `pvpRuleset or battlegrounds`), and `tags` containing `pvp` requires the `pvp` goal tag.
  Status: skipped or snoozed (`snoozedUntil[id] > snap.now or time()`) items are dropped;
  `manualDone[id]` or `Detectors.check(...) == true` gives `done`; `level < min` gives `soon` if
  `min <= level + 5` else dropped; `min <= level <= max` gives `now`; `level > max` gives
  `overdue`. Sort `now` by priority rank (`high` 1, `normal` 2, `low` 3), then current-zone first,
  then `level.min`, then `id`. `soon` sorts by `level.min`, `overdue` by `level.max`.
- [ ] **Step 4: run it, expect pass.** `python -m pytest -q` passes.
- [ ] **Step 5: commit.** `git add -A && git commit -m "feat: checklist engine with sections, filters and ranking"`

### Task 10: First dataset, Undead Warlock levels 1 to 20

**Files:**
- Create: `data/items/general.yaml`, `data/items/warlock.yaml`, `data/items/undead.yaml`
- Modify: `data/zones.yaml`, `data/dungeons.yaml`
- Test: `tests/python/test_dataset.py`

**Interfaces:** Consumes the schema (Task 5) and the probe results (Task 4) for IDs. Produces the
shipped `ns.Data.Items` the engine runs on in game.

- [ ] **Step 1: write the failing test.**
  ```python
  from tools.build_data import load_all
  def test_dataset_covers_levels_1_to_20_for_undead_warlock():
      items = load_all("data")["items"]
      ids = {i["id"] for i in items}
      for required in ["warlock-imp-quest", "warlock-train-immolate", "general-first-wand",
                       "general-pick-professions", "general-first-aid", "warlock-voidwalker-quest",
                       "warlock-first-talent", "warlock-healthstone", "general-hearth-brill",
                       "dungeon-ruins-of-lordaeron", "warlock-sayaad-quest", "general-riding-savings"]:
          assert required in ids, required
      for lvl in range(1, 21):
          assert any(i["level"]["min"] <= lvl <= i["level"]["max"] for i in items), lvl
      assert all(i["verified"]["forever"] is False for i in items)
  ```
- [ ] **Step 2: run it, expect failure.** `AssertionError: warlock-imp-quest`.
- [ ] **Step 3: author the items** from `docs/guides/undead-affliction-warlock.md`, bands 1-9 and
  10-19 plus the level-20 entries, one YAML item per checklist row, in the Task 5 shape. Every
  `done_when` with an ID carries a `verify` note citing the probe. Add `data/zones.yaml` for
  Tirisfal Glades, Silverpine Forest, The Barrens, Hillsbrad Foothills, Undercity, Orgrimmar
  (Classic map IDs 1420, 1421, 1413, 1424, 1458, 1454 marked verify) and `data/dungeons.yaml`
  for Ragefire Chasm, Ruins of Lordaeron, Wailing Caverns, Shadowfang Keep with the ranges from
  the guide. Items that depend on the PvP ruleset (contested-zone warnings for Hillsbrad and
  Ashenvale) get `tags: [pvp]`.
- [ ] **Step 4: run it, expect pass.** `python -m pytest -q` and `python -m tools.build_data` both
  succeed; commit the regenerated `LevelCoach/Data/*.lua`.
- [ ] **Step 5: commit.** `git add -A && git commit -m "feat: first dataset, Undead Warlock levels 1-20"`

### Task 11: State snapshot and the first in-game checklist

**Files:**
- Create: `LevelCoach/Core/State.lua`
- Modify: `LevelCoach/Core/Init.lua` (events, `/lc` subcommands), `LevelCoach/LevelCoach.toc`
- Test: `tests/python/test_state.py`

**Interfaces:** Consumes the probe's confirmed API names (Task 4). Produces
`ns.State.snapshot() -> snapshot` in the Task 8 shape, and the slash commands `/lc` (print the
Now and Overdue sections to chat), `/lc done <id>`, `/lc skip <id>`, `/lc probe`.

- [ ] **Step 1: write the failing test.** With the WoW stub extended by the test to return fixed
  values (`UnitLevel` 14, `UnitClass` `"Warlock", "WARLOCK"`, `UnitRace` `"Undead", "Scourge"`,
  `UnitFactionGroup` `"Horde"`, `GetZoneText` `"Silverpine Forest"`, `GetMoney` 9500,
  `GetBindLocation` `"Brill"`, `IsPlayerSpell` true only for 697, `C_QuestLog.GetAllCompletedQuestIDs`
  returning `{1470}`, skill-line functions per Task 4):
  ```python
  def test_snapshot_shape(lua, wow_fixture):
      lua.load_addon_file("Core/State.lua")
      s = lua.ns.State.snapshot()
      assert (s.level, s["class"], s.race, s.faction) == (14, "WARLOCK", "Scourge", "Horde")
      assert s.spells["697"] is True and s.questsCompleted["1470"] is True
      assert s.money == 9500 and s.bindLocation == "Brill"

  def test_snapshot_survives_missing_api(lua, wow_fixture):
      lua.rt.globals().C_QuestLog = None
      lua.load_addon_file("Core/State.lua")
      s = lua.ns.State.snapshot()
      assert s.questsCompleted is None   # section absent, detectors return nil
  ```
- [ ] **Step 2: run it, expect failure.** `attempt to index field 'State' (a nil value)`.
- [ ] **Step 3: implement** `State.lua`: every API call inside `pcall`; sets keyed by
  `tostring(id)`; `zonesVisited` and `taxiNodes` merged from `LevelCoachCharDB` (recorded on
  `ZONE_CHANGED_NEW_AREA` and `TAXIMAP_OPENED`); `manualDone`, `skipped`, `snoozedUntil` read
  from `LevelCoachCharDB`. In `Init.lua`: register `PLAYER_ENTERING_WORLD`, `PLAYER_LEVEL_UP`,
  `ZONE_CHANGED_NEW_AREA`, `QUEST_TURNED_IN`, `SPELLS_CHANGED`, `SKILL_LINES_CHANGED`,
  `PLAYER_MONEY`, `HEARTHSTONE_BOUND`, `TAXIMAP_OPENED`, `PLAYER_REGEN_ENABLED`; on any of them,
  if not `InCombatLockdown()`, recompute `ns.lastResult = ns.Engine.evaluate(...)` and, on
  `PLAYER_LEVEL_UP` only, print the Now section. `/lc` prints `now` and `overdue` with indices.
- [ ] **Step 4: run it, expect pass.** `python -m pytest -q` passes. Then, in game: `git pull`,
  `/reload`, `/lc` prints the level-appropriate items with no BugSack errors. Record anything
  surprising in `docs/research/api-probe.md`.
- [ ] **Step 5: commit.** `git add -A && git commit -m "feat: live snapshot and chat checklist"`

### Task 12: Continuous integration

**Files:**
- Create: `.github/workflows/ci.yml`

- [ ] **Step 1: write the workflow.** On push and pull request: checkout; Python 3.12;
  `pip install -e .[dev]`; `python -m pytest -q`; `python -m tools.build_data --check`;
  `sudo apt-get install -y lua-check && luacheck LevelCoach`.
- [ ] **Step 2: verify.** Push the branch; the workflow is green. If luacheck flags a WoW global,
  add it to `.luacheckrc` `read_globals`, not to the code.
- [ ] **Step 3: commit.** `git add -A && git commit -m "ci: pytest, data check and luacheck"`

---

## Later phases (outline only; planned after Phase 1 ships)

- **Phase 2, UI:** movable panel with Now / Soon / Overdue / Done, expand for why and where,
  built-in map pin via `C_Map.SetUserWaypoint`, TomTom hook, interview wizard writing the goal
  profile, `/lc setup`, minimap button optional.
- **Phase 3, breadcrumbs and bridge:** event log in `LevelCoachCharDB`, export shape, the
  private `level_coach_sync` repo, `watcher.ps1`, `tools/export_reader.py` producing YAML drafts.
- **Phase 4, coach:** `.claude/skills/coach/SKILL.md`, the Linux daemon, validator and trust
  tiers, `Overlay.pending.lua` handling with `/lc accept` and `/lc trust`.

## Self-review

- Coverage: every design-doc §3 goal for v1 maps to a task (interview is Phase 2; checklist,
  explanations, data-as-YAML, breadcrumbs later, zero-config now).
- Names used across tasks: `ns.Detectors.check`, `ns.Engine.evaluate`, `ns.Engine.applies`,
  `ns.State.snapshot`, `ns.Data.Items`, `render_lua`, `build`, `load_all`, `BuildError`, fixture
  `lua` with `compile`, `load_addon_file`, `table`, `ns`, `rt`.
- Review-focus items each have a test: renumbered IDs (Task 6 verify rule, Task 2 probe), filter
  leaks (Task 9), overdue surfacing (Task 9), broken generated Lua (Task 6), missing API (Tasks 8
  and 11).
- Proportion: twelve tasks for a spec of two documents; Phase 0 is deliberately small.

## Handoff

Two ways to execute this plan:

1. **Subagent-driven:** a fresh subagent per task, a fresh reviewer per task, a final
   whole-branch review. Most thorough, costs the most context.
2. **Native:** one session implements every task in order, then one fresh review of the branch.
   Cheaper and faster; no independent review until the end.

Recommendation: native for Phase 0 and Tasks 5 to 7 (small, mechanical, and Task 3 needs
Brendon at the game PC anyway), then subagent-driven from Task 8 onward, where the engine
logic is where a second pair of eyes pays for itself.
