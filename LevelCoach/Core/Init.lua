-- Level Coach: addon bootstrap. One frame, one OnEvent, a handler table keyed by event name.
-- Load order (TOC): Init, Data, Detectors, Engine, State, Probe. Handlers resolve ns.* at call time.
local addonName, ns = ...

ns.name = addonName
ns.handlers = {}
ns.commands = {}

-- Goal profile used until the interview (Phase 2) writes LevelCoachCharDB.goals.
ns.defaultGoals = {
  aim = "learn", secondary = "story", guidance = "zones", professions = "craft",
  dungeons = "convenient", battlegrounds = false, session = "medium", pvpRuleset = true,
}

function ns.print(msg)
  DEFAULT_CHAT_FRAME:AddMessage("|cff7fbfffLevel Coach|r " .. tostring(msg))
end

local frame = CreateFrame("Frame", "LevelCoachEventFrame")
ns.frame = frame

frame:SetScript("OnEvent", function(_, event, ...)
  local handler = ns.handlers[event]
  if handler then
    handler(...)
  end
end)

function ns.registerEvent(event, handler)
  ns.handlers[event] = handler
  frame:RegisterEvent(event)
end

function ns.goals()
  return (LevelCoachCharDB and LevelCoachCharDB.goals) or ns.defaultGoals
end

local function ready()
  return ns.State ~= nil and ns.Engine ~= nil
end

-- Recompute the checklist. Deferred while in combat; PLAYER_REGEN_ENABLED picks it up.
function ns.refresh()
  if not ready() then
    return nil
  end
  if type(InCombatLockdown) == "function" and InCombatLockdown() then
    ns.dirty = true
    return ns.lastResult
  end
  ns.dirty = false
  ns.lastSnapshot = ns.State.snapshot()
  ns.lastResult = ns.Engine.evaluate(ns.lastSnapshot, ns.goals(), ns.State.allItems())
  return ns.lastResult
end

local function describe(entry, index)
  local item = entry.item
  local where = item.where and (item.where.zone or item.where.note)
  local tail = where and (" |cff999999(" .. where .. ")|r") or ""
  return string.format("%d. %s%s", index, item.title, tail)
end

-- Prints a section and appends its entries to ns.lastListing so "/lc done 3" can refer to them.
local function printSection(result, name, label)
  local list = result[name]
  if #list == 0 then
    return
  end
  ns.print(label .. ":")
  for _, entry in ipairs(list) do
    ns.lastListing[#ns.lastListing + 1] = entry
    ns.print(describe(entry, #ns.lastListing))
  end
end

function ns.showChecklist()
  local result = ns.refresh()
  if not result then
    ns.print("engine not loaded yet")
    return
  end
  ns.lastListing = {}
  if #result.now == 0 and #result.overdue == 0 then
    ns.print("nothing to do right now; " .. #result.soon .. " items open soon")
    return
  end
  printSection(result, "now", "Now")
  printSection(result, "overdue", "Overdue")
  ns.print(#result.soon .. " soon, " .. #result.done .. " done. /lc help for commands.")
end

-- Resolve "3" (index in the last listing) or an item id to an item id.
local function resolveID(token)
  token = (token or ""):match("^%s*(.-)%s*$")
  if token == "" then
    return nil
  end
  local index = tonumber(token)
  if index and ns.lastListing and ns.lastListing[index] then
    return ns.lastListing[index].item.id
  end
  for _, item in ipairs(ns.State and ns.State.allItems() or {}) do
    if item.id == token then
      return item.id
    end
  end
  return nil
end

local function mark(field, token, value, verb)
  if not ready() then
    return
  end
  local id = resolveID(token)
  if not id then
    ns.print("no such item: " .. tostring(token) .. " (use the number from /lc or the item id)")
    return
  end
  ns.State.charDB()[field][id] = value
  ns.print(verb .. " " .. id)
  ns.refresh()
end

ns.commands[""] = function()
  ns.showChecklist()
end
ns.commands.soon = function()
  local result = ns.refresh()
  if result then
    ns.lastListing = {}
    printSection(result, "soon", "Soon")
  end
end
ns.commands.done = function(rest)
  mark("manualDone", rest, true, "marked done:")
end
ns.commands.undo = function(rest)
  mark("manualDone", rest, nil, "unmarked:")
  mark("skipped", rest, nil, "unskipped:")
end
ns.commands.skip = function(rest)
  mark("skipped", rest, true, "skipped:")
end
ns.commands.snooze = function(rest)
  local token, hours = rest:match("^(%S+)%s*(%S*)$")
  local seconds = (tonumber(hours) or 24) * 3600
  local now = (type(time) == "function" and time()) or 0
  mark("snoozedUntil", token, now + seconds, "snoozed:")
end
ns.commands.goals = function()
  local g = ns.goals()
  local parts = {}
  for _, key in ipairs({ "aim", "secondary", "guidance", "professions", "dungeons", "battlegrounds", "session", "pvpRuleset" }) do
    parts[#parts + 1] = key .. "=" .. tostring(g[key])
  end
  ns.print("goals: " .. table.concat(parts, ", ") .. " (interview comes in a later version)")
end
function ns.commandNames()
  local names = {}
  for name in pairs(ns.commands) do
    if name ~= "" then
      names[#names + 1] = name
    end
  end
  table.sort(names)
  return names
end

ns.commands.help = function()
  ns.print("commands: " .. table.concat(ns.commandNames(), ", "))
  ns.print("/lc shows the checklist. done, undo, skip and snooze take the number from the listing or an item id; snooze takes optional hours.")
end

ns.registerEvent("ADDON_LOADED", function(name)
  if name ~= addonName then
    return
  end
  -- SavedVariables exist only from here on; never touch them at file scope.
  LevelCoachDB = LevelCoachDB or {}
  LevelCoachCharDB = LevelCoachCharDB or {}
  LevelCoachDB.probe = LevelCoachDB.probe or {}
  if ns.State then
    ns.State.charDB()
  end
end)

ns.registerEvent("PLAYER_ENTERING_WORLD", function()
  local result = ns.refresh()
  if result then
    ns.print(#result.now .. " items now, " .. #result.overdue .. " overdue. /lc to list.")
  end
end)

ns.registerEvent("PLAYER_LEVEL_UP", function(level)
  -- Spells and skills update right after the event; one frame later is enough.
  C_Timer.After(1, function()
    ns.print("Level " .. tostring(level) .. ". Here is what changed:")
    ns.showChecklist()
  end)
end)

for _, event in ipairs({ "QUEST_TURNED_IN", "SPELLS_CHANGED", "SKILL_LINES_CHANGED", "PLAYER_MONEY",
  "HEARTHSTONE_BOUND", "BAG_UPDATE_DELAYED" }) do
  ns.registerEvent(event, function()
    ns.refresh()
  end)
end

ns.registerEvent("ZONE_CHANGED_NEW_AREA", function()
  if ns.State then
    ns.State.recordZone()
  end
  ns.refresh()
end)

ns.registerEvent("TAXIMAP_OPENED", function()
  if ns.State then
    ns.State.recordTaxiNodes()
  end
  if ns.Probe and ns.Probe.onTaxiMap then
    ns.Probe.onTaxiMap()
  end
end)

ns.registerEvent("PLAYER_REGEN_ENABLED", function()
  if ns.dirty then
    ns.refresh()
  end
end)

SLASH_LEVELCOACH1 = "/lc"
SlashCmdList["LEVELCOACH"] = function(msg)
  msg = msg or ""
  local cmd, rest = msg:match("^(%S*)%s*(.-)$")
  cmd = (cmd or ""):lower()
  local fn = ns.commands[cmd] or ns.commands[""]
  fn(rest or "")
end
