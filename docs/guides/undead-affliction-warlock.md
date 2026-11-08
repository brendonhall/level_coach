# Undead Affliction Warlock, levels 1 to 60, on WoW: Forever

**Status:** v0, compiled 2026-11-08 from the best current community guides (digests with source
tags in `docs/research/`). Forever launched four days earlier; nothing here has been verified in
game yet, and Blizzard announced class tuning for November 10. Treat every number as "reported"
until a character has done it. The point of this document is to seed Level Coach's data files
and to answer "what should I be doing at this level" without alt-tabbing.

**How to read it.** Each band lists checklist items, not a quest route. Columns:

- **Do**: the item as it would appear in the addon.
- **Why**: the one-line explanation the addon shows on expand.
- **Where**: location or NPC when known.
- **Detect**: how Level Coach can auto-complete it (`spell`, `quest`, `skill`, `item`, `hearth`,
  `level`, `talent`, or `manual`).
- **Conf.**: how the sources agree. **C** consensus of several guides, **R** reported by one
  or two, **U** unverified or conflicting, **K** Classic-era knowledge not checked for Forever.

Sources are abbreviated: Method, Tavern (Warcraft Tavern), Maxroll (via timesaver.gg),
WFG.gg (wowforever.gg), WFT (wowforevertalent), FC (foreverchanges), Wiki (warcraft.wiki.gg),
Blizzard, WFL (wowforeverleveling), WFGuides (wowforeverguides). Several routing sources carry
RestedXP or Zygor affiliate links; see the caveats at the end.

---

## The journey in one screen

| Levels | Play style | Pet | Zones for an Undead | Dungeons in range (Horde access) |
|---|---|---|---|---|
| 1-9 | Immolate, Corruption, Shadow Bolt, wand as soon as you own one | Imp | Deathknell, Tirisfal Glades, Brill | none |
| 10-19 | Voidwalker tanks; Bane of Agony to pull, Corruption, then wand | Voidwalker | Silverpine Forest (Sepulcher), then zeppelin to the Barrens (Crossroads) | Ragefire Chasm 13-19, Ruins of Lordaeron 15-20 (Undercity), Wailing Caverns 19-25 |
| 20-29 | Sayaad out; still wand filler; Fear the second mob | Succubus or Incubus | Barrens, Hillsbrad Foothills (Tarren Mill), Ashenvale, Stonetalon | Shadowfang Keep 23-29, Blackfathom Deeps 25-31, City of Dalaran 28-33 (attune in Tarren Mill) |
| 30-39 | Drain tanking: DoTs up, Drain Life filler, Life Tap when health exceeds mana | Sayaad (Felhunter for casters) | Thousand Needles, Arathi, Desolace, Stranglethorn, Dustwallow, Badlands, Swamp of Sorrows, Riverglades from 36 | Razorfen Kraul 30-36, Scarlet Monastery 31-45 (Tirisfal), The Drowned City 35-40 (Grom'gol), Razorfen Downs 38-44 |
| 40-49 | Same loop; Curse of the Elements opener on big mobs; mounted | Sayaad | Riverglades, Tanaris, Feralas, Hinterlands | Krol'dok Stronghold 40-45 (Riverglades), Uldaman 44-50, Zul'Farrak 45-51, Alcaz Prison 48-53, Maraudon 48-54 |
| 50-60 | Same loop | Sayaad | Blasted Lands, Searing Gorge, Azshara, Felwood, Un'Goro, Plaguelands, Silithus, Winterspring, Mount Hyjal late | Sunken Temple 52-58, Blackrock Depths 52-60, Blackmaw Hold 55-60, Lower Blackrock Spire 55-60, Shaper's Terrace 58-60, Scholomance, Stratholme, Dire Maul 58-60 |

Dungeon ranges: Wiki, with WFL for Ruins of Lordaeron (Wiki says 15-22). Zone bands: Tavern's
minimum-level list and the Wowdee Horde route relayed by WFL, which was tested only to level 30.

---

## Before level 1: setup items

| Do | Why | Where | Detect · Conf. |
|---|---|---|---|
| Choose the **Enhanced** experience preset, or at least turn on quest guidance | Blizzard's own quest objective markers and points of interest replace half of what people install Questie for | Game Menu > Options; presets are presentation only, not a ruleset | manual · C (Blizzard) |
| Turn on the built-in **Cooldown Manager** | Forever ships one; it covers every class since the Oct 8 beta build | Options > Gameplay Enhancement | manual · R |
| Install the short addon list | See `addons-for-a-leveling-warlock.md` | | manual · C |

---

## Levels 1 to 9: Deathknell and Tirisfal Glades

| Lvl | Do | Why | Where | Detect · Conf. |
|---|---|---|---|---|
| 1 | Do the **Imp** class quest immediately | Your first pet; ranged damage plus the Blood Pact stamina buff. Keep it out at all times until 10 | Maximillion, class trainer, Deathknell (30.8, 66.2) | spell Summon Imp · C |
| 1 | Train **Immolate** right away | Your opener for the first nine levels; it costs 10 copper. Sell starting gear if you are short | Maximillion | spell Immolate · C |
| 1 | Cast **Demon Skin** and keep it up | Armor plus health regeneration; later Demon Armor | self | manual · C |
| 3-4 | Do the **starter gathering quest** and pick a manual | New in Forever: a choice of Herbalism, Mining or Skinning manuals worth 2 skill points. Herbalism or Skinning both pay for riding later and give campsite buffs | Deathknell; trainers Florence Nightshade (Herbalism) and Walter Mason (Mining) | skill Herbalism or Skinning · R (WFGuides) |
| 4 | Train **Corruption** and **Curse of Weakness** | Corruption is your core DoT for 60 levels. Curse of Weakness for hard-hitting melee | Maximillion | spell Corruption · C |
| 4 | Buy **Grimoire of Blood Pact** | Demon trainers sell pet abilities as grimoires now; the starter-zone trainer only carries Imp and Voidwalker books | Kayla Smithe, demon trainer, Deathknell (30.8, 66.4) | manual · C (Method, Tavern) |
| 5 | Get a **wand**: Lesser Magic Wand | Wands are free damage with no mana; every guide says this is the single biggest early upgrade. Wand skill is default for warlocks | Enchanting-made, bind on equip: auction house or any enchanter | item wand equipped · C |
| 5 | Pick two **professions**; start **First Aid** and **Cooking** | Guides lean Tailoring plus Enchanting (craft, then disenchant; Enchanting makes your wands). First Aid now also makes healing potions and cures. Cooking gives Well Fed (+5% kill XP) and powers your own campsite | Brill or Undercity trainers | skill First Aid, skill Cooking · C |
| 5-6 | Unlock **camping** | New Forever system: sit at a campfire to pick up campsite buffs; profession camp buffs from skill 20 | An adventurer outside the first quest hub; quest "The Great Outdoors" | quest · R (Wiki) |
| 6 | Train **Life Tap** and **Shadow Bolt rank 2**; replace rank 1 on your bars | Life Tap turns health into mana and scales with Spirit in Forever. Carry food: tap, then eat | Maximillion or Brill | spell Life Tap · C |
| 6 | Move to **Brill** and set your **hearth** there | Brill is the handoff town and has the Voidwalker quest at 10 | Brill inn | hearth Brill · K |
| 7 | **Makeshift Stormcaller** staff from "Stormy Potential" | Early Horde quest staff (Method's list) | Horde quest, level 7 | item · R |
| 8 | Train **Bane of Agony** and **Fear** | Bane of Agony tags a mob instantly and ramps slowly, so the pet picks up threat. Fear is your main crowd control, 20-yard range | Brill: Rupert Boch, class trainer (61.6, 52.4) | spell Bane of Agony · C |
| 8 | Pull with **Bane of Agony**, not Immolate | Immolate's upfront hit steals threat from the pet | | manual · C (Tavern) |
| 1-9 | Keep bags growing; start a **shard habit** | Soul Shards take bag space. Keep a few spare, never a full bag of them | Vendor or auction house bags | item bags · C |

**Rotation 1-9:** pet attacks first, Immolate, Corruption (from 4), Shadow Bolt or wand to finish,
Life Tap between pulls. Shadow Bolt is mana-hungry at 1-5; expect to wait for mana.

---

## Levels 10 to 19: Voidwalker, Silverpine, first talents

| Lvl | Do | Why | Where | Detect · Conf. |
|---|---|---|---|---|
| 10 | **Voidwalker** quest: "Halgar's Summons" | Your tank for the next ten levels. Take the Brill version, not Orgrimmar's Skull Rock version | Halgar, Brill | spell Summon Voidwalker · C |
| 10 | Train **Drain Soul** and **Create Healthstone**; make a Healthstone and always carry one | Drain Soul makes shards (a chance per tick on real mobs, always on a kill). Healthstone is on its own cooldown, separate from potions | Rupert Boch, Brill | spell Create Healthstone, item Healthstone · C |
| 10 | Spend your first **talent** point: Improved Corruption | Instant Corruption at 5/5 is where every guide starts. See the talent table | Talent frame | talent · C |
| 10 | Train **Journeyman** professions when eligible | | | skill · R |
| 10 | Quest in **Silverpine Forest** from the Sepulcher | Shared Horde 10-20 zone; Shadowfang Keep (23-29) is here for later | Silverpine | zone · C |
| 12 | Train **Health Funnel**; buy the Voidwalker's new **Torment** rank every time one appears | Torment threat steps every ten levels; a stale rank means the Voidwalker loses mobs to your DoTs | Gina Lang, demon trainer, Brill (61.6, 52.6) | spell Health Funnel · C |
| 12-14 | **Zeppelin** from Undercity to Orgrimmar, then to the **Barrens** (Crossroads) | The route most Horde guides follow: Barrens 12-26 with Hillsbrad 20-30 | Undercity zeppelin tower | zone Barrens · C (WFL) |
| 13 | Upgrade the wand: **Greater Magic Wand** or **Branding Rod** | 17.5 DPS beats most wands before 18; Branding Rod is the Barrens quest "Isha Awak" | Enchanting-made, or the quest | item · R (Method) |
| 13 | **Darkwood Staff** from "The Family Crypt" | Early Horde staff on Method's list (Tirisfal quest) | Horde quest, level 13 | item · R |
| 13-19 | **Ragefire Chasm** when a group forms; do "Hidden Enemies" for the **Staff of Orgrimmar** | Dungeon quests are a large share of Forever XP (dungeon kill XP was raised about 20% in beta, quest XP halved) | Orgrimmar, Cleft of Shadow | quest · C |
| 14 | Train **Drain Life** and **Curse of Recklessness** | Drain Life is the drain-tank tool later; the wand stays your filler until about 29. Curse of Recklessness cancels a Fear that runs the wrong way; never put it on a mob you intend to Fear | Trainer | spell Drain Life · C |
| 14 | Consider the **Cozy Sleeping Bag** chain | Reported stacking XP buff plus a portable rest spot; starts at 14 in the Barrens (Burned-Out Remains, 46, 74). Long chain through level 25-30 zones; disputed details | Barrens | quest · U |
| 15-20 | **Ruins of Lordaeron**, the Undead home dungeon | New dungeon above the Undercity. Six Horde quests, four picked up in Tirisfal, Silverpine and the Undercity, so collect them when you pass through | Undercity | quest · R (WFL) |
| 16 | Train **Unending Breath** | Makes the Undead water racial irrelevant | Trainer | spell · C |
| 18 | Train **Create Soulstone**; keep one active | Battle resurrection for you or a friend. Skip Searing Pain as Affliction | Trainer | spell Create Soulstone · C |
| 18+ | **Gravestone Scepter** from "Blackfathom Villainy" | 29 DPS wand, the best before the mid-twenties. Quest opens at 18, expect to need to be higher | Blackfathom Deeps, Ashenvale | item · R (Method, Tavern) |
| 19-25 | **Wailing Caverns** | On the Horde mandatory list of every dungeon route | Barrens | manual · C |
| 15-19 | Talents: Suppression 4 or 5 | Hit chance plus reduced threat, which matters when a pet tanks | | talent · C |

**Rotation 10-19:** pet in first, Bane of Agony to pull, Corruption, Immolate only on mobs that
will live long enough, wand until dead. Life Tap whenever health is higher than mana. Second
mob: DoT it and Fear it, kill the first.

---

## Levels 20 to 29: Sayaad, Hillsbrad, dungeons in range

| Lvl | Do | Why | Where | Detect · Conf. |
|---|---|---|---|---|
| 20 | **Succubus or Incubus** quest: "Devourer of Souls" or "Hearts of the Lovers" | Highest-damage demon and the drain-tanking partner from 30. The Horde chain is eight quests across the Barrens and Stonetalon: grab both flight paths first. Reported reward: a 14-slot Small Soul Pouch | Undercity | spell Summon Succubus or Summon Incubus · C (reward size U) |
| 20 | Train **Demon Armor** (replace Demon Skin), **Ritual of Summoning**, **Curse of the Elements** | Ritual is the only way to summon players: Meeting Stones no longer summon. Curse of the Elements is a Curse, so it sits next to your Bane | Trainer | spell Demon Armor · C |
| 20 | **The Orb of Soran'ruk** from Doan Karhan | Needs fragments from Blackfathom Deeps and Shadowfang Keep; rewards a two-hander with +34 Shadow and Fire damage or an off-hand with a heal | Barrens | quest · R (Tavern) |
| 20 | Train **Expert** professions when eligible | | | skill · R |
| 20-30 | Quest in **Hillsbrad Foothills** from **Tarren Mill**; set hearth there while you do | Standard Horde 20-30 zone | Hillsbrad | hearth Tarren Mill · K |
| 20-28 | Pick up the **City of Dalaran attunement**: "Key to the City" and "Prison Break-In" | New dungeon at 28-33 in Alterac; the attunement starts in Tarren Mill, so take it during the Hillsbrad visit | Magus Wordeen Voidglare, Tarren Mill | quest · R (WFL citing Blizzard) |
| 22 | Train **Eye of Kilrogg**; watch for the **Staff of the Shade** | Rare Razorfen Kraul drop, excellent from 22 | Razorfen Kraul | item · R |
| 23-29 | **Shadowfang Keep** | Horde quests from the Sepulcher; one Soran'ruk fragment | Silverpine | manual · C |
| 25 | Spend your first **Legacy Point** | New account-wide system: leveling a class to 25, 40 and 60 awards points; perks such as Talented (earlier talents) and Well Rested help leveling | Class trainer | level 25 · R |
| 25 | Use **Lesser Arcane** and **Lesser Mageblood** elixirs | Cheap caster consumables start here | Auction house or an alchemist | manual · R |
| 25-31 | **Blackfathom Deeps** | Gravestone Scepter quest, Rod of the Sleepwalker staff from Kelris, the other Soran'ruk fragment | Ashenvale | manual · C |
| 26 | Train **Curse of Tongues**, **Detect Invisibility**; wand: **Dancing Flame** | Dancing Flame is a Horde quest reward at 26 | Trainer; quest | item · R (Tavern) |
| 28 | Train **Banish**; skip Create Firestone as Affliction | Banish is not broken by damage | Trainer | spell Banish · C |
| 28-33 | **City of Dalaran** | New dungeon; Wand of Mana Concentration and the Spine of the Devourer staff drop here | Alterac Mountains | manual · R |
| 19-29 | Talents: pet first or damage first (see table) | Maxroll and Tavern buy Unholy Power and Demonic Energies at 19-25 so the Sayaad kills faster; Method waits until 46 and takes Affliction damage talents first | | talent · U |

**Rotation 20-29:** the Sayaad holds threat worse than the Voidwalker, so let it hit for a second
before your first spell. Keep wanding as the filler; switch to Drain Life only when your wand
falls behind. Curse of the Elements plus Bane of Agony plus Corruption on anything big.

---

## Levels 30 to 39: drain tanking and the long middle

| Lvl | Do | Why | Where | Detect · Conf. |
|---|---|---|---|---|
| 30 | **Felhunter** quest: "Seeking Strahad", then Strahad Farsan in Ratchet | Spell Lock and Devour Magic; the pet for caster-heavy areas and PvP | Undercity, then Ratchet (Barrens) | spell Summon Felhunter · C |
| 30 | Switch to **drain tanking** | DoTs up, let the mob hit you, Drain Life to heal and damage, Life Tap for mana, Drain Life again. Almost no eating or drinking. Needs Improved Drains 3/3 and the level 30 Drain Life rank | | manual · C (Method, Tavern) |
| 30 | Train **Subjugate Demon**; skip Hellfire | | Trainer | spell · C |
| 30-36 | **Razorfen Kraul** | Staff of the Shade chance | Barrens | manual · C |
| 31-45 | **Scarlet Monastery** wings as you level | It is in Tirisfal, next to your home city; Necrotic Wand (Azshuir) and Illusionary Rod (Doan) drop here. Optional on speed routes, excellent for an Undead | Tirisfal Glades | manual · C |
| 32 | Train **Shadow Ward** | Absorbs Shadow damage, 30-second cooldown | Trainer | spell · C |
| 35 | Train **Artisan** professions when eligible | | | skill · R |
| 35-40 | **The Drowned City** | New dungeon off the Stranglethorn coast, west of Grom'gol; its quests start at Grom'gol | Zeppelin to Grom'gol | manual · R (WFL) |
| 36 | Train **Create Spellstone** and use it as your weapon oil | Spellstone is a weapon enchant in Forever: +1% haste and up to 14 Shadow damage | Trainer | spell Create Spellstone · C |
| 36+ | Quest in the **Riverglades** from **Rog'mar**; take its flight path first | New Horde zone, mid-30s to mid-40s; Krol'dok Stronghold is here | Riverglades (Eastern Kingdoms) | zone · R |
| 37 | Wand: **Twisted Nether Wand** | Enchanting-made | | item · R (Method) |
| 30-39 | **Save for riding**: 100 gold by 40 | Fresh economy, no mains to fund you. Sell greens and cloth, vendor greys. Honored with Undercity cuts the price to 90 | | gold 100 · C |
| 30-39 | Talents (Maxroll order): Fel Concentration 31-33, Pandemic 34-36, Soul Siphon 37-39 | Pandemic doubles DoT crit damage; Soul Siphon buffs drains per Affliction effect on the target | | talent · R |

**Rotation 30-39:** pet in, Bane of Agony, Corruption, Immolate on long fights, Drain Life until
dead. Life Tap when health far exceeds mana; Drain Life when mana far exceeds health; never wand
at full mana. Fight two at a time: DoT and Fear one, pet on the other.

---

## Levels 40 to 49: mount, Curse of the Elements, Riverglades

| Lvl | Do | Why | Where | Detect · Conf. |
|---|---|---|---|---|
| 40 | **Felsteed** class quest | Short quest per Tavern. Whether it also teaches Apprentice Riding is unconfirmed, so still bring 100 gold | Strahad Farsan, Ratchet (Method) | spell Summon Felsteed · R |
| 40 | **Apprentice Riding**, if the quest did not grant it | 100 gold (90 at Honored), first racial mount included, extra colors 20 gold. Undead must buy from their own race's trainer until Exalted elsewhere | Velma Warnam (skill) and Zachariah Post (mounts), Brill (60.1, 52.6, beta coordinates) | spell Apprentice Riding · C (prices beta-era) |
| 40 | Consider **Dual Talent Specialization** | New: a second spec for dungeons or PvP, reported 50 gold at class trainers | Class trainer | manual · R |
| 40 | Train **Howl of Terror** and **Curse of the Elements rank 3** | Howl for overpulls. Rank 3 adds 8% magic damage taken: open with it on high-health mobs | Trainer | spell Howl of Terror · C |
| 40 | Legacy: second challenge point at 40 | | Class trainer | level 40 · R |
| 40 | Talents: **Siphon Life** (Maxroll at 40), or **Wrack** if you want the 31-point channel | Wrack is far stronger than it was in beta and is the raid filler at 60; only WFG.gg takes it while leveling | | talent · U |
| 40-45 | **Krol'dok Stronghold** | New dungeon in the Riverglades | Riverglades | manual · R |
| 42 | Train **Death Coil** | Instant escape that heals you | Trainer | spell Death Coil · C |
| 43 | Wand: **Dreambough Wand** or **Peacekeeper Wand**; staff: **Zum'rah's Vexing Cane** | Enchanting wand; Zul'Farrak staff | | item · R |
| 44-54 | **Uldaman**, **Zul'Farrak**, **Alcaz Prison** (new, Dustwallow, contested for Horde), **Maraudon** | | | manual · C |
| 47 | **Greater Arcane Elixir** and friends | Arcane Elixir, Elixir of Shadow Power, Mageblood in the forties | | manual · R |
| 48 | Skip **Soul Fire** as Affliction | Demonology tool | | spell · C |
| 41-49 | Talents (Maxroll): Malevolence 41-45, Improved Bane of Agony 46-47, Nightfall 48-49 | | | talent · R |

---

## Levels 50 to 60: finishing

| Lvl | Do | Why | Where | Detect · Conf. |
|---|---|---|---|---|
| 50 | Skip **Inferno** for leveling | Reagent cost, one-hour cooldown | | spell · C |
| 50-60 | Zones: Blasted Lands, Searing Gorge (43), Azshara, Felwood (45), Un'Goro (48), Western Plaguelands (50), Eastern Plaguelands and Winterspring (53), Silithus (55), **Mount Hyjal** late | Hyjal is new and hosts the first raids | | zone · R |
| 52-60 | **Sunken Temple**, **Blackrock Depths**, **Blackmaw Hold** (new, Azshara), **Lower Blackrock Spire** | | | manual · C |
| 51 | Wand: **Wand of Biting Cold** (quest); 55 **Greater Eternal Wand**; 60 **Torch of Light** | | | item · R |
| 58-60 | **Shaper's Terrace** (new, Un'Goro): collect power crystals while questing there | The consoles inside use them (Blizzard overview) | Un'Goro Crater | manual · R |
| 50-60 | Talents (Maxroll): Suppression 5/5 at 50, Fel Vitality 51-53, Shadow Mastery 54-58, Master Summoner 59-60 | Final split 39 Affliction, 12 Demonology | | talent · R |
| 60 | Train **Bane of Doom**; use it only on targets that live past a minute | Renamed Curse of Doom | Trainer | spell · C |
| 60 | **Journeyman Riding** (1,000 gold) plus a 200-gold epic mount, or the **Dreadsteed** chain | Dreadsteed is a long chain with reagents costing hundreds of gold, still likely cheaper than the training | | spell Summon Dreadsteed · R |
| 60 | Legacy: third challenge point; raids open **December 9, 2026** (Barrow Deeps 10, Hyjal Summit 20, Onyxia 40) | | | level 60 · R (Wiki) |

---

## Reference: talent order

Recommended default: the explicit per-level list Maxroll publishes (relayed by timesaver.gg,
checked against the live trees on November 6). Where the other three guides differ, the note
says so. The Legacy perk Talented can move any of this up to five levels earlier.

| Levels | Talent | Note |
|---|---|---|
| 10-14 | Improved Corruption 5/5 | All four guides take it first or by 20. Instant Corruption plus 10% damage |
| 15-18 | Suppression 4/5 | Hit and reduced threat. Method takes 4 points here *before* Improved Corruption |
| 19-23 | Unholy Power 5/5 | Pet damage. Tavern agrees (20-24); Method delays all Demonology to 46; WFG.gg to 41-60 |
| 24-25 | Demonic Energies 2/2 | Pet heals from your spell damage and shares Life Tap mana |
| 26-27 | Improved Life Tap 2/2 | 20% more mana per tap |
| 28-30 | Improved Drains 3/3 | Timed for drain tanking at 30. WFG.gg has it by 20 |
| 31-33 | Fel Concentration 3/3 | Pushback resistance on drains and Wrack. Method 23-25 |
| 34-36 | Pandemic 3/3 | DoT crit damage bonus to 100%. Method 20-22 |
| 37-39 | Soul Siphon 3/3 | Drains +12% per other Affliction effect, up to 36% |
| 40 | Siphon Life | WFG.gg takes Wrack here instead and had Siphon Life by 30 |
| 41-45 | Malevolence 5/5 | +5% Shadow crit |
| 46-47 | Improved Bane of Agony 2/2 | |
| 48-49 | Nightfall 2/2 | Shadow Trance procs |
| 50 | Suppression 5/5 | |
| 51-53 | Fel Vitality 3/3 | Pet health and mana, own max mana |
| 54-58 | Shadow Mastery 5/5 | +10% Shadow damage. Method 35-39 |
| 59-60 | Master Summoner 2/2 | Faster, cheaper summons |

Final splits by source: Maxroll 39/12/0, Method about 41/10/0 (derived from narrative), Tavern
40/7/4, WFG.gg 31/20/0. Everyone ends with Improved Corruption, Suppression, Improved Life Tap,
Improved Drains, Improved Bane of Agony, Fel Concentration, Pandemic, Nightfall, Siphon Life,
Soul Siphon, Shadow Mastery and Unholy Power. Respecs are cheap early and also reset Legacy talents.

## Reference: demon quests for an Undead

| Demon | Level | Quest | Start | Notes |
|---|---|---|---|---|
| Imp | 1 | class quest | Deathknell | Do it at once |
| Voidwalker | 10 | Halgar's Summons | Brill | Far easier than the Orgrimmar version (Skull Rock) |
| Succubus | 20 | Devourer of Souls | Undercity | Eight-quest Horde chain across the Barrens and Stonetalon; take the flight paths first |
| Incubus | 20 | Hearts of the Lovers | Undercity | Same demon, other model; Summon Incubus is new and costs a shard |
| Felhunter | 30 | Seeking Strahad | Undercity, then Ratchet | Strahad Farsan in Ratchet |
| Felsteed | 40 | short class quest | Ratchet (Method) | Riding grant unconfirmed; bring 100 gold |
| Dreadsteed | 60 | long chain | | Reagents cost hundreds of gold |

Summons for Voidwalker, Sayaad and Felhunter each cost a Soul Shard; the Imp does not.

## Reference: wand progression

| Level | Wand | Source |
|---|---|---|
| 5 | Lesser Magic Wand (11.3 DPS) | Enchanting, bind on equip |
| 13 | Greater Magic Wand (17.5 DPS) or Branding Rod | Enchanting; Barrens quest "Isha Awak" |
| 18-22 | Gravestone Scepter (29 DPS) | Blackfathom Deeps quest "Blackfathom Villainy" |
| 26 | Dancing Flame | Horde quest |
| 27 | Wand of Mana Concentration | City of Dalaran, Arcanic Enigma |
| 30 | Necrotic Wand | Scarlet Monastery, Azshuir the Sleepless |
| 37 | Twisted Nether Wand | Enchanting |
| 39 | White Obsidian Wand | not stated |
| 43 | Dreambough Wand; Peacekeeper Wand | Enchanting; not stated |
| 49 | Lesser Eternal Wand | Enchanting |
| 51 | Wand of Biting Cold | quest |
| 55 | Greater Eternal Wand | Enchanting |
| 60 | Torch of Light | Enchanting |

Early wands hit almost as hard as Shadow Bolt for free. Before 30 prefer the wand over Drain
Life unless you need the health; from 30 Drain Life is the filler and the wand finishes mobs.

## Reference: trainers an Undead will use

| Place | Class trainer | Demon trainer (grimoires) |
|---|---|---|
| Deathknell | Maximillion (30.8, 66.2) | Kayla Smithe (30.8, 66.4), Imp and Voidwalker books only |
| Brill | Rupert Boch (61.6, 52.4) | Gina Lang (61.6, 52.6) |
| Undercity, Magic Quarter | Kaal Soulreaper (86.0, 15.6), Luther Pickman (86.2, 15.2), Richard Kerwin (88.6, 16.0) | Martha Strain (85.8, 15.8) |

Riding: Velma Warnam and Zachariah Post, Brill. Weapon skills: Staves from Hanashi or Sayoc in
Orgrimmar or Ansekhwa in Thunder Bluff; One-Handed Swords from Archibald in Undercity. Coordinates
are from Tavern and were recorded during beta.

## Reference: gold milestones

| Level | Need | Amount (beta-era figures) |
|---|---|---|
| 1-60 | Class training, every rank | about 206 to 207 gold total per Blizzard; skip ranks you will not use |
| 40 | Apprentice Riding, mount included | 100 gold, 90 at Honored with Undercity; extra colors 20 |
| 40 | Dual Talent Specialization | 50 (reported, currency assumed gold) |
| 60 | Journeyman Riding | 1,000 gold, skill only |
| 60 | Epic mount | 200 gold, or the Dreadsteed chain |

Gold tips the guides agree on: a gathering profession from level 1, auction whites and greens
while launch prices are high, vendor greys, turn in loot crates at the Durotar Supply and
Logistics camp west of the Crossroads (42, 34) for reputation and Merchant's Favor, and do not
overspend on auction-house greens in your thirties.

## Undead racial notes

- **Will of the Forsaken**: breaks or prevents Charm, Fear and Sleep. The strongest warlock PvP
  racial.
- **Cannibalize**: buffed in Forever to restore mana as well as health. With Life Tap this
  nearly removes downtime after fights. Use it on every humanoid or undead corpse.
- **Touch of the Grave** (new passive): hits have a 30% chance to steal health, 15-second
  internal cooldown, scales with Stamina. Offsets some Life Tap.
- **Underwater Breathing**: irrelevant once you train Unending Breath at 16.

## What changed from Classic, so old guides mislead you

- Damage curses are now **Banes** (Bane of Agony, Bane of Doom); one Bane and one Curse can sit
  on the same target. Curse of Shadow is gone; Curse of the Elements covers all magic schools.
- **DoTs can crit**; Pandemic and Malevolence make crit a real Affliction stat. DoT damage is
  recomputed every tick, so buffs apply to running DoTs. The debuff cap is gone.
- **Life Tap** scales with Spirit, not spell power, and no longer counts as spending mana.
- **Soul Shards** can drop from any Drain Soul tick on a real mob and always on a kill; the soul
  bag fits the reagent slot. Meeting Stones no longer summon, so keep spare shards for Ritual of
  Summoning.
- **Firestone and Spellstone** are weapon oils, not off-hands. Healthstones are numbered ranks.
- **Health Funnel** generates reduced threat. **Demonic Sacrifice** lasts two hours with
  swapped buffs. Pets scale with your gear and take half damage from boss AoE. "Move To"
  replaces Stay. Summon Incubus exists.
- **Talents**: 51 points at 60, reworked trees, new 31-point talents (Wrack, Demonic Pact,
  Incinerate), Dual Talent Specialization at 40, respecs also reset Legacy talents.
- **Mounts**: riding skill grants the mount; 40 and 60 remain the riding levels.
- **Legacy** account-wide perk trees; **camping** buffs; new zones (Riverglades, Mount Hyjal,
  Shen'dralas, Zephras Isle) and nine new dungeons; Ruins of Lordaeron is the Undead home dungeon.

## Caveats and the verification plan

- **Vintage.** Method was updated November 8 but says its leveling detail will be extended after
  release; Tavern's class guide is from November 3; the talent data is a third-party dataset
  from client builds between November 3 and 7; WFT's ability book is beta data from November 4.
  Blizzard's November 10 class tuning may move numbers.
- **Known conflicts.** Life Tap's base conversion (60 vs "20 plus Spirit"); Gravestone Scepter
  level (18 vs 22); Ruins of Lordaeron range (15-20 vs 15-22); whether the Felsteed quest teaches
  riding; the Succubus quest's bag reward size; Pandemic's talent tier; Portal of Summoning (one
  source only); Cozy Sleeping Bag details.
- **Commercial bias.** timesaver.gg sells gold and leveling services and copies its build from
  Maxroll; Warcraft Tavern carries a Zygor affiliate link; wowforeverleveling and wowforeverguides
  carry RestedXP affiliate links; Method is ad-supported. The three fan datasets (wowforever.gg,
  wowforevertalent, foreverchanges) show no ads.
- **Verification.** Every item above starts as `verified: false` in the data files. Level Coach's
  breadcrumbs (what the character actually did, where, at what level) flip items to verified and
  correct the ones that are wrong. The coach's job is to keep this document honest, not to defend it.

## Sources

- Method, Warlock Leveling Guide and Talents: https://www.method.gg/wow-forever/wow-forever-warlock-leveling-guide-and-talents
- Method, How to get a mount in WoW Forever: https://www.method.gg/wow-forever/how-to-get-a-mount-in-wow-forever-cost-requirement-and-mount-options
- Warcraft Tavern, Warlock Leveling Guide: https://www.warcrafttavern.com/forever/guides/warlock-leveling/
- Warcraft Tavern, Warlock Class Guide: https://www.warcrafttavern.com/forever/guides/warlock/
- Maxroll build via timesaver.gg talent calculator: https://timesaver.gg/tools/wow-forever/talent-calculator/warlock/affliction
- wowforever.gg Affliction leveling build: https://wowforever.gg/en/builds/warlock-affliction-leveling/
- wowforevertalent, Warlock abilities: https://wowforevertalent.com/abilities/warlock/
- foreverchanges, Warlock changes vs Classic: https://foreverchanges.pro/class/warlock
- Blizzard, What's New and What Feels Familiar: https://news.blizzard.com/en-us/article/24315821/wow-foreverwhats-new-and-what-feels-familiar
- Warcraft Wiki, World of Warcraft: Forever (CC BY-SA): https://warcraft.wiki.gg/wiki/World_of_Warcraft:_Forever
- wowforeverleveling, Horde Leveling Guide and Mounts: https://wowforeverleveling.com/guides/wow-forever-horde-leveling-guide and https://wowforeverleveling.com/guides/wow-forever-mounts-riding
- wowforeverguides, Starting Zones: https://wowforeverguides.com/leveling/starting-zones
- timesaver.gg mount cost article: https://timesaver.gg/blog/wow-forever-mount-cost-gold-to-save
- Icy Veins, nine new dungeons (via search summary): https://www.icy-veins.com/wow-forever/news/all-9-new-wow-forever-dungeons-previewed-how-to-access-level-ranges-locations-and-more/
