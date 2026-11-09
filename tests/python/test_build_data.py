import pytest

from tools.build_data import BuildError, build, render_lua


def write_data(tmp_path, items_yaml, zones="[]", dungeons="[]"):
    (tmp_path / "items").mkdir(exist_ok=True)
    (tmp_path / "items" / "a.yaml").write_text(items_yaml, encoding="utf-8")
    (tmp_path / "zones.yaml").write_text(zones, encoding="utf-8")
    (tmp_path / "dungeons.yaml").write_text(dungeons, encoding="utf-8")


def test_render_lua_is_deterministic_and_escapes():
    out = render_lua("Items", [{"id": "a", "title": 'say "hi"\\n', "level": {"min": 1, "max": 5}, "tags": []}])
    assert out.startswith("local _, ns = ...\nns.Data = ns.Data or {}\nns.Data.Items = {")
    assert '"say \\"hi\\"\\\\n"' in out
    assert out.index('["id"]') < out.index('["level"]') < out.index('["tags"]')
    assert '["tags"] = {}' in out
    assert render_lua("Items", []) == "local _, ns = ...\nns.Data = ns.Data or {}\nns.Data.Items = {}\n"


def test_build_rejects_invalid_item(tmp_path):
    (tmp_path / "items").mkdir()
    (tmp_path / "items" / "bad.yaml").write_text("- id: bad\n  title: x\n", encoding="utf-8")
    (tmp_path / "zones.yaml").write_text("[]")
    (tmp_path / "dungeons.yaml").write_text("[]")
    with pytest.raises(BuildError, match="bad.yaml"):
        build(tmp_path, tmp_path / "out")


def test_build_rejects_duplicate_ids(tmp_path, valid_item_yaml):
    write_data(tmp_path, valid_item_yaml + valid_item_yaml)
    with pytest.raises(BuildError, match="duplicate id"):
        build(tmp_path, tmp_path / "out")


def test_build_requires_verify_note_on_numeric_detectors(tmp_path, valid_item_yaml):
    write_data(tmp_path, valid_item_yaml.replace('    verify: "probe: name must be Summon Voidwalker"\n', ""))
    with pytest.raises(BuildError, match="verify"):
        build(tmp_path, tmp_path / "out")


def test_verified_items_need_no_verify_note(tmp_path, valid_item_yaml):
    yaml_text = valid_item_yaml.replace('    verify: "probe: name must be Summon Voidwalker"\n', "")
    yaml_text = yaml_text.replace("verified: {forever: false}", "verified: {forever: true, by: brendon, date: '2026-11-20'}")
    write_data(tmp_path, yaml_text)
    assert len(build(tmp_path, tmp_path / "out")) == 3


def test_generated_lua_compiles(tmp_path, valid_item_yaml, lua):
    write_data(tmp_path, valid_item_yaml,
               zones="- {name: Tirisfal Glades, faction: Horde, level: {min: 1, max: 10}, continent: Eastern Kingdoms, new: false}",
               dungeons="- {name: Ruins of Lordaeron, level: {min: 15, max: 20}, zone: Undercity, new: true}")
    paths = build(tmp_path, tmp_path / "out")
    assert sorted(p.name for p in paths) == ["Dungeons.lua", "Items.lua", "Zones.lua"]
    for path in paths:
        lua.compile(path.read_text(encoding="utf-8"), "=" + path.name)
