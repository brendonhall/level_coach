-- Level Coach: builds the plain character snapshot the engine consumes. The only file that reads
-- the WoW API for character state. Every call is guarded; a missing API yields nil, never an error.
local _, ns = ...

local State = {}
ns.State = State

local function call(fn, ...)
  if type(fn) ~= "function" then
    return nil
  end
  local ok, a, b, c, d = pcall(fn, ...)
  if not ok then
    return nil
  end
  return a, b, c, d
end

-- Secret values (Midnight-era combat restrictions) must never reach the engine.
local function plain(v)
  if type(issecretvalue) == "function" and issecretvalue(v) then
    return nil
  end
  return v
end

-- IDs referenced by detectors of the given type, as { [tostring(id)] = id }.
function State.collectIDs(items, detectorType, out)
  out = out or {}
  local function walk(dw)
    if type(dw) ~= "table" then
      return
    end
    if dw.type == detectorType and dw.id ~= nil then
      out[tostring(dw.id)] = tonumber(dw.id) or dw.id
    end
    if type(dw.of) == "table" then
      for _, child in ipairs(dw.of) do
        walk(child)
      end
    end
  end
  for _, item in ipairs(items or {}) do
    walk(item.done_when)
  end
  return out
end

-- Shipped data plus accepted and pending overlay items, in load order.
function State.allItems()
  local list = {}
  local data = ns.Data or {}
  for _, source in ipairs({ data.Items, data.Overlay, data.OverlayPending }) do
    for _, item in ipairs(source or {}) do
      list[#list + 1] = item
    end
  end
  return list
end

local function spells(items)
  if type(IsPlayerSpell) ~= "function" then
    return nil
  end
  local set = {}
  for key, id in pairs(State.collectIDs(items, "spell_known")) do
    if call(IsPlayerSpell, id) then
      set[key] = true
    end
  end
  return set
end

local function questsCompleted()
  if type(C_QuestLog) ~= "table" or type(C_QuestLog.GetAllCompletedQuestIDs) ~= "function" then
    return nil
  end
  local ids = call(C_QuestLog.GetAllCompletedQuestIDs)
  if type(ids) ~= "table" then
    return nil
  end
  local set = {}
  for _, id in ipairs(ids) do
    set[tostring(id)] = true
  end
  return set
end

local function skills()
  if type(GetNumSkillLines) == "function" and type(GetSkillLineInfo) == "function" then
    -- Collapsed headers hide their children from the enumeration; expand them all first.
    call(ExpandSkillHeader, 0)
    local out = {}
    for i = 1, (call(GetNumSkillLines) or 0) do
      local name, isHeader, _, rank = call(GetSkillLineInfo, i)
      if name and not isHeader then
        out[tostring(name)] = tonumber(rank) or 0
      end
    end
    return out
  end
  if type(GetProfessions) == "function" and type(GetProfessionInfo) == "function" then
    local out = {}
    local ok, p1, p2, p3, p4, p5, p6 = pcall(GetProfessions)
    if not ok then
      return nil
    end
    for _, index in ipairs({ p1, p2, p3, p4, p5, p6 }) do
      local name, _, rank = call(GetProfessionInfo, index)
      if name then
        out[tostring(name)] = tonumber(rank) or 0
      end
    end
    return out
  end
  return nil
end

-- Counts only the item IDs the data cares about, so the table stays small.
local function bagItems(items)
  if type(C_Container) ~= "table" or type(C_Container.GetContainerItemID) ~= "function" then
    return nil
  end
  local wanted = State.collectIDs(items, "has_item")
  local counts = {}
  for bag = 0, 4 do
    for slot = 1, (call(C_Container.GetContainerNumSlots, bag) or 0) do
      local id = call(C_Container.GetContainerItemID, bag, slot)
      if id and wanted[tostring(id)] then
        local info = call(C_Container.GetContainerItemInfo, bag, slot)
        local n = (type(info) == "table" and tonumber(info.stackCount)) or 1
        counts[tostring(id)] = (counts[tostring(id)] or 0) + n
      end
    end
  end
  return counts
end

function State.charDB()
  LevelCoachCharDB = LevelCoachCharDB or {}
  local db = LevelCoachCharDB
  db.zonesVisited = db.zonesVisited or {}
  db.taxiNodes = db.taxiNodes or {}
  db.manualDone = db.manualDone or {}
  db.skipped = db.skipped or {}
  db.snoozedUntil = db.snoozedUntil or {}
  return db
end

function State.recordZone()
  local zone = plain(call(GetZoneText))
  if type(zone) == "string" and zone ~= "" then
    State.charDB().zonesVisited[zone] = true
  end
  return zone
end

function State.recordTaxiNodes()
  local n = call(NumTaxiNodes)
  if type(n) ~= "number" then
    return 0
  end
  -- The modern taxi map lists undiscovered nodes too (probe 2026-11-09), so keep only CURRENT and
  -- REACHABLE ones; when the type API is missing, keep everything except the generic placeholder.
  local db = State.charDB()
  local kept = 0
  for i = 1, n do
    local kind = call(TaxiNodeGetType, i)
    local name = plain(call(TaxiNodeName, i))
    if type(name) == "string" and name ~= "" and not name:find("^Generic")
      and (kind == nil or kind == "CURRENT" or kind == "REACHABLE") then
      db.taxiNodes[name] = true
      kept = kept + 1
    end
  end
  return kept
end

function State.snapshot()
  local list = State.allItems()
  local db = State.charDB()
  local _, classToken = call(UnitClass, "player")
  local _, raceFile = call(UnitRace, "player")
  local snap = {
    level = plain(call(UnitLevel, "player")),
    class = plain(classToken),
    race = plain(raceFile),
    faction = plain((call(UnitFactionGroup, "player"))),
    name = plain((call(UnitName, "player"))),
    ruleset = plain((call(GetRealmName))),
    zone = State.recordZone(),
    subzone = plain((call(GetSubZoneText))),
    mapID = type(C_Map) == "table" and plain((call(C_Map.GetBestMapForUnit, "player"))) or nil,
    money = plain((call(GetMoney))),
    bindLocation = plain((call(GetBindLocation))),
    rested = plain((call(GetXPExhaustion))),
    spells = spells(list),
    questsCompleted = questsCompleted(),
    skills = skills(),
    items = bagItems(list),
    zonesVisited = db.zonesVisited,
    taxiNodes = db.taxiNodes,
    manualDone = db.manualDone,
    skipped = db.skipped,
    snoozedUntil = db.snoozedUntil,
    now = (type(time) == "function" and time()) or 0,
  }
  return snap
end
