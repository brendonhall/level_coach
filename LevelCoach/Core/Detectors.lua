-- Level Coach: completion detectors. Pure functions over a plain snapshot table; no WoW API here.
-- Every handler returns true (done), false (not done) or nil (cannot tell: treat as manual).
local _, ns = ...

local Detectors = {}
ns.Detectors = Detectors

-- Set membership for tables keyed by tostring(id). Values may be true or a positive count.
local function inSet(set, key)
  if type(set) ~= "table" then
    return nil
  end
  local v = set[tostring(key)]
  if v == nil or v == false then
    return false
  end
  if type(v) == "number" then
    return v > 0
  end
  return true
end

local handlers = {}

handlers.spell_known = function(dw, snap)
  return inSet(snap.spells, dw.id)
end

handlers.quest_complete = function(dw, snap)
  return inSet(snap.questsCompleted, dw.id)
end

handlers.has_item = function(dw, snap)
  return inSet(snap.items, dw.id)
end

handlers.zone_visited = function(dw, snap)
  return inSet(snap.zonesVisited, dw.zone)
end

handlers.taxi_known = function(dw, snap)
  return inSet(snap.taxiNodes, dw.node)
end

handlers.skill_line = function(dw, snap)
  if type(snap.skills) ~= "table" then
    return nil
  end
  local rank = snap.skills[dw.name]
  if rank == nil then
    return false
  end
  return rank >= (dw.min or 1)
end

handlers.level_at_least = function(dw, snap)
  if type(snap.level) ~= "number" then
    return nil
  end
  return snap.level >= (dw.n or 1)
end

handlers.money_at_least = function(dw, snap)
  if type(snap.money) ~= "number" then
    return nil
  end
  return snap.money >= (dw.copper or 0)
end

handlers.bind_location = function(dw, snap)
  if type(snap.bindLocation) ~= "string" then
    return nil
  end
  local have, want = snap.bindLocation:lower(), tostring(dw.zone or ""):lower()
  return have == want or have:find(want, 1, true) ~= nil
end

handlers.manual = function()
  return nil
end

handlers.any_of = function(dw, snap)
  local sawUnknown = false
  for _, child in ipairs(dw.of or {}) do
    local r = Detectors.check(child, snap)
    if r == true then
      return true
    elseif r == nil then
      sawUnknown = true
    end
  end
  if sawUnknown then
    return nil
  end
  return false
end

handlers.all_of = function(dw, snap)
  local sawUnknown = false
  for _, child in ipairs(dw.of or {}) do
    local r = Detectors.check(child, snap)
    if r == false then
      return false
    elseif r == nil then
      sawUnknown = true
    end
  end
  if sawUnknown then
    return nil
  end
  return true
end

function Detectors.check(dw, snap)
  if type(dw) ~= "table" then
    return nil
  end
  local handler = handlers[dw.type]
  if not handler then
    return nil
  end
  return handler(dw, snap or {})
end

Detectors.types = handlers
