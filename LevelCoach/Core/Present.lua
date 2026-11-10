-- Level Coach: presentation. Pure functions that turn an engine result into what the panel shows.
-- No WoW API here; the panel renders what buildModel and tooltipLines return.
local _, ns = ...

local Present = {}
ns.Present = Present

Present.sections = {
  { key = "now", label = "Now" },
  { key = "overdue", label = "Overdue" },
  { key = "soon", label = "Soon" },
  { key = "done", label = "Done" },
}

local function className(token)
  if type(token) ~= "string" or token == "" then
    return ""
  end
  return token:sub(1, 1):upper() .. token:sub(2):lower()
end

local function zoneText(item)
  local where = item and item.where
  if type(where) ~= "table" then
    return ""
  end
  return where.zone or where.note or ""
end

function Present.buildModel(result, snapshot, collapsed)
  result = result or {}
  snapshot = snapshot or {}
  collapsed = collapsed or {}
  local header = "Level " .. tostring(snapshot.level or "?") .. " " .. className(snapshot.class)
  if type(snapshot.zone) == "string" and snapshot.zone ~= "" then
    header = header .. "  ·  " .. snapshot.zone
  end
  local model = { header = header, sections = {}, total = 0 }
  for _, def in ipairs(Present.sections) do
    local entries = result[def.key] or {}
    local section = {
      key = def.key, label = def.label, count = #entries, collapsed = collapsed[def.key] == true, rows = {},
    }
    for _, entry in ipairs(entries) do
      local item = entry.item or {}
      local manual = snapshot.manualDone and snapshot.manualDone[item.id] and true or false
      section.rows[#section.rows + 1] = {
        entry = entry,
        item = item,
        id = item.id,
        title = item.title or tostring(item.id),
        zoneText = zoneText(item),
        status = entry.status,
        checked = entry.status == "done",
        auto = entry.status == "done" and not manual,
      }
    end
    model.total = model.total + #entries
    model.sections[#model.sections + 1] = section
  end
  return model
end

function Present.formatMoney(copper)
  copper = tonumber(copper) or 0
  local gold = math.floor(copper / 10000)
  local silver = math.floor((copper % 10000) / 100)
  if gold > 0 and silver > 0 then
    return gold .. " gold " .. silver .. " silver"
  elseif gold > 0 then
    return gold .. " gold"
  end
  return silver .. " silver"
end

-- resolver (optional): { spellName = f(id), questTitle = f(id), itemName = f(id) } for live names.
function Present.describeDetector(dw, resolver)
  if type(dw) ~= "table" then
    return "unknown rule"
  end
  resolver = resolver or {}
  local function named(kind, id, lookup)
    local name = lookup and lookup(id)
    if type(name) == "string" and name ~= "" then
      return name
    end
    return kind .. " #" .. tostring(id)
  end
  local t = dw.type
  if t == "spell_known" then
    return "you know " .. named("spell", dw.id, resolver.spellName)
  elseif t == "quest_complete" then
    return named("quest", dw.id, resolver.questTitle) .. " is complete"
  elseif t == "skill_line" then
    return tostring(dw.name) .. " reaches " .. tostring(dw.min or 1)
  elseif t == "level_at_least" then
    return "you reach level " .. tostring(dw.n)
  elseif t == "bind_location" then
    return "your hearth is set in " .. tostring(dw.zone)
  elseif t == "has_item" then
    return named("item", dw.id, resolver.itemName) .. " is in your bags"
  elseif t == "money_at_least" then
    return "you have " .. Present.formatMoney(dw.copper)
  elseif t == "zone_visited" then
    return "you have been to " .. tostring(dw.zone)
  elseif t == "taxi_known" then
    return "you know the flight path at " .. tostring(dw.node)
  elseif t == "manual" then
    return "you tick it yourself"
  elseif t == "any_of" or t == "all_of" then
    local parts = {}
    for _, child in ipairs(dw.of or {}) do
      parts[#parts + 1] = Present.describeDetector(child, resolver)
    end
    return (t == "any_of" and "any of: " or "all of: ") .. table.concat(parts, "; ")
  end
  return "unknown rule"
end

local function paragraphs(text)
  local out = {}
  for para in tostring(text or ""):gmatch("[^\n]+") do
    para = para:match("^%s*(.-)%s*$")
    if para ~= "" then
      out[#out + 1] = para
    end
  end
  return out
end

local function statusLine(entry, item)
  local level = item.level or {}
  local range = "levels " .. tostring(level.min or 1) .. " to " .. tostring(level.max or 60)
  local labels = { now = "Now", overdue = "Overdue", soon = "Soon", done = "Done" }
  local label = labels[entry.status] or tostring(entry.status)
  local parts = { label, range }
  if item.priority and item.priority ~= "normal" then
    parts[#parts + 1] = item.priority .. " priority"
  end
  if entry.reason and entry.reason ~= "in window" then
    parts[#parts + 1] = entry.reason
  end
  return table.concat(parts, " · ")
end

local GOLD = { 1, 0.82, 0 }
local WHITE = { 1, 1, 1 }
local GREY = { 0.7, 0.7, 0.7 }
local LIGHT = { 0.9, 0.9, 0.9 }
local BLUE = { 0.6, 0.8, 1 }
local ORANGE = { 1, 0.6, 0.2 }
local GREEN = { 0.5, 1, 0.5 }

local function line(text, color, wrap)
  return { text = text, r = color[1], g = color[2], b = color[3], wrap = wrap == true }
end

local function double(left, right)
  return { left = left, right = tostring(right) }
end

-- Returns an array of { text, r, g, b, wrap } or { left, right } tables, top to bottom.
function Present.tooltipLines(entry, _snapshot, resolver)
  local item = entry.item or {}
  local lines = {}
  lines[#lines + 1] = line(item.title or tostring(item.id), GOLD)
  lines[#lines + 1] = line(statusLine(entry, item), GREY)
  if item.why then
    lines[#lines + 1] = line(" ", WHITE)
    lines[#lines + 1] = line(item.why, WHITE, true)
  end
  for _, para in ipairs(paragraphs(item.detail)) do
    lines[#lines + 1] = line(" ", WHITE)
    lines[#lines + 1] = line(para, LIGHT, true)
  end
  local where = item.where
  if type(where) == "table" and (where.zone or where.npc or where.waypoint or where.note) then
    lines[#lines + 1] = line(" ", WHITE)
    if where.zone then
      lines[#lines + 1] = double("Zone", where.zone)
    end
    if where.npc then
      lines[#lines + 1] = double("NPC", where.npc)
    end
    if type(where.waypoint) == "table" and where.waypoint[1] and where.waypoint[2] then
      lines[#lines + 1] = double("At", tostring(where.waypoint[1]) .. ", " .. tostring(where.waypoint[2]))
    end
    if where.note then
      lines[#lines + 1] = line(where.note, GREY, true)
    end
  end
  lines[#lines + 1] = line(" ", WHITE)
  lines[#lines + 1] = line("Done when " .. Present.describeDetector(item.done_when, resolver) .. ".", BLUE, true)
  local verified = item.verified or {}
  if verified.forever then
    local by = verified.by and (" by " .. tostring(verified.by)) or ""
    lines[#lines + 1] = line("Verified in Forever" .. by .. ".", GREEN)
  else
    lines[#lines + 1] = line("Not yet verified in Forever; from community guides.", ORANGE, true)
  end
  local source = type(item.sources) == "table" and item.sources[1]
  if type(source) == "string" then
    local host = source:match("^https?://([^/]+)") or source
    lines[#lines + 1] = line("Source: " .. host, GREY)
  end
  lines[#lines + 1] = line(" ", WHITE)
  local hint = "Click the box to mark done. Right-click: skip or snooze."
  if type(where) == "table" and type(where.waypoint) == "table" then
    hint = hint .. " Shift-click: pin on the map."
  end
  lines[#lines + 1] = line(hint, GREEN, true)
  return lines
end
