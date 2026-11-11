-- Stand-ins for the WoW client globals the addon touches outside the game. Not an emulation:
-- widgets accept any CamelCase method as a no-op and remember what the common setters set, so
-- frame-building code runs headless and tests can inspect text, checks, tooltips and scripts.
CHAT = {}
DEFAULT_CHAT_FRAME = { AddMessage = function(_, msg) CHAT[#CHAT + 1] = msg end }
SlashCmdList = {}

local methods = {}
local meta = {}

local function newWidget(kind, name, parent)
  local w = { kind = kind, name = name, parent = parent, scripts = {}, events = {}, children = {}, shown = true }
  if parent and parent.children then parent.children[#parent.children + 1] = w end
  if name then _G[name] = w end
  return setmetatable(w, meta)
end

meta.__index = function(_, key)
  local m = methods[key]
  if m then return m end
  if type(key) == "string" and key:match("^%u") then
    return function() end -- any other widget method is a no-op
  end
  return nil
end

function methods:SetScript(k, fn) self.scripts[k] = fn end
function methods:GetScript(k) return self.scripts[k] end
function methods:HookScript(k, fn) self.scripts[k] = fn end
function methods:RegisterEvent(e) self.events[e] = true end
function methods:UnregisterEvent(e) self.events[e] = nil end
function methods:Show() self.shown = true; if self.scripts.OnShow then self.scripts.OnShow(self) end end
function methods:Hide() self.shown = false; if self.scripts.OnHide then self.scripts.OnHide(self) end end
function methods:SetShown(v) if v then self:Show() else self:Hide() end end
function methods:IsShown() return self.shown == true end
function methods:IsVisible() return self.shown == true end
function methods:SetSize(w, h) self.w, self.h = w, h end
function methods:SetWidth(w) self.w = w end
function methods:SetHeight(h) self.h = h end
function methods:GetWidth() return self.w or 300 end
function methods:GetHeight() return self.h or 20 end
function methods:GetSize() return self:GetWidth(), self:GetHeight() end
function methods:SetPoint(point, rel, relPoint, x, y)
  if type(rel) == "number" then
    point, rel, relPoint, x, y = point, nil, nil, rel, relPoint
  end
  self.point = { point, rel, relPoint, x, y }
end
function methods:GetPoint()
  local p = self.point or {}
  return p[1] or "CENTER", p[2], p[3] or "CENTER", p[4] or 0, p[5] or 0
end
function methods:ClearAllPoints() self.point = nil end
function methods:SetText(t) self.text = t end
function methods:GetText() return self.text end
function methods:SetChecked(v) self.checked = v and true or false end
function methods:GetChecked() return self.checked == true end
function methods:SetEnabled(v) self.enabled = v and true or false end
function methods:Enable() self.enabled = true end
function methods:Disable() self.enabled = false end
function methods:IsEnabled() return self.enabled ~= false end
function methods:GetParent() return self.parent end
function methods:GetName() return self.name end
function methods:GetObjectType() return self.kind end
function methods:CreateFontString(name) return newWidget("FontString", name, self) end
function methods:CreateTexture(name) return newWidget("Texture", name, self) end
function methods:SetScrollChild(c) self.scrollChild = c end
function methods:GetScrollChild() return self.scrollChild end
function methods:SetTextColor(r, g, b) self.color = { r, g, b } end
function methods:SetAlpha(a) self.alpha = a end
function methods:GetAlpha() return self.alpha or 1 end

UIParent = newWidget("Frame", "UIParent")
UIParent.w, UIParent.h = 1920, 1080

function CreateFrame(kind, name, parent, template)
  local f = newWidget(kind or "Frame", name, parent or UIParent)
  f.template = template
  return f
end

GameTooltip = newWidget("GameTooltip", "GameTooltip")
GameTooltip.lines = {}
function GameTooltip:SetOwner(owner, anchor) self.owner = owner; self.anchor = anchor; self.lines = {} end
function GameTooltip:ClearLines() self.lines = {} end
function GameTooltip:AddLine(text, r, g, b, wrap)
  self.lines[#self.lines + 1] = { text = text, r = r, g = g, b = b, wrap = wrap }
end
function GameTooltip:AddDoubleLine(left, right)
  self.lines[#self.lines + 1] = { text = tostring(left) .. " " .. tostring(right), left = left, right = right }
end
function GameTooltip:NumLines() return #self.lines end

-- Deliver an event or a click to a frame as the client would.
function FIRE(frame, event, ...)
  local fn = frame.scripts.OnEvent
  if fn then fn(frame, event, ...) end
end
function CLICK(frame, button)
  local fn = frame.scripts.OnClick
  if fn then fn(frame, button or "LeftButton") end
end

C_Timer = { After = function(_, fn) fn() end }
time = os.time
date = os.date
function GetTime() return os.time() end
function InCombatLockdown() return false end
function IsShiftKeyDown() return false end

-- Secure-hook and StaticPopup stand-ins. StaticPopup_Show builds a dialog widget, runs the
-- dialog's OnShow if StaticPopupDialogs defines one, then runs post-hooks like hooksecurefunc would.
HOOKS = {}
function hooksecurefunc(a, b, c)
  local name, fn = a, b
  if type(a) == "table" then name, fn = b, c end
  HOOKS[name] = HOOKS[name] or {}
  HOOKS[name][#HOOKS[name] + 1] = fn
end
StaticPopupDialogs = StaticPopupDialogs or {}
VISIBLE_POPUPS = {}
function StaticPopup_Show(which, text1, text2, data)
  local dialog = CreateFrame("Frame", nil, UIParent)
  dialog.which, dialog.data = which, data
  dialog.editBox = CreateFrame("EditBox", nil, dialog)
  local def = StaticPopupDialogs[which]
  if def and def.OnShow then def.OnShow(dialog, data) end
  VISIBLE_POPUPS[which] = dialog
  for _, fn in ipairs(HOOKS["StaticPopup_Show"] or {}) do fn(which, text1, text2, data) end
  return dialog
end
function StaticPopup_FindVisible(which) return VISIBLE_POPUPS[which] end
function IsInGuild() return true end
function ToggleGuildFrame() TOGGLED_GUILD = (TOGGLED_GUILD or 0) + 1 end
