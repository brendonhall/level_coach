-- Level Coach: map pins for an item's location. Prefers TomTom when present, else the client's
-- own user waypoint. Everything behind feature detection and pcall; returns ok, how.
local _, ns = ...

local Waypoints = {}
ns.Waypoints = Waypoints

function Waypoints.mapIDForZone(zone)
  if type(zone) ~= "string" then
    return nil
  end
  for _, z in ipairs((ns.Data and ns.Data.Zones) or {}) do
    if z.name == zone and z.mapID then
      return z.mapID
    end
  end
  return nil
end

-- { mapID, x, y (0-1), title } for an item, or nil plus a reason.
function Waypoints.target(item)
  local where = item and item.where
  if type(where) ~= "table" or type(where.waypoint) ~= "table" then
    return nil, "no coordinates"
  end
  local x, y = tonumber(where.waypoint[1]), tonumber(where.waypoint[2])
  if not (x and y) then
    return nil, "no coordinates"
  end
  local mapID = where.mapID or Waypoints.mapIDForZone(where.zone)
  if not mapID then
    return nil, "no map id for " .. tostring(where.zone)
  end
  return { mapID = mapID, x = x / 100, y = y / 100, title = item.title or item.id }
end

function Waypoints.pin(item)
  local target, why = Waypoints.target(item)
  if not target then
    return false, why
  end
  if type(TomTom) == "table" and type(TomTom.AddWaypoint) == "function" then
    local ok = pcall(TomTom.AddWaypoint, TomTom, target.mapID, target.x, target.y,
      { title = target.title, persistent = false, minimap = true, world = true })
    if ok then
      return true, "TomTom"
    end
  end
  if type(C_Map) == "table" and type(C_Map.SetUserWaypoint) == "function"
    and type(UiMapPoint) == "table" and type(UiMapPoint.CreateFromCoordinates) == "function" then
    local ok = pcall(function()
      C_Map.SetUserWaypoint(UiMapPoint.CreateFromCoordinates(target.mapID, target.x, target.y))
    end)
    if ok then
      if type(C_SuperTrack) == "table" and type(C_SuperTrack.SetSuperTrackedUserWaypoint) == "function" then
        pcall(C_SuperTrack.SetSuperTrackedUserWaypoint, true)
      end
      return true, "map pin"
    end
  end
  return false, "no waypoint support"
end
