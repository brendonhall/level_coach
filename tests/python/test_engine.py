import pytest


def item(**kw):
    base = {"id": kw.get("id", "x"), "title": "t", "why": "w", "kind": "train", "level": {"min": 10, "max": 60},
            "priority": "normal", "goals": ["any"], "tags": [], "done_when": {"type": "manual"},
            "verified": {"forever": False}, "sources": ["https://example.invalid/"]}
    base.update(kw)
    return base


GOALS = {"aim": "learn", "dungeons": "convenient", "battlegrounds": False, "pvpRuleset": True}
SNAP = {"level": 14, "class": "WARLOCK", "race": "Scourge", "faction": "Horde", "zone": "Silverpine Forest",
        "spells": {}, "questsCompleted": {}, "skills": {}, "items": {}, "manualDone": {}, "skipped": {},
        "snoozedUntil": {}, "now": 1_000_000}


def ids(section):
    return [i for i, _ in section]


@pytest.fixture
def engine(lua):
    lua.load_addon_file("Core/Detectors.lua")
    lua.load_addon_file("Core/Engine.lua")

    def run(items, snap=SNAP, goals=GOALS):
        r = lua.ns.Engine.evaluate(lua.table(snap), lua.table(goals), lua.table(items))
        out = {}
        for k in ("now", "soon", "overdue", "done"):
            section = r[k]
            out[k] = [(section[i].item.id, section[i].status) for i in range(1, len(section) + 1)]
        return out
    return run


def test_sections_by_level_window(engine):
    r = engine([item(id="now", level={"min": 10, "max": 20}), item(id="soon", level={"min": 18, "max": 30}),
                item(id="far", level={"min": 30, "max": 40}), item(id="late", level={"min": 5, "max": 12})])
    assert r["now"] == [("now", "now")]
    assert r["soon"] == [("soon", "soon")]
    assert r["overdue"] == [("late", "overdue")]
    assert all("far" not in ids(section) for section in r.values())


def test_overdue_surfaces_missed_class_quest(engine):
    r = engine([item(id="vw", kind="quest", level={"min": 10, "max": 12}, classes=["WARLOCK"])])
    assert r["overdue"] == [("vw", "overdue")]


def test_overdue_false_drops_expired_items(engine):
    r = engine([item(id="habit", level={"min": 1, "max": 9}, overdue=False)])
    assert all(section == [] for section in r.values())


def test_detector_completion_moves_to_done(engine):
    snap = dict(SNAP, spells={"697": True})
    r = engine([item(id="vw", done_when={"type": "spell_known", "id": 697})], snap=snap)
    assert r["done"] == [("vw", "done")]


def test_done_items_stay_done_even_outside_window(engine):
    snap = dict(SNAP, spells={"688": True})
    r = engine([item(id="imp", level={"min": 1, "max": 4}, done_when={"type": "spell_known", "id": 688})], snap=snap)
    assert r["done"] == [("imp", "done")] and r["overdue"] == []


def test_class_race_faction_filters(engine):
    r = engine([item(id="mage", classes=["MAGE"]), item(id="orc", races=["Orc"]),
                item(id="ally", factions=["Alliance"]), item(id="ok", classes=["WARLOCK"], factions=["Horde"])])
    assert ids(r["now"]) == ["ok"]


def test_goal_filter(engine):
    items = [item(id="dng", goals=["dungeons"]), item(id="fast", goals=["fast"]), item(id="any")]
    assert ids(engine(items)["now"]) == ["any", "dng"]
    assert ids(engine(items, goals=dict(GOALS, dungeons="avoid"))["now"]) == ["any"]


def test_pvp_tag_needs_pvp_ruleset_or_goal(engine):
    items = [item(id="pvp", tags=["pvp"])]
    assert ids(engine(items)["now"]) == ["pvp"]
    assert engine(items, goals=dict(GOALS, pvpRuleset=False))["now"] == []
    assert ids(engine(items, goals=dict(GOALS, pvpRuleset=False, battlegrounds=True))["now"]) == ["pvp"]


def test_ranking_priority_then_current_zone(engine):
    items = [item(id="low", priority="low"), item(id="here", priority="normal", where={"zone": "Silverpine Forest"}),
             item(id="there", priority="normal", where={"zone": "The Barrens"}), item(id="hi", priority="high")]
    assert ids(engine(items)["now"]) == ["hi", "here", "there", "low"]


def test_manual_done_skipped_and_snoozed(engine):
    snap = dict(SNAP, manualDone={"a": True}, skipped={"b": True}, snoozedUntil={"c": 9e12, "e": 1})
    r = engine([item(id="a"), item(id="b"), item(id="c"), item(id="d"), item(id="e")], snap=snap)
    assert r["done"] == [("a", "done")]
    assert ids(r["now"]) == ["d", "e"]


def test_applies_is_exposed(lua):
    lua.load_addon_file("Core/Detectors.lua")
    lua.load_addon_file("Core/Engine.lua")
    assert lua.ns.Engine.applies(lua.table(item(classes=["WARLOCK"])), lua.table(SNAP), lua.table(GOALS)) is True
    assert lua.ns.Engine.applies(lua.table(item(classes=["MAGE"])), lua.table(SNAP), lua.table(GOALS)) is False
