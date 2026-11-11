-- GuildKin: pre-fills Blizzard's officer-note dialog with the proposed note. The officer confirms
-- with Enter; the write itself stays inside Blizzard's own handler, which Forever allows.
local _, ns = ...

local Prefill = {}
ns.Prefill = Prefill

Prefill.proposals = {}
Prefill.installed = false

function Prefill.enabled()
  local db = ns.db and ns.db()
  return not (db and db.prefill == false)
end

-- Remember desired notes by member GUID from a plan's pending list.
function Prefill.setProposals(plan)
  local proposals = {}
  for _, entry in ipairs((plan and plan.pending) or {}) do
    if entry.member and entry.member.guid then
      proposals[entry.member.guid] = { text = entry.desired, name = entry.member.name }
    end
  end
  Prefill.proposals = proposals
end

function Prefill.fill(dialog, data)
  if not Prefill.enabled() or type(dialog) ~= "table" or type(data) ~= "table" or data.guid == nil then
    return false
  end
  local proposal = Prefill.proposals[data.guid]
  if not proposal then
    return false
  end
  local editBox = dialog.editBox or dialog.EditBox
  if not editBox or type(editBox.SetText) ~= "function" then
    return false
  end
  editBox:SetText(proposal.text)
  if type(editBox.SetCursorPosition) == "function" then
    editBox:SetCursorPosition(#proposal.text)
  end
  Prefill.last = { guid = data.guid, text = proposal.text }
  local first, last = ns.Names.split(proposal.name)
  ns.print("filled the officer note for " .. ns.Names.display(first or "?", last) .. ": \"" .. proposal.text
    .. "\". Press Enter to apply, Escape to cancel.")
  return true
end

function Prefill.install()
  if Prefill.installed then
    return true
  end
  if type(hooksecurefunc) ~= "function" or type(StaticPopup_Show) ~= "function" then
    return false
  end
  hooksecurefunc("StaticPopup_Show", function(which, _, _, data)
    if which ~= "SET_GUILDOFFICERNOTE" then
      return
    end
    local dialog = type(StaticPopup_FindVisible) == "function" and StaticPopup_FindVisible(which, data)
    if dialog then
      Prefill.fill(dialog, data)
    end
  end)
  Prefill.installed = true
  return true
end
