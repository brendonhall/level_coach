-- Level Coach: API probe. Reports what the live client offers, to chat and to LevelCoachDB.probe.
-- Every call is wrapped in pcall; the probe must never error, whatever the client lacks.
local _, ns = ...

local Probe = {}
ns.Probe = Probe

-- Classic-era spell IDs for: Shadow Bolt, Immolate, Corruption, Curse of Weakness, Summon Imp,
-- Life Tap, Curse of Agony (Bane of Agony in Forever), Fear, Drain Soul, Create Healthstone,
-- Summon Voidwalker, Health Funnel, Drain Life, Curse of Recklessness, Unending Breath,
-- Create Soulstone, Summon Succubus, Demon Armor, Ritual of Summoning, Curse of the Elements,
-- Summon Felhunter, Summon Felsteed, Demon Skin. All to be confirmed by name.
Probe.spellIDs = { 686, 348, 172, 702, 688, 1454, 980, 5782, 1120, 6201, 697, 755, 689, 704, 5697,
  693, 712, 706, 698, 1490, 691, 5784, 687 }
-- Classic-era quest IDs believed to be Halgar's Summons, Devourer of Souls, Seeking Strahad.
Probe.questIDs = { 1470, 1740, 1798 }
-- Spells whose Forever IDs the data still lacks; resolved by name when the client has them cached.
Probe.spellNames = { "Curse of the Elements", "Summon Incubus", "Bane of Doom", "Create Firestone",
  "Create Spellstone", "Wrack", "Portal of Summoning", "Apprentice Riding" }

local count = 0

local function store(label, text)
  LevelCoachDB.probe = LevelCoachDB.probe or {}
  LevelCoachDB.probe[label] = text
  count = count + 1
  ns.print(label .. " = " .. text)
end

local function try(label, fn)
  local ok, r1, r2, r3, r4 = pcall(fn)
  if not ok then
    store(label, "ERR " .. tostring(r1))
    return
  end
  local values = { r1, r2, r3, r4 }
  local last = 0
  for i = 1, 4 do
    if values[i] ~= nil then
      last = i
    end
  end
  local parts = {}
  for i = 1, last do
    parts[i] = tostring(values[i])
  end
  store(label, last > 0 and table.concat(parts, " | ") or "nil")
end

function Probe.run()
  LevelCoachDB.probe = {}
  count = 0
  LevelCoachDB.probe.when = (type(date) == "function" and date("%Y-%m-%d %H:%M:%S"))
    or tostring(time and time() or 0)

  try("build.info", function() return GetBuildInfo() end)
  try("build.toc", function() return select(4, GetBuildInfo()) end)
  try("build.projectIDs", function()
    return WOW_PROJECT_ID, WOW_PROJECT_CAMELOT, WOW_PROJECT_MAINLINE, WOW_PROJECT_CLASSIC
  end)
  try("build.foreverPresetFn", function() return type(C_GameRules and C_GameRules.GetForeverExperiencePreset) end)
  try("build.gameMode", function() return C_GameRules.GetActiveGameMode() end)
  try("build.realm", function() return GetRealmName() end)

  try("unit.level", function() return UnitLevel("player") end)
  try("unit.class", function() return UnitClass("player") end)
  try("unit.race", function() return UnitRace("player") end)
  try("unit.faction", function() return UnitFactionGroup("player") end)
  try("unit.name", function() return UnitName("player") end)

  try("loc.zone", function() return GetZoneText(), GetSubZoneText(), GetRealZoneText() end)
  try("loc.mapID", function() return C_Map.GetBestMapForUnit("player") end)
  try("loc.pos", function()
    local mapID = C_Map.GetBestMapForUnit("player")
    local pos = C_Map.GetPlayerMapPosition(mapID, "player")
    if not pos then
      return nil
    end
    return pos:GetXY()
  end)

  try("quest.numLog", function() return C_QuestLog.GetNumQuestLogEntries() end)
  try("quest.numCompleted", function() return #C_QuestLog.GetAllCompletedQuestIDs() end)
  for _, id in ipairs(Probe.questIDs) do
    try("quest." .. id, function() return C_QuestLog.GetTitleForQuestID(id), C_QuestLog.IsQuestFlaggedCompleted(id) end)
  end

  for _, id in ipairs(Probe.spellIDs) do
    try("spell." .. id, function()
      local info = C_Spell.GetSpellInfo(id)
      return info and info.name, IsPlayerSpell(id)
    end)
  end

  for _, name in ipairs(Probe.spellNames) do
    try("spellByName." .. name, function()
      local info = C_Spell.GetSpellInfo(name)
      return info and info.spellID, info and info.name
    end)
  end

  try("skill.fns", function()
    return type(GetNumSkillLines), type(GetSkillLineInfo), type(GetProfessions), type(GetProfessionInfo)
  end)
  try("skill.lines", function()
    if type(GetNumSkillLines) ~= "function" then return "n/a" end
    local out = {}
    for i = 1, GetNumSkillLines() do
      local name, isHeader, _, rank = GetSkillLineInfo(i)
      if not isHeader then out[#out + 1] = tostring(name) .. ":" .. tostring(rank) end
    end
    return table.concat(out, ", ")
  end)
  try("skill.professions", function()
    if type(GetProfessions) ~= "function" then return "n/a" end
    local profs = { GetProfessions() }
    local out = {}
    for i = 1, 6 do
      local idx = profs[i]
      if idx then
        local name, _, rank = GetProfessionInfo(idx)
        out[#out + 1] = tostring(name) .. ":" .. tostring(rank)
      end
    end
    return table.concat(out, ", ")
  end)

  try("talent.fns", function() return type(C_Traits), type(C_ClassTalents), type(C_SpecializationInfo) end)

  try("econ.money", function() return GetMoney() end)
  try("econ.bind", function() return GetBindLocation() end)
  try("econ.rested", function() return GetXPExhaustion() end)
  try("econ.bagSlots", function() return C_Container.GetContainerNumSlots(0) end)

  try("map.setWaypointFn", function() return type(C_Map.SetUserWaypoint) end)
  try("map.canWaypoint", function() return C_Map.CanSetUserWaypointOnMap(C_Map.GetBestMapForUnit("player")) end)

  try("misc.fns", function() return type(issecretvalue), type(RequestTimePlayed), type(NumTaxiNodes) end)

  ns.print(count .. " probe entries stored. Open a flight master's map once, then /reload to save them.")
end

-- Called from Init's TAXIMAP_OPENED handler after State.recordTaxiNodes has run.
function Probe.onTaxiMap()
  if not (ns.State and LevelCoachDB) then
    return
  end
  local names = {}
  for name in pairs(ns.State.charDB().taxiNodes) do
    names[#names + 1] = name
  end
  table.sort(names)
  LevelCoachDB.probe = LevelCoachDB.probe or {}
  LevelCoachDB.probe.taxi = table.concat(names, "; ")
  -- Raw listing with node types, for research.
  local ok, n = pcall(NumTaxiNodes)
  if ok and type(n) == "number" then
    local raw = {}
    for i = 1, n do
      local ok2, nm = pcall(TaxiNodeName, i)
      local ok3, kind = pcall(TaxiNodeGetType, i)
      raw[#raw + 1] = (ok2 and tostring(nm) or "?") .. " [" .. (ok3 and tostring(kind) or "?") .. "]"
    end
    LevelCoachDB.probe.taxiRaw = table.concat(raw, "; ")
  end
  ns.print("known taxi nodes recorded: " .. #names)
end

ns.commands.probe = function()
  Probe.run()
end
