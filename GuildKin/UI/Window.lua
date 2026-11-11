-- GuildKin: the window. Lists pending officer notes with the proposed text in a copy box.
local _, ns = ...

local Window = {}
ns.Window = Window

local WIDTH, HEIGHT, ROW_H = 470, 440, 40
Window.rows = {}
Window.rowCount = 0

local function db()
  return ns.db().window
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

local function acquireRow(index)
  local row = Window.rows[index]
  if row then
    return row
  end
  row = CreateFrame("Frame", nil, Window.content)
  row:SetHeight(ROW_H)
  row.name = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
  row.name:SetPoint("TOPLEFT", row, "TOPLEFT", 4, -3)
  row.name:SetJustifyH("LEFT")
  row.meta = row:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
  row.meta:SetPoint("TOPRIGHT", row, "TOPRIGHT", -8, -3)
  row.meta:SetJustifyH("RIGHT")
  row.name:SetPoint("RIGHT", row.meta, "LEFT", -6, 0)
  row.current = row:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
  row.current:SetPoint("BOTTOMLEFT", row, "BOTTOMLEFT", 4, 5)
  row.current:SetJustifyH("LEFT")
  row.current:SetWordWrap(false)
  row.edit = CreateFrame("EditBox", nil, row, "InputBoxTemplate")
  row.edit:SetSize(210, 20)
  row.edit:SetPoint("BOTTOMRIGHT", row, "BOTTOMRIGHT", -8, 2)
  row.edit:SetAutoFocus(false)
  row.edit:SetMaxLetters(ns.Plan.MAX_NOTE)
  row.edit:SetScript("OnEditFocusGained", function(e) e:HighlightText() end)
  row.edit:SetScript("OnEscapePressed", function(e) e:ClearFocus() end)
  row.edit:SetScript("OnEnterPressed", function(e) e:ClearFocus() end)
  -- A copy box, not an editor: typing reverts to the proposal.
  row.edit:SetScript("OnTextChanged", function(e, userInput)
    if userInput and e.desired then
      e:SetText(e.desired)
      e:HighlightText()
    end
  end)
  row.current:SetPoint("RIGHT", row.edit, "LEFT", -8, 0)
  Window.rows[index] = row
  return row
end

local function headerText()
  if not ns.Roster.inGuild() then
    return "You are not in a guild."
  end
  if not ns.Roster.canView() then
    return "Your rank cannot view officer notes."
  end
  local plan = ns.plan
  if not plan then
    return "Waiting for the roster..."
  end
  local text = plan.counts.pending .. " to do, " .. plan.counts.done .. " done, " .. plan.counts.skipped .. " skipped"
  if not ns.Roster.canEdit() then
    text = text .. "  (your rank cannot edit officer notes)"
  end
  return text
end

local function hintText()
  if ns.Prefill and ns.Prefill.enabled() then
    return "Open the guild roster, click a toon, click its officer note. GuildKin fills in the text; press Enter."
      .. " If the dialog stays empty, copy a note below (click, Ctrl+C) and paste it."
  end
  return "Copy a note below (click, Ctrl+C), paste it into the toon's officer note in the guild roster, press Enter."
end

function Window.update()
  if not (Window.frame and Window.frame:IsShown()) then
    return
  end
  Window.frame.header:SetText(headerText())
  Window.frame.hint:SetText(hintText())
  local content = Window.content
  content:SetWidth(Window.scroll:GetWidth() or (WIDTH - 40))
  local y, count = 0, 0
  local pending = (ns.plan and ns.plan.pending) or {}
  for _, entry in ipairs(pending) do
    count = count + 1
    local row = acquireRow(count)
    row.entry = entry
    row:ClearAllPoints()
    row:SetPoint("TOPLEFT", content, "TOPLEFT", 0, -y)
    row:SetPoint("RIGHT", content, "RIGHT", 0, 0)
    local first, last = ns.Names.split(entry.member.name)
    row.name:SetText(ns.Names.display(first or "?", last))
    row.meta:SetText(entry.player .. " (" .. entry.source .. ")")
    row.current:SetText("now: " .. ((entry.current ~= "" and entry.current) or "(empty)"))
    row.edit.desired = entry.desired
    row.edit:SetText(entry.desired)
    row:Show()
    y = y + ROW_H
  end
  for i = count + 1, #Window.rows do
    Window.rows[i]:Hide()
    Window.rows[i].entry = nil
  end
  Window.rowCount = count
  content:SetHeight(math.max(y, 1))
  if count == 0 then
    Window.frame.empty:Show()
  else
    Window.frame.empty:Hide()
  end
end

function Window.create()
  if Window.frame then
    return Window.frame
  end
  local frame = CreateFrame("Frame", "GuildKinWindow", UIParent, "BackdropTemplate")
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
  frame:SetScript("OnShow", function() Window.update() end)
  if frame.SetBackdrop then
    frame:SetBackdrop({
      bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
      tile = true, tileSize = 16, edgeSize = 16, insets = { left = 4, right = 4, top = 4, bottom = 4 },
    })
    frame:SetBackdropColor(0.05, 0.08, 0.05, 0.92)
    frame:SetBackdropBorderColor(0.45, 0.55, 0.45, 1)
  end
  frame.title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  frame.title:SetPoint("TOPLEFT", 12, -10)
  frame.title:SetText("GuildKin: officer notes")
  frame.header = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
  frame.header:SetPoint("TOPLEFT", 12, -28)
  frame.header:SetPoint("RIGHT", frame, "RIGHT", -30, 0)
  frame.header:SetJustifyH("LEFT")
  frame.hint = frame:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
  frame.hint:SetPoint("TOPLEFT", 12, -44)
  frame.hint:SetPoint("RIGHT", frame, "RIGHT", -12, 0)
  frame.hint:SetJustifyH("LEFT")
  frame.hint:SetWordWrap(true)
  frame.close = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
  frame.close:SetPoint("TOPRIGHT", -2, -2)
  frame.rescan = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
  frame.rescan:SetSize(90, 22)
  frame.rescan:SetPoint("BOTTOMLEFT", 10, 10)
  frame.rescan:SetText("Rescan")
  frame.rescan:SetScript("OnClick", function() ns.scan(true) end)
  frame.roster = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
  frame.roster:SetSize(110, 22)
  frame.roster:SetPoint("LEFT", frame.rescan, "RIGHT", 6, 0)
  frame.roster:SetText("Guild roster")
  frame.roster:SetScript("OnClick", function()
    if type(ToggleGuildFrame) == "function" then
      pcall(ToggleGuildFrame)
    end
  end)
  frame.empty = frame:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
  frame.empty:SetPoint("CENTER")
  frame.empty:SetText("Nothing to do: every readable officer note already names its player.")
  frame.empty:Hide()
  Window.scroll = CreateFrame("ScrollFrame", "GuildKinWindowScroll", frame, "UIPanelScrollFrameTemplate")
  Window.scroll:SetPoint("TOPLEFT", 10, -76)
  Window.scroll:SetPoint("BOTTOMRIGHT", -30, 40)
  Window.content = CreateFrame("Frame", nil, Window.scroll)
  Window.content:SetSize(WIDTH - 40, 1)
  Window.scroll:SetScrollChild(Window.content)
  Window.scroll:SetScript("OnSizeChanged", function(_, w) Window.content:SetWidth(w) end)
  restorePosition(frame)
  frame:Hide()
  Window.frame = frame
  return frame
end

function Window.show()
  Window.create()
  Window.frame:Show()
  Window.update()
end

function Window.hide()
  if Window.frame then
    Window.frame:Hide()
  end
end

function Window.toggle()
  if Window.frame and Window.frame:IsShown() then
    Window.hide()
  else
    Window.show()
  end
end
