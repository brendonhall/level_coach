# Forever API probe results

**Status:** awaiting the first run (`docs/dev/windows-deploy.md`, step 5). Until then every ID in
`data/` carries a `verify` note and `Core/State.lua` guards every call with `pcall`.

Fill one table per probe section from `LevelCoachDB.probe`. The third column records the
decision the code takes.

## Build

| probe | result | use in State.lua |
|---|---|---|
| build.toc (`select(4, GetBuildInfo())`) | | TOC interface number |
| build.projectIDs (`WOW_PROJECT_ID`, `WOW_PROJECT_CAMELOT`) | | Forever detection |
| build.foreverPresetFn | | capability probe |
| build.gameMode, build.realm | | ruleset detection |

## Identity and location

| probe | result | use in State.lua |
|---|---|---|
| unit.level, unit.class, unit.race, unit.faction | | snapshot identity (race file name expected `Scourge`) |
| loc.zone, loc.mapID, loc.pos | | zone, mapID, waypoint support |

## Quests

| probe | result | use in State.lua |
|---|---|---|
| quest.numCompleted | | `C_QuestLog.GetAllCompletedQuestIDs` available? |
| quest.1470 | | expected "Halgar's Summons" |
| quest.1740 | | expected "Devourer of Souls" |
| quest.1798 | | expected "Seeking Strahad" |

## Spells

One row per ID in `Probe.spellIDs`: `confirmed <name>`, `renumbered` (name differs), or
`unknown`. Renumbered entries get the new ID from the spellbook tooltip or `/dump`.

| id | expected name | result |
|---|---|---|
| 686 | Shadow Bolt | |
| 348 | Immolate | |
| 172 | Corruption | |
| 702 | Curse of Weakness | |
| 688 | Summon Imp | |
| 1454 | Life Tap | |
| 980 | Bane of Agony (was Curse of Agony) | |
| 5782 | Fear | |
| 1120 | Drain Soul | |
| 6201 | Create Healthstone (rank 1) | |
| 697 | Summon Voidwalker | |
| 755 | Health Funnel | |
| 689 | Drain Life | |
| 704 | Curse of Recklessness | |
| 5697 | Unending Breath | |
| 693 | Create Soulstone (rank 1) | |
| 712 | Summon Succubus | |
| 706 | Demon Armor | |
| 698 | Ritual of Summoning | |
| 1490 | Curse of the Elements | |
| 691 | Summon Felhunter | |
| 5784 | Summon Felsteed | |
| 687 | Demon Skin | |

## Skills and professions

| probe | result | decision |
|---|---|---|
| skill.fns | | if `GetNumSkillLines` exists use skill lines; else if `GetProfessions` exists use `GetProfessionInfo`; else `skill_line` detectors return nil (manual) |
| skill.lines or skill.professions | | names as the data must spell them |

## Economy, map, misc

| probe | result | use in State.lua |
|---|---|---|
| econ.money, econ.bind, econ.rested, econ.bagSlots | | money, bindLocation, rested, bag scan |
| map.setWaypointFn, map.canWaypoint | | built-in pin for "where" |
| misc.fns (`issecretvalue`, `RequestTimePlayed`, `NumTaxiNodes`) | | guards, play time, taxi recording |
| taxi | | node name format for `taxi_known` detectors |
