-- Level Coach: the checklist panel. Renders ns.Present's model; all behavior routes through ns.markItem.
local _, ns = ...

local Panel = {}
ns.Panel = Panel

local ROW_H, HEADER_H, WIDTH, HEIGHT = 20, 18, 380, 460
local ROW_COLORS = {
  now = { 1, 1, 1 }, overdue = { 1, 0.55, 0.3 }, soon = { 0.65, 0.65, 0.65 }, done = { 0.5, 0.5, 0.5 },
}
local HEADER_COLORS = {
  now = { 1, 0.82, 0 }, overdue = { 1, 0.5, 0.25 }, soon = { 0.7, 0.7, 0.8 }, done = { 0.6, 0.6, 0.6 },
}

Panel.rows = {}
Panel.headers = {}
Panel.rowCount = 0
Panel.headerCount = 0

local function db()
  LevelCoachDB = LevelCoachDB or {}
  LevelCoachDB.panel = LevelCoachDB.panel or {}
  LevelCoachDB.panel.collapsed = LevelCoachDB.panel.collapsed or { done = true }
  return LevelCoachDB.panel
end

local function savePosition(frame)
  local point, _, relPoint, x, y = frame:GetPoint()
  local saved = db()
  saved.point, saved.relPoint, saved.x, saved.y = point, relPoint, x, y
end

local function restorePosition(frame)
  local saved = db()
  frame:ClearAllPoints()
  if saved.point then
    frame:SetPoint(saved.point, UIParent, saved.relPoint or saved.point, saved.x or 0, saved.y or 0)
  else
    frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
  end
end

-- Live names for the tooltip's "Done when" line, when the client can provide them.
local resolver = {
  spellName = function(id)
    if type(C_Spell) == "table" and type(C_Spell.GetSpellInfo) == "function" then
      local ok, info = pcall(C_Spell.GetSpellInfo, id)
      if ok and type(info) == "table" then
        return info.name
      end
    end
    return nil
  end,
  questTitle = function(id)
    if type(C_QuestLog) == "table" and type(C_QuestLog.GetTitleForQuestID) == "function" then
      local ok, title = pcall(C_QuestLog.GetTitleForQuestID, id)
      if ok then
        return title
      end
    end
    return nil
  end,
  itemName = function(id)
    if type(C_Item) == "table" and type(C_Item.GetItemInfo) == "function" then
      local ok, name = pcall(C_Item.GetItemInfo, id)
      if ok then
        return name
      end
    end
    return nil
  end,
}

local function showTooltip(row)
  if not (row and row.data and GameTooltip) then
    return
  end
  GameTooltip:SetOwner(row, "ANCHOR_RIGHT")
  for _, l in ipairs(ns.Present.tooltipLines(row.data.entry, ns.lastSnapshot, resolver)) do
    if l.left then
      GameTooltip:AddDoubleLine(l.left, l.right, 0.8, 0.8, 0.8, 1, 1, 1)
    else
      GameTooltip:AddLine(l.text, l.r, l.g, l.b, l.wrap)
    end
  end
  GameTooltip:Show()
end

local function hideTooltip()
  if GameTooltip then
    GameTooltip:Hide()
  end
end

function Panel.pin(item)
  local ok, how = ns.Waypoints.pin(item)
  if ok then
    ns.print("pinned " .. tostring(item.title or item.id) .. " (" .. how .. ")")
  else
    ns.print("cannot pin " .. tostring(item.title or item.id) .. ": " .. how)
  end
  return ok
end

local function snooze(id, hours)
  local now = (type(time) == "function" and time()) or 0
  ns.markItem({ "snoozedUntil" }, id, now + hours * 3600, "snoozed:")
end

local function contextMenu(row)
  local data = row.data
  if not data then
    return
  end
  local id, item = data.id, data.item
  if type(MenuUtil) == "table" and type(MenuUtil.CreateContextMenu) == "function" then
    MenuUtil.CreateContextMenu(row, function(_, root)
      root:CreateTitle(data.title)
      if data.status ~= "done" then
        root:CreateButton("Mark done", function() ns.markItem({ "manualDone" }, id, true, "marked done:") end)
      end
      root:CreateButton("Skip for good", function() ns.markItem({ "skipped" }, id, true, "skipped:") end)
      root:CreateButton("Snooze 24 hours", function() snooze(id, 24) end)
      root:CreateButton("Snooze 3 days", function() snooze(id, 72) end)
      if ns.Waypoints.target(item) then
        root:CreateButton("Pin on the map", function() Panel.pin(item) end)
      end
      root:CreateButton("Clear marks", function()
        ns.markItem({ "manualDone", "skipped", "snoozedUntil" }, id, nil, "cleared:")
      end)
    end)
    return
  end
  -- Without the menu API, right-click skips and says how to undo it.
  ns.markItem({ "skipped" }, id, true, "skipped (right-click; /lc undo " .. id .. " brings it back):")
end

local function onRowClick(row, button)
  if not row.data then
    return
  end
  if button == "RightButton" then
    contextMenu(row)
    return
  end
  if type(IsShiftKeyDown) == "function" and IsShiftKeyDown() then
    Panel.pin(row.data.item)
    return
  end
  showTooltip(row)
end

local function onCheckClick(check)
  local row = check:GetParent()
  local data = row and row.data
  if not data then
    return
  end
  if data.auto then
    check:SetChecked(true) -- detected from the game; cannot be unticked
    return
  end
  if data.checked then
    ns.markItem({ "manualDone" }, data.id, nil, "unmarked:")
  else
    ns.markItem({ "manualDone" }, data.id, true, "marked done:")
  end
end

local function acquireRow(index)
  local row = Panel.rows[index]
  if row then
    return row
  end
  row = CreateFrame("Button", nil, Panel.content)
  row:SetHeight(ROW_H)
  row:RegisterForClicks("LeftButtonUp", "RightButtonUp")
  row:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight", "ADD")
  row.check = CreateFrame("CheckButton", nil, row, "UICheckButtonTemplate")
  row.check:SetSize(22, 22)
  row.check:SetPoint("LEFT", row, "LEFT", 2, 0)
  row.check:SetScript("OnClick", onCheckClick)
  row.check:SetScript("OnEnter", function(c) showTooltip(c:GetParent()) end)
  row.check:SetScript("OnLeave", hideTooltip)
  row.zone = row:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
  row.zone:SetPoint("RIGHT", row, "RIGHT", -6, 0)
  row.zone:SetWidth(110)
  row.zone:SetJustifyH("RIGHT")
  row.zone:SetWordWrap(false)
  row.text = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
  row.text:SetPoint("LEFT", row.check, "RIGHT", 2, 0)
  row.text:SetPoint("RIGHT", row.zone, "LEFT", -6, 0)
  row.text:SetJustifyH("LEFT")
  row.text:SetWordWrap(false)
  row:SetScript("OnEnter", showTooltip)
  row:SetScript("OnLeave", hideTooltip)
  row:SetScript("OnClick", onRowClick)
  Panel.rows[index] = row
  return row
end

local function acquireHeader(index)
  local header = Panel.headers[index]
  if header then
    return header
  end
  header = CreateFrame("Button", nil, Panel.content)
  header:SetHeight(HEADER_H)
  header.text = header:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  header.text:SetPoint("LEFT", header, "LEFT", 4, 0)
  header.text:SetJustifyH("LEFT")
  header:SetScript("OnClick", function(self)
    if self.sectionKey then
      Panel.toggleSection(self.sectionKey)
    end
  end)
  Panel.headers[index] = header
  return header
end

function Panel.update()
  if not (Panel.frame and Panel.frame:IsShown()) then
    return
  end
  local result = ns.lastResult or ns.refresh()
  Panel.model = ns.Present.buildModel(result, ns.lastSnapshot, db().collapsed)
  Panel.frame.header:SetText(Panel.model.header)
  local content = Panel.content
  content:SetWidth(Panel.scroll:GetWidth() or (WIDTH - 40))
  local y, rowIndex, headerIndex = 0, 0, 0
  for _, section in ipairs(Panel.model.sections) do
    if section.count > 0 then
      headerIndex = headerIndex + 1
      local header = acquireHeader(headerIndex)
      header.sectionKey = section.key
      header:ClearAllPoints()
      header:SetPoint("TOPLEFT", content, "TOPLEFT", 0, -y)
      header:SetPoint("RIGHT", content, "RIGHT", 0, 0)
      local hc = HEADER_COLORS[section.key] or HEADER_COLORS.now
      header.text:SetTextColor(hc[1], hc[2], hc[3])
      header.text:SetText((section.collapsed and "+ " or "- ") .. section.label .. " (" .. section.count .. ")")
      header:Show()
      y = y + HEADER_H
      if not section.collapsed then
        for _, data in ipairs(section.rows) do
          rowIndex = rowIndex + 1
          local row = acquireRow(rowIndex)
          row.data = data
          row:ClearAllPoints()
          row:SetPoint("TOPLEFT", content, "TOPLEFT", 0, -y)
          row:SetPoint("RIGHT", content, "RIGHT", 0, 0)
          row.text:SetText(data.title)
          local rc = ROW_COLORS[data.status] or ROW_COLORS.now
          row.text:SetTextColor(rc[1], rc[2], rc[3])
          row.zone:SetText(data.zoneText)
          row.check:SetChecked(data.checked)
          row.check:SetEnabled(not data.auto)
          row:Show()
          y = y + ROW_H
        end
      end
    end
  end
  for i = rowIndex + 1, #Panel.rows do
    Panel.rows[i]:Hide()
    Panel.rows[i].data = nil
  end
  for i = headerIndex + 1, #Panel.headers do
    Panel.headers[i]:Hide()
    Panel.headers[i].sectionKey = nil
  end
  Panel.rowCount, Panel.headerCount = rowIndex, headerIndex
  content:SetHeight(math.max(y, 1))
  if Panel.model.total == 0 then
    Panel.frame.empty:Show()
  else
    Panel.frame.empty:Hide()
  end
end

function Panel.create()
  if Panel.frame then
    return Panel.frame
  end
  local frame = CreateFrame("Frame", "LevelCoachPanel", UIParent, "BackdropTemplate")
  frame:SetSize(WIDTH, HEIGHT)
  frame:SetFrameStrata("MEDIUM")
  frame:SetClampedToScreen(true)
  frame:SetMovable(true)
  frame:EnableMouse(true)
  frame:RegisterForDrag("LeftButton")
  frame:SetScript("OnDragStart", function(f) f:StartMoving() end)
  frame:SetScript("OnDragStop", function(f)
    f:StopMovingOrSizing()
    savePosition(f)
  end)
  frame:SetScript("OnShow", function() Panel.update() end)
  frame:SetScript("OnHide", hideTooltip)
  if frame.SetBackdrop then
    frame:SetBackdrop({
      bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
      tile = true, tileSize = 16, edgeSize = 16, insets = { left = 4, right = 4, top = 4, bottom = 4 },
    })
    frame:SetBackdropColor(0.05, 0.05, 0.08, 0.92)
    frame:SetBackdropBorderColor(0.45, 0.45, 0.55, 1)
  end
  frame.title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  frame.title:SetPoint("TOPLEFT", 12, -10)
  frame.title:SetText("Level Coach")
  frame.header = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
  frame.header:SetPoint("TOPLEFT", 12, -28)
  frame.header:SetPoint("RIGHT", frame, "RIGHT", -30, 0)
  frame.header:SetJustifyH("LEFT")
  frame.close = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
  frame.close:SetPoint("TOPRIGHT", -2, -2)
  frame.empty = frame:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
  frame.empty:SetPoint("CENTER")
  frame.empty:SetText("Nothing to do right now.")
  frame.empty:Hide()
  Panel.scroll = CreateFrame("ScrollFrame", "LevelCoachPanelScroll", frame, "UIPanelScrollFrameTemplate")
  Panel.scroll:SetPoint("TOPLEFT", 10, -48)
  Panel.scroll:SetPoint("BOTTOMRIGHT", -30, 12)
  Panel.content = CreateFrame("Frame", nil, Panel.scroll)
  Panel.content:SetSize(WIDTH - 40, 1)
  Panel.scroll:SetScrollChild(Panel.content)
  Panel.scroll:SetScript("OnSizeChanged", function(_, w) Panel.content:SetWidth(w) end)
  restorePosition(frame)
  frame:Hide()
  Panel.frame = frame
  return frame
end

function Panel.show()
  Panel.create()
  Panel.frame:Show()
  Panel.update()
end

function Panel.hide()
  if Panel.frame then
    Panel.frame:Hide()
  end
end

function Panel.toggle()
  if Panel.frame and Panel.frame:IsShown() then
    Panel.hide()
  else
    Panel.show()
  end
end

function Panel.toggleSection(key)
  local collapsed = db().collapsed
  collapsed[key] = (not collapsed[key]) or nil
  Panel.update()
end

function Panel.resetPosition()
  local saved = db()
  saved.point, saved.relPoint, saved.x, saved.y = nil, nil, nil, nil
  if Panel.frame then
    restorePosition(Panel.frame)
  end
end

ns.afterRefresh(function()
  Panel.update()
end)
