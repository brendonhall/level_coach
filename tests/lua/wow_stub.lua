-- Minimal stand-ins for the WoW client globals that the Core files touch at load time.
-- Tests extend or replace these per case. Nothing here is a faithful emulation.
CHAT = {}
DEFAULT_CHAT_FRAME = { AddMessage = function(_, msg) CHAT[#CHAT + 1] = msg end }
SlashCmdList = {}

local function newFrame(name)
  local f = { name = name, events = {}, scripts = {} }
  function f:RegisterEvent(e) self.events[e] = true end
  function f:UnregisterEvent(e) self.events[e] = nil end
  function f:SetScript(k, fn) self.scripts[k] = fn end
  function f:GetScript(k) return self.scripts[k] end
  function f:Show() self.shown = true end
  function f:Hide() self.shown = false end
  return f
end

function CreateFrame(_, name) return newFrame(name) end
UIParent = newFrame("UIParent")

-- Deliver an event to a frame as the client would.
function FIRE(frame, event, ...)
  local fn = frame.scripts.OnEvent
  if fn then fn(frame, event, ...) end
end

C_Timer = { After = function(_, fn) fn() end }
time = os.time
date = os.date
function GetTime() return os.time() end
function InCombatLockdown() return false end
