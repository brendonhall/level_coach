std = "lua51"
max_line_length = 120
codes = true
exclude_files = { "tests/lua/wow_stub.lua" }

-- Globals this addon owns.
globals = { "LevelCoachDB", "LevelCoachCharDB", "SLASH_LEVELCOACH1", "SlashCmdList" }

-- WoW client API the addon reads. Extend here, never silence warnings in code.
read_globals = {
  "CreateFrame", "UIParent", "DEFAULT_CHAT_FRAME", "ExpandSkillHeader",
  "C_Map", "C_QuestLog", "C_Spell", "C_Item", "C_Container", "C_Timer", "C_AddOns", "C_GameRules",
  "C_Traits", "C_ClassTalents", "C_SpecializationInfo",
  "UnitLevel", "UnitClass", "UnitRace", "UnitFactionGroup", "UnitName", "UnitXP", "UnitXPMax",
  "GetXPExhaustion", "GetMoney", "GetBindLocation", "GetZoneText", "GetSubZoneText", "GetRealZoneText",
  "GetRealmName", "GetBuildInfo", "IsPlayerSpell", "IsSpellKnown", "GetNumSkillLines", "GetSkillLineInfo",
  "GetProfessions", "GetProfessionInfo", "InCombatLockdown", "RequestTimePlayed", "NumTaxiNodes",
  "TaxiNodeName", "GetInventoryItemLink", "GetInventoryItemID", "GetTime", "date", "time",
  "WOW_PROJECT_ID", "WOW_PROJECT_CAMELOT", "WOW_PROJECT_MAINLINE", "WOW_PROJECT_CLASSIC",
  "issecretvalue", "wipe", "strsplit", "tinsert", "format",
  "GameTooltip", "MenuUtil", "TomTom", "UiMapPoint", "C_SuperTrack", "IsShiftKeyDown",
}

-- Generated data files carry long explanation strings; they are not hand-formatted.
files["LevelCoach/Data"] = { max_line_length = false }
