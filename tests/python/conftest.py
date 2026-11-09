import pathlib

import pytest
from lupa.lua51 import LuaRuntime

ROOT = pathlib.Path(__file__).resolve().parents[2]


class Lua:
    """A Lua 5.1 runtime with WoW stubs, for running addon files outside the game."""

    def __init__(self):
        self.rt = LuaRuntime(unpack_returned_tuples=True)
        self._load = self.rt.eval("function(src, name) local f, e = loadstring(src, name); assert(f, e); return f end")
        self.rt.execute((ROOT / "tests" / "lua" / "wow_stub.lua").read_text(encoding="utf-8"))
        self.ns = self.rt.table()

    def compile(self, src, name):
        """Compile without running; raises on a syntax error."""
        return self._load(src, name)

    def load_addon_file(self, relpath):
        """Run an addon file with the (addonName, ns) varargs the client passes."""
        src = (ROOT / "LevelCoach" / relpath).read_text(encoding="utf-8")
        return self._load(src, "=" + relpath)("LevelCoach", self.ns)

    def table(self, obj):
        """Recursively convert a Python dict or list into a Lua table."""
        return self.rt.table_from(obj, recursive=True)


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


WOW_FIXTURE_LUA = """
function UnitLevel() return 14 end
function UnitClass() return "Warlock", "WARLOCK" end
function UnitRace() return "Undead", "Scourge" end
function UnitFactionGroup() return "Horde", "Horde" end
function UnitName() return "Testlock" end
function GetZoneText() return "Silverpine Forest" end
function GetSubZoneText() return "The Sepulcher" end
function GetRealZoneText() return "Silverpine Forest" end
function GetMoney() return 9500 end
function GetBindLocation() return "Brill" end
function GetXPExhaustion() return 1200 end
function GetRealmName() return "PvP" end
function IsPlayerSpell(id) return id == 697 end
C_QuestLog = { GetAllCompletedQuestIDs = function() return { 1470 } end, GetNumQuestLogEntries = function() return 3 end }
C_Map = { GetBestMapForUnit = function() return 1421 end, GetPlayerMapPosition = function() return nil end }
function GetNumSkillLines() return 2 end
function GetSkillLineInfo(i) if i == 1 then return "Weapon Skills", true end return "First Aid", false, nil, 75 end
C_Container = { GetContainerNumSlots = function(bag) return bag == 0 and 16 or 0 end,
                GetContainerItemID = function() return nil end, GetContainerItemInfo = function() return nil end }
LevelCoachCharDB = {}
LevelCoachDB = {}
"""


@pytest.fixture
def wow_fixture(lua):
    """A Lua runtime whose WoW globals describe a level 14 Undead Warlock in Silverpine."""
    lua.rt.execute(WOW_FIXTURE_LUA)
    return lua
