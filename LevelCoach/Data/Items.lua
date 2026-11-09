local _, ns = ...
ns.Data = ns.Data or {}
ns.Data.Items = {
  {
    ["done_when"] = {
      ["type"] = "manual",
    },
    ["goals"] = {
      "any",
    },
    ["id"] = "general-experience-preset",
    ["kind"] = "setup",
    ["level"] = {
      ["max"] = 5,
      ["min"] = 1,
    },
    ["priority"] = "normal",
    ["sources"] = {
      "https://news.blizzard.com/en-us/article/24315821/wow-foreverwhats-new-and-what-feels-familiar",
    },
    ["title"] = "Pick the Enhanced preset, or turn on quest guidance",
    ["verified"] = {
      ["forever"] = false,
    },
    ["where"] = {
      ["note"] = "Game Menu > Options > Experience preset",
    },
    ["why"] = "Forever ships Blizzard's own quest objective markers and points of interest. They replace half of what people install Questie for. Presentation only, not a ruleset.",
  },
  {
    ["done_when"] = {
      ["type"] = "manual",
    },
    ["goals"] = {
      "any",
    },
    ["id"] = "general-cooldown-manager",
    ["kind"] = "setup",
    ["level"] = {
      ["max"] = 10,
      ["min"] = 1,
    },
    ["priority"] = "low",
    ["sources"] = {
      "https://forevermastery.com/en/addons/forever-compatibility",
    },
    ["title"] = "Turn on the built-in Cooldown Manager",
    ["verified"] = {
      ["forever"] = false,
    },
    ["where"] = {
      ["note"] = "Options > Gameplay Enhancement",
    },
    ["why"] = "Forever has one; it is off by default and covers every class since the Oct 8 beta build.",
  },
  {
    ["classes"] = {
      "WARLOCK",
      "MAGE",
      "PRIEST",
    },
    ["done_when"] = {
      ["type"] = "manual",
    },
    ["goals"] = {
      "any",
    },
    ["id"] = "general-first-wand",
    ["kind"] = "item",
    ["level"] = {
      ["max"] = 20,
      ["min"] = 5,
    },
    ["priority"] = "high",
    ["sources"] = {
      "https://www.method.gg/wow-forever/wow-forever-warlock-leveling-guide-and-talents",
    },
    ["title"] = "Get a wand as soon as you can afford one",
    ["verified"] = {
      ["forever"] = false,
    },
    ["where"] = {
      ["note"] = "Auction house or any enchanter; wand skill is default for casters",
    },
    ["why"] = "Wands are free damage with no mana cost. Every guide calls the first wand the biggest early upgrade for a caster. Lesser Magic Wand is enchanter-made and sells on the auction house.",
  },
  {
    ["done_when"] = {
      ["of"] = {
        {
          ["min"] = 1,
          ["name"] = "Tailoring",
          ["type"] = "skill_line",
        },
        {
          ["min"] = 1,
          ["name"] = "Enchanting",
          ["type"] = "skill_line",
        },
        {
          ["min"] = 1,
          ["name"] = "Herbalism",
          ["type"] = "skill_line",
        },
        {
          ["min"] = 1,
          ["name"] = "Mining",
          ["type"] = "skill_line",
        },
        {
          ["min"] = 1,
          ["name"] = "Skinning",
          ["type"] = "skill_line",
        },
        {
          ["min"] = 1,
          ["name"] = "Alchemy",
          ["type"] = "skill_line",
        },
        {
          ["min"] = 1,
          ["name"] = "Engineering",
          ["type"] = "skill_line",
        },
        {
          ["min"] = 1,
          ["name"] = "Leatherworking",
          ["type"] = "skill_line",
        },
        {
          ["min"] = 1,
          ["name"] = "Blacksmithing",
          ["type"] = "skill_line",
        },
      },
      ["type"] = "any_of",
    },
    ["goals"] = {
      "any",
    },
    ["id"] = "general-pick-professions",
    ["kind"] = "profession",
    ["level"] = {
      ["max"] = 20,
      ["min"] = 5,
    },
    ["priority"] = "high",
    ["sources"] = {
      "https://www.warcrafttavern.com/forever/guides/warlock-leveling/",
    },
    ["title"] = "Pick two professions",
    ["verified"] = {
      ["forever"] = false,
    },
    ["where"] = {
      ["note"] = "Brill or Undercity profession trainers",
    },
    ["why"] = "Guides lean Tailoring plus Enchanting for a cloth caster. Gathering pays for riding at 40 on a fresh economy. Professions also unlock campsite buffs from skill 20.",
  },
  {
    ["done_when"] = {
      ["min"] = 1,
      ["name"] = "First Aid",
      ["type"] = "skill_line",
    },
    ["goals"] = {
      "any",
    },
    ["id"] = "general-first-aid",
    ["kind"] = "profession",
    ["level"] = {
      ["max"] = 60,
      ["min"] = 5,
    },
    ["priority"] = "high",
    ["sources"] = {
      "https://www.warcrafttavern.com/forever/guides/warlock-leveling/",
    },
    ["title"] = "Learn First Aid",
    ["verified"] = {
      ["forever"] = false,
    },
    ["why"] = "Bandages heal between pulls or while a mob is feared. In Forever, First Aid also makes healing potions and cures for poisons, diseases and bleeds, which a warlock cannot otherwise remove.",
  },
  {
    ["done_when"] = {
      ["min"] = 1,
      ["name"] = "Cooking",
      ["type"] = "skill_line",
    },
    ["goals"] = {
      "any",
    },
    ["id"] = "general-cooking",
    ["kind"] = "profession",
    ["level"] = {
      ["max"] = 60,
      ["min"] = 5,
    },
    ["priority"] = "low",
    ["sources"] = {
      "https://www.warcrafttavern.com/forever/guides/warlock-leveling/",
    },
    ["title"] = "Learn Cooking",
    ["verified"] = {
      ["forever"] = false,
    },
    ["why"] = "Well Fed food gives about 5% more kill XP, and your own campsite needs a cooking fire.",
  },
  {
    ["done_when"] = {
      ["type"] = "manual",
    },
    ["goals"] = {
      "any",
    },
    ["id"] = "general-camping-unlock",
    ["kind"] = "quest",
    ["level"] = {
      ["max"] = 12,
      ["min"] = 5,
    },
    ["priority"] = "normal",
    ["sources"] = {
      "https://warcraft.wiki.gg/wiki/World_of_Warcraft:_Forever",
    },
    ["title"] = "Unlock camping",
    ["verified"] = {
      ["forever"] = false,
    },
    ["why"] = "New Forever system. Sit at a campfire to pick up campsite buffs; every profession adds a camp buff from skill 20. Start with the adventurer outside the first quest hub and the quest The Great Outdoors.",
  },
  {
    ["done_when"] = {
      ["type"] = "manual",
    },
    ["goals"] = {
      "any",
    },
    ["id"] = "general-bags-four-slots",
    ["kind"] = "setup",
    ["level"] = {
      ["max"] = 20,
      ["min"] = 5,
    },
    ["priority"] = "normal",
    ["sources"] = {
      "https://www.method.gg/wow-forever/wow-forever-warlock-leveling-guide-and-talents",
    },
    ["title"] = "Fill all four bag slots",
    ["verified"] = {
      ["forever"] = false,
    },
    ["why"] = "Shards, quest items and loot pile up fast. Any 6-slot bag is fine early; vendor greys and auction greens to pay for them.",
  },
  {
    ["done_when"] = {
      ["type"] = "bind_location",
      ["zone"] = "Brill",
    },
    ["goals"] = {
      "any",
    },
    ["id"] = "general-hearth-brill",
    ["kind"] = "setup",
    ["level"] = {
      ["max"] = 12,
      ["min"] = 6,
    },
    ["priority"] = "normal",
    ["races"] = {
      "Scourge",
    },
    ["sources"] = {
      "https://www.warcrafttavern.com/forever/guides/warlock-leveling/",
    },
    ["title"] = "Set your hearth in Brill",
    ["verified"] = {
      ["forever"] = false,
      ["note"] = "Classic knowledge; confirm the inn is unchanged",
    },
    ["where"] = {
      ["note"] = "Gallows' End Tavern, Brill",
      ["npc"] = "Innkeeper Renee",
      ["zone"] = "Tirisfal Glades",
    },
    ["why"] = "Brill is the handoff town after Deathknell and holds the Voidwalker quest at 10.",
  },
  {
    ["done_when"] = {
      ["type"] = "bind_location",
      ["zone"] = "The Sepulcher",
    },
    ["factions"] = {
      "Horde",
    },
    ["goals"] = {
      "any",
    },
    ["id"] = "general-hearth-sepulcher",
    ["kind"] = "setup",
    ["level"] = {
      ["max"] = 13,
      ["min"] = 10,
    },
    ["priority"] = "low",
    ["sources"] = {
      "https://wowforeverleveling.com/guides/wow-forever-horde-leveling-guide",
    },
    ["title"] = "Move your hearth to The Sepulcher",
    ["verified"] = {
      ["forever"] = false,
    },
    ["where"] = {
      ["note"] = "The Sepulcher inn",
      ["zone"] = "Silverpine Forest",
    },
    ["why"] = "The Sepulcher is the Silverpine quest hub for levels 10 to 20.",
  },
  {
    ["done_when"] = {
      ["type"] = "zone_visited",
      ["zone"] = "Silverpine Forest",
    },
    ["factions"] = {
      "Horde",
    },
    ["goals"] = {
      "any",
    },
    ["id"] = "general-zone-silverpine",
    ["kind"] = "zone",
    ["level"] = {
      ["max"] = 14,
      ["min"] = 10,
    },
    ["priority"] = "normal",
    ["sources"] = {
      "https://wowforeverleveling.com/guides/wow-forever-horde-leveling-guide",
    },
    ["title"] = "Quest in Silverpine Forest from The Sepulcher",
    ["verified"] = {
      ["forever"] = false,
    },
    ["where"] = {
      ["zone"] = "Silverpine Forest",
    },
    ["why"] = "The shared Horde zone for levels 10 to 20. Shadowfang Keep is here for later, and some Ruins of Lordaeron quests start here.",
  },
  {
    ["done_when"] = {
      ["type"] = "zone_visited",
      ["zone"] = "The Barrens",
    },
    ["factions"] = {
      "Horde",
    },
    ["goals"] = {
      "any",
    },
    ["id"] = "general-zeppelin-to-barrens",
    ["kind"] = "zone",
    ["level"] = {
      ["max"] = 16,
      ["min"] = 12,
    },
    ["priority"] = "normal",
    ["sources"] = {
      "https://wowforeverleveling.com/guides/wow-forever-horde-leveling-guide",
    },
    ["title"] = "Take the zeppelin to Orgrimmar and head to the Barrens",
    ["verified"] = {
      ["forever"] = false,
    },
    ["where"] = {
      ["note"] = "Zeppelin tower outside the Undercity, Orgrimmar line",
      ["zone"] = "Tirisfal Glades",
    },
    ["why"] = "Most Horde routes move to the Barrens around 12 to 14 and use the Crossroads as a base, with Hillsbrad later. The zeppelin tower is outside the Undercity.",
  },
  {
    ["done_when"] = {
      ["type"] = "bind_location",
      ["zone"] = "Crossroads",
    },
    ["factions"] = {
      "Horde",
    },
    ["goals"] = {
      "any",
    },
    ["id"] = "general-hearth-crossroads",
    ["kind"] = "setup",
    ["level"] = {
      ["max"] = 26,
      ["min"] = 14,
    },
    ["priority"] = "low",
    ["sources"] = {
      "https://wowforeverleveling.com/guides/wow-forever-horde-leveling-guide",
    },
    ["title"] = "Set your hearth at the Crossroads",
    ["verified"] = {
      ["forever"] = false,
    },
    ["where"] = {
      ["note"] = "Crossroads inn",
      ["zone"] = "The Barrens",
    },
    ["why"] = "Central to the Barrens, with a flight path and the zeppelin to Orgrimmar nearby.",
  },
  {
    ["done_when"] = {
      ["type"] = "manual",
    },
    ["factions"] = {
      "Horde",
    },
    ["goals"] = {
      "any",
    },
    ["id"] = "general-cozy-sleeping-bag",
    ["kind"] = "quest",
    ["level"] = {
      ["max"] = 30,
      ["min"] = 14,
    },
    ["priority"] = "low",
    ["sources"] = {
      "https://wowforeverleveling.com/guides/wow-forever-horde-leveling-guide",
    },
    ["title"] = "Consider the Cozy Sleeping Bag chain",
    ["verified"] = {
      ["forever"] = false,
      ["note"] = "third-party reports only",
    },
    ["where"] = {
      ["note"] = "Burned-Out Remains",
      ["waypoint"] = {
        46,
        74,
      },
      ["zone"] = "The Barrens",
    },
    ["why"] = "Reported stacking XP buff plus a portable rest spot. Starts at 14 at the Burned-Out Remains in the southern Barrens and runs through level 25 to 30 zones. Details are disputed, so treat it as optional.",
  },
  {
    ["done_when"] = {
      ["copper"] = 1000000,
      ["type"] = "money_at_least",
    },
    ["goals"] = {
      "any",
    },
    ["id"] = "general-riding-savings",
    ["kind"] = "gold",
    ["level"] = {
      ["max"] = 40,
      ["min"] = 20,
    },
    ["priority"] = "high",
    ["sources"] = {
      "https://www.method.gg/wow-forever/how-to-get-a-mount-in-wow-forever-cost-requirement-and-mount-options",
    },
    ["title"] = "Save 100 gold for riding at 40",
    ["verified"] = {
      ["forever"] = false,
      ["note"] = "beta-era price",
    },
    ["where"] = {
      ["note"] = "Undead buy from Velma Warnam in Brill",
    },
    ["why"] = "Apprentice Riding is reported at 100 gold with the first mount included, 90 at Honored with your home city. Fresh economy, no main to fund you. Sell greens and cloth, vendor greys.",
  },
  {
    ["done_when"] = {
      ["type"] = "manual",
    },
    ["goals"] = {
      "any",
    },
    ["id"] = "general-legacy-point-25",
    ["kind"] = "setup",
    ["level"] = {
      ["max"] = 60,
      ["min"] = 25,
    },
    ["priority"] = "low",
    ["sources"] = {
      "https://news.blizzard.com/en-us/article/24315821/wow-foreverwhats-new-and-what-feels-familiar",
    },
    ["title"] = "Spend your first Legacy Point",
    ["verified"] = {
      ["forever"] = false,
    },
    ["why"] = "New account-wide system. Reaching 25, 40 and 60 awards points; perks such as Talented and Well Rested help leveling. Spend them at your class trainer.",
  },
  {
    ["done_when"] = {
      ["type"] = "manual",
    },
    ["goals"] = {
      "any",
    },
    ["id"] = "general-vendor-and-auction-habit",
    ["kind"] = "habit",
    ["level"] = {
      ["max"] = 40,
      ["min"] = 5,
    },
    ["overdue"] = false,
    ["priority"] = "low",
    ["sources"] = {
      "https://timesaver.gg/blog/wow-forever-mount-cost-gold-to-save",
    },
    ["title"] = "Vendor greys, auction whites and greens",
    ["verified"] = {
      ["forever"] = false,
    },
    ["why"] = "Launch-week prices are high and you need bags now and 100 gold by 40.",
  },
  {
    ["done_when"] = {
      ["type"] = "manual",
    },
    ["factions"] = {
      "Horde",
    },
    ["goals"] = {
      "any",
    },
    ["id"] = "general-pvp-contested-zones",
    ["kind"] = "habit",
    ["level"] = {
      ["max"] = 30,
      ["min"] = 20,
    },
    ["priority"] = "normal",
    ["sources"] = {
      "https://wowforeverleveling.com/guides/wow-forever-horde-leveling-guide",
    },
    ["tags"] = {
      "pvp",
    },
    ["title"] = "Hillsbrad is contested; expect Alliance",
    ["verified"] = {
      ["forever"] = false,
    },
    ["where"] = {
      ["zone"] = "Hillsbrad Foothills",
    },
    ["why"] = "On a PvP ruleset, Hillsbrad Foothills and Ashenvale are where both factions quest at the same levels. Tarren Mill gets raided. Keep an escape ready and avoid Southshore.",
  },
  {
    ["done_when"] = {
      ["type"] = "manual",
    },
    ["factions"] = {
      "Horde",
    },
    ["goals"] = {
      "dungeons",
    },
    ["id"] = "dungeon-ragefire-chasm",
    ["kind"] = "dungeon",
    ["level"] = {
      ["max"] = 19,
      ["min"] = 13,
    },
    ["priority"] = "normal",
    ["sources"] = {
      "https://warcraft.wiki.gg/wiki/World_of_Warcraft:_Forever",
    },
    ["title"] = "Run Ragefire Chasm when a group forms",
    ["verified"] = {
      ["forever"] = false,
    },
    ["where"] = {
      ["note"] = "Cleft of Shadow",
      ["zone"] = "Orgrimmar",
    },
    ["why"] = "Dungeon quests are a large share of Forever XP. Warlocks also pick up Hidden Enemies here for the Staff of Orgrimmar.",
  },
  {
    ["done_when"] = {
      ["type"] = "manual",
    },
    ["factions"] = {
      "Horde",
    },
    ["goals"] = {
      "dungeons",
    },
    ["id"] = "dungeon-ruins-of-lordaeron",
    ["kind"] = "dungeon",
    ["level"] = {
      ["max"] = 20,
      ["min"] = 15,
    },
    ["priority"] = "high",
    ["sources"] = {
      "https://wowforeverleveling.com/guides/wow-forever-horde-leveling-guide",
    },
    ["title"] = "Run Ruins of Lordaeron, the Undead home dungeon",
    ["verified"] = {
      ["forever"] = false,
      ["note"] = "level range 15-20 per wfl, 15-22 per wiki",
    },
    ["where"] = {
      ["note"] = "Entrance above the Undercity",
      ["zone"] = "Tirisfal Glades",
    },
    ["why"] = "New dungeon above the Undercity. Six Horde quests, four picked up in Tirisfal, Silverpine and the Undercity, so collect them when you pass through.",
  },
  {
    ["done_when"] = {
      ["type"] = "manual",
    },
    ["factions"] = {
      "Horde",
    },
    ["goals"] = {
      "dungeons",
    },
    ["id"] = "dungeon-wailing-caverns",
    ["kind"] = "dungeon",
    ["level"] = {
      ["max"] = 25,
      ["min"] = 19,
    },
    ["priority"] = "normal",
    ["sources"] = {
      "https://warcraft.wiki.gg/wiki/World_of_Warcraft:_Forever",
    },
    ["title"] = "Run Wailing Caverns",
    ["verified"] = {
      ["forever"] = false,
    },
    ["where"] = {
      ["zone"] = "The Barrens",
    },
    ["why"] = "On every Horde dungeon route's mandatory list for the low twenties.",
  },
  {
    ["done_when"] = {
      ["type"] = "manual",
    },
    ["factions"] = {
      "Horde",
    },
    ["goals"] = {
      "dungeons",
    },
    ["id"] = "dungeon-shadowfang-keep",
    ["kind"] = "dungeon",
    ["level"] = {
      ["max"] = 29,
      ["min"] = 23,
    },
    ["priority"] = "normal",
    ["sources"] = {
      "https://warcraft.wiki.gg/wiki/World_of_Warcraft:_Forever",
    },
    ["title"] = "Run Shadowfang Keep",
    ["verified"] = {
      ["forever"] = false,
    },
    ["where"] = {
      ["zone"] = "Silverpine Forest",
    },
    ["why"] = "Horde quests from the Sepulcher, and one of the two Orb of Soran'ruk fragments for warlocks.",
  },
  {
    ["done_when"] = {
      ["of"] = {
        {
          ["min"] = 1,
          ["name"] = "Herbalism",
          ["type"] = "skill_line",
        },
        {
          ["min"] = 1,
          ["name"] = "Mining",
          ["type"] = "skill_line",
        },
        {
          ["min"] = 1,
          ["name"] = "Skinning",
          ["type"] = "skill_line",
        },
      },
      ["type"] = "any_of",
    },
    ["goals"] = {
      "any",
    },
    ["id"] = "undead-starter-gathering-manual",
    ["kind"] = "profession",
    ["level"] = {
      ["max"] = 8,
      ["min"] = 3,
    },
    ["priority"] = "normal",
    ["races"] = {
      "Scourge",
    },
    ["sources"] = {
      "https://wowforeverguides.com/leveling/starting-zones",
    },
    ["title"] = "Do the starter gathering quest and pick a manual",
    ["verified"] = {
      ["forever"] = false,
    },
    ["where"] = {
      ["note"] = "Deathknell; trainers Florence Nightshade (Herbalism) and Walter Mason (Mining)",
      ["zone"] = "Tirisfal Glades",
    },
    ["why"] = "New in Forever. A level 3 to 4 quest offers Herbalism, Mining or Skinning manuals worth 2 skill points. Herbalism or Skinning pays for riding later.",
  },
  {
    ["done_when"] = {
      ["type"] = "manual",
    },
    ["goals"] = {
      "any",
    },
    ["id"] = "undead-cannibalize-habit",
    ["kind"] = "habit",
    ["level"] = {
      ["max"] = 60,
      ["min"] = 1,
    },
    ["overdue"] = false,
    ["priority"] = "low",
    ["races"] = {
      "Scourge",
    },
    ["sources"] = {
      "https://www.warcrafttavern.com/forever/guides/warlock/",
    },
    ["title"] = "Cannibalize after fights",
    ["verified"] = {
      ["forever"] = false,
    },
    ["why"] = "Buffed in Forever to restore mana as well as health. With Life Tap this nearly removes downtime. Works on humanoid and undead corpses.",
  },
  {
    ["done_when"] = {
      ["type"] = "manual",
    },
    ["goals"] = {
      "any",
    },
    ["id"] = "undead-will-of-forsaken-pvp",
    ["kind"] = "habit",
    ["level"] = {
      ["max"] = 60,
      ["min"] = 10,
    },
    ["overdue"] = false,
    ["priority"] = "low",
    ["races"] = {
      "Scourge",
    },
    ["sources"] = {
      "https://www.warcrafttavern.com/forever/guides/warlock/",
    },
    ["tags"] = {
      "pvp",
    },
    ["title"] = "Keybind Will of the Forsaken",
    ["verified"] = {
      ["forever"] = false,
    },
    ["why"] = "Breaks or prevents Charm, Fear and Sleep. On a PvP ruleset it is a free trinket; have it on a key before Hillsbrad.",
  },
  {
    ["classes"] = {
      "WARLOCK",
    },
    ["done_when"] = {
      ["id"] = 688,
      ["type"] = "spell_known",
      ["verify"] = "probe spell.688 must read Summon Imp",
    },
    ["goals"] = {
      "any",
    },
    ["id"] = "warlock-imp-quest",
    ["kind"] = "quest",
    ["level"] = {
      ["max"] = 4,
      ["min"] = 1,
    },
    ["priority"] = "high",
    ["sources"] = {
      "https://www.warcrafttavern.com/forever/guides/warlock-leveling/",
    },
    ["title"] = "Do the Imp class quest right away",
    ["verified"] = {
      ["forever"] = false,
    },
    ["where"] = {
      ["note"] = "Deathknell class trainer (Undead)",
      ["npc"] = "Maximillion",
      ["waypoint"] = {
        30.8,
        66.2,
      },
      ["zone"] = "Tirisfal Glades",
    },
    ["why"] = "Your first pet. Ranged damage plus the Blood Pact stamina buff. Keep it out at all times until 10.",
  },
  {
    ["classes"] = {
      "WARLOCK",
    },
    ["done_when"] = {
      ["id"] = 348,
      ["type"] = "spell_known",
      ["verify"] = "probe spell.348 must read Immolate",
    },
    ["goals"] = {
      "any",
    },
    ["id"] = "warlock-train-immolate",
    ["kind"] = "train",
    ["level"] = {
      ["max"] = 6,
      ["min"] = 1,
    },
    ["priority"] = "high",
    ["sources"] = {
      "https://www.method.gg/wow-forever/wow-forever-warlock-leveling-guide-and-talents",
    },
    ["title"] = "Train Immolate",
    ["verified"] = {
      ["forever"] = false,
    },
    ["where"] = {
      ["note"] = "Class trainer in your starting valley",
    },
    ["why"] = "Your opener for the first nine levels. It costs 10 copper; sell starting gear if you are short.",
  },
  {
    ["classes"] = {
      "WARLOCK",
    },
    ["done_when"] = {
      ["type"] = "manual",
    },
    ["goals"] = {
      "any",
    },
    ["id"] = "warlock-demon-skin-habit",
    ["kind"] = "habit",
    ["level"] = {
      ["max"] = 19,
      ["min"] = 1,
    },
    ["overdue"] = false,
    ["priority"] = "low",
    ["sources"] = {
      "https://www.method.gg/wow-forever/wow-forever-warlock-leveling-guide-and-talents",
    },
    ["title"] = "Keep Demon Skin up",
    ["verified"] = {
      ["forever"] = false,
    },
    ["why"] = "Armor plus health regeneration for thirty minutes. Demon Armor replaces it at 20.",
  },
  {
    ["classes"] = {
      "WARLOCK",
    },
    ["done_when"] = {
      ["id"] = 172,
      ["type"] = "spell_known",
      ["verify"] = "probe spell.172 must read Corruption",
    },
    ["goals"] = {
      "any",
    },
    ["id"] = "warlock-train-corruption",
    ["kind"] = "train",
    ["level"] = {
      ["max"] = 8,
      ["min"] = 4,
    },
    ["priority"] = "high",
    ["sources"] = {
      "https://www.warcrafttavern.com/forever/guides/warlock-leveling/",
    },
    ["title"] = "Train Corruption and Curse of Weakness",
    ["verified"] = {
      ["forever"] = false,
    },
    ["why"] = "Corruption is your core DoT for sixty levels. Curse of Weakness blunts hard-hitting melee mobs.",
  },
  {
    ["classes"] = {
      "WARLOCK",
    },
    ["done_when"] = {
      ["type"] = "manual",
    },
    ["goals"] = {
      "any",
    },
    ["id"] = "warlock-blood-pact-grimoire",
    ["kind"] = "train",
    ["level"] = {
      ["max"] = 10,
      ["min"] = 4,
    },
    ["priority"] = "normal",
    ["sources"] = {
      "https://www.method.gg/wow-forever/wow-forever-warlock-leveling-guide-and-talents",
    },
    ["title"] = "Buy Grimoire of Blood Pact for the Imp",
    ["verified"] = {
      ["forever"] = false,
    },
    ["where"] = {
      ["note"] = "Deathknell demon trainer (Undead)",
      ["npc"] = "Kayla Smithe",
      ["waypoint"] = {
        30.8,
        66.4,
      },
      ["zone"] = "Tirisfal Glades",
    },
    ["why"] = "Demon trainers sell pet abilities as grimoires in Forever. The starting-valley trainer only carries Imp and Voidwalker books.",
  },
  {
    ["classes"] = {
      "WARLOCK",
    },
    ["done_when"] = {
      ["id"] = 1454,
      ["type"] = "spell_known",
      ["verify"] = "probe spell.1454 must read Life Tap",
    },
    ["goals"] = {
      "any",
    },
    ["id"] = "warlock-train-life-tap",
    ["kind"] = "train",
    ["level"] = {
      ["max"] = 10,
      ["min"] = 6,
    },
    ["priority"] = "normal",
    ["sources"] = {
      "https://www.method.gg/wow-forever/wow-forever-warlock-leveling-guide-and-talents",
    },
    ["title"] = "Train Life Tap, and carry food",
    ["verified"] = {
      ["forever"] = false,
    },
    ["why"] = "Turns health into mana and scales with Spirit in Forever. Tap between pulls, then eat the health back.",
  },
  {
    ["classes"] = {
      "WARLOCK",
    },
    ["done_when"] = {
      ["id"] = 980,
      ["type"] = "spell_known",
      ["verify"] = "probe spell.980: renamed spell, ID may differ",
    },
    ["goals"] = {
      "any",
    },
    ["id"] = "warlock-train-bane-of-agony",
    ["kind"] = "train",
    ["level"] = {
      ["max"] = 12,
      ["min"] = 8,
    },
    ["priority"] = "normal",
    ["sources"] = {
      "https://www.warcrafttavern.com/forever/guides/warlock-leveling/",
    },
    ["title"] = "Train Bane of Agony",
    ["verified"] = {
      ["forever"] = false,
    },
    ["where"] = {
      ["note"] = "Brill class trainer",
      ["npc"] = "Rupert Boch",
      ["waypoint"] = {
        61.6,
        52.4,
      },
      ["zone"] = "Tirisfal Glades",
    },
    ["why"] = "Renamed from Curse of Agony. Tags a mob instantly and ramps slowly, so the pet picks up threat. Pull with it, not with Immolate.",
  },
  {
    ["classes"] = {
      "WARLOCK",
    },
    ["done_when"] = {
      ["id"] = 5782,
      ["type"] = "spell_known",
      ["verify"] = "probe spell.5782 must read Fear",
    },
    ["goals"] = {
      "any",
    },
    ["id"] = "warlock-train-fear",
    ["kind"] = "train",
    ["level"] = {
      ["max"] = 12,
      ["min"] = 8,
    },
    ["priority"] = "normal",
    ["sources"] = {
      "https://www.warcrafttavern.com/forever/guides/warlock-leveling/",
    },
    ["title"] = "Train Fear",
    ["verified"] = {
      ["forever"] = false,
    },
    ["why"] = "Your main crowd control, 20-yard range in Forever. Fear the second mob, kill the first.",
  },
  {
    ["classes"] = {
      "WARLOCK",
    },
    ["done_when"] = {
      ["type"] = "manual",
    },
    ["goals"] = {
      "any",
    },
    ["id"] = "warlock-pull-with-bane-habit",
    ["kind"] = "habit",
    ["level"] = {
      ["max"] = 20,
      ["min"] = 8,
    },
    ["overdue"] = false,
    ["priority"] = "low",
    ["sources"] = {
      "https://www.warcrafttavern.com/forever/guides/warlock-leveling/",
    },
    ["title"] = "Pull with Bane of Agony, pet in first",
    ["verified"] = {
      ["forever"] = false,
    },
    ["why"] = "Immolate's upfront hit steals threat from the pet. Send the demon, Bane of Agony, Corruption, then wand.",
  },
  {
    ["classes"] = {
      "WARLOCK",
    },
    ["done_when"] = {
      ["id"] = 697,
      ["type"] = "spell_known",
      ["verify"] = "probe spell.697 must read Summon Voidwalker; probe quest.1470 title",
    },
    ["goals"] = {
      "any",
    },
    ["id"] = "warlock-voidwalker-quest",
    ["kind"] = "quest",
    ["level"] = {
      ["max"] = 12,
      ["min"] = 10,
    },
    ["priority"] = "high",
    ["races"] = {
      "Scourge",
    },
    ["sources"] = {
      "https://www.warcrafttavern.com/forever/guides/warlock-leveling/",
    },
    ["title"] = "Do the Voidwalker quest: Halgar's Summons",
    ["verified"] = {
      ["forever"] = false,
    },
    ["where"] = {
      ["note"] = "Brill",
      ["npc"] = "Halgar",
      ["zone"] = "Tirisfal Glades",
    },
    ["why"] = "Your tank for the next ten levels. Take the Brill version; the Orgrimmar one sends you into Skull Rock.",
  },
  {
    ["classes"] = {
      "WARLOCK",
    },
    ["done_when"] = {
      ["id"] = 6201,
      ["type"] = "spell_known",
      ["verify"] = "probe spell.6201: ranks renumbered in Forever, ID may differ",
    },
    ["goals"] = {
      "any",
    },
    ["id"] = "warlock-healthstone",
    ["kind"] = "train",
    ["level"] = {
      ["max"] = 14,
      ["min"] = 10,
    },
    ["priority"] = "high",
    ["sources"] = {
      "https://www.warcrafttavern.com/forever/guides/warlock-leveling/",
    },
    ["title"] = "Train Create Healthstone and always carry one",
    ["verified"] = {
      ["forever"] = false,
    },
    ["why"] = "Separate cooldown from potions. Healthstone ranks are numbered in Forever.",
  },
  {
    ["classes"] = {
      "WARLOCK",
    },
    ["done_when"] = {
      ["type"] = "manual",
    },
    ["goals"] = {
      "any",
    },
    ["id"] = "warlock-first-talent",
    ["kind"] = "talent",
    ["level"] = {
      ["max"] = 11,
      ["min"] = 10,
    },
    ["priority"] = "high",
    ["sources"] = {
      "https://timesaver.gg/tools/wow-forever/talent-calculator/warlock/affliction",
    },
    ["title"] = "Spend your first talent point in Improved Corruption",
    ["verified"] = {
      ["forever"] = false,
    },
    ["why"] = "Instant Corruption at 5/5 is where every guide starts. Points come one per level from 10.",
  },
  {
    ["classes"] = {
      "WARLOCK",
    },
    ["done_when"] = {
      ["type"] = "manual",
    },
    ["goals"] = {
      "any",
    },
    ["id"] = "warlock-improved-corruption",
    ["kind"] = "talent",
    ["level"] = {
      ["max"] = 14,
      ["min"] = 11,
    },
    ["priority"] = "normal",
    ["sources"] = {
      "https://timesaver.gg/tools/wow-forever/talent-calculator/warlock/affliction",
    },
    ["title"] = "Finish Improved Corruption 5/5",
    ["verified"] = {
      ["forever"] = false,
    },
    ["why"] = "Instant cast plus 10% damage. Maxroll and Tavern take it at 10 to 14; Method takes Suppression first.",
  },
  {
    ["classes"] = {
      "WARLOCK",
    },
    ["done_when"] = {
      ["id"] = 1120,
      ["type"] = "spell_known",
      ["verify"] = "probe spell.1120 must read Drain Soul",
    },
    ["goals"] = {
      "any",
    },
    ["id"] = "warlock-train-drain-soul",
    ["kind"] = "train",
    ["level"] = {
      ["max"] = 14,
      ["min"] = 10,
    },
    ["priority"] = "normal",
    ["sources"] = {
      "https://www.warcrafttavern.com/forever/guides/warlock-leveling/",
    },
    ["title"] = "Train Drain Soul",
    ["verified"] = {
      ["forever"] = false,
    },
    ["why"] = "Makes Soul Shards. In Forever any tick on a real mob can drop one and a kill always does. Channel rank 1 while the pet tanks to farm.",
  },
  {
    ["classes"] = {
      "WARLOCK",
    },
    ["done_when"] = {
      ["type"] = "manual",
    },
    ["goals"] = {
      "any",
    },
    ["id"] = "warlock-torment-ranks-habit",
    ["kind"] = "habit",
    ["level"] = {
      ["max"] = 60,
      ["min"] = 12,
    },
    ["overdue"] = false,
    ["priority"] = "low",
    ["sources"] = {
      "https://www.warcrafttavern.com/forever/guides/warlock-leveling/",
    },
    ["title"] = "Buy every Torment rank when it appears",
    ["verified"] = {
      ["forever"] = false,
    },
    ["where"] = {
      ["note"] = "Brill demon trainer; Martha Strain in the Undercity",
      ["npc"] = "Gina Lang",
      ["waypoint"] = {
        61.6,
        52.6,
      },
      ["zone"] = "Tirisfal Glades",
    },
    ["why"] = "Torment threat steps every ten levels; a stale rank means the Voidwalker loses mobs to your DoTs.",
  },
  {
    ["classes"] = {
      "WARLOCK",
    },
    ["done_when"] = {
      ["id"] = 755,
      ["type"] = "spell_known",
      ["verify"] = "probe spell.755 must read Health Funnel",
    },
    ["goals"] = {
      "any",
    },
    ["id"] = "warlock-train-health-funnel",
    ["kind"] = "train",
    ["level"] = {
      ["max"] = 16,
      ["min"] = 12,
    },
    ["priority"] = "low",
    ["sources"] = {
      "https://www.warcrafttavern.com/forever/guides/warlock-leveling/",
    },
    ["title"] = "Train Health Funnel",
    ["verified"] = {
      ["forever"] = false,
    },
    ["why"] = "Heals the pet from your health; generates reduced threat in Forever.",
  },
  {
    ["classes"] = {
      "WARLOCK",
    },
    ["done_when"] = {
      ["id"] = 689,
      ["type"] = "spell_known",
      ["verify"] = "probe spell.689 must read Drain Life",
    },
    ["goals"] = {
      "any",
    },
    ["id"] = "warlock-train-drain-life",
    ["kind"] = "train",
    ["level"] = {
      ["max"] = 18,
      ["min"] = 14,
    },
    ["priority"] = "normal",
    ["sources"] = {
      "https://www.method.gg/wow-forever/wow-forever-warlock-leveling-guide-and-talents",
    },
    ["title"] = "Train Drain Life",
    ["verified"] = {
      ["forever"] = false,
    },
    ["why"] = "The drain-tanking tool from 30. Until then the wand stays your filler.",
  },
  {
    ["classes"] = {
      "WARLOCK",
    },
    ["done_when"] = {
      ["id"] = 704,
      ["type"] = "spell_known",
      ["verify"] = "probe spell.704 must read Curse of Recklessness",
    },
    ["goals"] = {
      "any",
    },
    ["id"] = "warlock-train-curse-of-recklessness",
    ["kind"] = "train",
    ["level"] = {
      ["max"] = 18,
      ["min"] = 14,
    },
    ["priority"] = "low",
    ["sources"] = {
      "https://www.warcrafttavern.com/forever/guides/warlock-leveling/",
    },
    ["title"] = "Train Curse of Recklessness",
    ["verified"] = {
      ["forever"] = false,
    },
    ["why"] = "Cancels a Fear that runs the wrong way. Never put it on a mob you intend to Fear.",
  },
  {
    ["classes"] = {
      "WARLOCK",
    },
    ["done_when"] = {
      ["type"] = "manual",
    },
    ["goals"] = {
      "any",
    },
    ["id"] = "warlock-suppression-talents",
    ["kind"] = "talent",
    ["level"] = {
      ["max"] = 19,
      ["min"] = 15,
    },
    ["priority"] = "normal",
    ["sources"] = {
      "https://timesaver.gg/tools/wow-forever/talent-calculator/warlock/affliction",
    },
    ["title"] = "Put the next talent points into Suppression",
    ["verified"] = {
      ["forever"] = false,
    },
    ["why"] = "Hit chance plus reduced threat, which matters while a pet tanks. Maxroll takes four points at 15 to 18.",
  },
  {
    ["classes"] = {
      "WARLOCK",
    },
    ["done_when"] = {
      ["id"] = 5697,
      ["type"] = "spell_known",
      ["verify"] = "probe spell.5697 must read Unending Breath",
    },
    ["goals"] = {
      "any",
    },
    ["id"] = "warlock-train-unending-breath",
    ["kind"] = "train",
    ["level"] = {
      ["max"] = 20,
      ["min"] = 16,
    },
    ["priority"] = "low",
    ["sources"] = {
      "https://www.warcrafttavern.com/forever/guides/warlock-leveling/",
    },
    ["title"] = "Train Unending Breath",
    ["verified"] = {
      ["forever"] = false,
    },
    ["why"] = "Makes the Undead water racial irrelevant and saves drownings in Silverpine and the Barrens.",
  },
  {
    ["classes"] = {
      "WARLOCK",
    },
    ["done_when"] = {
      ["id"] = 693,
      ["type"] = "spell_known",
      ["verify"] = "probe spell.693: ranks renumbered in Forever, ID may differ",
    },
    ["goals"] = {
      "any",
    },
    ["id"] = "warlock-soulstone",
    ["kind"] = "train",
    ["level"] = {
      ["max"] = 22,
      ["min"] = 18,
    },
    ["priority"] = "normal",
    ["sources"] = {
      "https://www.method.gg/wow-forever/wow-forever-warlock-leveling-guide-and-talents",
    },
    ["title"] = "Train Create Soulstone and keep one active",
    ["verified"] = {
      ["forever"] = false,
    },
    ["why"] = "Battle resurrection for you or a friend.",
  },
  {
    ["classes"] = {
      "WARLOCK",
      "MAGE",
      "PRIEST",
    },
    ["done_when"] = {
      ["type"] = "manual",
    },
    ["goals"] = {
      "any",
    },
    ["id"] = "warlock-gravestone-scepter",
    ["kind"] = "item",
    ["level"] = {
      ["max"] = 26,
      ["min"] = 18,
    },
    ["priority"] = "normal",
    ["sources"] = {
      "https://www.method.gg/wow-forever/wow-forever-warlock-leveling-guide-and-talents",
    },
    ["title"] = "Get the Gravestone Scepter from Blackfathom Villainy",
    ["verified"] = {
      ["forever"] = false,
    },
    ["where"] = {
      ["note"] = "Blackfathom Deeps quest",
      ["zone"] = "Ashenvale",
    },
    ["why"] = "29 DPS wand, the best before the mid-twenties. The quest opens at 18; expect to need to be higher.",
  },
  {
    ["classes"] = {
      "WARLOCK",
    },
    ["done_when"] = {
      ["type"] = "manual",
    },
    ["goals"] = {
      "any",
    },
    ["id"] = "warlock-shards-habit",
    ["kind"] = "habit",
    ["level"] = {
      ["max"] = 60,
      ["min"] = 5,
    },
    ["overdue"] = false,
    ["priority"] = "low",
    ["sources"] = {
      "https://www.warcrafttavern.com/forever/guides/warlock-leveling/",
    },
    ["title"] = "Keep two or three spare Soul Shards, never a bag full",
    ["verified"] = {
      ["forever"] = false,
    },
    ["why"] = "Voidwalker, Sayaad and Felhunter summons each cost a shard, and Ritual of Summoning is the only way to summon players. A soul bag fits the reagent slot.",
  },
  {
    ["classes"] = {
      "WARLOCK",
    },
    ["done_when"] = {
      ["id"] = 712,
      ["type"] = "spell_known",
      ["verify"] = "probe spell.712 must read Summon Succubus; add Summon Incubus ID as any_of",
    },
    ["factions"] = {
      "Horde",
    },
    ["goals"] = {
      "any",
    },
    ["id"] = "warlock-sayaad-quest",
    ["kind"] = "quest",
    ["level"] = {
      ["max"] = 24,
      ["min"] = 20,
    },
    ["priority"] = "high",
    ["sources"] = {
      "https://www.warcrafttavern.com/forever/guides/warlock-leveling/",
    },
    ["title"] = "Do the Succubus or Incubus quest: Devourer of Souls or Hearts of the Lovers",
    ["verified"] = {
      ["forever"] = false,
    },
    ["where"] = {
      ["note"] = "Quest starts in the Undercity for Undead",
      ["zone"] = "Undercity",
    },
    ["why"] = "Highest-damage demon and the drain-tanking partner from 30. The Horde chain is eight quests across the Barrens and Stonetalon; grab both flight paths first.",
  },
  {
    ["classes"] = {
      "WARLOCK",
    },
    ["done_when"] = {
      ["id"] = 706,
      ["type"] = "spell_known",
      ["verify"] = "probe spell.706 must read Demon Armor",
    },
    ["goals"] = {
      "any",
    },
    ["id"] = "warlock-train-demon-armor",
    ["kind"] = "train",
    ["level"] = {
      ["max"] = 24,
      ["min"] = 20,
    },
    ["priority"] = "normal",
    ["sources"] = {
      "https://www.method.gg/wow-forever/wow-forever-warlock-leveling-guide-and-talents",
    },
    ["title"] = "Train Demon Armor",
    ["verified"] = {
      ["forever"] = false,
    },
    ["why"] = "Replaces Demon Skin with more armor, shadow resistance and regeneration.",
  },
  {
    ["classes"] = {
      "WARLOCK",
    },
    ["done_when"] = {
      ["id"] = 1490,
      ["type"] = "spell_known",
      ["verify"] = "probe spell.1490 must read Curse of the Elements",
    },
    ["goals"] = {
      "any",
    },
    ["id"] = "warlock-train-curse-of-elements",
    ["kind"] = "train",
    ["level"] = {
      ["max"] = 24,
      ["min"] = 20,
    },
    ["priority"] = "normal",
    ["sources"] = {
      "https://www.warcrafttavern.com/forever/guides/warlock-leveling/",
    },
    ["title"] = "Train Curse of the Elements",
    ["verified"] = {
      ["forever"] = false,
    },
    ["why"] = "A Curse, so it sits next to your Bane. Covers every magic school in Forever; rank 3 at 40 is the opener on big mobs.",
  },
  {
    ["classes"] = {
      "WARLOCK",
    },
    ["done_when"] = {
      ["id"] = 698,
      ["type"] = "spell_known",
      ["verify"] = "probe spell.698 must read Ritual of Summoning",
    },
    ["goals"] = {
      "any",
    },
    ["id"] = "warlock-train-ritual-of-summoning",
    ["kind"] = "train",
    ["level"] = {
      ["max"] = 30,
      ["min"] = 20,
    },
    ["priority"] = "low",
    ["sources"] = {
      "https://www.method.gg/wow-forever/wow-forever-warlock-leveling-guide-and-talents",
    },
    ["title"] = "Train Ritual of Summoning",
    ["verified"] = {
      ["forever"] = false,
    },
    ["why"] = "Meeting Stones no longer summon in Forever, so this is the only way to bring a friend to a dungeon.",
  },
  {
    ["classes"] = {
      "WARLOCK",
    },
    ["done_when"] = {
      ["type"] = "manual",
    },
    ["factions"] = {
      "Horde",
    },
    ["goals"] = {
      "any",
    },
    ["id"] = "warlock-orb-of-soranruk",
    ["kind"] = "quest",
    ["level"] = {
      ["max"] = 30,
      ["min"] = 20,
    },
    ["priority"] = "normal",
    ["sources"] = {
      "https://www.warcrafttavern.com/forever/guides/warlock-leveling/",
    },
    ["title"] = "Pick up The Orb of Soran'ruk from Doan Karhan",
    ["verified"] = {
      ["forever"] = false,
    },
    ["where"] = {
      ["npc"] = "Doan Karhan",
      ["zone"] = "The Barrens",
    },
    ["why"] = "Needs fragments from Blackfathom Deeps and Shadowfang Keep. Rewards a two-hander with 34 Shadow and Fire damage or an off-hand with a heal.",
  },
}
