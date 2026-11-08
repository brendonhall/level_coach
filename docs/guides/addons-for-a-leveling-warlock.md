# Addons for a leveling Undead Affliction Warlock on WoW: Forever

**Status:** recommendations compiled 2026-11-08 from community compatibility lists and addon
roundups (see `docs/research/2026-11-08-addons-and-api.md` for the sourced digest). Forever is
days old: check each addon's CurseForge page for a file tagged for the **Forever** game version
before installing, and expect churn after every client patch.

Context: Brendon runs no addons yet, levels an Undead Affliction Warlock, and wants Level Coach
to be the checklist layer. Everything below is complementary to that, not a substitute.

## How installing works on Forever

- Use the **CurseForge app** with the game version set to **Forever**, or install manually.
- Manual path: `World of Warcraft\_forever_\Interface\AddOns\`. Guides show `_forever_` after
  launch and `_classic_beta_` during the beta; confirm by opening the install folder from the
  Battle.net launcher. Each addon folder must match its `.toc` file name.
- After adding a **new** addon folder, restart the client. Sources disagree on whether `/reload`
  is enough; a restart always is. `/reload` is fine after updating an existing addon.
- If an addon shows as out of date after a patch, tick **Load out of date AddOns** in the
  AddOns list at character select, then update it when the author ships a new file.
- Forever hides Lua errors by default. Install **BugSack** and **BugGrabber** to see them, and
  especially while Level Coach is being developed.

## Install now (the short list)

| Addon | Why for you | Forever notes |
|---|---|---|
| **Questie** | Quest givers, turn-ins and objectives on the map and minimap. The standard quest helper. | Forever file exists (v12.3.1, Oct 26). Its database is Classic's, so new Forever quests have no markers yet. Status "known issues" on Oct 31. Still worth it. |
| **Forever Quest Pins** | Yellow "!" pins for quests you could pick up but have not, including the new Forever ones Questie misses. | Made for Forever (v0.3.5, Oct 25). Tiny. |
| **Guidelime + TUGs Leveling Guide** | A free step-by-step route with an arrow. TUGs covers every starting zone and levels 12 to 30 written against the Forever beta; 30 to 60 uses a Classic route until the author updates it. | Both have Forever files (Oct 26 to 30). Free. The alternative is **RestedXP**: free addon, levels 1 to 20 free, paid routes after, Forever-specific 35 to 60 routes promised post-launch. Try TUGs first. |
| **Leatrix Plus** | Auto-accept and auto-complete quests, auto-sell junk, auto-repair, block duels. Saves hundreds of clicks over 60 levels. | `-forever` file (1.60.25, Oct 21). Settings via `/ltp`. |
| **Baganator** | Bag addon with a categories view. Warlocks live with Soul Shard clutter; a category or rule for shards keeps them out of the way. | Forever file (build 839, Oct 28). Combined bags are built into Forever, so this is about sorting, not merging. **Bagnon** or **BetterBags** are fine alternatives. |
| **Soul Shards Forever (SSF)** | Caps your shard count and moves loose shards into a soul bag, one shard per keypress or macro click. | Built for the Forever client. Cannot run in combat (Blizzard limitation). Found via CurseForge and GitHub, not in the compatibility lists, so verify it loads. |
| **Threat Plates** | Nameplates colored by threat. In DPS view, red means you pulled aggro off your pet or tank, orange means ease off. For a multi-DoT class with a Voidwalker tank this is the single most useful combat display. | Forever version 13.3.4 (Oct 28); an earlier CurseForge build failed to load around Oct 21, so update if it misbehaves. Compact alternative: **ThreatMeter** (made for Forever and Hardcore). |
| **TellMeWhen** | Icons with timers for your DoTs on the current target (Corruption, Bane of Agony, Immolate, Siphon Life) and for cooldowns. | Forever file (12.1.5, Oct 12). **WeakAuras has no Forever file**; the forks **ForeverAuras** (1.1.0) and **Musca Auras** exist if you prefer that style. Aura reading in combat is subject to Forever's secret-value rules, so some displays may be limited. |
| **TomTom** | Waypoint arrow for pasted coordinates. Level Coach will hand it waypoints when present. | Forever file (v4.3.13, Oct 24). |
| **What's Training?** | Lists in your spellbook what the class trainer can teach you next, so you know whether a trainer trip is worth it. | Forever beta file (11.0.0-beta25, Oct 23). Alternative: **GnomeLevelUp**. Level Coach will eventually cover this in its checklist. |
| **DungeonJournal** (`/dj`) | Bosses, loot, dungeon map, and the dungeon's quests with their quest givers. Dungeon quests are a large share of Forever leveling XP. | Forever flavor file (1.6.5, Oct 19). Loot tables still incomplete for some dungeons. |
| **GearQuest Forever** | Right-click a gear slot to see class and level upgrades from 1 to 60 and where they come from. Good for a first character. | Made for Forever (v1.0.6, Oct 28). **Pawn** (2.14.0) adds upgrade arrows on quest rewards. |
| **BugSack + BugGrabber** | Shows Lua errors Forever otherwise hides. Required for Level Coach development, harmless otherwise. | Forever files (Oct 26). |

## Nice to have

- **OpenMap** or **Leatrix Maps** (pick one, they conflict): zone level ranges on the world map,
  dungeon layouts. OpenMap was a 0.7 beta on Oct 20. Useful for planning zones as a new player.
- **SkillUp Forever**: skill-up odds and recipe costs in the profession window. Install if you
  take Tailoring and Enchanting.
- **Auctionator**: selling cloth and greens for bag money. Forever file (Oct 13).
- **Details!**: damage meter with an aggro display. Forever has a damage meter built in, so
  this is optional.
- **Bartender4** or **Dominos**: action bars. Edit Mode is built in; `/kb` keybinding in
  Bartender4 is the main reason to add it.
- **Atlas** and **AtlasLoot Classic Forever**: dungeon maps and loot tables if DungeonJournal
  is not enough.
- **GTFO**: a sound when you stand in something harmful. Cloth casters appreciate it.
- **Nova Instance Tracker**: tracks alts' rested XP and instance lockouts. Later.

## Skip for now

- **WeakAuras**: no Forever file; development stopped before Midnight's API changes. Use the
  forks or TellMeWhen.
- **TradeSkillMaster**, **AdiBags**, **Skada**, **Recount**, **OmniCC**, **Shadowed Unit
  Frames**, **Nova World Buffs**: no Forever files as of Oct 31, or replaced by built-ins
  (damage meter, Cooldown Manager under Options > Gameplay Enhancement, combined bags, sell-all
  junk and repair-all buttons at merchants).
- **Zygor**: Forever guides were announced for November with partial coverage; only worth it
  if you already subscribe.
- Healer suites (**HealBot**, **VuhDo**, **Grid2**, **Decursive**, **Clique**): nothing for a
  warlock to do with them.

## Built-ins worth turning on instead of an addon

Forever's client ships a damage meter, a Cooldown Manager (off by default), Edit Mode for moving
UI elements, an equipment manager, combined bags, click casting on raid frames, and quest
guidance under the "Enhanced" experience preset. Check Options before adding a duplicate.

## A note on sources

The two Kami Labs articles and both wowforeverguides pages carry RestedXP sponsorship or
affiliate links, which colors their routing recommendations. The forevermastery compatibility
list (checked Oct 31 against client 1.60.1) and the mein-mmo roundup disclose no sponsorship.
Compatibility statuses are snapshots; CurseForge is the source of truth on any given day.
