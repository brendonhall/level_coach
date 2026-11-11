-- GuildKin: Forever character names. The roster hands back "First-Surname" (the surname sits where
-- Retail puts the realm); display strings use "First Surname". Pure functions, no WoW API.
local _, ns = ...

local Names = {}
ns.Names = Names

-- Returns first, surname. surname is nil when the name has only one part.
function Names.split(full)
  if type(full) ~= "string" then
    return nil, nil
  end
  full = full:match("^%s*(.-)%s*$")
  if full == "" then
    return nil, nil
  end
  local first, last = full:match("^([^%-%s]+)%-(.+)$")
  if not first then
    first, last = full:match("^(%S+)%s+(.+)$")
  end
  if not first then
    return full, nil
  end
  return first, last
end

function Names.display(first, last)
  if last and last ~= "" then
    return first .. " " .. last
  end
  return first
end

function Names.key(full)
  return (type(full) == "string" and full:lower():gsub("%s+", "-")) or ""
end
