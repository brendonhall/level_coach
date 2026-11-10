import pytest


def item(**kw):
    base = {"id": "vw", "title": "Do the Voidwalker quest", "why": "Your tank for ten levels.", "kind": "quest",
            "level": {"min": 10, "max": 12}, "priority": "high", "goals": ["any"], "tags": [],
            "where": {"zone": "Tirisfal Glades", "npc": "Halgar", "waypoint": [61.6, 52.4], "note": "Brill"},
            "done_when": {"type": "spell_known", "id": 697, "verify": "probe"},
            "verified": {"forever": False}, "sources": ["https://www.warcrafttavern.com/forever/guides/warlock-leveling/"],
            "detail": "First paragraph.\nSecond paragraph."}
    base.update(kw)
    return base


def entry(status, it=None, reason="in window"):
    return {"item": it or item(), "status": status, "reason": reason}


SNAP = {"level": 14, "class": "WARLOCK", "zone": "Silverpine Forest", "manualDone": {"manual-one": True}}
RESULT = {
    "now": [entry("now"), entry("now", item(id="b", title="B", where=None))],
    "overdue": [entry("overdue", reason="window ended at 12")],
    "soon": [entry("soon", reason="opens at 18")],
    "done": [entry("done", reason="detected: spell_known"), entry("done", item(id="manual-one"), reason="marked done")],
}


@pytest.fixture
def present(lua):
    lua.load_addon_file("Core/Present.lua")
    return lua


def test_model_sections_counts_and_rows(present):
    m = present.ns.Present.buildModel(present.table(RESULT), present.table(SNAP), present.table({"done": True}))
    assert m.header == "Level 14 Warlock  ·  Silverpine Forest"
    keys = [m.sections[i].key for i in range(1, 5)]
    assert keys == ["now", "overdue", "soon", "done"]
    counts = [m.sections[i].count for i in range(1, 5)]
    assert counts == [2, 1, 1, 2] and m.total == 6
    assert m.sections[4].collapsed is True and m.sections[1].collapsed is False
    row = m.sections[1].rows[1]
    assert (row.title, row.zoneText, row.checked, row.auto, row.status) == ("Do the Voidwalker quest", "Tirisfal Glades", False, False, "now")
    assert m.sections[1].rows[2].zoneText == ""
    done_rows = m.sections[4].rows
    assert done_rows[1].checked is True and done_rows[1].auto is True
    assert done_rows[2].checked is True and done_rows[2].auto is False


def test_model_tolerates_empty_result(present):
    m = present.ns.Present.buildModel(None, None, None)
    assert m.total == 0 and m.sections[1].count == 0 and m.header.startswith("Level ?")


def test_tooltip_lines_full_item(present):
    lines = present.ns.Present.tooltipLines(present.table(entry("now")), present.table(SNAP), None)
    texts = [(lines[i].text or (lines[i].left + " " + lines[i].right)) for i in range(1, len(lines) + 1)]
    assert texts[0] == "Do the Voidwalker quest"
    assert "Now" in texts[1] and "10 to 12" in texts[1] and "high" in texts[1]
    assert "Your tank for ten levels." in texts
    assert "First paragraph." in texts and "Second paragraph." in texts
    assert "Zone Tirisfal Glades" in texts and "NPC Halgar" in texts and "At 61.6, 52.4" in texts
    assert any(t.startswith("Done when") and "spell #697" in t for t in texts)
    assert any("Not yet verified" in t for t in texts)
    assert any(t.startswith("Source: www.warcrafttavern.com") for t in texts)
    assert any("Shift-click" in t for t in texts)
    why = next(lines[i] for i in range(1, len(lines) + 1) if lines[i].text == "Your tank for ten levels.")
    assert why.wrap is True


def test_tooltip_lines_without_where_or_detail(present):
    e = entry("done", item(id="x", where=None, detail=None, done_when={"type": "manual"}), reason="marked done")
    lines = present.ns.Present.tooltipLines(present.table(e), present.table(SNAP), None)
    texts = [(lines[i].text or (lines[i].left + " " + lines[i].right)) for i in range(1, len(lines) + 1)]
    assert not any(t.startswith("Zone ") or t.startswith("At ") for t in texts)
    assert not any("Shift-click" in t for t in texts)
    assert any("you tick it" in t for t in texts)


def test_tooltip_uses_resolver_for_names(present):
    resolver = present.rt.eval('{ spellName = function(id) return "Summon Voidwalker" end }')
    lines = present.ns.Present.tooltipLines(present.table(entry("now")), present.table(SNAP), resolver)
    texts = [lines[i].text or "" for i in range(1, len(lines) + 1)]
    assert any("Summon Voidwalker" in t for t in texts)


@pytest.mark.parametrize("dw,expected", [
    ({"type": "spell_known", "id": 5}, "you know spell #5"),
    ({"type": "quest_complete", "id": 7}, "quest #7 is complete"),
    ({"type": "skill_line", "name": "First Aid", "min": 75}, "First Aid reaches 75"),
    ({"type": "level_at_least", "n": 20}, "you reach level 20"),
    ({"type": "bind_location", "zone": "Brill"}, "your hearth is set in Brill"),
    ({"type": "has_item", "id": 9}, "item #9 is in your bags"),
    ({"type": "money_at_least", "copper": 1000000}, "you have 100 gold"),
    ({"type": "zone_visited", "zone": "The Barrens"}, "you have been to The Barrens"),
    ({"type": "taxi_known", "node": "Brill"}, "you know the flight path at Brill"),
    ({"type": "manual"}, "you tick it yourself"),
    ({"type": "any_of", "of": [{"type": "manual"}, {"type": "level_at_least", "n": 2}]}, "any of: you tick it yourself; you reach level 2"),
    ({"type": "all_of", "of": [{"type": "level_at_least", "n": 2}, {"type": "manual"}]}, "all of: you reach level 2; you tick it yourself"),
    ({"type": "telepathy"}, "unknown rule"),
])
def test_describe_detector(present, dw, expected):
    assert present.ns.Present.describeDetector(present.table(dw), None) == expected
