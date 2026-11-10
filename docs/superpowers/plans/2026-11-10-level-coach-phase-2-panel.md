# Level Coach: implementation plan, Phase 2 (panel, tooltips, waypoints)

> For agentic workers: REQUIRED SUB-SKILL: Use superpowers:executing-plans. Steps are checkboxes.
> Execution method chosen by Brendon for this project: native.

**Goal:** the checklist moves from chat into a movable panel with a checkbox per item, sections for
Now, Overdue, Soon and Done, a mouseover tooltip carrying the full explanation, step detail and
location, shift-click to pin the location on the map, and right-click for skip and snooze.

**Architecture:** `UI/Panel.lua` renders a display model; the model and the tooltip text come from
pure functions in `Core/Present.lua` so they are unit-tested through lupa. `Core/Waypoints.lua`
wraps the built-in user waypoint and TomTom behind feature detection. The test stub grows a
permissive widget model so frame construction runs headless and tooltip content can be asserted.

**Spec:** design doc §3 goal 3, §5.1, §5.7. **Constraints:** no protected frames touched; every
client call behind `pcall` or a type check; CamelCase widget methods only; row widgets recycled.

**Review focus:** a nil `where` or missing `waypoint` must not break rendering (Task 14 test);
auto-detected done items must not be un-checkable (Task 15 test); `/lc` with no panel loaded must
still print the chat list (Task 15 test).

## Task 13: `detail` field and richer data
- [x] Schema: optional `detail` string (multi-paragraph instructions). Build and tests unchanged.
- [x] Data: add `detail` to the items a new player asks about most (Imp and Voidwalker quests,
  first wand, professions, First Aid, Healthstone, hearth, zeppelin, Ruins of Lordaeron, Sayaad
  chain, riding savings). Rebuild `LevelCoach/Data`.
- [x] Commit: `feat: detail text for tooltip instructions`

## Task 14: presentation model and tooltip text (pure Lua)
- [ ] Tests: `tests/python/test_present.py` for `ns.Present.buildModel(result, snapshot, collapsed)`
  (section order Now, Overdue, Soon, Done; counts; collapsed flag; row fields `title`, `zoneText`,
  `checked`, `auto`, `status`) and `ns.Present.tooltipLines(entry, snapshot, resolver)` (title,
  status line, why, detail paragraphs, Where lines, Done-when text, verification notice, hints;
  items with no `where` produce no Where lines) and `ns.Present.describeDetector`.
- [ ] Implement `LevelCoach/Core/Present.lua`; add to TOC after `Core\State.lua`.
- [ ] Commit: `feat: presentation model and tooltip text`

## Task 15: panel, waypoints, commands
- [ ] Stub: `tests/lua/wow_stub.lua` gains a permissive widget (CamelCase methods default to
  no-ops, common getters return stored values, `CreateFontString`, `CreateTexture`,
  `SetScrollChild`), a recording `GameTooltip`, `IsShiftKeyDown`, named frames as globals.
- [ ] Tests: `tests/python/test_panel.py`: `/lc` toggles the panel; rows match the model; a row's
  OnEnter fills GameTooltip with the title and the Where line; the checkbox of an auto-done row
  is disabled; clicking an unchecked row's box marks it done and the model updates; `/lc list`
  prints the chat listing; waypoint pin returns false with no API and true with a TomTom stub.
- [ ] Implement `LevelCoach/UI/Panel.lua` (movable, saved position in `LevelCoachDB.panel`,
  close button, header, scroll list, section headers that collapse, recycled rows with
  checkbox, title and zone text, highlight, tooltip on hover, shift-click pin, right-click menu
  via `MenuUtil` when present with skip, snooze 24h, snooze 3 days, clear marks, pin) and
  `LevelCoach/Core/Waypoints.lua` (`ns.Waypoints.pin(item) -> ok, how`). Init: `/lc` toggles,
  `/lc list` prints, `/lc show|hide|reset`; refresh notifies the panel through `ns.afterRefresh`.
- [ ] Commit: `feat: checklist panel with tooltips, waypoints and context menu`

## Task 16: verify in game (Brendon)
- [ ] `git pull` on the game PC, `/reload`, `/lc`. Drag the panel, hover a row, shift-click a row
  with coordinates, right-click a row, tick a box, `/reload` and confirm position and ticks persist.
  Record anything broken in `docs/research/api-probe.md` under a "Panel" heading.
