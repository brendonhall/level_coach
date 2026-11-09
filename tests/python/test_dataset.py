from tools.build_data import load_all

REQUIRED = [
    "warlock-imp-quest", "warlock-train-immolate", "general-first-wand", "general-pick-professions",
    "general-first-aid", "warlock-voidwalker-quest", "warlock-first-talent", "warlock-healthstone",
    "general-hearth-brill", "dungeon-ruins-of-lordaeron", "warlock-sayaad-quest", "general-riding-savings",
]


def test_dataset_covers_levels_1_to_20_for_undead_warlock():
    data = load_all("data")
    items = data["items"]
    ids = {i["id"] for i in items}
    for required in REQUIRED:
        assert required in ids, required
    for lvl in range(1, 21):
        assert any(i["level"]["min"] <= lvl <= i["level"]["max"] for i in items), lvl
    assert all(i["verified"]["forever"] is False for i in items)
    assert {z["name"] for z in data["zones"]} >= {"Tirisfal Glades", "Silverpine Forest", "The Barrens"}
    assert {d["name"] for d in data["dungeons"]} >= {"Ruins of Lordaeron", "Ragefire Chasm", "Wailing Caverns"}


def test_class_items_are_class_scoped_and_pvp_items_tagged():
    items = load_all("data")["items"]
    for i in items:
        if i["id"].startswith("warlock-"):
            assert i.get("classes") == ["WARLOCK"], i["id"]
        if i["id"].startswith("undead-"):
            assert i.get("races") == ["Scourge"], i["id"]
        if "pvp" in i["id"]:
            assert "pvp" in i.get("tags", []), i["id"]
