import pathlib

from lupa.lua51 import LuaRuntime

import pytest

REPO = pathlib.Path(__file__).resolve().parents[2]
ADDONS = ["LevelCoach", "GuildKin"]


def toc_files(addon):
    root = REPO / addon
    toc = (root / f"{addon}.toc").read_text(encoding="utf-8").splitlines()
    assert "## Interface: 16001" in toc
    return [root / line.strip().replace("\\", "/") for line in toc if line.strip() and not line.startswith("#")]


@pytest.mark.parametrize("addon", ADDONS)
def test_every_toc_file_compiles(addon):
    rt = LuaRuntime()
    load = rt.eval("function(src, name) local f, err = loadstring(src, name); assert(f, err); return true end")
    files = toc_files(addon)
    assert files, "TOC lists no files"
    for path in files:
        assert path.exists(), path
        assert load(path.read_text(encoding="utf-8"), "=" + path.name)
