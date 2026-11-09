import pathlib

import pytest
from lupa.lua51 import LuaRuntime

ROOT = pathlib.Path(__file__).resolve().parents[2]


class Lua:
    """A Lua 5.1 runtime for compiling and running addon files outside the game."""

    def __init__(self):
        self.rt = LuaRuntime(unpack_returned_tuples=True)
        self._load = self.rt.eval("function(src, name) local f, e = loadstring(src, name); assert(f, e); return f end")

    def compile(self, src, name):
        return self._load(src, name)


@pytest.fixture
def lua():
    return Lua()


VALID_ITEM_YAML = """\
- id: warlock-voidwalker-quest
  title: "Do the Voidwalker quest: Halgar's Summons"
  why: Your tank for ten levels. Take the Brill version, not Orgrimmar's.
  kind: quest
  level: {min: 10, max: 60}
  classes: [WARLOCK]
  races: [Scourge]
  factions: [Horde]
  goals: [any]
  tags: []
  priority: high
  where: {zone: Tirisfal Glades, npc: Halgar, waypoint: [61.6, 52.4]}
  done_when:
    type: spell_known
    id: 697
    verify: "probe: name must be Summon Voidwalker"
  verified: {forever: false}
  sources: ["https://www.warcrafttavern.com/forever/guides/warlock-leveling/"]
"""


@pytest.fixture
def valid_item_yaml():
    return VALID_ITEM_YAML
