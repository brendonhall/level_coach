import jsonschema
import pytest

from tools.schema import validate

VALID_ITEM = {
    "id": "warlock-voidwalker-quest",
    "title": "Do the Voidwalker quest: Halgar's Summons",
    "why": "Your tank for ten levels. Take the Brill version, not Orgrimmar's.",
    "kind": "quest",
    "level": {"min": 10, "max": 60},
    "classes": ["WARLOCK"],
    "races": ["Scourge"],
    "factions": ["Horde"],
    "goals": ["any"],
    "tags": [],
    "priority": "high",
    "where": {"zone": "Tirisfal Glades", "npc": "Halgar", "waypoint": [61.6, 52.4]},
    "done_when": {"type": "spell_known", "id": 697, "verify": "probe: name must be Summon Voidwalker"},
    "verified": {"forever": False},
    "sources": ["https://www.warcrafttavern.com/forever/guides/warlock-leveling/"],
}


def test_valid_item_passes():
    validate("item", VALID_ITEM)


@pytest.mark.parametrize("field", ["id", "title", "why", "level", "done_when", "verified", "sources"])
def test_missing_required_field_fails(field):
    bad = {k: v for k, v in VALID_ITEM.items() if k != field}
    with pytest.raises(jsonschema.ValidationError):
        validate("item", bad)


def test_unknown_detector_type_fails():
    with pytest.raises(jsonschema.ValidationError):
        validate("item", dict(VALID_ITEM, done_when={"type": "telepathy"}))


def test_level_max_below_min_fails():
    with pytest.raises(jsonschema.ValidationError):
        validate("item", dict(VALID_ITEM, level={"min": 20, "max": 10}))


def test_nested_detectors_validate():
    nested = {"type": "any_of", "of": [{"type": "manual"}, {"type": "level_at_least", "n": 5}]}
    validate("item", dict(VALID_ITEM, done_when=nested))
    with pytest.raises(jsonschema.ValidationError):
        validate("item", dict(VALID_ITEM, done_when={"type": "any_of", "of": [{"type": "nope"}]}))


def test_zone_dungeon_goals_schemas():
    validate("zone", {"name": "Tirisfal Glades", "faction": "Horde", "level": {"min": 1, "max": 10},
                      "continent": "Eastern Kingdoms", "new": False, "mapID": 1420, "verify": "probe loc.mapID"})
    validate("dungeon", {"name": "Ruins of Lordaeron", "level": {"min": 15, "max": 20}, "zone": "Undercity", "new": True})
    validate("goals", {"aim": "learn", "secondary": "story", "guidance": "zones", "professions": "craft",
                       "dungeons": "convenient", "battlegrounds": False, "session": "medium", "pvpRuleset": True})
    with pytest.raises(jsonschema.ValidationError):
        validate("goals", {"aim": "win"})
