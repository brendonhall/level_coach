import pytest

SNAP = {
    "level": 14, "money": 9500, "bindLocation": "Brill", "zone": "Silverpine Forest",
    "spells": {"697": True}, "questsCompleted": {"1470": True}, "skills": {"First Aid": 75},
    "items": {"6948": 1}, "zonesVisited": {"Tirisfal Glades": True},
    "taxiNodes": {"Brill, Tirisfal Glades": True},
}


@pytest.fixture
def check(lua):
    lua.load_addon_file("Core/Detectors.lua")
    return lambda dw, snap=SNAP: lua.ns.Detectors.check(lua.table(dw), lua.table(snap))


@pytest.mark.parametrize("dw,expected", [
    ({"type": "spell_known", "id": 697}, True),
    ({"type": "spell_known", "id": 712}, False),
    ({"type": "quest_complete", "id": 1470}, True),
    ({"type": "quest_complete", "id": 1740}, False),
    ({"type": "skill_line", "name": "First Aid", "min": 75}, True),
    ({"type": "skill_line", "name": "First Aid", "min": 76}, False),
    ({"type": "skill_line", "name": "Cooking", "min": 1}, False),
    ({"type": "level_at_least", "n": 14}, True),
    ({"type": "level_at_least", "n": 15}, False),
    ({"type": "bind_location", "zone": "Brill"}, True),
    ({"type": "bind_location", "zone": "brill"}, True),
    ({"type": "bind_location", "zone": "Crossroads"}, False),
    ({"type": "has_item", "id": 6948}, True),
    ({"type": "has_item", "id": 1}, False),
    ({"type": "money_at_least", "copper": 9500}, True),
    ({"type": "money_at_least", "copper": 9501}, False),
    ({"type": "zone_visited", "zone": "Tirisfal Glades"}, True),
    ({"type": "zone_visited", "zone": "The Barrens"}, False),
    ({"type": "taxi_known", "node": "Brill, Tirisfal Glades"}, True),
    ({"type": "any_of", "of": [{"type": "spell_known", "id": 1}, {"type": "level_at_least", "n": 1}]}, True),
    ({"type": "any_of", "of": [{"type": "spell_known", "id": 1}, {"type": "level_at_least", "n": 99}]}, False),
    ({"type": "all_of", "of": [{"type": "spell_known", "id": 1}, {"type": "level_at_least", "n": 1}]}, False),
    ({"type": "all_of", "of": [{"type": "spell_known", "id": 697}, {"type": "level_at_least", "n": 1}]}, True),
])
def test_detectors(check, dw, expected):
    assert check(dw) == expected


def test_unknown_type_returns_nil_not_error(check):
    assert check({"type": "telepathy"}) is None


def test_manual_returns_nil(check):
    assert check({"type": "manual"}) is None


def test_missing_snapshot_section_returns_nil(check):
    assert check({"type": "spell_known", "id": 697}, snap={"level": 14}) is None
    assert check({"type": "money_at_least", "copper": 1}, snap={"level": 14}) is None


def test_any_of_with_only_unknowns_is_nil_and_all_of_with_unknown_is_nil(check):
    assert check({"type": "any_of", "of": [{"type": "manual"}, {"type": "spell_known", "id": 1}]}, snap={"level": 1}) is None
    assert check({"type": "all_of", "of": [{"type": "level_at_least", "n": 1}, {"type": "manual"}]}) is None
    assert check({"type": "all_of", "of": [{"type": "level_at_least", "n": 99}, {"type": "manual"}]}) is False
