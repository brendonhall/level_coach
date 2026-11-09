def test_load_addon_file_shares_namespace(lua):
    lua.load_addon_file("Core/Init.lua")
    assert lua.ns.print is not None
    lua.ns.print("hello")
    assert "hello" in lua.rt.globals().CHAT[1]


def test_table_conversion_round_trip(lua):
    t = lua.table({"level": 14, "spells": {"686": True}, "tags": ["pvp"]})
    assert t.level == 14 and t.tags[1] == "pvp" and t.spells["686"] is True


def test_slash_dispatch_and_events(lua):
    lua.load_addon_file("Core/Init.lua")
    g = lua.rt.globals()
    g.SlashCmdList.LEVELCOACH("help")
    assert any("commands:" in line for line in g.CHAT.values())
    g.FIRE(lua.ns.frame, "ADDON_LOADED", "LevelCoach")
    assert g.LevelCoachDB is not None and g.LevelCoachCharDB is not None
