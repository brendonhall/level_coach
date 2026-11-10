ADDON_FILES = ["Core/Init.lua", "Data/Items.lua", "Data/Zones.lua", "Data/Dungeons.lua", "Data/Overlay.lua",
               "Data/Overlay.pending.lua", "Core/Detectors.lua", "Core/Engine.lua", "Core/State.lua",
               "Core/Present.lua", "Core/Waypoints.lua", "UI/Panel.lua"]


def load_all(lua):
    for f in ADDON_FILES:
        lua.load_addon_file(f)
    g = lua.rt.globals()
    g.FIRE(lua.ns.frame, "ADDON_LOADED", "LevelCoach")
    g.FIRE(lua.ns.frame, "PLAYER_ENTERING_WORLD")
    return lua


def visible_rows(panel):
    return [panel.rows[i] for i in range(1, panel.rowCount + 1)]


def test_slash_lc_toggles_panel_with_rows_for_open_sections(wow_fixture):
    lua = load_all(wow_fixture)
    g = lua.rt.globals()
    g.SlashCmdList.LEVELCOACH("")
    panel = lua.ns.Panel
    assert panel.frame.IsShown(panel.frame) is True
    model = panel.model
    open_counts = sum(model.sections[i].count for i in range(1, 5) if not model.sections[i].collapsed)
    assert model.sections[4].key == "done" and model.sections[4].collapsed is True
    assert panel.rowCount == open_counts > 0
    assert panel.frame.header.GetText(panel.frame.header).startswith("Level 14 Warlock")
    g.SlashCmdList.LEVELCOACH("")
    assert panel.frame.IsShown(panel.frame) is False


def test_row_hover_fills_tooltip_with_title_and_location(wow_fixture):
    lua = load_all(wow_fixture)
    lua.rt.globals().SlashCmdList.LEVELCOACH("show")
    panel = lua.ns.Panel
    row = next(r for r in visible_rows(panel) if r.data.item.where and r.data.item.where.zone)
    row.scripts.OnEnter(row)
    tip = lua.rt.globals().GameTooltip
    texts = [tip.lines[i].text for i in range(1, tip.NumLines(tip) + 1)]
    assert texts[0] == row.data.title
    assert any(t.startswith("Zone ") for t in texts)
    assert any(t.startswith("Done when") for t in texts)
    row.scripts.OnLeave(row)


def test_checkbox_marks_done_and_auto_rows_are_locked(wow_fixture):
    lua = load_all(wow_fixture)
    g = lua.rt.globals()
    g.SlashCmdList.LEVELCOACH("show")
    panel = lua.ns.Panel
    row = next(r for r in visible_rows(panel) if r.data.status == "now")
    item_id = row.data.id
    g.CLICK(row.check, "LeftButton")
    assert g.LevelCoachCharDB.manualDone[item_id] is True
    assert all(r.data.id != item_id for r in visible_rows(panel))  # moved to the collapsed Done section
    panel.toggleSection(panel, "done") if False else lua.ns.Panel.toggleSection("done")
    done_rows = [r for r in visible_rows(panel) if r.data.status == "done"]
    auto = next(r for r in done_rows if r.data.auto)
    manual = next(r for r in done_rows if r.data.id == item_id)
    assert auto.check.IsEnabled(auto.check) is False and auto.check.GetChecked(auto.check) is True
    assert manual.check.IsEnabled(manual.check) is True and manual.check.GetChecked(manual.check) is True
    g.CLICK(manual.check, "LeftButton")
    assert g.LevelCoachCharDB.manualDone[item_id] is None


def test_right_click_without_menu_api_skips_and_shift_click_pins(wow_fixture):
    lua = load_all(wow_fixture)
    g = lua.rt.globals()
    g.SlashCmdList.LEVELCOACH("show")
    panel = lua.ns.Panel
    row = next(r for r in visible_rows(panel) if r.data.status == "now")
    item_id = row.data.id
    g.CLICK(row, "RightButton")
    assert g.LevelCoachCharDB.skipped[item_id] is True
    lua.rt.execute("function IsShiftKeyDown() return true end")
    lua.rt.execute("TomTom = { AddWaypoint = function(self, m, x, y, opts) PINNED = { m, x, y, opts.title } end }")
    pinnable = next(r for r in visible_rows(panel) if r.data.item.where and r.data.item.where.waypoint)
    g.CLICK(pinnable, "LeftButton")
    assert g.PINNED[1] == 1420 and abs(g.PINNED[2] - pinnable.data.item.where.waypoint[1] / 100) < 1e-9


def test_lc_list_still_prints_to_chat(wow_fixture):
    lua = load_all(wow_fixture)
    lua.rt.globals().SlashCmdList.LEVELCOACH("list")
    assert any(line.endswith("Now:") for line in lua.rt.globals().CHAT.values())


def test_waypoint_targets_and_fallbacks(wow_fixture):
    lua = load_all(wow_fixture)
    wp = lua.ns.Waypoints
    assert wp.pin(lua.table({"id": "x", "where": {"zone": "Tirisfal Glades"}})) == (False, "no coordinates")
    item = lua.table({"id": "x", "title": "T", "where": {"zone": "Tirisfal Glades", "waypoint": [50, 25]}})
    assert wp.pin(item) == (False, "no waypoint support")
    assert wp.pin(lua.table({"id": "y", "where": {"zone": "Nowhere", "waypoint": [1, 1]}})) == (False, "no map id for Nowhere")
    lua.rt.execute("UiMapPoint = { CreateFromCoordinates = function(m, x, y) return { m = m, x = x, y = y } end }")
    lua.rt.execute("C_Map.SetUserWaypoint = function(p) PIN = p end")
    assert wp.pin(item) == (True, "map pin")
    assert lua.rt.globals().PIN.m == 1420 and abs(lua.rt.globals().PIN.y - 0.25) < 1e-9


def test_panel_position_saved_on_drag_stop(wow_fixture):
    lua = load_all(wow_fixture)
    g = lua.rt.globals()
    g.SlashCmdList.LEVELCOACH("show")
    frame = lua.ns.Panel.frame
    frame.SetPoint(frame, "TOPLEFT", g.UIParent, "TOPLEFT", 120, -80)
    frame.scripts.OnDragStop(frame)
    saved = g.LevelCoachDB.panel
    assert (saved.point, saved.x, saved.y) == ("TOPLEFT", 120, -80)
