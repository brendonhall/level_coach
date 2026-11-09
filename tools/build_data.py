"""Compile the YAML guide data under data/ into Lua tables under LevelCoach/Data/.

Usage:
    python -m tools.build_data            # write LevelCoach/Data/*.lua
    python -m tools.build_data --check    # exit 1 if any generated file is stale
"""
from __future__ import annotations

import argparse
import pathlib
import sys
from typing import Any, Iterator

import yaml
from jsonschema import ValidationError

from tools.schema import validate

ROOT = pathlib.Path(__file__).resolve().parents[1]
DEFAULT_DATA = ROOT / "data"
DEFAULT_OUT = ROOT / "LevelCoach" / "Data"
OUTPUTS = {"Items": "items", "Zones": "zones", "Dungeons": "dungeons"}
NUMERIC_ID_DETECTORS = {"quest_complete", "spell_known", "has_item"}


class BuildError(Exception):
    """A data file is invalid. The message names the file."""


def load_yaml(path: pathlib.Path) -> Any:
    try:
        data = yaml.safe_load(path.read_text(encoding="utf-8"))
    except yaml.YAMLError as exc:
        raise BuildError(f"{path.name}: YAML error: {exc}") from exc
    return [] if data is None else data


def _detectors(dw: dict) -> Iterator[dict]:
    yield dw
    for child in dw.get("of") or []:
        yield from _detectors(child)


def _check_verify(item: dict, path: pathlib.Path) -> None:
    if item.get("verified", {}).get("forever"):
        return
    for det in _detectors(item["done_when"]):
        if det.get("type") in NUMERIC_ID_DETECTORS and "verify" not in det:
            raise BuildError(
                f"{path.name}: item '{item['id']}' done_when {det['type']} {det.get('id')} "
                "needs a verify note until verified.forever is true"
            )


def _validated_list(path: pathlib.Path, kind: str) -> list[dict]:
    if not path.exists():
        raise BuildError(f"{path.name}: missing; create it with an empty list ([]) if there is nothing to add")
    entries = load_yaml(path)
    if not isinstance(entries, list):
        raise BuildError(f"{path.name}: expected a list of {kind} entries")
    for entry in entries:
        try:
            validate(kind, entry)
        except ValidationError as exc:
            where = "/".join(str(p) for p in exc.path) or kind
            raise BuildError(f"{path.name}: {exc.message} (at {where})") from exc
    return entries


def load_all(data_dir: str | pathlib.Path) -> dict[str, list[dict]]:
    """Load and validate every data file. Returns {"items": [...], "zones": [...], "dungeons": [...]}."""
    data_dir = pathlib.Path(data_dir)
    items: list[dict] = []
    seen: dict[str, str] = {}
    for path in sorted((data_dir / "items").glob("*.yaml")):
        for entry in _validated_list(path, "item"):
            if entry["id"] in seen:
                raise BuildError(f"{path.name}: duplicate id '{entry['id']}' (also in {seen[entry['id']]})")
            seen[entry["id"]] = path.name
            _check_verify(entry, path)
            items.append(entry)
    return {
        "items": items,
        "zones": _validated_list(data_dir / "zones.yaml", "zone"),
        "dungeons": _validated_list(data_dir / "dungeons.yaml", "dungeon"),
    }


def _lua_string(text: str) -> str:
    escaped = (text.replace("\\", "\\\\").replace('"', '\\"')
               .replace("\n", "\\n").replace("\r", "\\r").replace("\t", "\\t"))
    return f'"{escaped}"'


def _lua(value: Any, indent: int) -> str:
    pad = "  " * indent
    if value is None:
        return "nil"
    if value is True:
        return "true"
    if value is False:
        return "false"
    if isinstance(value, int):
        return str(value)
    if isinstance(value, float):
        return repr(value)
    if isinstance(value, str):
        return _lua_string(value)
    if isinstance(value, (list, tuple)):
        if not value:
            return "{}"
        inner = ",\n".join(pad + "  " + _lua(v, indent + 1) for v in value)
        return "{\n" + inner + ",\n" + pad + "}"
    if isinstance(value, dict):
        if not value:
            return "{}"
        inner = ",\n".join(f'{pad}  [{_lua_string(str(k))}] = {_lua(value[k], indent + 1)}' for k in sorted(value, key=str))
        return "{\n" + inner + ",\n" + pad + "}"
    raise BuildError(f"cannot render a {type(value).__name__} as Lua")


def render_lua(name: str, value: Any) -> str:
    """Render ``value`` as the Lua file that sets ``ns.Data.<name>``."""
    return f"local _, ns = ...\nns.Data = ns.Data or {{}}\nns.Data.{name} = {_lua(value, 0)}\n"


def render_all(data: dict[str, list[dict]]) -> dict[str, str]:
    return {f"{name}.lua": render_lua(name, data[key]) for name, key in OUTPUTS.items()}


def build(data_dir: str | pathlib.Path, out_dir: str | pathlib.Path) -> list[pathlib.Path]:
    """Validate the data and write the generated Lua files. Returns the written paths."""
    rendered = render_all(load_all(data_dir))
    out_dir = pathlib.Path(out_dir)
    out_dir.mkdir(parents=True, exist_ok=True)
    written = []
    for filename, text in rendered.items():
        target = out_dir / filename
        target.write_text(text, encoding="utf-8")
        written.append(target)
    return written


def stale_files(data_dir: str | pathlib.Path, out_dir: str | pathlib.Path) -> list[str]:
    """Names of generated files that are missing or differ from a fresh render."""
    rendered = render_all(load_all(data_dir))
    out_dir = pathlib.Path(out_dir)
    stale = []
    for filename, text in rendered.items():
        target = out_dir / filename
        if not target.exists() or target.read_text(encoding="utf-8") != text:
            stale.append(filename)
    return stale


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--data", default=DEFAULT_DATA, type=pathlib.Path)
    parser.add_argument("--out", default=DEFAULT_OUT, type=pathlib.Path)
    parser.add_argument("--check", action="store_true", help="verify generated files are current; write nothing")
    args = parser.parse_args(argv)
    try:
        if args.check:
            stale = stale_files(args.data, args.out)
            if stale:
                print("stale generated files: " + ", ".join(stale) + " (run: python -m tools.build_data)")
                return 1
            print("generated data is current")
            return 0
        for path in build(args.data, args.out):
            print(f"wrote {path.relative_to(ROOT) if path.is_relative_to(ROOT) else path}")
        return 0
    except BuildError as exc:
        print(f"build error: {exc}", file=sys.stderr)
        return 2


if __name__ == "__main__":
    raise SystemExit(main())
