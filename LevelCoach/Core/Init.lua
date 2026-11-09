-- Level Coach: addon bootstrap. One frame, one OnEvent, a handler table keyed by event name.
local addonName, ns = ...

ns.name = addonName
ns.handlers = {}
ns.commands = {}

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

ns.registerEvent("ADDON_LOADED", function(name)
  if name ~= addonName then
    return
  end
  -- SavedVariables exist only from here on; never touch them at file scope.
  LevelCoachDB = LevelCoachDB or {}
  LevelCoachCharDB = LevelCoachCharDB or {}
  LevelCoachDB.probe = LevelCoachDB.probe or {}
  if ns.onLoaded then
    ns.onLoaded()
  end
end)

ns.registerEvent("PLAYER_LOGIN", function()
  if ns.onLogin then
    ns.onLogin()
  end
end)

function ns.commandNames()
  local names = {}
  for name in pairs(ns.commands) do
    names[#names + 1] = name
  end
  table.sort(names)
  return names
end

SLASH_LEVELCOACH1 = "/lc"
SlashCmdList["LEVELCOACH"] = function(msg)
  msg = msg or ""
  local cmd, rest = msg:match("^(%S*)%s*(.-)$")
  cmd = (cmd or ""):lower()
  local fn = ns.commands[cmd]
  if fn then
    fn(rest)
  elseif ns.commands[""] then
    ns.commands[""](msg)
  else
    ns.print("commands: " .. table.concat(ns.commandNames(), ", "))
  end
end

ns.commands.help = function()
  ns.print("commands: " .. table.concat(ns.commandNames(), ", "))
end
