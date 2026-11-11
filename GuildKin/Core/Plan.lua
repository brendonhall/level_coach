-- GuildKin: from roster members to proposed officer notes. Pure functions, no WoW API.
-- member = { name = "First-Surname", guid, officerNote = string | nil (unreadable), level, online }
-- options = { mode = "prefix" | "replace", separator = " | ", overrides = { [key] = player },
--             families = { [surname lower] = player } }
local _, ns = ...

local Plan = {}
ns.Plan = Plan
Plan.MAX_NOTE = 31

local function escape(s)
  return (s:gsub("(%W)", "%%%1"))
end

-- The player behind a toon, and where that answer came from.
function Plan.playerFor(member, options)
  options = options or {}
  local _, last = ns.Names.split(member and member.name)
  local key = ns.Names.key(member and member.name)
  if options.overrides and options.overrides[key] then
    return options.overrides[key], "override"
  end
  if last and options.families and options.families[last:lower()] then
    return options.families[last:lower()], "family"
  end
  if last then
    return last, "surname"
  end
  return nil, "no surname"
end

function Plan.truncate(text)
  if #text > Plan.MAX_NOTE then
    return text:sub(1, Plan.MAX_NOTE)
  end
  return text
end

-- True when the note already names the player: exactly, or followed by a separator.
function Plan.hasPlayer(note, player)
  if type(note) ~= "string" or type(player) ~= "string" or player == "" then
    return false
  end
  local n, p = note:lower(), player:lower()
  if n == p then
    return true
  end
  return n:find("^" .. escape(p) .. "%s*[|/:%-,]") ~= nil
end

function Plan.desiredNote(current, player, options)
  current = type(current) == "string" and current or ""
  local mode = (options and options.mode) or "prefix"
  if mode == "replace" or current == "" then
    return Plan.truncate(player)
  end
  if Plan.hasPlayer(current, player) then
    return current
  end
  local separator = (options and options.separator) or " | "
  return Plan.truncate(player .. separator .. current)
end

local function byPlayerThenName(a, b)
  if a.player ~= b.player then
    return a.player < b.player
  end
  return tostring(a.member.name) < tostring(b.member.name)
end

-- Returns { pending = {...}, done = {...}, skipped = {...}, groups = { [player] = {members} }, counts = {...} }.
function Plan.build(members, options)
  local result = { pending = {}, done = {}, skipped = {}, groups = {} }
  for _, member in ipairs(members or {}) do
    local player, source = Plan.playerFor(member, options)
    if player then
      result.groups[player] = result.groups[player] or {}
      table.insert(result.groups[player], member)
    end
    if not player then
      table.insert(result.skipped, { member = member, reason = source })
    elseif member.officerNote == nil then
      table.insert(result.skipped, { member = member, reason = "officer note unreadable", player = player })
    elseif Plan.hasPlayer(member.officerNote, player) then
      table.insert(result.done, { member = member, player = player })
    else
      table.insert(result.pending, {
        member = member, player = player, source = source,
        current = member.officerNote, desired = Plan.desiredNote(member.officerNote, player, options),
      })
    end
  end
  table.sort(result.pending, byPlayerThenName)
  table.sort(result.done, byPlayerThenName)
  result.counts = { pending = #result.pending, done = #result.done, skipped = #result.skipped }
  return result
end
