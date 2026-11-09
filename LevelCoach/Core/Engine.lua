-- Level Coach: the checklist engine. Pure Lua over plain tables; no WoW API here.
-- evaluate(snapshot, goals, items) -> { now = {}, soon = {}, overdue = {}, done = {} }
-- Each entry is { item = <item>, status = "now"|"soon"|"overdue"|"done", reason = <string> }.
local _, ns = ...

local Engine = {}
ns.Engine = Engine

local PRIORITY = { high = 1, normal = 2, low = 3 }
local SOON_WINDOW = 5

-- nil when the list imposes no restriction, otherwise whether value is in it.
local function allows(list, value)
  if type(list) ~= "table" or #list == 0 then
    return nil
  end
  for _, v in ipairs(list) do
    if v == value then
      return true
    end
  end
  return false
end

-- The goal tags an item may match, derived from the interview profile.
function Engine.goalTags(goals)
  local tags = { any = true }
  if type(goals) ~= "table" then
    return tags
  end
  if goals.aim then
    tags[goals.aim] = true
  end
  if goals.secondary and goals.secondary ~= "none" then
    tags[goals.secondary] = true
  end
  if goals.dungeons ~= "avoid" then
    tags.dungeons = true
  end
  if goals.professions and goals.professions ~= "skip" then
    tags.professions = true
  end
  if goals.pvpRuleset or goals.battlegrounds then
    tags.pvp = true
  end
  return tags
end

function Engine.applies(item, snap, goals)
  snap = snap or {}
  if allows(item.classes, snap.class) == false then
    return false
  end
  if allows(item.races, snap.race) == false then
    return false
  end
  if allows(item.factions, snap.faction) == false then
    return false
  end
  local tags = Engine.goalTags(goals)
  if type(item.goals) == "table" and #item.goals > 0 then
    local matched = false
    for _, g in ipairs(item.goals) do
      if tags[g] then
        matched = true
        break
      end
    end
    if not matched then
      return false
    end
  end
  if type(item.tags) == "table" then
    for _, t in ipairs(item.tags) do
      if t == "pvp" and not tags.pvp then
        return false
      end
    end
  end
  return true
end

local function statusFor(item, snap, now)
  local id = item.id
  if snap.skipped and snap.skipped[id] then
    return nil
  end
  local until_ = snap.snoozedUntil and snap.snoozedUntil[id]
  if until_ and until_ > now then
    return nil
  end
  if snap.manualDone and snap.manualDone[id] then
    return "done", "marked done"
  end
  if ns.Detectors and ns.Detectors.check(item.done_when, snap) == true then
    return "done", "detected: " .. tostring(item.done_when and item.done_when.type)
  end
  local level = snap.level or 1
  local window = item.level or {}
  local min, max = window.min or 1, window.max or 60
  if level < min then
    if min <= level + SOON_WINDOW then
      return "soon", "opens at " .. min
    end
    return nil
  end
  if level <= max then
    return "now", "in window"
  end
  if item.overdue == false then
    return nil
  end
  return "overdue", "window ended at " .. max
end

local function nowKey(entry, snap)
  local item = entry.item
  local p = PRIORITY[item.priority or "normal"] or PRIORITY.normal
  local here = (item.where and snap.zone and item.where.zone == snap.zone) and 0 or 1
  local min = (item.level and item.level.min) or 1
  return p, here, min, tostring(item.id)
end

local function lessNow(snap)
  return function(a, b)
    local p1, h1, m1, i1 = nowKey(a, snap)
    local p2, h2, m2, i2 = nowKey(b, snap)
    if p1 ~= p2 then return p1 < p2 end
    if h1 ~= h2 then return h1 < h2 end
    if m1 ~= m2 then return m1 < m2 end
    return i1 < i2
  end
end

local function byField(field, fallback)
  return function(a, b)
    local va = (a.item.level and a.item.level[field]) or fallback
    local vb = (b.item.level and b.item.level[field]) or fallback
    if va ~= vb then return va < vb end
    return tostring(a.item.id) < tostring(b.item.id)
  end
end

function Engine.evaluate(snap, goals, items)
  snap = snap or {}
  local result = { now = {}, soon = {}, overdue = {}, done = {} }
  local now = snap.now or (type(time) == "function" and time()) or 0
  for _, item in ipairs(items or {}) do
    if Engine.applies(item, snap, goals) then
      local status, reason = statusFor(item, snap, now)
      if status then
        table.insert(result[status], { item = item, status = status, reason = reason })
      end
    end
  end
  table.sort(result.now, lessNow(snap))
  table.sort(result.soon, byField("min", 1))
  table.sort(result.overdue, byField("max", 60))
  table.sort(result.done, byField("min", 1))
  return result
end
