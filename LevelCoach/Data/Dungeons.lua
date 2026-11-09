local _, ns = ...
ns.Data = ns.Data or {}
ns.Data.Dungeons = {
  {
    ["access"] = "Cleft of Shadow",
    ["level"] = {
      ["max"] = 19,
      ["min"] = 13,
    },
    ["name"] = "Ragefire Chasm",
    ["new"] = false,
    ["zone"] = "Orgrimmar",
  },
  {
    ["access"] = "Horde home dungeon above the Undercity; six Horde quests",
    ["horde_quests_from"] = {
      "Tirisfal Glades",
      "Silverpine Forest",
      "Undercity",
    },
    ["level"] = {
      ["max"] = 20,
      ["min"] = 15,
    },
    ["name"] = "Ruins of Lordaeron",
    ["new"] = true,
    ["verify"] = "range 15-20 per wowforeverleveling, 15-22 per wiki",
    ["zone"] = "Undercity",
  },
  {
    ["level"] = {
      ["max"] = 25,
      ["min"] = 19,
    },
    ["name"] = "Wailing Caverns",
    ["new"] = false,
    ["zone"] = "The Barrens",
  },
  {
    ["access"] = "Horde quests from The Sepulcher",
    ["level"] = {
      ["max"] = 29,
      ["min"] = 23,
    },
    ["name"] = "Shadowfang Keep",
    ["new"] = false,
    ["zone"] = "Silverpine Forest",
  },
  {
    ["level"] = {
      ["max"] = 31,
      ["min"] = 25,
    },
    ["name"] = "Blackfathom Deeps",
    ["new"] = false,
    ["zone"] = "Ashenvale",
  },
  {
    ["access"] = "Attunement: Key to the City and Prison Break-In from Magus Wordeen Voidglare in Tarren Mill",
    ["level"] = {
      ["max"] = 33,
      ["min"] = 28,
    },
    ["name"] = "City of Dalaran",
    ["new"] = true,
    ["zone"] = "Alterac Mountains",
  },
}
