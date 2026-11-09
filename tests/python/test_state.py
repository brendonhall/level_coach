ADDON_FILES = ["Core/Init.lua", "Data/Items.lua", "Data/Zones.lua", "Data/Dungeons.lua", "Data/Overlay.lua",
               "Data/Overlay.pending.lua", "Core/Detectors.lua", "Core/Engine.lua", "Core/State.lua"]


def load_all(lua):
    for f in ADDON_FILES:
        lua.load_addon_file(f)
    lua.rt.globals().FIRE(lua.ns.frame, "ADDON_LOADED", "LevelCoach")
    return lua


def chat(lua):
    return list(lua.rt.globals().CHAT.values())


def test_snapshot_shape(wow_fixture):
    lua = load_all(wow_fixture)
    s = lua.ns.State.snapshot()
    assert (s.level, s["class"], s.race, s.faction) == (14, "WARLOCK", "Scourge", "Horde")
    assert s.spells["697"] is True and s.spells["712"] is None
    assert s.questsCompleted["1470"] is True
    assert s.skills["First Aid"] == 75 and s.skills["Weapon Skills"] is None
    assert s.money == 9500 and s.bindLocation == "Brill" and s.zone == "Silverpine Forest"
    assert s.zonesVisited["Silverpine Forest"] is True


def test_snapshot_survives_missing_api(wow_fixture):
    lua = load_all(wow_fixture)
    lua.rt.globals().C_QuestLog = None
    lua.rt.globals().IsPlayerSpell = None
    s = lua.ns.State.snapshot()
    assert s.questsCompleted is None and s.spells is None
    assert s.level == 14


def test_slash_lc_prints_now_and_marks_done(wow_fixture):
    lua = load_all(wow_fixture)
    g = lua.rt.globals()
    g.SlashCmdList.LEVELCOACH("")
    lines = chat(lua)
    assert any(line.endswith("Now:") for line in lines), lines
    assert any("Train Drain Life" in line for line in lines), lines
    overdue_at = next(i for i, line in enumerate(lines) if line.endswith("Overdue:"))
    imp_at = next(i for i, line in enumerate(lines) if "Imp class quest" in line)
    assert imp_at > overdue_at  # the level 1-4 quest is overdue at 14, listed after the Now section
    g.SlashCmdList.LEVELCOACH("done 1")
    assert len(list(g.LevelCoachCharDB.manualDone.keys())) == 1
    g.SlashCmdList.LEVELCOACH("skip general-first-aid")
    assert g.LevelCoachCharDB.skipped["general-first-aid"] is True


def test_snooze_undo_and_unknown_command(wow_fixture):
    lua = load_all(wow_fixture)
    g = lua.rt.globals()
    g.SlashCmdList.LEVELCOACH("")
    g.SlashCmdList.LEVELCOACH("snooze 1 2")
    snoozed = dict(g.LevelCoachCharDB.snoozedUntil.items())
    assert len(snoozed) == 1 and all(v > 7000 for v in snoozed.values())
    g.SlashCmdList.LEVELCOACH("done 2")
    g.SlashCmdList.LEVELCOACH("undo 2")
    assert len(list(g.LevelCoachCharDB.manualDone.keys())) == 0
    g.SlashCmdList.LEVELCOACH("skipp 3")
    assert any("unknown command" in line for line in chat(lua))


def test_pvp_ruleset_is_inferred_from_the_client(wow_fixture):
    lua = load_all(wow_fixture)
    assert lua.ns.effectiveGoals(lua.ns.State.snapshot()).pvpRuleset is True
    lua.rt.execute('function GetRealmName() return "Normal" end')
    assert lua.ns.effectiveGoals(lua.ns.State.snapshot()).pvpRuleset is False


def test_level_up_event_prints_now_section(wow_fixture):
    lua = load_all(wow_fixture)
    g = lua.rt.globals()
    g.FIRE(lua.ns.frame, "PLAYER_LEVEL_UP", 15)
    assert any("Level 15" in line for line in chat(lua))
