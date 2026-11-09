import pathlib

from lupa.lua51 import LuaRuntime

ROOT = pathlib.Path(__file__).resolve().parents[2] / "LevelCoach"


def toc_files():
    toc = (ROOT / "LevelCoach.toc").read_text(encoding="utf-8").splitlines()
    assert "## Interface: 16001" in toc
    return [ROOT / line.strip().replace("\\", "/") for line in toc if line.strip() and not line.startswith("#")]


def test_every_toc_file_compiles():
    rt = LuaRuntime()
    load = rt.eval("function(src, name) local f, err = loadstring(src, name); assert(f, err); return true end")
    files = toc_files()
    assert files, "TOC lists no files"
    for path in files:
        assert path.exists(), path
        assert load(path.read_text(encoding="utf-8"), "=" + path.name)
