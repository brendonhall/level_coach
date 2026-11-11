import pytest


@pytest.fixture
def gk(lua):
    ns = lua.rt.table()
    lua.load_addon_file("Core/Names.lua", addon="GuildKin", ns=ns)
    lua.load_addon_file("Core/Plan.lua", addon="GuildKin", ns=ns)
    return lua, ns


@pytest.mark.parametrize("full,first,last", [
    ("Boney-Scruggins", "Boney", "Scruggins"),
    ("Boney Scruggins", "Boney", "Scruggins"),
    ("  Boney Scruggins  ", "Boney", "Scruggins"),
    ("Boney", "Boney", None),
    ("", None, None),
])
def test_names_split(gk, full, first, last):
    lua, ns = gk
    assert ns.Names.split(full) == (first, last)


def test_names_display(gk):
    lua, ns = gk
    assert ns.Names.display("Boney", "Scruggins") == "Boney Scruggins"
    assert ns.Names.display("Boney", None) == "Boney"


def member(name, note="", **kw):
    m = {"name": name, "guid": "Player-" + name, "officerNote": note, "level": 10, "online": True}
    m.update(kw)
    return m


def test_player_resolution_order(gk):
    lua, ns = gk
    opts = lua.table({"overrides": {"boney-scruggins": "Brendon"}, "families": {"doe": "Jane"}})
    assert ns.Plan.playerFor(lua.table(member("Boney-Scruggins")), opts) == ("Brendon", "override")
    assert ns.Plan.playerFor(lua.table(member("Alta-Doe")), opts) == ("Jane", "family")
    assert ns.Plan.playerFor(lua.table(member("Zed-Ironfoot")), opts) == ("Ironfoot", "surname")
    assert ns.Plan.playerFor(lua.table(member("Lonely")), opts) == (None, "no surname")


def test_desired_note_prefix_replace_and_idempotence(gk):
    lua, ns = gk
    plan = ns.Plan
    assert plan.desiredNote("", "Scruggins", None) == "Scruggins"
    assert plan.desiredNote("tank, raids tue", "Scruggins", None) == "Scruggins | tank, raids tue"
    assert plan.desiredNote("Scruggins | tank", "Scruggins", None) == "Scruggins | tank"
    assert plan.desiredNote("scruggins", "Scruggins", None) == "scruggins"
    assert plan.desiredNote("tank", "Scruggins", lua.table({"mode": "replace"})) == "Scruggins"
    long = plan.desiredNote("a very long officer note indeed, truly", "Scruggins", None)
    assert len(long) == 31 and long.startswith("Scruggins | ")


def test_has_player_requires_a_separator_after_the_name(gk):
    lua, ns = gk
    assert ns.Plan.hasPlayer("Scruggins | x", "Scruggins") is True
    assert ns.Plan.hasPlayer("Scruggins", "Scruggins") is True
    assert ns.Plan.hasPlayer("Scrugginsson", "Scruggins") is False
    assert ns.Plan.hasPlayer("x Scruggins", "Scruggins") is False
    assert ns.Plan.hasPlayer(None, "Scruggins") is False


def test_build_sorts_into_pending_done_skipped_and_groups(gk):
    lua, ns = gk
    members = [
        member("Boney-Scruggins", ""),
        member("Alta-Scruggins", "Scruggins | bank alt"),
        member("Zed-Ironfoot", "raider"),
        member("Nameless", ""),
        member("Secret-Keeper", None),
    ]
    r = ns.Plan.build(lua.table(members), lua.table({}))
    pending = [(r.pending[i].member.name, r.pending[i].desired) for i in range(1, len(r.pending) + 1)]
    assert pending == [("Zed-Ironfoot", "Ironfoot | raider"), ("Boney-Scruggins", "Scruggins")]
    assert [r.done[i].member.name for i in range(1, len(r.done) + 1)] == ["Alta-Scruggins"]
    skipped = {r.skipped[i].member.name: r.skipped[i].reason for i in range(1, len(r.skipped) + 1)}
    assert skipped == {"Nameless": "no surname", "Secret-Keeper": "officer note unreadable"}
    assert len(r.groups["Scruggins"]) == 2 and len(r.groups["Ironfoot"]) == 1
    assert (r.counts.pending, r.counts.done, r.counts.skipped) == (2, 1, 2)
