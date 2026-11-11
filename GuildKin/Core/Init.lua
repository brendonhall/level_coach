-- GuildKin: bootstrap, commands and events. One frame, one OnEvent, a handler table keyed by event.
-- Load order (TOC): Init, Names, Plan, Roster, Prefill, Window. Handlers resolve ns.* at call time.
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

function ns.options()
  local db = ns.db()
  return { mode = db.mode, separator = db.separator, families = db.families, overrides = db.overrides }
end

-- Recompute the plan from the roster as the client currently reports it.
function ns.rebuild()
  if not (ns.Roster and ns.Plan) then
    return nil
  end
  local members, reason = ns.Roster.members()
  ns.lastReason = reason
  ns.plan = ns.Plan.build(members, ns.options())
  if ns.Prefill then
    ns.Prefill.setProposals(ns.plan)
  end
  if ns.Window then
    ns.Window.update()
  end
  return ns.plan
end

local function summary()
  local plan = ns.plan
  if not plan then
    return "no roster yet"
  end
  return plan.counts.pending .. " to do, " .. plan.counts.done .. " done, " .. plan.counts.skipped .. " skipped"
end

function ns.scan(verbose)
  if not ns.Roster.inGuild() then
    ns.print("you are not in a guild")
    return nil
  end
  ns.Roster.request()
  local plan = ns.rebuild()
  if verbose then
    if not ns.Roster.canView() then
      ns.print("your rank cannot view officer notes, so there is nothing to plan")
    else
      ns.print(summary() .. (ns.Roster.canEdit() and "" or " (your rank cannot edit officer notes)"))
    end
  end
  return plan
end

local function listPending()
  local plan = ns.plan or ns.scan(false)
  if not plan then
    return
  end
  if #plan.pending == 0 then
    ns.print("nothing to do: " .. summary())
    return
  end
  for i, entry in ipairs(plan.pending) do
    ns.print(string.format("%d. %s  ->  \"%s\"  (now: %s)", i, entry.member.name, entry.desired,
      entry.current ~= "" and entry.current or "empty"))
  end
end

local function listSkipped()
  local plan = ns.plan or ns.scan(false)
  if not plan or #plan.skipped == 0 then
    ns.print("nothing skipped")
    return
  end
  for _, entry in ipairs(plan.skipped) do
    ns.print(entry.member.name .. ": " .. entry.reason)
  end
end

ns.commands[""] = function()
  if ns.Window then
    ns.Window.toggle()
  else
    listPending()
  end
end
ns.commands.scan = function()
  ns.scan(true)
end
ns.commands.list = listPending
ns.commands.skipped = listSkipped
ns.commands.player = function(rest)
  local toon, player = rest:match("^(%S+)%s+(.+)$")
  if not toon then
    ns.print("usage: /gk player <Toon-Surname> <Player name>")
    return
  end
  ns.db().overrides[ns.Names.key(toon)] = player
  ns.print(toon .. " belongs to " .. player)
  ns.rebuild()
end
ns.commands.family = function(rest)
  local surname, player = rest:match("^(%S+)%s+(.+)$")
  if not surname then
    ns.print("usage: /gk family <Surname> <Player name>")
    return
  end
  ns.db().families[surname:lower()] = player
  ns.print("every " .. surname .. " belongs to " .. player)
  ns.rebuild()
end
ns.commands.forget = function(rest)
  local toon = rest:match("^(%S+)")
  if not toon then
    ns.print("usage: /gk forget <Toon-Surname or Surname>")
    return
  end
  ns.db().overrides[ns.Names.key(toon)] = nil
  ns.db().families[toon:lower()] = nil
  ns.print("forgot " .. toon)
  ns.rebuild()
end
ns.commands.mode = function(rest)
  local mode = rest:match("^(%S+)")
  if mode ~= "prefix" and mode ~= "replace" then
    ns.print("usage: /gk mode prefix|replace (now " .. ns.db().mode .. ")")
    return
  end
  ns.db().mode = mode
  ns.print("mode " .. mode)
  ns.rebuild()
end
ns.commands.prefill = function(rest)
  local value = rest:match("^(%S+)")
  if value ~= "on" and value ~= "off" then
    ns.print("usage: /gk prefill on|off (now " .. (ns.Prefill.enabled() and "on" or "off") .. ")")
    return
  end
  ns.db().prefill = (value == "on")
  ns.print("prefill " .. value)
  if ns.Window then
    ns.Window.update()
  end
end
ns.commands.probe = function()
  local probe = ns.Roster.probe(5)
  ns.db().probe = probe
  local keys = {}
  for k in pairs(probe) do
    keys[#keys + 1] = k
  end
  table.sort(keys)
  for _, k in ipairs(keys) do
    ns.print(k .. " = " .. tostring(probe[k]))
  end
  ns.print("probe stored; /reload to write it to disk")
end
ns.commands.help = function()
  ns.print("/gk toggles the window. scan, list, skipped, player <Toon> <Player>, family <Surname> <Player>,"
    .. " forget <Toon or Surname>, mode prefix|replace, prefill on|off, probe")
end

ns.registerEvent("ADDON_LOADED", function(name)
  if name ~= addonName then
    return
  end
  ns.db()
  if ns.Prefill then
    ns.Prefill.install()
  end
end)

ns.registerEvent("PLAYER_ENTERING_WORLD", function()
  if ns.Roster and ns.Roster.inGuild() then
    ns.Roster.request()
  end
end)

ns.registerEvent("PLAYER_GUILD_UPDATE", function()
  if ns.Roster and ns.Roster.inGuild() then
    ns.Roster.request()
  end
end)

-- Roster updates arrive in bursts; coalesce them.
ns.registerEvent("GUILD_ROSTER_UPDATE", function()
  if ns.rebuildPending then
    return
  end
  ns.rebuildPending = true
  C_Timer.After(0.3, function()
    ns.rebuildPending = false
    ns.rebuild()
  end)
end)

SLASH_GUILDKIN1 = "/gk"
SlashCmdList["GUILDKIN"] = function(msg)
  msg = msg or ""
  local cmd, rest = msg:match("^(%S*)%s*(.-)$")
  cmd = (cmd or ""):lower()
  local fn = ns.commands[cmd]
  if not fn then
    ns.print("unknown command '" .. cmd .. "'")
    ns.commands.help()
    return
  end
  fn(rest or "")
end
