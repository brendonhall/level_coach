# GuildKin: design note

**Status:** v0.1, 2026-11-11. Second addon in this repository. Built natively right after this note,
per the execution method Brendon chose for the project; say so if the design should change first.

## 1. Intent

Brendon's guild wants every character's **Officer Note** to carry the **player's name**, so officers
can tell at a glance which toons belong to the same person. GuildKin reads the guild roster, works
out the player behind each toon, proposes the note, and makes applying it as cheap as the game allows.

## 2. The constraints that shape it

- **Addons cannot write guild notes on Forever.** `C_GuildInfo.SetNote` raises
  ADDON_ACTION_FORBIDDEN for addons on Forever (confirmed by GuildOS issue 259 on build
  1.60.1.70790 and Guilded PR 618, including from the addon's own button). The legacy
  `GuildRosterSetOfficerNote` is a wrapper over the same protected call. GuildKin never calls them.
- **Blizzard's dialog is the write path.** The roster's officer-note editor is the StaticPopup
  `SET_GUILDOFFICERNOTE`: `OnShow` fills its edit box from `data.currentNote`, and Enter or Accept
  calls `C_GuildInfo.SetNote(data.guid, editBox:GetText(), false)`, max 31 letters. GuildKin hooks
  the dialog's show and replaces the edit box text with its proposal; the officer presses Enter.
  Whether the client accepts text an addon typed into the box is the one thing only a live test can
  settle, so the window also offers the text to copy, and the officer can paste it instead.
- **Player identity.** Forever characters have a first name and a surname; surnames are chosen per
  character but Blizzard itself showcased "families" of alts sharing one. GuildKin's default is
  **surname = player**, with two overrides: a family label (`/gk family Scruggins Brendon`) and a
  per-toon assignment (`/gk player Brendon Boney-Scruggins`). Toons without a surname are listed
  as needing a manual assignment.
- **Names from the roster.** `GetGuildRosterInfo` exists on Forever; the surname arrives where
  Retail puts the realm, so the parser accepts both `First-Surname` and `First Surname`. Notes can
  be secret values in some states, so unreadable notes are skipped, never overwritten.
- **Permissions.** With `C_GuildInfo.CanViewOfficerNote()` false the plan cannot be computed;
  with `CanEditOfficerNote()` false it is shown read-only.

## 3. Behavior

1. `/gk` opens the window (or `/gk scan` in chat). GuildKin requests the roster and, on
   `GUILD_ROSTER_UPDATE`, builds the plan: **pending** toons whose officer note does not yet start
   with their player name, **done** toons, and **skipped** toons (no surname, unreadable note).
2. Each pending row shows toon, player, current note and proposed note, with the proposal in a
   copyable edit box. The header shows counts and whether you can edit officer notes.
3. The officer opens the guild roster, clicks a toon, clicks its officer note. GuildKin fills the
   dialog with the proposal and says so in chat. Enter applies it. The roster update that follows
   moves the toon to done.
4. Note format: `Player` when the note is empty; otherwise `Player | existing text` cut to 31
   characters (`/gk mode replace` writes only the player name). A note already starting with the
   player name is left alone, so the process is idempotent and safe to repeat.

## 4. Non-goals

Writing notes directly; public notes; syncing between officers; alt detection by anything other
than surname or explicit assignment; anything that touches guild invites or ranks.

## 5. Layout

`GuildKin/` beside `LevelCoach/`, same conventions: `Core/Init.lua`, `Core/Names.lua` and
`Core/Plan.lua` (pure, tested through lupa), `Core/Roster.lua` (guarded API reads),
`Core/Prefill.lua` (dialog hook), `UI/Window.lua`. SavedVariables `GuildKinDB`, account-wide:
mode, separator, families, overrides, window position. A `/gk probe` records the raw roster fields
of the first few members so the name format and note behavior can be confirmed from a paste.

## Sources

- GuildOS issue 259 (SetNote forbidden on Forever): https://github.com/danielcosta42/guildos/issues/259
- Guilded PR 618 (manual click blocked too): https://github.com/kevincaron28/Guilded/pull/618
- RGMS issue 152 (Forever names, GetGuildRosterInfo present, secret notes): https://github.com/segfaultsoftware/retail-guild-management-system/issues/152
- Blizzard UI source, SET_GUILDOFFICERNOTE dialog: https://github.com/Gethe/wow-ui-source
- Surname rules: https://blizzardwatch.com/2026/09/13/surnames-wow-forever/ and https://nameforge.gg/wow-forever/guides/how-surnames-work/
