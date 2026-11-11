-- GuildKin: guarded reads of the guild roster. Never writes anything.
local _, ns = ...

local Roster = {}
ns.Roster = Roster

local function plain(v)
  if type(issecretvalue) == "function" and issecretvalue(v) then
    return nil
  end
  return v
end

local function flag(fn)
  if type(fn) ~= "function" then
    return false
  end
  local ok, v = pcall(fn)
  return ok and v == true
end

function Roster.inGuild()
  return flag(IsInGuild)
end

function Roster.canView()
  return type(C_GuildInfo) == "table" and flag(C_GuildInfo.CanViewOfficerNote)
end

function Roster.canEdit()
  return type(C_GuildInfo) == "table" and flag(C_GuildInfo.CanEditOfficerNote)
end

-- Ask the server for a fresh roster; GUILD_ROSTER_UPDATE follows.
function Roster.request()
  if type(C_GuildInfo) == "table" and type(C_GuildInfo.GuildRoster) == "function" then
    pcall(C_GuildInfo.GuildRoster)
  elseif type(GuildRoster) == "function" then
    pcall(GuildRoster)
  end
end

-- GetGuildRosterInfo positions (1-based after the pcall flag): name, rankName, rankIndex, level,
-- classDisplayName, zone, publicNote, officerNote, isOnline, status, classFile, achievementPoints,
-- achievementRank, isMobile, canSoR, repStanding, guid.
local function row(i)
  local r = { pcall(GetGuildRosterInfo, i) }
  if not r[1] or r[2] == nil then
    return nil
  end
  return r
end

-- Returns members, reason. members is a list of { name, guid, officerNote (nil when unreadable),
-- publicNote, level, online, rankIndex, class }; reason is set when nothing could be read.
function Roster.members()
  local list = {}
  if type(GetGuildRosterInfo) ~= "function" or type(GetNumGuildMembers) ~= "function" then
    return list, "roster API missing"
  end
  local okCount, count = pcall(GetNumGuildMembers)
  if not okCount or type(count) ~= "number" then
    return list, "roster not available"
  end
  local canView = Roster.canView()
  for i = 1, count do
    local r = row(i)
    local name = r and plain(r[2])
    if type(name) == "string" and name ~= "" then
      local officerNote = canView and plain(r[9]) or nil
      if officerNote ~= nil and type(officerNote) ~= "string" then
        officerNote = nil
      end
      list[#list + 1] = {
        name = name,
        guid = plain(r[18]),
        officerNote = officerNote,
        publicNote = plain(r[8]),
        level = plain(r[5]),
        online = plain(r[10]) and true or false,
        rankIndex = plain(r[4]),
        class = plain(r[12]),
      }
    end
  end
  return list, nil
end

-- Raw dump of the first few rows and the API surface, for a paste back to the developer.
function Roster.probe(limit)
  limit = limit or 5
  local out = {}
  out.when = (type(date) == "function" and date("%Y-%m-%d %H:%M:%S")) or "?"
  out.api = "GetGuildRosterInfo=" .. type(GetGuildRosterInfo) .. " GetNumGuildMembers=" .. type(GetNumGuildMembers)
    .. " C_GuildInfo=" .. type(C_GuildInfo) .. " C_Club=" .. type(C_Club) .. " hooksecurefunc=" .. type(hooksecurefunc)
    .. " StaticPopup_Show=" .. type(StaticPopup_Show) .. " StaticPopup_FindVisible=" .. type(StaticPopup_FindVisible)
    .. " dialogDef=" .. type(StaticPopupDialogs and StaticPopupDialogs["SET_GUILDOFFICERNOTE"])
  out.permissions = "inGuild=" .. tostring(Roster.inGuild()) .. " canView=" .. tostring(Roster.canView())
    .. " canEdit=" .. tostring(Roster.canEdit())
  local okCount, count = pcall(GetNumGuildMembers)
  out.count = okCount and tostring(count) or "ERR"
  for i = 1, math.min(limit, (okCount and tonumber(count)) or 0) do
    local r = row(i)
    if r then
      local parts = {}
      for k = 2, 18 do
        local v = r[k]
        if type(issecretvalue) == "function" and issecretvalue(v) then
          parts[#parts + 1] = "<secret>"
        else
          parts[#parts + 1] = tostring(v)
        end
      end
      out["member." .. i] = table.concat(parts, " | ")
    end
  end
  return out
end
