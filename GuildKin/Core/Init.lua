-- GuildKin: bootstrap. One frame, one OnEvent, a handler table keyed by event name.
local addonName, ns = ...

ns.name = addonName
ns.handlers = {}
ns.commands = {}

function ns.print(msg)
  DEFAULT_CHAT_FRAME:AddMessage("|cffb0e0a0GuildKin|r " .. tostring(msg))
end

local frame = CreateFrame("Frame", "GuildKinEventFrame")
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

function ns.db()
  GuildKinDB = GuildKinDB or {}
  local db = GuildKinDB
  db.mode = db.mode or "prefix"
  db.separator = db.separator or " | "
  db.families = db.families or {}
  db.overrides = db.overrides or {}
  db.window = db.window or {}
  return db
end

ns.registerEvent("ADDON_LOADED", function(name)
  if name ~= addonName then
    return
  end
  ns.db()
end)

SLASH_GUILDKIN1 = "/gk"
SlashCmdList["GUILDKIN"] = function(msg)
  msg = msg or ""
  local cmd, rest = msg:match("^(%S*)%s*(.-)$")
  cmd = (cmd or ""):lower()
  local fn = ns.commands[cmd]
  if not fn then
    ns.print("unknown command '" .. cmd .. "'")
    if ns.commands.help then
      ns.commands.help()
    end
    return
  end
  fn(rest or "")
end
