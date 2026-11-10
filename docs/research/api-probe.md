# Forever API probe results

**First run:** 2026-11-09, client 1.60.1 build 70862 (Nov 6 2026), interface 16001. Level 10 Undead
Warlock standing in the Undercity, PvP ruleset. Raw file: `probe/LevelCoach.lua` (character name
redacted). Every row below is confirmed on the live client unless marked otherwise.

## Build and identity

| probe | result | decision |
|---|---|---|
| `GetBuildInfo()` | 1.60.1, build 70862, TOC 16001 | TOC stays at 16001 |
| `WOW_PROJECT_ID`, `WOW_PROJECT_CAMELOT`, `_MAINLINE`, `_CLASSIC` | 18, 18, 1, 2 | Forever is `WOW_PROJECT_ID == WOW_PROJECT_CAMELOT` |
| `C_GameRules.GetForeverExperiencePreset` | function | usable as a capability probe |
| `C_GameRules.GetActiveGameMode()` | 1 | meaning unknown; not used |
| `GetRealmName()` | "CAMWOW US1 Realm 8 PvP" | ruleset is the last word; the PvP inference (substring) works |
| `UnitClass("player")` | "Warlock", "WARLOCK", 9 | class token as expected |
| `UnitRace("player")` | "Undead", "Scourge", 5 | race file name `Scourge` as the data assumes |
| `UnitFactionGroup("player")` | "Horde", "Horde" | |
| `UnitName("player")` | first name, last name | Forever characters have two names; the second return is the surname, not a realm |

## Location

| probe | result | decision |
|---|---|---|
| `GetZoneText()`, `GetSubZoneText()`, `GetRealZoneText()` | "Undercity", "Trade Quarter", "Undercity" | zone strings match the data |
| `C_Map.GetBestMapForUnit("player")` | 1458 | equals the Classic uiMapID for the Undercity; the Classic map table in `zones.yaml` is very likely right |
| `C_Map.GetPlayerMapPosition(...):GetXY()` | 0.633 (y truncated by the probe's `and`) | works; probe fixed to return both values |
| `C_Map.SetUserWaypoint` | function | built-in pin available |
| `C_Map.CanSetUserWaypointOnMap(1458)` | true | |

## Quests

| probe | result | decision |
|---|---|---|
| `C_QuestLog.GetNumQuestLogEntries()` | 16 entries, 12 quests | |
| `#C_QuestLog.GetAllCompletedQuestIDs()` | 62 | completed-quest set is available |
| 1470 | title nil, **flagged complete** | the quest exists; at level 10 with Summon Voidwalker still unknown, 1470 is the breadcrumb "Halgar's Summons", not the quest that teaches the spell |
| 1740, 1798 | title nil, not complete | expected at level 10; `GetTitleForQuestID` returns nil for uncached quests, so titles are not a reliable probe |

## Spells (`C_Spell.GetSpellInfo(id).name`, `IsPlayerSpell(id)`)

| id | name on live | known at 10 | decision |
|---|---|---|---|
| 686 | Shadow Bolt | yes | confirmed |
| 348 | Immolate | yes | confirmed |
| 172 | Corruption | yes | confirmed |
| 702 | Curse of Weakness | no | confirmed id (not trained yet) |
| 688 | Summon Imp | yes | confirmed |
| 1454 | Life Tap | yes | confirmed |
| 980 | **Bane of Agony** | yes | same id as Classic's Curse of Agony, renamed |
| 5782 | Fear | yes | confirmed |
| 1120 | Drain Soul | yes | confirmed |
| 6201 | Create Healthstone | yes | confirmed; the renumbered rank 1 keeps the old id |
| 697 | Summon Voidwalker | no | confirmed id |
| 755 | Health Funnel | no | confirmed id |
| 689 | Drain Life | no | confirmed id |
| 704 | Curse of Recklessness | no | confirmed id |
| 5697 | Unending Breath | no | confirmed id |
| 693 | Create Soulstone | no | confirmed id |
| 712 | Summon Succubus | no | confirmed id; Summon Incubus id still unknown |
| 706 | Demon Armor | no | confirmed id |
| 698 | Ritual of Summoning | no | confirmed id |
| 1490 | **nil** | | **Curse of the Elements 1490 does not exist in Forever** (ranks were reworked); item switched to manual until the new id is found by name |
| 691 | Summon Felhunter | no | confirmed id |
| 5784 | Summon Felsteed | no | confirmed id |
| 687 | Demon Skin | yes | confirmed |

Next probe adds a by-name lookup (`C_Spell.GetSpellInfo("Curse of the Elements")`) for the ids the
data still lacks: Curse of the Elements, Summon Incubus, Bane of Doom, Create Firestone, Create
Spellstone, Wrack, Portal of Summoning.

## Skills and professions

| probe | result | decision |
|---|---|---|
| `GetNumSkillLines`, `GetSkillLineInfo` | nil, nil | the Classic skill-line API is gone |
| `GetProfessions`, `GetProfessionInfo` | function, function | **State.skills() uses the profession path**; names as returned: "Herbalism", "First Aid", "Cooking" |
| live values | Herbalism 16, First Aid 1, Cooking 1 | the `skill_line` detectors work with these names |

Weapon skills are not reported by this path. If a future item needs one, probe `C_SkillInfo` or the
character sheet before adding a detector.

## Talents, economy, misc

| probe | result | decision |
|---|---|---|
| `C_Traits`, `C_ClassTalents`, `C_SpecializationInfo` | table, table, table | talents run on the trait system; a `talent` detector would use `C_Traits` |
| `GetMoney()` | 3434 copper | |
| `GetBindLocation()` | "Undercity" | hearth strings are area names; the Brill item now accepts Brill or the Undercity |
| `GetXPExhaustion()` | 1058 | rested XP readable |
| `C_Container.GetContainerNumSlots(0)` | 20 | the backpack has 20 slots |
| `issecretvalue`, `RequestTimePlayed`, `NumTaxiNodes` | function, function, function | |
| taxi map | 14 nodes listed from the Undercity at level 10, including Rog'mar and Light's Hope | **the taxi map lists undiscovered nodes too**; `State.recordTaxiNodes` now keeps only nodes whose `TaxiNodeGetType` is CURRENT or REACHABLE and drops the "Generic, World target" entry. Node name format: "Undercity, Tirisfal" |

## Panel

Not yet run in game. Record findings here after the first `/lc` on the live client.
