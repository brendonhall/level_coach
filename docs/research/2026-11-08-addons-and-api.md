> Research digest, generated 2026-11-08 by a reader agent from six public pages fetched that day (two Kami Labs addon articles, the forevermastery compatibility list, a mein-mmo addon roundup, and the wowforeverguides API cheat sheet and development guide). Paraphrased facts with source tags; third-party claims, not verified in game. Provenance for `docs/guides/addons-for-a-leveling-warlock.md` and the API notes in the design doc.

# WoW: Forever addons and addon API — source digest

Compiled 2026-11-08 from six stripped public pages, read in full and treated as data. Facts are paraphrased; names, versions, dates and function names are kept exact.

Source tags used below:

- **kami-best** — kami-labs.fr, "Best WoW Forever addons: Kami's top picks", published Oct 23, 2026 (based on Kami's Oct 21 video; "directory" checks dated Oct 20; CurseForge figures dated Oct 23).
- **kami-leveling** — kami-labs.fr, "WoW Forever Leveling Addon: RestedXP, Zygor, Questie", published Oct 11, 2026 (body text says its snapshot date is Oct 5, with the beta capped at level 30).
- **forevermastery** — forevermastery.com, "Which addons work on WoW Forever?", checked Oct 31, 2026 against client game version 1.60.1, before launch. 82 addons: 70 "Forever version", 1 "Known issues", 2 "Built into the game", 9 "Not yet"; 7 of the Forever files were alpha/beta test versions.
- **meinmmo** — mein-mmo.de, "WoW Forever Addons: The 10 Most Important Mods and How to Install Them", Karsten Scholz, Oct 26, 2026. Only page 1 of 11 was captured (install instructions plus the table of contents naming the ten addons); the per-addon pages are not in the capture.
- **wfg-api** — wowforeverguides.com, "Addon API Cheat Sheet for Interface 16001", by Harenil, published Sep 27, 2026, updated Oct 21, 2026; "Checked Sep 28, 2026"; beta reports from build 1.60.1.69913; Oct 13 additions from retained build 1.60.1.70338 client files.
- **wfg-dev** — wowforeverguides.com, "Addon Development Guide: Writing Addons With AI", by Harenil, published Sep 27, 2026, updated Oct 13, 2026; same build basis.

Status words in the table ("Forever version", "Known issues", "Built into the game", "Not yet") are forevermastery's own labels as of Oct 31, 2026. "free*" means no page states a price for that addon; forevermastery notes Blizzard's add-on policy requires addons to be free with no premium tier, so CurseForge addons are assumed free. Version strings and dates in the "Forever build" column are the newest Forever file forevermastery listed on Oct 31 unless tagged otherwise. The "Leveling-warlock note" column is my relevance assessment, not a page claim, except where tagged.

---

## 1. Addon table

### Quests and routing

| Addon | What it does | Category | Free / paid | Forever build and what to install | Forever-API limits, conflicts | Status (check date) | Leveling-warlock note | Sources |
|---|---|---|---|---|---|---|---|---|
| Questie | Puts quest pickup, turn-in and objective markers on the world map and minimap; tidies the quest log; gives no order or route | quests | free | Forever support arrived in 12.0.1 (Sep 25, 2026), then 12.0.2 (Sep 28) and 12.0.3 (Sep 30, fixing a Journal error on Forever) [kami-leveling]; newest Forever file v12.3.1+v1.0.9, Oct 26, 2026, CurseForge [forevermastery]; ships a `Questie_Camelot.toc` [forevermastery] | Quest database comes from Classic, so Forever's new quests (four new zones, 1,000+ new quests per wowforever.be) have no markers; QuestieTrace records sessions and sends them to the team [kami-leveling, kami-best]. "Fails to load on Forever" bug #8012 closed Oct 10; on Oct 31, 17 open GitHub issues carried "Forever" in the title, e.g. #8027 unknown quest lines [forevermastery]. Kami thinks the default UI partly replaces it [kami-best] | Known issues (Oct 31, 2026) [forevermastery]; meinmmo lists it first in its top 10 (details not captured) | Free quest finder; expect blank spots in new Forever zones | kami-best, kami-leveling, forevermastery, meinmmo |
| QuestieTrace | Companion that records Forever quests missing from Questie's database and submits them | quests / dev | free* | Paired with Questie in Kami's directory | — | — | Run it if you quest in the new zones | kami-best, kami-leveling |
| RestedXP Guide | Speed-leveling routes that pick the most profitable quests, a blue follow arrow, quest tracking; Kami's comment says it accounts for class, class quests and professions | routing | Addon free; guide $30 per faction or $45 for both; levels 1–20 free [kami-leveling, kami-best]; guides sold separately on RestedXP's own shop [forevermastery] | CurseForge "WoW Forever" file: 4.11.15 (Oct 4) [kami-leveling]; v4.11.29, Oct 29, 2026 [forevermastery]; wfg-api also notes a "WoW Forever" file exists | Forever-specific level 35–60 routes and dungeon routes were due after launch, Classic routes filling in meanwhile; three zone updates Sep 22–25 [kami-leveling]. Running Shortest Path Forever replaces its blue arrow with that addon's own UI [kami-best]. Full version adds dungeons and a French localisation at launch [kami-best] | Forever version (Oct 31) | Fastest route if you pay; 1–20 is a free trial | kami-best, kami-leveling, forevermastery, wfg-api, wfg-dev |
| Guidelime | Step-by-step guide engine: tracks quests, shows an arrow, offers the next step; contains no routes itself, reads community-written guides | routing | free | v6.000 (Sep 24) announced "initial" Forever work; 6.003 on Oct 4 [kami-leveling]; v6.013, Oct 30, 2026 [forevermastery]; the free TUGs guide pack has its own Forever file (Oct 26) [forevermastery] | v6.000 release notes include a fix to skip secret values in UNIT_SPELLCAST_SUCCEEDED on Forever and mention an arrow ETA / TomTom option [wfg-api]; support described as initial [kami-leveling] | Forever version (Oct 31) | The only free full route (with TUGs) | kami-leveling, forevermastery, wfg-api |
| TUGs Leveling Guide (for Guidelime) | Free community route: all starting zones; levels 12–30 written with beta access; 30–60 to be updated after release (Classic 30–60 route included meanwhile); last Forever update Oct 3; author says it stays free | routing | free | CurseForge: Guidelime TUGs; Forever file Oct 26 [forevermastery] | Volunteer author; beta capped at 30, so nothing above was tested [kami-leveling] | Forever version (Oct 31) | Best no-cost "tell me where to go" | kami-leveling, forevermastery |
| Zygor Guides | Guide library: leveling, dungeons, gear, gold, reputations | routing | Elite subscription; Forever guides included at no extra cost for subscribers [kami-leveling]; $15/month or $40/quarter per wowforeverguides.com, which Kami flags as third-party pricing to verify [kami-leveling] | Not on CurseForge; delivered through Zygor's own app. Sep 15 post promised guides at launch, possibly limited [kami-leveling]; on Oct 31 Zygor's site announced them for November, warning of partial 1–60 coverage [forevermastery] | Nothing released during the beta; nothing to test before Nov 4 [kami-leveling] | Not yet (Oct 31) | Only worth it if you already pay for Zygor | kami-leveling, forevermastery |
| WoW-Pro Guides | Guide addon (no description given) | routing | free* | None; newest file 2026.10.16.A (Oct 16) does not list Forever | — | Not yet (Oct 31) | Skip for now | forevermastery |
| Forever Quest Pins | Made for Forever: yellow "!" pins on the world map for quests you could pick up but have not, next to the game's own tracking | quests | free* | v0.3.5, Oct 25, 2026 | — | Forever version (Oct 31) | Cheap way to catch new Forever quests Questie lacks | forevermastery |
| Forever Quest Tint | Named in meinmmo's table of contents as revealing all new Forever quests; details are on an uncaptured page | quests | free* | — | — | — | May be the same niche as Forever Quest Pins; the name comes from an AI translation, so treat it as unverified | meinmmo |
| Dialogue UI | Shows quest text in a dialogue window, with camera control and gamepad support | quests / UI | free* | 1.0.6, Oct 4, 2026 | — | Forever version (Oct 31) | Cosmetic | forevermastery |
| Shortest Path Forever | Computes the route to a quest: suggests the hearthstone when bound nearby, draws flight then walking legs, shows boat routes; directions appear in the objective tracker, world map and minimap; 95,267 downloads on Oct 23 | routing | free* | CurseForge Forever files | Does the same job as Mapzeroth and Travelcraft, so install one of the three [kami-best]; overrides RestedXP's arrow [kami-best] | Directory check Oct 20; CurseForge Oct 23 [kami-best] | Ideal for a player who does not know Azeroth | kami-best |
| Mapzeroth, Travelcraft | Routing alternatives, named only | routing | free* | — | Pick only one routing addon [kami-best] | — | — | kami-best |

### Maps and gathering

| Addon | What it does | Category | Free / paid | Forever build and what to install | Forever-API limits, conflicts | Status (check date) | Leveling-warlock note | Sources |
|---|---|---|---|---|---|---|---|---|
| OpenMap | Shows every zone and its level range without exploring; jump between continents; map matches minimap; city interiors; click a dungeon for its layout and boss positions | map | free* | 0.7 beta in Kami's directory | Conflicts with Leatrix Maps, Mapster and Magnify — install only one [kami-best] | Beta (directory check Oct 20) [kami-best] | Plan zones by level without wandering | kami-best |
| Leatrix Maps | World map enhancements | map | free* | 1.60.25-forever, Oct 21, 2026 | Conflicts with OpenMap [kami-best] | Forever version (Oct 31) | Alternative to OpenMap | forevermastery, kami-best |
| Mapster, Magnify | Map addons, named only as OpenMap conflicts | map | — | — | Conflict with OpenMap | — | — | kami-best |
| TomTom | Waypoints and a follow arrow | map | free* | v4.3.13-release, Oct 24, 2026 | Guidelime v6.000 notes mention a TomTom option [wfg-api] | Forever version (Oct 31) | Arrow for pasted coordinates | forevermastery, wfg-api |
| HandyNotes | Map-note framework | map | free* | v1.6.31-2-g438a547 alpha, Oct 2, 2026 | Alpha only; required by HandyNotes: WoW Forever | Forever version, test file (Oct 31) | Needed for the plugin below | forevermastery |
| HandyNotes: WoW Forever | Plugin made for Forever: treasures and rares on the map | map | free* | v3-forever, Oct 4, 2026 | Depends on HandyNotes, whose Forever file is an alpha | Forever version (Oct 31) | Treasures and rares are leveling gold/XP | forevermastery |
| GatherLite | Herb, ore, chest and fishing spots from a built-in list, with per-zone farming routes | map / professions | free* | 8.2.0, Oct 18, 2026 | — | Forever version (Oct 31) | If you pick herbalism or mining | forevermastery |
| GatherMate2 | Records nodes you have found | map / professions | free* | 1.52.3-11-gda3567d alpha, Oct 22, 2026 | Alpha | Forever version, test file (Oct 31) | Same | forevermastery |
| Atlas | Dungeon and raid map browser; maps ship as separate modules | map | free* | v1.54.04, Oct 20, 2026 | — | Forever version (Oct 31) | Dungeon layouts | forevermastery |
| SexyMap | Minimap appearance options | map / UI | free* | v12.1.4, Oct 22, 2026 | — | Forever version (Oct 31) | Cosmetic | forevermastery |
| RareScanner | Rare detection | map | free* | RareScanner_FOREVER_1.60.1.b15 beta, Oct 23, 2026 | Beta | Forever version, test file (Oct 31) | Rares drop leveling gear | forevermastery |
| SilverDragon | Warns when a rare creature is near | map | free* | v2026.41, Oct 24, 2026 | — | Forever version (Oct 31) | Same | forevermastery |

### Bags

| Addon | What it does | Category | Free / paid | Forever build and what to install | Forever-API limits, conflicts | Status (check date) | Leveling-warlock note | Sources |
|---|---|---|---|---|---|---|---|---|
| Bagnon | One window for inventory, another for the bank | bags | free* | 12.1.7, Oct 15, 2026 | Combined bags are built into Forever | Forever version (Oct 31) | Any bag addon helps with shard clutter; no page names a shard-specific tool | forevermastery |
| Baganator | Bags in categories or one view | bags | free* | 839, Oct 28, 2026 | Combined bags built in | Forever version (Oct 31); in meinmmo's top 10 ("more than just a bag") | Category view could separate shards (not stated by any page) | forevermastery, meinmmo |
| BetterBags | Full bag replacement, presented as AdiBags' successor | bags | free* | v0.8.12, Oct 30, 2026 | — | Forever version (Oct 31) | Same | forevermastery |
| ArkInventory | Bags and bank sorted by user rules | bags | free* | 3.12.17, Oct 16, 2026 (no longer a test version since then) | — | Forever version (Oct 31) | Rule-based sorting | forevermastery |
| AdiBags | Bag addon | bags | — | None; no new file since September 2024 | Combined bags built in | Not yet (Oct 31) | Skip | forevermastery |

### Interface, action bars, unit frames, chat

| Addon | What it does | Category | Free / paid | Forever build and what to install | Forever-API limits, conflicts | Status (check date) | Leveling-warlock note | Sources |
|---|---|---|---|---|---|---|---|---|
| Bartender4 | Place action bars anywhere and add extra ones; `/kb` enters a keybind mode where you hover a button and press a key | UI | free* | 4.18.3.1, Oct 2, 2026 [forevermastery]; Kami's directory says there is no "-forever" file because the Retail package already declares the Forever client interface [kami-best] | Edit Mode now does part of the job, so Kami calls it optional; Bartender bars show green in Edit Mode [kami-best] | Forever version (Oct 31) | Fast keybinds for a spell-heavy class; no page discusses pet bars | kami-best, forevermastery |
| Dominos | Replacement for the main action bar | UI | free* | 11.5.0, Oct 25, 2026 | Edit Mode built in | Forever version (Oct 31) | Alternative to Bartender4 | forevermastery |
| ElvUI | Full interface replacement | UI | free* | 16.00, Oct 13, 2026, downloaded from Tukui, not CurseForge; changelog says it "adds initial support" for Forever | Uses `[AllowLoadGameType camelot]` in a shared .toc to load Forever-only files [forevermastery] | Forever version (Oct 31) | Heavy; optional | forevermastery |
| Leatrix Plus | Automations: accepts and completes quests (except when a reward must be chosen), accepts summons and resurrections, instant PvP spirit release, sells junk, repairs, blocks duels and invites; settings via `/ltp` | UI | free* | 1.60.21-forever dated Oct 19 in Kami's directory [kami-best] vs 1.60.25-forever, Oct 21, 2026 [forevermastery] (different check dates) | — | Forever version (Oct 31); meinmmo top 10 | Saves clicks on every quest turn-in | kami-best, forevermastery, meinmmo |
| MoveAny | Moves any Blizzard interface element | UI | free* | v1.14.0-forever, Oct 30, 2026 | Edit Mode built in | Forever version (Oct 31) | — | forevermastery |
| BlizzMove | Drag Blizzard windows | UI | free* | v3.8.5, Oct 14, 2026 | Edit Mode built in | Forever version (Oct 31) | — | forevermastery |
| Titan Panel | Screen-edge bar with gold, bag space, location and more | UI | free* | 9.3.5, Oct 15, 2026 | — | Forever version (Oct 31); meinmmo top 10 | Handy bag-space and gold readout | forevermastery, meinmmo |
| EllesmereUI | Interface editor with deep customisation | UI | free* | v9.7.2, Oct 31, 2026 | — | Forever version (Oct 31) | — | forevermastery |
| Shadowed Unit Frames | Unit frames | UI | — | None; v4.3.9-classic (Jan 18, 2026) does not list Forever | — | Not yet (Oct 31) | — | forevermastery |
| MinimapButtonButton | Gathers addon minimap buttons into one | UI | free* | 1.24.14, Oct 26, 2026 | — | Forever version (Oct 31); meinmmo top 10 | Tidy minimap | forevermastery, meinmmo |
| Plumber | Opt-in interface helpers such as a loot window; some listed features (e.g. Dragonriding races) belong to current retail | UI | free* | 1.9.7, Oct 25, 2026 | Retail-only features irrelevant on Forever | Forever version (Oct 31) | — | forevermastery |
| BetterBlizzFrames | Keeps Blizzard unit frames and adds settings | UI | free* | v2.1.9c beta, Oct 23, 2026; release v2.1.8 (Oct 16) also lists Forever | Newest file is a beta | Forever version, test file (Oct 31) | — | forevermastery |
| Enhance QoL | Small opt-in options such as a drink macro; some features (Mythic Keystone helper) are retail-only | UI | free* | 13.16.1-forever, Oct 28, 2026 | — | Forever version (Oct 31) | — | forevermastery |
| Better Forever Chat (by aehya) | Shows race, class and level before each chat message; lets you enlarge text | UI (chat) | free* | 0.13.11, labelled "Development alpha" | Author warns settings and history may not reload; export your profile. Do not confuse with the separate "Forever Chat" | Alpha (Oct 23) [kami-best] | Spot whether a group inviter fits your group | kami-best |
| Prat 3.0 | Chat filters and interface changes | UI (chat) | free* | 3.9.113, Oct 14, 2026 | — | Forever version (Oct 31) | — | forevermastery |
| WIM (WoW Instant Messenger) | Whispers in separate windows | UI (chat) | free* | 3.19.0-beta-2, Oct 28, 2026; release 3.18.2 (Oct 12) also lists Forever | Newest file is a beta | Forever version, test file (Oct 31) | — | forevermastery |
| HealBot Continued | One-click healing frames | UI (healing) | free* | 26.10.30, Oct 30, 2026 | Click casting and dispellable-debuff display are built in | Forever version (Oct 31) | Not for a warlock | forevermastery |
| VuhDo | Healer raid frames | UI (healing) | free* | v3.219, Oct 24, 2026 (no longer a test version since then) | Built-in click casting | Forever version (Oct 31) | No | forevermastery |
| Grid2 | Compact party/raid frames | UI (healing) | free* | 4.1.9-forever, Oct 21, 2026 | Built-in click casting | Forever version (Oct 31) | No | forevermastery |
| Clique | Click-casting on unit frames without a big healing suite | UI (healing) | free* | Kami: only alpha test versions on CurseForge, including v5.1.3 from Oct 1 [kami-best]; forevermastery: v5.1.0-beta, Oct 25, 2026, a beta after four alphas | Kami calls it "in beta" and not quite up to date; wfg-dev reports secure snippets failed to compile on build 69913, which breaks click-casting that depends on them; click casting is built into Forever [forevermastery] | Forever version, test file (Oct 31) | Not needed | kami-best, forevermastery, wfg-dev |
| Decursive | Shows dispellable debuffs on your group and dispels in one click | UI (healing) | free* | 2.9.0-RC3-forever, Oct 4, 2026 | Built-in dispellable-debuff display | Forever version (Oct 31) | Warlock has nothing to dispel; skip | forevermastery |

### Combat: bosses, threat, nameplates

| Addon | What it does | Category | Free / paid | Forever build and what to install | Forever-API limits, conflicts | Status (check date) | Leveling-warlock note | Sources |
|---|---|---|---|---|---|---|---|---|
| Deadly Boss Mods (DBM) | Boss timers and warnings | combat | free* | 12.1.18, Oct 26, 2026; Classic dungeon/raid modules come in the separate "DBM - SoD and Vanilla" pack (r834, Oct 26), which also lists Forever | wfg-api/wfg-dev say the combat log is reported unavailable to addons (unverified), a general constraint on combat-log boss mods; the pages do not say DBM is affected | Forever version (Oct 31) | Useful once you run leveling dungeons | forevermastery |
| BigWigs | Boss timers and warnings | combat | free* | v427.8, Oct 23, 2026 | — | Forever version (Oct 31) | Same | forevermastery |
| GTFO | Sound when you stand in something harmful | combat | free* | 6.12.2, Oct 16, 2026 | — | Forever version (Oct 31) | Good for a cloth caster in dungeons | forevermastery |
| Method Raid Tools | Raid cooldowns, notes, fight logs, ready checks | combat | free* | v.5335, Oct 13, 2026 | — | Forever version (Oct 31) | Endgame only | forevermastery |
| Northern Sky Raid Tools | Boss reminders, gear and cooldown checks, group setup | combat | free* | 12.1.32, Oct 19, 2026 | — | Forever version (Oct 31) | Endgame only | forevermastery |
| Nova Instance Tracker | Instance lockouts and run stats, trade logs, alts' rested XP | combat / tools | free* | v2.31, Oct 19, 2026 | — | Forever version (Oct 31) | Rested-XP tracking across alts | forevermastery |
| Details! Damage Meter | Damage meter; meinmmo's headline stresses its aggro display | combat | free* | Details.20261015.15339.172, Oct 16, 2026 | Forever has a damage meter built in, so Details! is optional [forevermastery] | Forever version (Oct 31); meinmmo top 10 | Threat/aggro view per meinmmo | forevermastery, meinmmo |
| Skada | Damage meter | combat | — | None; flavors are Retail, MoP Classic and Classic | Damage meter built in | Built into the game (Oct 31) | Skip | forevermastery |
| Recount | Damage meter | combat | — | None; last update July 10, 2025 | Damage meter built in | Built into the game (Oct 31) | Skip | forevermastery |
| ThreatClassic2 | Your group's threat on your current target, as bars | combat (threat) | free* | 2.75-forever, Oct 10, 2026 | — | Forever version (Oct 31) | Know when your DoTs are about to out-threat the tank or pet | forevermastery |
| ThreatMeter | Your highest threat percentage on the mobs around you; made for Forever and Hardcore | combat (threat) | free* | v0.7.4-forever, Oct 14, 2026 | — | Forever version (Oct 31) | Compact threat for solo multi-DoT play | forevermastery |
| Threat Plates | Nameplates colored by threat. Tank view: green = you have aggro, orange/yellow = losing it, red = lost it. DPS view flips: red = you pulled aggro, orange = ease off. Also shows debuffs and player class on plates | combat (nameplates) | free* | Kami: the CurseForge version did not appear in the in-game addon list during filming (~Oct 21), so he published a temporary modified build in his directory pending the official update; 39,509,610 downloads on Oct 23 [kami-best]. forevermastery: ThreatPlates-13.3.4, Oct 28, 2026, Forever version | Kami notes Blizzard intends threat to be harder to hold in Forever [kami-best] | Forever version (Oct 31) [forevermastery] | See at a glance which DoT'd mob is coming for you instead of your pet | kami-best, forevermastery |
| Plater Nameplates | Highly customisable nameplates with scripts and animations | combat (nameplates) | free* | Plater-v662, Oct 28, 2026 | — | Forever version (Oct 31) | Debuffs on plates; heavier setup | forevermastery |
| Platynator | Simple, flexible nameplates | combat (nameplates) | free* | 528, Oct 30, 2026 | — | Forever version (Oct 31) | — | forevermastery |
| MiniAuras (formerly MiniCC) | Alert icons with optional sound for enemy crowd control and defensives, also on party frames and nameplates | auras | free* | 5.44.0, Oct 21, 2026 | — | Forever version (Oct 31) | PvP-leaning | forevermastery |

### Auras and cooldowns

| Addon | What it does | Category | Free / paid | Forever build and what to install | Forever-API limits, conflicts | Status (check date) | Leveling-warlock note | Sources |
|---|---|---|---|---|---|---|---|---|
| WeakAuras | Custom aura/cooldown displays | auras | — | None: newest 5.22.1 (Oct 10) lists only the Classic clients. Forks ForeverAuras and Musca Auras exist; the built-in Cooldown Manager (Options > Gameplay Enhancement) covers part of the need [forevermastery] | Wowhead (quoted by wfg-api) says the Midnight API changes caused WeakAuras to stop development before Midnight | Not yet (Oct 31) | The main DoT-tracker gap for warlocks | forevermastery, wfg-api |
| ForeverAuras | WeakAuras fork for Forever, created Sep 22, 2026 by an author outside the WeakAuras team | auras | free* | 1.1.0, Oct 28, 2026 | Aura data in combat is subject to secret-value rules (wfg-api's general guidance: let Blizzard's aura frames draw auras; UNIT_AURA is not permission to read aura data in combat) | Forever version (Oct 31) | Prime candidate for DoT timers | forevermastery, wfg-api |
| Musca Auras | WeakAuras fork by another author | auras | free* | Listed on CurseForge; no version given | Same caveat | — | Alternative candidate | forevermastery |
| TellMeWhen | Icons for cooldowns, buffs and debuffs | auras | free* | 12.1.5, Oct 12, 2026 | Cooldown Manager built in | Forever version (Oct 31) | Classic choice for debuff/DoT icons | forevermastery |
| OmniCC | Cooldown counts on buttons | auras | — | None; newest 11.2.8 (Dec 14, 2025) does not list Forever | — | Not yet (Oct 31) | — | forevermastery |

### Professions, gear and loot

| Addon | What it does | Category | Free / paid | Forever build and what to install | Forever-API limits, conflicts | Status (check date) | Leveling-warlock note | Sources |
|---|---|---|---|---|---|---|---|---|
| SkillUp Forever (by cjber) | In the profession window: each recipe's chance to raise skill (screenshot shows 83%, 100%, 67%), component cost, most profitable crafts; also leveling routes, shopping lists and a crafted-gear tab | professions | free* | v0.18.10-forever, Oct 21 (Kami's directory) | — | Directory Oct 21 [kami-best] | Useful for tailoring/enchanting while leveling | kami-best |
| What's Training? | Lists in the spellbook the spells your trainer can teach; Forever beta files also add a recipe list to the profession window | professions / UI | free* | 11.0.0-beta25, Oct 23, 2026 | Beta only | Forever version, test file (Oct 31); meinmmo top 10 | Decide whether a trainer trip is worth it | forevermastery, meinmmo |
| GnomeLevelUp (by Captain_British) | Level-up screen with stat gains and icons of spells to learn at the trainer | UI | free* | v1.4.0, Release Candidate | Kami's video did not name its trainer addon; the directory lists GnomeLevelUp without confirming it is the one demoed [kami-best] | RC [kami-best] | Same purpose; Kami says trainer round-trips cost 20–30 minutes | kami-best |
| DungeonJournal (`/dj`) | Bosses, their loot, the dungeon map, plus the dungeon's quests: rewards, quest-giver positions on your map, chain order; dungeons only, no raids yet | combat / quests | free* | 1,467,837 downloads, Forever-flavor page, Oct 23 [kami-best]; 1.6.5, Oct 19, 2026 [forevermastery] | Loot tables for 30+ dungeons and raids still incomplete [kami-best] | Forever version (Oct 31); meinmmo calls it essential for the new leveling meta | Dungeon quests are a large leveling XP source | kami-best, forevermastery, meinmmo |
| AtlasLoot Classic Forever | Dungeon and raid loot tables | loot | free* | 1.2.7, Oct 21, 2026; "AtlasLootClassic Continued" also lists Forever (Oct 29) [forevermastery]; more than 11 AtlasLoot projects coexist and the historic page has no Forever version [kami-best] | Kami finds DungeonJournal more intuitive | Forever version (Oct 31); meinmmo top 10 (as "AtlasLoot") | Know which dungeon drops to chase | kami-best, forevermastery, meinmmo |
| FojjiCore | Loot-table data; with AtlasLoot it feeds Kami's BiS list | loot | free* | — | — | — | — | kami-best |
| Pawn | Compares items, finds upgrades | gear | free* | 2.14.0 (Forever), Oct 22, 2026 | — | Forever version (Oct 31) | Upgrade arrows on quest rewards | forevermastery |
| GearQuest Forever | Made for Forever: right-click a gear slot to see class/level upgrades from 1 to 60 and their sources; track one like a quest | gear | free* | v1.0.6, Oct 28, 2026 | — | Forever version (Oct 31) | Plan warlock gear while leveling | forevermastery |
| ItemRack (TBC Classic & Forever) | Gear sets swapped by button or event | gear | free* | v6.0.4, Oct 5, 2026 | Equipment manager built in | Forever version (Oct 31) | — | forevermastery |
| Simulationcraft | `/simc` profile export | dev / gear | free* | 12.1.5-03, Oct 22, 2026 | — | Forever version (Oct 31) | Endgame | forevermastery |
| Gargul | Loot tool for leaders: rolls, soft reserves, priority lists, auto loot | loot | free* | v8.0.1-forever, Oct 3, 2026 | — | Forever version (Oct 31) | Endgame | forevermastery |
| Attune | Tracks dungeon/raid attunement chains | quests | free* | Attune-Forever-v16001-34, Oct 20, 2026 | — | Forever version (Oct 31) | Later | forevermastery |

### Auction house

| Addon | What it does | Category | Free / paid | Forever build and what to install | Forever-API limits, conflicts | Status (check date) | Leveling-warlock note | Sources |
|---|---|---|---|---|---|---|---|---|
| Auctionator | Search, price history, quick selling | auction | free* | 341, Oct 13, 2026 | — | Forever version (Oct 31) | Sell cloth and greens for bag money | forevermastery |
| TradeSkillMaster | Auction suite | auction | — | None; v4.14.78 (Oct 14) covers retail and Classic only | — | Not yet (Oct 31) | — | forevermastery |

### Tools, dev, PvP, misc

| Addon | What it does | Category | Free / paid | Forever build and what to install | Forever-API limits, conflicts | Status (check date) | Leveling-warlock note | Sources |
|---|---|---|---|---|---|---|---|---|
| BugSack (+ BugGrabber) | Collects Lua errors, which Forever hides by default; needs BugGrabber, which also lists Forever | dev | free* | v12.1.9, Oct 26, 2026 | — | Forever version (Oct 31) | Essential if you build an addon | forevermastery |
| Scrap | Sells junk at merchants | UI | free* | 12.1.8, Oct 15, 2026 | Merchants have a built-in sell-all-grays button | Forever version (Oct 31) | Redundant | forevermastery |
| Altoholic | All characters' gold, bags, professions in one window | tools | free* | v1.60.005, Oct 14, 2026 | — | Forever version (Oct 31) | Alts | forevermastery |
| Nova World Buffs | World-buff timers | tools | — | None; 3.42 (Oct 19) does not list Forever | — | Not yet (Oct 31) | — | forevermastery |
| ALL THE THINGS | Missing collectibles, quests, achievements | tools | free* | 5.4.5, Oct 25, 2026 | — | Forever version (Oct 31) | Completionists | forevermastery |
| Better Fishing | One-key or double-click fishing | tools | free* | 66, Oct 21, 2026 | — | Forever version (Oct 31) | — | forevermastery |
| Speedy AutoLoot | Faster auto loot | tools | free* | 124, Oct 14, 2026 | — | Forever version (Oct 31) | Minor QoL | forevermastery |
| Total RP 3 | Role-play profiles | tools | free* | 3.5.3, Oct 25, 2026 | — | Forever version (Oct 31) | — | forevermastery |
| Spy / Spy Classic | Enemy-player detection | PvP | — | Neither Spy (v3.12.1, June 20) nor Spy Classic (v1.3.8, Aug 14) lists Forever | — | Not yet (Oct 31) | — | forevermastery |
| Capping Battleground Timers | Battleground timers and PvP features | PvP | free* | v12.1.7, Oct 22, 2026 | — | Forever version (Oct 31) | — | forevermastery |
| Forever Beacon | wowforeverguides' inspectable sample addon (.toc, .lua, .zip downloads), described as an unverified reference | dev | free | From wowforeverguides.com, page 7 of its addon guide | Unverified on live builds | — | Starting point for your own addon | wfg-dev, wfg-api |

---

## 2. Picks for a warlock or any caster

- **DoT / debuff timers.** No page recommends a warlock-specific DoT tracker. The named options: TellMeWhen (icons for cooldowns, buffs, debuffs; 12.1.5, Oct 12, Forever version) [forevermastery]; ForeverAuras (WeakAuras fork, 1.1.0, Oct 28) and Musca Auras [forevermastery]; Plater and Threat Plates both show debuffs on nameplates [forevermastery, kami-best]. WeakAuras itself has no Forever file (5.22.1 is Classic-only) [forevermastery]. API caveat for anything aura-based: wfg-api advises letting Blizzard's aura frames draw auras and says UNIT_AURA does not grant permission to read aura data in combat; Midnight's secret-value rules are active on Forever, so timers that compute from unit data may hit secrets [wfg-api, wfg-dev].
- **Cooldowns.** Forever's built-in Cooldown Manager is off by default (Options > Gameplay Enhancement); since the Oct 8 beta build it covers every class, racials and trinkets, with consumables promised later [forevermastery]. OmniCC has no Forever file [forevermastery].
- **Soul shard managers.** None of the six pages names one. The closest are the bag addons with categories or rules (Baganator, BetterBags, ArkInventory, Bagnon) and the fact that combined bags are built in [forevermastery].
- **Pet bars.** No page mentions pet bars or pet-frame addons. Action-bar addons named: Bartender4 (with `/kb` quick binding) [kami-best, forevermastery], Dominos [forevermastery]; Edit Mode is built in [forevermastery].
- **Threat.** The richest category for a DoT class: Threat Plates (DPS colors: red = you pulled aggro, orange = ease off; Kami's temporary modified build existed while the CurseForge file did not load; 13.3.4 on Oct 28) [kami-best, forevermastery]; ThreatClassic2 (2.75-forever, Oct 10) and ThreatMeter (v0.7.4-forever, Oct 14, made for Forever and Hardcore) [forevermastery]; Details! has an aggro display per meinmmo's headline [meinmmo]. Kami says Blizzard wants threat harder to manage in Forever [kami-best].
- **Damage meter.** Built in; Details! is optional [forevermastery, wfg-dev]. wfg-dev's system prompt tells AI models not to build a damage or healing meter because the combat log is reported unavailable [wfg-dev].
- **Caster dungeon survival.** GTFO (sound when standing in harm, 6.12.2) [forevermastery]; DBM/BigWigs have Forever files [forevermastery].
- **Trainer planning.** What's Training? (11.0.0-beta25) [forevermastery, meinmmo] or GnomeLevelUp (v1.4.0 RC) [kami-best]; Kami's point is that a trainer trip costs 20–30 minutes on Forever as in Classic, so knowing which spells await lets you skip low-value trips [kami-best].
- **Gear.** GearQuest Forever (class/level upgrades 1–60 with sources) and Pawn [forevermastery]; DungeonJournal and AtlasLoot Classic Forever for dungeon drops [kami-best, forevermastery].
- **Professions.** SkillUp Forever (skill-up odds and costs) [kami-best]; What's Training? adds a recipe list [forevermastery].
- **Chat/grouping.** Better Forever Chat shows race/class/level per message (development alpha 0.13.11) [kami-best].
- **Undead-specific.** Nothing in these pages is race-specific.
- **Other built-ins that replace addons** (forevermastery, citing Blizzard/Icy Veins Sep 17, Method.gg Sep 30, beta observation Oct 2026): damage meter, Cooldown Manager, click casting with dispellable debuffs on raid frames, Edit Mode, equipment manager, merchant sell-all-grays and repair-all buttons, combined bags, Ping, focus and mouseover keybinds, nameplate options, and a swing timer (see the disagreement in section 5).

---

## 3. Install mechanics

- **Where the AddOns folder lives (every variant given):**
  - Battle.net launcher → cog → "open installation folder" / "Show in explorer" → open the folder for the game version you play; during the beta this was the Classic beta folder → `Interface` → `AddOns` [kami-best].
  - `World of Warcraft\_classic_beta_\Interface\AddOns\` for the beta; the addon folder name must match its .toc file name [wfg-dev].
  - `/_forever_/Interface/AddOns` [meinmmo].
  - The `Interface\AddOns` folder of "your Forever install" [forevermastery].
  - No page gives a confirmed post-launch folder name beyond meinmmo's `_forever_`.
- **Manual install steps:** download the Forever-flavor zip from CurseForge, drop it in AddOns, "extract here", delete the zip [kami-best]; archives may be ZIP or RAR, open with a tool like WinRAR, extract the folders into AddOns [meinmmo]; download from CurseForge or WoW Interface [meinmmo].
- **CurseForge flavor selection:** on CurseForge, click "Forever" to see compatible versions; Kami's directory links open on the Forever files tab; check that a Forever version really exists [kami-best]. CurseForge has a "WoW Forever" game version; on an addon's Files page, filter by it and check the file date; alpha test versions stay hidden until you choose to show them [forevermastery]. In the CurseForge app (optionally bundled with Overwolf; skip Overwolf if you only want addons), select World of Warcraft, pick "Forever" from the version dropdown, then install/update/remove addons [meinmmo]. ElvUI comes from Tukui, not CurseForge [forevermastery]. Zygor uses its own app [forevermastery]. Kami's modified Threat Plates came from his own directory [kami-best].
- **Addons without a "-forever" file:** Bartender4 has none because its Retail package already declares the Forever interface [kami-best]. An addon whose .toc lacks the Forever interface number or a Forever .toc shows as out of date; changing the number yourself does not make the code work; wait for the author [forevermastery].
- **"Load out of date AddOns" checkbox:** none of the six pages mentions this checkbox by name.
- **In-game AddOns menu:** game menu → AddOns to enable/disable installed addons; also reachable from the character-selection screen before login; type `/reload` after changing selections [meinmmo].
- **Reload vs restart (sources differ):** Kami says `/reload` or waiting for a loading screen makes a newly extracted addon appear [kami-best]; forevermastery says restart the game fully after adding a new addon because `/reload` does not pick up new files; wfg-dev tells users to restart the client if a new addon folder does not appear. Also: the "Interface action failed because of an AddOn" counter in the AddOns panel is reported to clear only on a full restart, not `/reload` (unverified) [wfg-api].
- **Errors:** Forever hides Lua errors by default; BugSack + BugGrabber collect them [forevermastery].
- **After patches:** a game update can raise the interface number, so update addons after each patch [forevermastery].

---

## 4. Addon API facts for developers

### Interface number, game version, TOC conventions
- Interface number **16001** for Forever's beta/test clients and game version 1.60.1 [forevermastery, wfg-api, wfg-dev]. wfg tags this "Reported" (Warcraft Wiki TOC table, "Forever Beta" row) and says to confirm in-game with `/dump select(4, GetBuildInfo())` and to retest when the number moves at launch [wfg-dev, wfg-api]. Comparison values: Classic Era 11509, Midnight 120100; models often write a retail number such as 110207 by mistake [wfg-dev].
- Game version string 1.60.1 [forevermastery]. Beta builds named: 1.60.1.69913 (original tests), 1.60.1.70009 (Sep 23), 1.60.1.70338 (retained client files; live probe Oct 12) [wfg-api, wfg-dev]. Attune's Forever file is named `Attune-Forever-v16001-34` [forevermastery].
- API family: Mainline UI architecture with "the vast majority of APIs available in 12.1.5", per Blizzard on the WoW UI Discord as quoted by Wowhead (Reported) [wfg-api, wfg-dev]; "we did opt for the modern API approach", Sep 17 Developer Q&A at 01:20:52 (Confirmed) [wfg-dev].
- Flavor suffixes: `AddOnName_Forever.toc` or `AddOnName_Camelot.toc` are read as Forever-only .toc files; Questie ships `Questie_Camelot.toc` [forevermastery]. `[AllowLoadGameType camelot]` inside a shared .toc loads that file only on Forever; ElvUI does this [forevermastery]. wfg-dev lists three ways to ship one package: a comma-separated `## Interface:` line, a `_Camelot.toc` (the wiki's Forever suffix), or a `_Mainline.toc` shared by Midnight and Forever. Camelot is Forever's internal game-type name and Blizzard said it would be renamed before launch; the wiki warns the value "may be changed to Forever" [forevermastery, wfg-dev]. Note the `_Forever` suffix is only mentioned by forevermastery.
- Game-type detection via TOC: declare `## X-Family:` and `## X-Game:` and read them with `C_AddOns.GetAddOnMetadata`; family Mainline + game Camelot = Forever in the wiki's example [wfg-api].
- Example Forever-only TOC fields: `## Interface: 16001`, `## Title`, `## Notes`, `## Author`, `## Version`, `## SavedVariables: MyAddonDB`, `## SavedVariablesPerCharacter: MyAddonCharDB`, `## IconTexture: Interface\Icons\INV_Misc_Note_01`, `## Category: Miscellaneous`, `## AddonCompartmentFunc: MyAddon_OnCompartmentClick` [wfg-api]. Compartment callbacks and SavedVariables names must be real globals; everything else should be file-local [wfg-api].

### Removed legacy globals and replacements (missing on build 69913 unless noted)
| Area | Gone | Use instead | Notes | Source |
|---|---|---|---|---|
| Spells | `GetSpellInfo(id)` | `C_Spell.GetSpellInfo(id)` | Returns one table (name, iconID, castTime, …); nil if not found or not yet loaded | wfg-api, wfg-dev |
| Spells | `GetSpellBookItemName` | `C_SpellBook.GetSpellBookItemName` | | wfg-api, wfg-dev |
| Items | `GetItemInfo(id)` | `C_Item.GetItemInfo(id)` | Returns the same multiple values as the old global; nil until cached | wfg-api, wfg-dev |
| Talents | `GetTalentInfo`, `GetNumTalentTabs` | `C_Traits` | Talents run on the trait system (WoW Forever Builds) | wfg-api, wfg-dev |
| Skills / professions | `GetNumSkillLines` | No replacement named | | wfg-dev |
| Addon metadata | `GetAddOnMetadata(name, field)` | `C_AddOns.GetAddOnMetadata` | Same move as Mainline | wfg-api |
| Combat log | `CombatLogGetCurrentEventInfo()` | No verified replacement | Reported unavailable (Unverified) | wfg-api, wfg-dev |
| Map pins | `C_SuperTrack.SetSuperTrackedUserWaypoint` (protected, fails silently) | `C_Map.SetUserWaypoint` with a `UiMapPoint` | | wfg-api, wfg-dev |
| Options | `InterfaceOptions_AddCategory` | Settings API | Old panel replaced | wfg-api |
| Sound | `PlaySoundFile` on `Sound\Interface\*.ogg` | `PlaySound(SOUNDKIT.X)` | `PlaySound` is aliased to `C_Sound.PlaySound`; second arg is a `UISoundSubType` | wfg-api |
| Region | — | `GetCurrentRegion()` returned an ID AceDB-3.0 did not recognise (nil regionKey); patch AceDB to tolerate unknown IDs | | wfg-api |

- Async loading: if `C_Spell.GetSpellInfo` / `C_Item.GetItemInfo` return nil, call `C_Spell.RequestLoadSpellData(spellID)` / `C_Item.RequestLoadItemDataByID(itemID)` and listen for `SPELL_DATA_LOAD_RESULT (spellID, success)` / `ITEM_DATA_LOAD_RESULT (itemID, success)`; success false means not found [wfg-api, wfg-dev].
- Not covered by any page: quest APIs, player-position / map-position functions, container or bag functions, aura-reading functions by name.

### Units, auras, secret values
- Midnight's "addon disarmament" with secret values is active on Forever (Reported via Wowhead; Blizzard said it) [wfg-dev, wfg-api]; forevermastery cites Icy Veins (Sep 17) for the same combat restrictions.
- Observed/reported secrets: `UnitHealth` / `UnitHealthMax` can be secret numbers (type() says "number", arithmetic throws) — pass them straight to `StatusBar:SetMinMaxValues` and `StatusBar:SetValue`; `UnitName` and creature names can be secret strings — show only after `issecretvalue` is false; `UnitCanAttack` / `UnitExists` can be secret booleans — do not branch until the guard says plain [wfg-api, wfg-dev]. `UnitIsEnemy` means attackable now, not opposite faction; for faction use `UnitFactionGroup` and compare theirs ~= yours after guarding [wfg-api].
- Guard helper: a function returning `type(issecretvalue) == "function" and issecretvalue(value)` [wfg-api, wfg-dev].
- Tainted code **can**: store a secret in a variable, upvalue or table value; pass it to Lua functions (C functions only when Blizzard marks them to accept it); concatenate secret strings/numbers; pass them to `string.format`, `string.concat`, `string.join`; test truthiness of a secret string or number; call `type()` on it. Tainted code **cannot**: do arithmetic, compare, use `#`, use it as a table key, index into it, call it, or truth-test a secret boolean. Each forbidden op throws immediately [wfg-api].
- Auras: let Blizzard's aura frames draw them; `UNIT_AURA` is not a licence to read aura data in combat [wfg-api].
- Combat lockdown: check `InCombatLockdown()` before showing, hiding or moving a protected frame; queue the closure and run it on `PLAYER_REGEN_ENABLED` [wfg-dev]. Do not move protected frames during lockdown [wfg-api].

### Events (use these instead of the combat log)
- Registering `COMBAT_LOG_EVENT_UNFILTERED` throws on Midnight (Warcraft Wiki, Patch 12.0.0 API changes); the combat log reader is reported unavailable on Forever (Unverified, Warcraft Forever) [wfg-api, wfg-dev].
- Replacements: `RegisterUnitEvent("UNIT_HEALTH", "player")`; `UNIT_POWER_UPDATE`; `UNIT_SPELLCAST_START`, `_STOP`, `_SUCCEEDED`, `_FAILED`, `_INTERRUPTED`; `PLAYER_REGEN_DISABLED` / `PLAYER_REGEN_ENABLED`; `ENCOUNTER_START` / `ENCOUNTER_END` (if the encounter fires them); `ZONE_CHANGED_NEW_AREA`, `PLAYER_ENTERING_WORLD` [wfg-api]. Guidelime v6.000 added a fix to skip secret values arriving via `UNIT_SPELLCAST_SUCCEEDED` on Forever [wfg-api].
- Lifecycle: `ADDON_LOADED` (per addon, after its SavedVariables load), `PLAYER_LOGIN` (after all non-load-on-demand addons), `PLAYER_LOGOUT` (last event before the save) [wfg-api, wfg-dev].
- Game rules: `GAME_RULES_CHANGED` and `ACTIVE_GAME_MODE_UPDATED` are documented, but their presence does not prove every preset change fires them [wfg-api].
- Nameplates: `NAME_PLATE_UNIT_ADDED` reportedly fires before the unit is populated, with no `namePlateUnitToken` on the plate frame (Unverified); workaround is to recheck shortly after or sweep `nameplate1`–`nameplate40` [wfg-api].
- Pattern: one frame, one `OnEvent` script, a handler table keyed by event name; no if/elseif chains; no `OnUpdate` polling when an event exists [wfg-dev].

### SavedVariables
- Load order: the client runs the addon's files, then loads SavedVariables and SavedVariablesPerCharacter, then fires `ADDON_LOADED` for that addon, one addon at a time; create/read saved tables inside `ADDON_LOADED`, never at file scope; use `PLAYER_LOGOUT` for a last write before save [wfg-api, wfg-dev].
- Beta restore bug: a Sep 21 Blizzard Forums report (the Soundtrack port) showed settings written correctly to the WTF folder but missing on the next launch; other authors confirmed; a Sep 25 reply said SavedVariables loaded again on build 1.60.1.70009. Unverified; retest [wfg-api, wfg-dev].
- Porting trap from the same report: split one `IsRetail` flag in two, because "use the modern API" and "enable Retail-only content" are different questions on Forever [wfg-api].

### Protected calls, secure templates, taint
- Protected calls fail silently: no Lua error, `pcall` does not help; the client posts "Interface action failed because of an AddOn" and increments a counter in the AddOns panel that clears only on full restart (Unverified community report, no build named) [wfg-api, wfg-dev]. Avoid: `ChatFrame_OpenChat` / `ChatEdit_ActivateChat` (use `HandleModifiedItemClick` for shift-click links), `C_SuperTrack.SetSuperTrackedUserWaypoint` (use `C_Map.SetUserWaypoint`), secure attributes on Blizzard unit frames (use your own buttons), `PlaySoundFile` on interface .ogg paths (use `PlaySound` with a SOUNDKIT ID) [wfg-api].
- Secure snippets broken on 69913: Blizzard's `RestrictedExecution.lua` calls `loadstring_untainted`, which the build did not provide; `/run print(type(loadstring_untainted))` printed nil and every secure snippet failed with a call-to-nil error. Affects action-bar paging, secure group headers and click-casting. WoW Forever Builds reads it as a bug, not policy; retest each build; do not ship healer frames that depend on snippets [wfg-api, wfg-dev].
- Frames: `CreateFrame("Frame", nil, UIParent, "BackdropTemplate")` for backdrops; named frames become globals, so name them after your addon or pass nil [wfg-api, wfg-dev]. `C_Timer.NewTimer` (cancellable) vs `C_Timer.After` (returns nothing); `SLASH_MYADDON1` / `SlashCmdList["MYADDON"]`; `DEFAULT_CHAT_FRAME:AddMessage(text, r, g, b)` [wfg-api]. `SetTexCoord` takes left, right, top, bottom as 0–1 fractions, not left, top, right, bottom [wfg-api].
- Settings API replaces the old Interface Options panel; prefer it for checkboxes/sliders; custom windows should inherit BackdropTemplate and save their anchor on drag stop [wfg-api].
- Addon Compartment: static button via the `## AddonCompartmentFunc` TOC field; dynamic icon/label via `AddonCompartmentFrame:RegisterAddon({ text, icon, notCheckable, func })` — Mainline documentation, not Forever-tested [wfg-api].

### Detecting Forever and reading the ruleset
- `WOW_PROJECT_ID`: reported as 1 (same as `WOW_PROJECT_MAINLINE`) on build 69913; the Oct 12 live probe on build 70338 records 18, with `WOW_PROJECT_CAMELOT = 18`, `WOW_PROJECT_MAINLINE = 1`, `WOW_PROJECT_CLASSIC = 2` in Blizzard's ProjectConstants.lua. Never branch to Classic code from the project ID alone; `if WOW_PROJECT_ID == WOW_PROJECT_CLASSIC` will not detect Forever [wfg-api, wfg-dev]. Suggested check: `WOW_PROJECT_CAMELOT ~= nil and WOW_PROJECT_ID == WOW_PROJECT_CAMELOT`, plus a capability probe such as `type(C_GameRules.GetForeverExperiencePreset) == "function"` [wfg-api]. The older wiki example (WOW_PROJECT_MAINLINE with `LE_EXPANSION_LEVEL_CURRENT == LE_EXPANSION_CLASSIC`) is false on 70338 [wfg-api].
- `C_GameRules` (from 70338 generated docs): `GetCurrentGameModeRecordID()` (numeric record ID; no Forever mapping asserted), `GetActiveGameMode()` (GameMode enum), `IsHardcoreActive()`, `IsGameRuleActive(gameRule)`, `GetForeverExperiencePreset()` → `Enum.ForeverExperiencePreset` (Classic = 0, Modern = 1) or nil; `C_ChatInfo.GetChannelRuleset(channelIndex)` is the chat ruleset, not the game ruleset. Diagnostic: `/dump C_GameRules.GetCurrentGameModeRecordID()` [wfg-api].
- Sound kit IDs from 70338 `SoundKitConstants.lua`: `IG_MAINMENU_OPTION_CHECKBOX_ON` 856, `IG_MAINMENU_OPTION_CHECKBOX_OFF` 857, `IG_MAINMENU_OPEN` 850, `IG_MAINMENU_CLOSE` 851, `IG_CHARACTER_INFO_TAB` 841, `RAID_WARNING` 8959; prefer the named constants; do not raise a player's audio automatically [wfg-api].

### Lua runtime
- Modified Lua 5.1: no `goto`, no `//`, no bitwise operators, no `_ENV`; use the `bit` library (`bit.band`, `bit.bor`, `bit.lshift`); no `os`, `io`, `require`, `dofile`, `loadfile`; the .toc is the module loader; every file starts `local addonName, ns = ...` with shared state on `ns` [wfg-dev].

### Blizzard policy and built-ins
- Addons must be free, with no premium version and no hidden code (Blizzard UI Add-On Development Policy); developers said they will restrict addons that automate communication or marking (Massively OP, Sep 15, 2026); no Forever-specific policy published yet [forevermastery]. RestedXP's addon is free; its guides are sold separately [forevermastery].
- Built in: damage meter and cooldown manager (Confirmed, Q&A at 01:21:51) [wfg-dev]; swing timer "perhaps coming soon" on that stream [wfg-dev] vs listed as a built-in feature by Method.gg (Sep 30) [forevermastery]. wfg-dev's rule: check whether a built-in panel already does the job before shipping a duplicate; "skin and inform", do not automate combat decisions or replace Blizzard unit frames, the damage meter or the cooldown manager.

### Developing with AI assistance (wfg-dev, wfg-api)
- The problem: models trained on old code write Classic-era calls — `GetSpellInfo`, a retail interface number like 110207, `COMBAT_LOG_EVENT_UNFILTERED`, `InterfaceOptions_AddCategory` — and branch on `WOW_PROJECT_ID`. A Sep 25, 2026 YouTube video by Kenneth Henseler shows an AI getting Forever addon code wrong four times [wfg-dev].
- Ten "golden rules" to apply to every AI draft: (1) `## Interface: 16001`; (2) Lua 5.1 limits; (3) Mainline family, not Classic — port a Midnight addon, not a Classic combat addon; (4) C_ namespaces with nil checks and async load; (5) namespace everything, only SavedVariables, slash entries and compartment callbacks as globals; (6) events, not the combat log; (7) secrets are drawn, not solved — guard with `issecretvalue`, feed StatusBars directly; (8) do not trust `WOW_PROJECT_ID` alone; (9) no secure-snippet dependency, own buttons for clicks, no secure attributes on Blizzard frames; (10) emit whole files in correct load order and state the install path. Rules 3, 6, 7 and 8 are Forever-beta-specific additions over Midnight guides [wfg-dev].
- Suggested system prompt (summarised, not reproduced): tells the model it writes WoW: Forever addons for a client that is neither Classic Era nor a private server; dates its facts (Sep 28 checks on 69913/70009, project-ID refresh from 70338 on Oct 13, launch Nov 4, 2026) and demands retesting on the actual build; then lists constraints — interface 16001; Lua 5.1 and missing libraries; Mainline 12.1.5 family with Midnight disarmament, Camelot game type, no 11500-series interface numbers; `WOW_PROJECT_ID` 18 vs the older 1, probe `select(4, GetBuildInfo())` and the needed API; the six missing globals and their C_ replacements with load-result events; no combat log, no meters or combat-log boss mods, built-in meter and cooldown manager, swing timer not promised; secret-value guarding and StatusBar handling; `pcall` does not help, the action-failed counter, the list of calls to avoid and their replacements; secure snippets as a beta defect; SavedVariables inside `ADDON_LOADED`; file header convention; one frame plus handler table, no `OnUpdate` polling; `InCombatLockdown()` queueing to `PLAYER_REGEN_ENABLED`; skin and inform only; emit complete .toc and .lua files with the beta install path and a restart hint; admit uncertainty with a capability probe and never invent C_ functions [wfg-dev].
- Ten-point verification checklist for AI output: interface line; Lua 5.1 compliance; namespace header and local privates; C_ lookups with nil checks; no combat-log code; secrets guarded; no project-ID-only branch; no secure attributes on Blizzard frames; SavedVariables set in `ADDON_LOADED`; protected-frame changes deferred to `PLAYER_REGEN_ENABLED` [wfg-dev].
- Quick-start "FirstLight" example: two files in a folder matching the TOC name; guarded `UnitName("player")` falling back to "adventurer"; a frame whose `OnEvent` dispatches to methods named after events; `FirstLightDB` created in `ADDON_LOADED`; a session counter printed on `PLAYER_LOGIN` [wfg-dev].
- Guide structure (7 pages): Start here; Forever patterns; API cheat sheet; Pitfalls (twelve AI mistakes); Code templates (Hello World, SavedVariables, guarded status bar, combat queue); AI prompts (system prompt, porting prompts, error diagnosis, review prompt); Forever Beacon sample addon [wfg-dev]. The site also hosts an "Addon Maker" tool and an AI Q&A widget that answers from its own guides and tells readers to check the source before quoting [wfg-api, wfg-dev].
- Porting advice: start from an addon's Midnight build, which already handles these rules, not its Classic Era branch [wfg-api].

---

## 5. Caveats

### Dates and era
- Everything predates or coincides with launch (Nov 4, 2026, 3:00 p.m. PST / 23:00 UTC, level cap 60 [wfg-dev]). Beta access ran Sep 17 to Oct 21, 2026 [wfg-dev]; the beta capped at level 30 when kami-leveling was written [kami-leveling].
- kami-best: published Oct 23; directory checks Oct 20; CurseForge counts Oct 23; video Oct 21. kami-leveling: published Oct 11 but written as of Oct 5. forevermastery: Oct 31 snapshot of CurseForge listings, "download pages change every day". meinmmo: Oct 26. wfg-api: checked Sep 28, updated Oct 21; wfg-dev: checked Sep 28, updated Oct 13; both warn beta behaviour can change with any build and that linked source mirrors may show a later build.
- Build-dependent facts: `WOW_PROJECT_ID` 1 (69913) vs 18 (70338); secure snippets dead on 69913; SavedVariables restore bug until 70009; interface 16001 "retest when the number moves at launch" [wfg-api, wfg-dev]. Camelot naming expected to change [forevermastery, wfg-dev].

### What the pages mark as unverified or untested
- wfg-api: "None were tested in game by this author"; status tags — Interface 16001 Reported; C_Spell/C_Item replacement Reported; combat log unavailable Unverified; API family Reported; project ID 18 Reported. Unverified items: combat-log unavailability, action-failed counter, nameplate timing, SavedVariables bug; Addon Compartment RegisterAddon and several examples are from Mainline docs, not Forever tests; C_GameRules probe recorded the function list but did not exercise return values.
- wfg-dev: Confirmed items are only the modern-API decision, built-in damage meter and cooldown manager, and the launch date; everything else Reported or Unverified. Forever Beacon is "an unverified reference sample".
- forevermastery: "We list what authors publish; we have not tested every addon"; Questie's status rests on GitHub issue counts; built-in feature claims rest on Icy Veins, Method.gg, Blizzard notes and beta observation.
- kami-leveling: author had not tested each leveling addon in game; relies on wowforever.be (Sep 19), MMonster, GitHub changelogs, CurseForge, Zygor's blog (Sep 15) and wowforeverguides.com (Zygor price, flagged as third-party).
- kami-best: GnomeLevelUp is not confirmed as the addon shown in the video; Kami's Threat Plates build is a temporary unofficial modification; Better Forever Chat is a development alpha whose author warns about settings loss.
- meinmmo: "AI-powered translation. Some inaccuracies might exist"; only page 1 of 11 captured, so the per-addon descriptions and "Forever Quest Tint" cannot be checked.

### Where sources disagree or differ
- Reload vs restart after installing: `/reload` suffices [kami-best] vs full restart needed for new files [forevermastery, wfg-dev]; meinmmo's `/reload` refers to toggling addons in the menu.
- AddOns folder: Classic beta folder [kami-best], `_classic_beta_` [wfg-dev], `_forever_` [meinmmo], "your Forever install" [forevermastery].
- Swing timer: built in per Method.gg [forevermastery] vs "perhaps coming soon", not a commitment [wfg-dev, wfg-api].
- Clique: alpha v5.1.3 from Oct 1 [kami-best] vs v5.1.0-beta on Oct 25 after four alphas [forevermastery] — the version numbering does not line up.
- Threat Plates: CurseForge build not loading around Oct 21 [kami-best] vs Forever version 13.3.4 on Oct 28 [forevermastery] — consistent with a fix in between, but neither page says so.
- Leatrix Plus 1.60.21-forever (Oct 19) [kami-best] vs 1.60.25-forever (Oct 21) [forevermastery]; Guidelime 6.003 (Oct 4) [kami-leveling] vs v6.013 (Oct 30) [forevermastery]; RestedXP 4.11.15 (Oct 4) [kami-leveling] vs v4.11.29 (Oct 29) [forevermastery] — different snapshot dates rather than conflicts.
- `WOW_PROJECT_ID`: 1 vs 18, by build [wfg-api, wfg-dev].
- Blizzard policy says addons must be free with no premium tier [forevermastery], while RestedXP and Zygor sell guide content; forevermastery frames RestedXP's addon as free with guides sold separately.

### Commercial bias
- kami-best and kami-leveling: RestedXP is a paid partner/sponsor of Kami's videos; affiliate links give 10% off and pay the site a commission; both pages carry a "Paid partnership" notice. The site solicits Tipeee donations and sells ad removal; Kami also hosts his own addon directory and a modified Threat Plates. Comments on kami-leveling show reader pushback against paid route addons, with Kami defending speed-leveling.
- wfg-api and wfg-dev: repeated RestedXP affiliate banners and an "Affiliate disclosure" footer stating the site earns commissions; the site also promotes its own AI assistant and "Addon Maker" tool.
- forevermastery: fan site, "Free, forever", no sponsorship or affiliate statements on the page; sources listed.
- meinmmo: Webedia-owned news site; no sponsorship disclosed on the captured page; partner sites listed in the footer.
