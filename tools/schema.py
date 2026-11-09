"""JSON Schema validation for Level Coach guide data, plus the rules JSON Schema cannot express."""
from __future__ import annotations

import json
import pathlib
from functools import lru_cache

from jsonschema import Draft202012Validator, ValidationError

SCHEMA_DIR = pathlib.Path(__file__).resolve().parents[1] / "data" / "schema"
KINDS = ("item", "zone", "dungeon", "goals")


@lru_cache(maxsize=None)
def load_schema(kind: str) -> dict:
    if kind not in KINDS:
        raise ValueError(f"unknown schema kind {kind!r}; expected one of {KINDS}")
    return json.loads((SCHEMA_DIR / f"{kind}.schema.json").read_text(encoding="utf-8"))


def validate(kind: str, obj: dict) -> dict:
    """Validate ``obj`` against the ``kind`` schema and the extra rules. Raises ValidationError."""
    validator = Draft202012Validator(load_schema(kind))
    errors = sorted(validator.iter_errors(obj), key=lambda e: (list(e.path), e.message))
    if errors:
        raise errors[0]
    level = obj.get("level") if isinstance(obj, dict) else None
    if isinstance(level, dict) and level.get("min") is not None and level.get("max") is not None:
        if level["min"] > level["max"]:
            raise ValidationError(f"level.min ({level['min']}) is greater than level.max ({level['max']})", path=["level"])
    return obj
