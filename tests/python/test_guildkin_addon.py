FILES = ["Core/Init.lua", "Core/Names.lua", "Core/Plan.lua", "Core/Roster.lua", "Core/Prefill.lua", "UI/Window.lua"]


def load_all(lua):
    ns = lua.rt.table()
    for f in FILES:
        lua.load_addon_file(f, addon="GuildKin", ns=ns)
    g = lua.rt.globals()
    g.FIRE(ns.frame, "ADDON_LOADED", "GuildKin")
    g.FIRE(ns.frame, "PLAYER_ENTERING_WORLD")
    g.FIRE(ns.frame, "GUILD_ROSTER_UPDATE", False)
    return lua, ns


def chat(lua):
    return list(lua.rt.globals().CHAT.values())


def test_roster_members_and_permissions(guild_fixture):
    lua, ns = load_all(guild_fixture)
    members, reason = ns.Roster.members()
    assert reason is None and len(members) == 4
    assert (members[1].name, members[1].guid, members[1].officerNote) == ("Boney-Scruggins", "Player-1", "")
    assert members[2].officerNote == "Scruggins | bank alt"
    lua.rt.execute("C_GuildInfo.CanViewOfficerNote = function() return false end")
    members, _ = ns.Roster.members()
    assert members[1].officerNote is None
    lua.rt.execute("GetGuildRosterInfo = nil")
    members, reason = ns.Roster.members()
    assert len(members) == 0 and reason == "roster API missing"


def test_roster_update_builds_plan_and_requests_roster(guild_fixture):
    lua, ns = load_all(guild_fixture)
    assert lua.rt.globals().ROSTER_REQUESTS >= 1
    plan = ns.plan
    assert (plan.counts.pending, plan.counts.done, plan.counts.skipped) == (2, 1, 1)
    assert plan.pending[1].member.name == "Zed-Ironfoot" and plan.pending[2].desired == "Scruggins"


def test_prefill_fills_only_the_officer_note_dialog_for_a_pending_toon(guild_fixture):
    lua, ns = load_all(guild_fixture)
    g = lua.rt.globals()
    dialog = g.StaticPopup_Show("SET_GUILDOFFICERNOTE", None, None, lua.table({"guid": "Player-1", "currentNote": ""}))
    assert dialog.editBox.GetText(dialog.editBox) == "Scruggins"
    assert any("Press Enter" in line for line in chat(lua))
    other = g.StaticPopup_Show("SET_GUILDPLAYERNOTE", None, None, lua.table({"guid": "Player-1", "currentNote": ""}))
    assert other.editBox.GetText(other.editBox) is None
    done = g.StaticPopup_Show("SET_GUILDOFFICERNOTE", None, None, lua.table({"guid": "Player-2", "currentNote": "x"}))
    assert done.editBox.GetText(done.editBox) is None
    g.SlashCmdList.GUILDKIN("prefill off")
    again = g.StaticPopup_Show("SET_GUILDOFFICERNOTE", None, None, lua.table({"guid": "Player-3", "currentNote": "raider"}))
    assert again.editBox.GetText(again.editBox) is None


def test_window_lists_pending_rows_with_copyable_text(guild_fixture):
    lua, ns = load_all(guild_fixture)
    g = lua.rt.globals()
    g.SlashCmdList.GUILDKIN("")
    w = ns.Window
    assert w.frame.IsShown(w.frame) is True
    assert w.rowCount == 2
    assert w.rows[1].edit.GetText(w.rows[1].edit) == "Ironfoot | raider"
    assert "Zed Ironfoot" in w.rows[1].name.GetText(w.rows[1].name)
    assert "2 to do" in w.frame.header.GetText(w.frame.header) and "1 done" in w.frame.header.GetText(w.frame.header)
    g.SlashCmdList.GUILDKIN("")
    assert w.frame.IsShown(w.frame) is False


def test_player_family_and_mode_commands_change_the_plan(guild_fixture):
    lua, ns = load_all(guild_fixture)
    g = lua.rt.globals()
    g.SlashCmdList.GUILDKIN("player Nameless Brendon")
    assert g.GuildKinDB.overrides["nameless"] == "Brendon"
    assert ns.plan.counts.skipped == 0 and ns.plan.counts.pending == 3
    g.SlashCmdList.GUILDKIN("family Ironfoot Jane Doe")
    assert g.GuildKinDB.families["ironfoot"] == "Jane Doe"
    zed = next(ns.plan.pending[i] for i in range(1, 4) if ns.plan.pending[i].member.name == "Zed-Ironfoot")
    assert zed.desired == "Jane Doe | raider"
    g.SlashCmdList.GUILDKIN("mode replace")
    zed = next(ns.plan.pending[i] for i in range(1, 4) if ns.plan.pending[i].member.name == "Zed-Ironfoot")
    assert zed.desired == "Jane Doe"
    g.SlashCmdList.GUILDKIN("forget Nameless")
    assert g.GuildKinDB.overrides["nameless"] is None


def test_probe_records_raw_rows(guild_fixture):
    lua, ns = load_all(guild_fixture)
    g = lua.rt.globals()
    g.SlashCmdList.GUILDKIN("probe")
    probe = g.GuildKinDB.probe
    assert probe["member.1"].startswith("Boney-Scruggins")
    assert "canView=true" in probe.permissions


def test_outside_a_guild_scan_says_so(guild_fixture):
    lua, ns = load_all(guild_fixture)
    lua.rt.execute("function IsInGuild() return false end")
    lua.rt.globals().SlashCmdList.GUILDKIN("scan")
    assert any("not in a guild" in line for line in chat(lua))
