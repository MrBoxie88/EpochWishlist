-------------------------------------------------------------------------------
-- EpochWishlist_Items.lua
-- Drop-source data for EpochWishlist.
--
-- HOW TO ADD A NEW ZONE:
--   zone("Zone Name", { boss(...) }, "raid")      -- appears under Raids
--   zone("Zone Name", { boss(...) }, "dungeon")   -- appears under Dungeons
--   zone("Zone Name", { boss(...) }, "set")       -- appears under Sets & Collections
--   Type defaults to "raid" if omitted.
--   No need to edit EpochWishlist.lua at all.
-------------------------------------------------------------------------------

EW_DROP_DATA  = {}
EW_ZONE_TYPE  = {}   -- [zoneName] = "raid" | "dungeon" | "set"

-- Helper: register all items for a boss into EW_DROP_DATA
local function zone(zoneName, bossList, zoneType)
    EW_ZONE_TYPE[zoneName] = zoneType or "raid"
    local em = "—"
    for _, b in ipairs(bossList) do
        for _, it in ipairs(b.items) do
            EW_DROP_DATA[it.id] = {
                source = b.name .. " " .. em .. " " .. zoneName,
                chance = it.chance,
            }
        end
    end
end

local function boss(bossName, items)
    return { name=bossName, items=items }
end

local function item(id, name, chance)
    return { id=id, name=name, chance=chance }
end

-- =====================================================================
--  R A I D S
-- =====================================================================

-- =====================================================================
--boss("Flamewaker Bosses", {
--        item( 16808, "Flamewaker Legplates", nil),
--   }),
--    boss("Magmadar", {
--        item( 17102, "Core Hound Tooth", nil),
--        item( 17111, "Striker's Mark", nil),
--        item( 17106, "Bonereaver's Edge", nil),
--        item( 17107, "Talisman of Binding Shard", nil),
--    }),
--    boss("Garr", {
--        item( 17105, "Binding of the Windseeker (Left)", nil),
--        item( 17104, "Earthshaker", nil),
--        item( 17112, "Obsidian Edged Blade", nil),
--    }),
--    boss("Baron Geddon", {
--        item( 17103, "Binding of the Windseeker (Right)", nil),
--        item( 17113, "Mana Igniting Cord", nil),
--        item( 17114, "Hammer of the Northern Wind", nil),
--        item( 17101, "Elemental Mage Staff", nil),
--        item( 17099, "Corehound Belt", nil),
--    }),
--    boss("Shazzrah", {
--        item( 16802, "Arcanist Gloves", nil),
 --       item( 16809, "Staff of Dominance", nil),
 --       item( 17098, "Spinal Reaper", nil),
  --  }),
    --boss("Golemagg", {
      --  item( 17109, "Sulfuron Ingot", nil),
        --item( 17076, "Aged Core Leather Gloves", nil),
        --item( 17100, "Onslaught Girdle", nil),
        --item( 17096, "Flamewaker Priest's Mantle", nil),
    --}),
    --boss("Sulfuron Harbinger", {
      --  item( 17097, "Sulfuron Hammer (legendary mat)", nil),
      --  item( 17095, "Helm of Latent Power", nil),
    --}),
    --boss("Majordomo Executus", {
     --   item( 17063, "Eye of Divinity", nil),
     --   item( 17050, "Ancient Petrified Leaf", nil),
      --  item( 17058, "Fireproof Cloak", nil),
       -- item( 17064, "Manastorm Leggings", nil),
    --}),
    --boss("Ragnaros", {
     --   item( 17204, "Eye of Sulfuras", nil),
      --  item( 17182, "Perdition's Blade", nil),
       -- item( 17168, "Shard of the Flame", nil),
       -- item( 17177, "Lok'delar, Stave of the Ancient Keepers", nil),
       -- item( 17178, "Rhok'delar, Longbow of the Ancient Keepers", nil),
       -- item( 17179, "Dragonstalker's Legguards (T2 legs)", nil),
       -- item( 16940, "Stormrage Legguards (T2 legs)", nil),
       -- item( 16938, "Netherwind Pants (T2 legs)", nil),
       -- item( 16936, "Nightslayer Pants (T2 legs)", nil),
       -- item( 16934, "Lawbringer Legplates (T2 legs)", nil),
       -- item( 16932, "Lightforge Legplates (T2 legs)", nil),
       -- item( 16930, "Earthfury Legguards (T2 legs)", nil),
       -- item( 16928, "Giantstalker's Leggings (T2 legs)", nil),
       -- item( 16926, "Felheart Pants (T2 legs)", nil),
       -- item( 16924, "Cenarion Leggings (T2 legs)", nil),
       -- item( 16922, "Arcanist Leggings (T2 legs)", nil),
    --}),
    --boss("MC Trash", {
      --  item( 16941, "Cenarion Bracers", nil),
       -- item( 16942, "Earthfury Bracers", nil),
       -- item( 16944, "Felheart Bracers", nil),
       -- item( 16946, "Giantstalker Bracers", nil),
       -- item( 16948, "Lawbringer Bracers", nil),
       -- item( 16950, "Lightforge Bracers", nil),
       -- item( 16952, "Netherwind Bracers", nil),
       -- item( 16954, "Nightslayer Bracers", nil),
       -- item( 16956, "Stormrage Bracers", nil),
    --}),
--})

-- =====================================================================
zone("Onyxia's Lair", {
    boss("Ortorg the Ardent", {
        item( 61794, "Ashen Belt of Might", nil),
        item( 61657, "Ashen Bracers of Might", nil),
        item( 61796, "Ashen Giantstalker's Belt", nil),
        item( 61659, "Ashen Giantstaler's Bracers", nil),
        item( 61795, "Ashen Easrthfury Belt", nil),
        item( 61658, "Ashen Earthfury Bracers", nil),
        item( 61797, "Ashen Nightslayer Belt", nil),
        item( 61660, "Ashen Nightslayer Bracelets", nil),

        item( 61802, "Cuffs of Malevolence", nil),
        item( 61800, "Chain Slippers of the Caldera", nil),
        item( 61799, "Boots of Vitriol", nil),
        item( 61811, "Heatproof Escutcheon", nil),
        item( 18202, "Eskhandar's Left Claw", nil),
        item( 61828, "Premonition", nil),
        item( 61806, "Dragon Slayer's Sword", nil),
    }),
    boss("Atressian", {
        item( 61832, "Scorched Cenarion Belt", nil),
        item( 61745, "Scorched Cenarion Bracers", nil),
        item( 61831, "Scorched Arcanist Belt", nil),
        item( 61744, "Scorched Arcanist Bindings", nil),
        item( 61795, "Ashen Earthfury Belt", nil),
        item( 61658, "Ashen Earthfury Bracers", nil),
        item( 61834, "Scorched Felheart Bracer", nil),
        item( 61747, "Scorched Felheart Bracers", nil),

        item( 61830, "Sapphiron Drape", nil),
        item( 61838, "Woven Shadowthread Chemise", nil),
        item( 61798, "Boots of contempt", nil),
        item( 61809, "Faceted Beryl Palm Stone", nil),
        item( 61793, "Ancient Cornerstone Grimoire", nil),
        item( 61837, "Vis'kag, the Bloodletter", nil),
    }),
    boss("Onyxia", {
        item( 18205, "Eskhandar's Collar", 21),
        item( 61807, "Dragon's Blood Cape", nil),
        item( 61835, "Shroud of the Cloaked Mists", nil),
        item( 61810, "Fury of the Black Flight", nil),
        item( 61805, "Draconic Focusing Leystone", nil),
        item( 17064, "Shard of the Scale", 6),
        item( 90505, "Broodmother's Eye", nil),
        item( 17966, "Onyxia Hide Backpack", nil),
        item( 61808, "Effigy of the Dragon Worshippers", nil),
        item( 61804, "Deathbringer", nil),
        item( 90504, "Roh'umir il Lronash", nil),

        item( 61774, "Helm of the Glorious Champion", 33.33),
        item( 61780, "Helm of the Glorious Defender", 33.33),
        item( 61786, "Helm of the Glorious Hero", 33.33),
    }),
}, "raid")

-- =====================================================================
--zone("Blackwing Lair", {
  --  boss("Vaelastrasz", {
  --      item( 19384, "Crul'shorukh, Edge of Chaos", nil),
 --   }),
 --   boss("Nefarian", {
 --       item( 19019, "Ashkandi, Greatsword of the Brotherhood", nil),
--}),
--})

-- zone("Zul'Gurub", {
--     boss("Boss Name", {
--         item(00000, "Item Name"),
--     }),
-- })

-- zone("AQ20", {
--     boss("Boss Name", {
--         item(00000, "Item Name"),
--     }),
-- })

-- zone("AQ40", {
--     boss("Boss Name", {
--         item(00000, "Item Name"),
--     }),
-- })

-- zone("Naxxramas", {
--     boss("Boss Name", {
--         item(00000, "Item Name"),
--     }),
-- })

-- =====================================================================
--  D U N G E O N S
-- =====================================================================

-- =====================================================================
-- =====================================================================
zone("Ragefire Chasm", {
    boss("Taragaman the Hungerer", {
        item( 14149, "Subterranean Cape", 31.59),
        item( 14148, "Crystalline Cuffs", 33.91),
        item( 14145, "Cursed Felblade", 15.98),
        item( 60427, "Felguard Sash", nil),
    }),
    boss("Jergosh the Invoker", {
        item( 14150, "Robe of Evocation", 36.4),
        item( 14147, "Cavedweller Bracers", 34.35),
        item( 14151, "Chanting Blade", 17.1),
    }),
    boss("Zelemar the Wrathful", {
    }),
    boss("Bazzalan", {
        item( 60425, "Bazzalan´s Shroud", nil),
        item( 60429, "Knives of the Satyr", nil),
        item( 60430, "Satyrchain Epaulets", nil),
    }),
}, "dungeon")

-- =====================================================================
zone("The Deadmines", {
    boss("Rizzo", {
        item(  61914, "Scabbers", nil),
    }),
    boss("Rhahk'Zor", {
        item(  5187, "Rhahk'Zor's Hammer", 77.98),
        item(  872, "Rockslicer", 3.13),
    }),
    boss("Miner Johnson", {
        item(  5444, "Miner's Cape", 54.88),
        item(  5443, "Gold-plated Buckler", 37.21),
    }),
    boss("Sneed", {
        item(  5195, "Gold-flecked Gloves", 62.38),
        item(  5194, "Taskmaster Axe", 26.23),
    }),
    boss("Sneed's Shredder", {
        item(  2169, "Buzzer Blade", 70.78),
        item(  1937, "Buzz Saw", 8.75),
        item(  7365, "Gnoam Sprecklesprocket", 100),
    }),
    boss("Gilnid", {
        item(  5199, "Smelting Pants", 51.37),
        item(  1156, "Lavishly Jeweled Ring", 35.02),
    }),
    boss("Mr. Smite", {
        item(  5192, "Thief's Blade", 34.96),
        item(  5196, "Smite's Reaver", 33.95),
        item(  7230, "Smite's Mighty Hammer", 17.27),
        item(  60280, "Wind-Up Cannon", nil),
    }),
    boss("Scinti", {
        item(  60277, "Emberlicked Greavesr", nil),
        item(  60278, "Tinfire Blades", nil),
        item(  60279, "Twinkling Cape", nil),
        item(  61913, "Eternal Ember", nil),
    }),
    boss("Captain Greenskin", {
        item(  10403, "Blackened Defias Belt", 23.62),
        item(  5200, "Impaling Harpoon", 25.39),
        item(  5201, "Emberstone", 34.10),
    }),
    boss("Edwin VanCleef", {
        item(  5193, "Cape of the Brotherhood", 21.25),
        item(  5202, "Corsair's Overshirt", 22.86),
        item(  7997, "Red Defias Mask", nil),
        item(  10399, "Blackened Defias Armor", 14.77),
        item( 5191, "Cruel Barb", 14.17),    
        item( 5203, "An Unsent Letter", 100),    
        item( 3637, "Head of VanCleef", 100),    
    }),
}, "dungeon")

-- =====================================================================
zone("Wailing Caverns", {
    boss("Kresh", {
        item( 13245, "Kresh's Back", 9.17),
        item(  6447, "Worn Turtle Shell Shield", 63.66),
    }),
    boss("Lady Anacondra", {
        item(  5404, "Serpent's Shoulders", 58.61),
        item( 10412, "Belt of the Fang", 8.63),
    }),
    boss("Skum", {
        item(  6449, "Glowing Lizardscale Cloak", 38.24),
        item(  6448, "Tail Spike", 39.24),
    }),
    boss("Lord Pythas", {
        item(  6472, "Stinging Viper", 28.24),
        item(  6473, "Armor of the Fang", 52.06),
    }),
    boss("Verdan the Everliving", {
        item(  6631, "Living Root", 34.47),
        item(  6630, "Seedcloud Buckler", 35.38),
        item(  6629, "Sporid Cape", 16.65),
    }),
    boss("Razor", {
        item( 62050, "Raptor Claws", nil),
        item( 62051, "Raptor Spaulders", nil),
    }),
    boss("Lord Cobrahn", {
        item( 10410, "Leggings of the Fang", 16.03),
        item(  6460, "Cobrahn's Grasp", 16.2),
        item(  6465, "Robe of the Moccasin", 51.73),
    }),
    boss("Nyx", {
        item(  5243, "Firebelcher", 39.65),
        item( 62049, "Emerald Amulet", nil),
        item(  6632, "Feyscale Cloak", 37.84),
    }),
    boss("Lord Serpentis", {
        item(  6469, "Venomstrike", 16.63),
        item(  5970, "Serpent Gloves", 20.96),
        item( 10411, "Footpads of the Fang", 19.07),
        item(  6459, "Savage Trodders", 24.39),
    }),
    boss("Muggugaj", {
        item(  6461, "Slime-encrusted Pads", 22.96),
        item(  6627, "Mutant Scale Breastplate", 18.33),
        item(  6463, "Deep Fathom Ring", 21.99),
    }),
    boss("Mutanus the Devourer", {
        item( 10413, "Gloves of the Fang", 1.2),
    }),
}, "dungeon")

-- =====================================================================
zone("Shadowfang Keep", {
    boss("Rethilgore", {
        item(  5254, "Rugged Spaulders", 84.73),
    }),
    boss("Razorclaw the Butcher", {
        item(  1292, "Butcher's Cleaver", 8.7),
        item(  6226, "Bloody Apron", 39.47),
        item(  6633, "Butcher's Slicer", 39.53),
    }),
    boss("Felsteed", {
        item(  6341, "Eerie Stable Lantern", 5.48),
    }),
    boss("Baron Silverlaine", {
        item(  6321, "Silverlaine's Family Seal", 18.91),
        item(  6323, "Baron's Scepter", 37.93),
    }),
    boss("Steward Graves", {
        item( 60470, "Graves Rod", nil),
        item( 60469, "Belt of Service", nil),
    }),
    boss("Commander Springvale", {
        item(  6320, "Commander's Crest", 27.71),
        item(  3191, "Arced War Axe", 31.73),
    }),
    boss("Odo the Blindwatcher", {
        item(  6318, "Odo's Ley Staff", 29.97),
        item(  6319, "Girdle of the Blindwatcher", 57.15),
    }),
    boss("Wolf Master Nandos", {
        item(  3748, "Feline Mantle", 48.55),
        item(  6314, "Wolfmaster Cape", 33.25),
    }),
    boss("Deathsworn Captain", {
        item(  6642, "Phantom Armor", 30.49),
        item(  6641, "Haunting Blade", 58.6),
    }),
    boss("Fenrus the Devourer", {
        item( 60471, "Helm of the Devourer", nil),
        item(  6340, "Fenrus' Hide", 58.02),
        item(  3230, "Black Wolf Bracers", 14.76),
    }),
    boss("Archmage Arugal", {
        item(  6324, "Robes of Arugal", 30.5),
        item(  6392, "Belt of Arugal", 30.51),
        item(  6220, "Meteor Shard", 15.78),
        item( 60472, "Orb of Arugal", nil),
    }),
    boss("Arugal's Voidwalker", {
        item(  5943, "Rift Bracers", 3.0),
    }),
    boss("Trash Mobs", {
        item(  2292, "Necrology Robes", 0.01),
        item(  1974, "Mindthrust Bracers", 0.02),
        item(  1489, "Gloomshroud Armor", 0.01),
        item(  1935, "Assassin's Blade", 0.01),
        item(  1482, "Shadowfang", 0.01),
        item(  2205, "Duskbringer", 0.01),
        item(  2807, "Guillotine Axe", 0.01),
        item(  1318, "Night Reaver", 0.01),
        item(  1483, "Face Smasher", 0.02),
        item(  3194, "Black Malice", 0.02),
        item(  1484, "Witching Stave", 0.01),
    }),
}, "dungeon")

-- =====================================================================
zone("Blackfathom Deeps", {
    boss("Ghamoo-ra", {
        item(  6908, "Ghamoo-ra's Bind", 45.81),
        item(  6907, "Tortoise Armor", 30.59),
    }),
    boss("Baron Aquanis", {
        item( 16886, "Outlaw Sabre", nil),
        item( 16887, "Witch's Finger", nil),
    }),
    boss("Lady Sarevess", {
        item(   888, "Naga Battle Gloves", 33.72),
        item( 11121, "Darkwater Talwar", 33.1),
        item(  3078, "Naga Heartpiercer", 16.87),
    }),
    boss("Gelihast", {
        item(  6906, "Algae Fists", 38.24),
        item(  6905, "Reef Axe", 42.29),
    }),
    boss("Twilight Lord Kelris", {
        item(  6903, "Gaze Dreamer Pants", 31.9),
        item(  1155, "Rod of the Sleepwalker", 45.59),
    }),
    boss("Old Serra'kis", {
        item(  6901, "Glowing Thresher Cape", 36.14),
        item(  6902, "Bands of Serra'kis", 29.24),
        item(  6904, "Bite of Serra'kis", 15.34),
    }),
    boss("Aku'mai", {
        item(  6910, "Leech Pants", 29.72),
        item(  6911, "Moss Cinch", 29.01),
        item(  6909, "Strike of the Hydra", 14.46),
    }),
    boss("Trash Mobs", {
        item(  1486, "Tree Bark Jacket", 0.02),
        item(  3416, "Martyr's Chain", 0.01),
        item(  1491, "Ring of Precision", 0.01),
        item(  3413, "Doomspike", 0.01),
        item(  2567, "Evocator's Blade", 0.02),
        item(  3417, "Onyx Claymore", 0.01),
        item(  1454, "Axe of the Enforcer", 0.01),
        item(  1481, "Grimclaw", 0.01),
        item(  3414, "Crested Scepter", 0.01),
        item(  3415, "Staff of the Friar", 0.02),
        item(  2271, "Staff of the Blessed Seer", 0.02),
    }),
}, "dungeon")

-- =====================================================================
zone("The Stockade", {
    boss("Targorr the Dread", {
        item( 60475, "Bone of Unknown Origins", nil),
        item( 60476, "Dreadpad", nil),
    }),
    boss("Kam Deepfury", {
        item(  2280, "Kam's Walking Stick", 0.62),
        item( 60479, "Spellbuckler", nil),
    }),
    boss("Hamhock", {
        item( 60477, "Hamhock´s Cleaver", nil),
        item( 60480, "Wand of Ogrehair", nil),
    }),
    boss("Dextren Ward", {
        item( 60481, "Warden Breastplate", nil),
        item( 60478, "Smuggling Pouch", nil),
    }),
    boss("Bruegal Ironknuckle", {
        item(  3228, "Jimmied Handcuffs", 54.73),
        item(  2942, "Iron Knuckles", 18.18),
        item(  2941, "Prison Shank", 16.05),
    }),
    boss("Bazil Thredd", {
    }),
    boss("Generic Mob", {
        item(  2909, "Red Wool Bandana", nil),
    }),
}, "dungeon")

-- =====================================================================
zone("Gnomeregan", {
    boss("Grubbis & Chomper", {
        item(  9445, "Grubbis Paws", 9.22),
        item( 60398, "Chompers Chomper", nil),
        item( 60399, "Slippery Sole Sandals", nil),
        item( 60400, "Strangely Strong Stone Spear", nil),
        item( 60401, "Trogghide Pads", nil),
    }),
    boss("Electrocutioner 6000", {
        item(  9447, "Electrocutioner Lagnut", 28.44),
        item(  9446, "Electrocutioner Leg", 13.19),
        item(  9448, "Spidertank Oilrag", 28.37),
    }),
    boss("Viscous Fallout", {
        item(  9454, "Acidic Walkers", 54.02),
        item(  9453, "Toxic Revenger", 19.05),
        item(  9452, "Hydrocane", 18.25),
    }),
    boss("Crowd Pummeler 9-60", {
        item(  9449, "Manual Crowd Pummeler", 33.14),
        item(  9450, "Gnomebot Operating Boots", 60.45),
    }),
    boss("Dark Iron Ambassador", {
        item(  9455, "Emissary Cuffs", 33.96),
        item(  9457, "Royal Diplomatic Scepter", 17.79),
        item(  9456, "Glass Shooter", 38.01),
    }),
    boss("Mekgineer Thermaplugg", {
        item(  9492, "Electromagnetic Gigaflux Reactivator", 7.65),
        item(  9461, "Charged Gear", 28.49),
        item(  9459, "Thermaplugg's Left Arm", 18.05),
        item(  9458, "Thermaplugg's Central Core", 28.61),
    }),
    boss("Trash Mobs", {
        item(  9508, "Mechbuilder's Overalls", 0.02),
        item(  9491, "Hotshot Pilot's Gloves", 0.01),
        item(  9509, "Petrolspill Leggings", 0.01),
        item(  9510, "Caverndeep Trudgers", 0.01),
        item(  9490, "Gizmotron Megachopper", 0.01),
        item(  9485, "Vibroblade", 0.01),
        item(  9486, "Supercharger Battle Axe", 0.02),
        item(  9488, "Oscillating Power Hammer", 0.02),
        item(  9487, "Hi-tech Supergun", 0.01),
    }),
}, "dungeon")

-- =====================================================================
zone("Razorfen Kraul", {
    boss("Roogug", {
    }),
    boss("Aggem Thorncurse", {
        item( 61971, "Thorn Spiked Mantle", nil),
        item(  6681, "Thornspike", 12.0),
    }),
    boss("Overlord Ramtusk", {
        item(  6687, "Corpsemaker", 27.79),
        item(  6686, "Tusken Helm", 57.14),
    }),
    boss("Death Speaker Jargba", {
        item(  2816, "Death Speaker Scepter", 7.72),
        item(  6685, "Death Speaker Mantle", 40.42),
        item(  6682, "Death Speaker Robes", 40.52),
        item( 61974, "Death Speaker Cloak", nil),
    }),
    boss("Agathelos the Raging", {
        item(  6691, "Swinetusk Shank", 24.85),
        item(  6690, "Ferine Leggings", 49.21),
        item( 61970, "Raging Mask", nil),
    }),
    boss("Razorfen Spearhide", {
        item(  6679, "Armor Piercer", 43.0),
    }),
    boss("Blind Hunter", {
        item(  6697, "Batwing Mantle", 27.65),
        item(  6695, "Stygian Bone Amulet", 22.24),
        item(  6696, "Nightstalker Bow", 25.12),
    }),
    boss("Earthcaller Halmgar", {
        item(  6689, "Wind Spirit Staff", 42.66),
        item(  6688, "Whisperwind Headdress", 43.75),
    }),
    boss("Charlga Razorflank", {
        item(  6693, "Agamaggan's Clutch", 32.15),
        item(  6692, "Pronged Reaver", 15.43),
        item(  6694, "Heart of Agamaggan", 30.24),
        item( 61973, "Razorfen Trousers", nil),
    }),
    boss("Trash Mobs", {
        item(  2264, "Mantle of Thieves", 0.02),
        item(  1978, "Wolfclaw Gloves", 0.02),
        item(  1488, "Avenger's Armor", 0.01),
        item(  4438, "Pugilist Bracers", 0.01),
        item(  2039, "Plains Ring", 0.02),
        item(   776, "Vendetta", 0.01),
        item(  1727, "Sword of Decay", 0.02),
        item(  1975, "Pysan's Old Greatsword", 0.02),
        item(  1976, "Slaghammer", 0.02),
        item(  2549, "Staff of the Shade", 0.02),
    }),
}, "dungeon")

-- =====================================================================
zone("SM Graveyard", {
    boss("Interrogator Vishas", {
        item(  7682, "Torturing Poker", 5.56),
        item( 60437, "Scarlet Bane", nil),
        item(  7683, "Bloody Brass Knuckles", 66.1),
    }),
    boss("Bloodmage Thalnos", {
        item(  7685, "Orb of the Forgotten Seer", 47.07),
        item( 60437, "Scarlet Bane", nil),
        item(  7684, "Bloodmage Mantle", 48.46),
    }),
    boss("Ironspine", {
        item(  7688, "Ironspine's Ribcage", 32.91),
        item(  7686, "Ironspine's Eye", 40.08),
        item(  7687, "Ironspine's Fist", 20.34),
    }),
    boss("Azshir the Sleepless", {
        item(  7709, "Blighted Leggings", 31.19),
        item(  7731, "Ghostshard Talisman", 32.71),
        item(  7708, "Necrotic Wand", 30.72),
    }),
    boss("Fallen Champion", {
        item(  7691, "Embalmed Shroud", 38.58),
        item(  7690, "Ebon Vise", 37.83),
        item(  7689, "Morbid Dawn", 19.15),
    }),
}, "dungeon")

-- =====================================================================
zone("SM Library", {
    boss("Houndmaster Loksey", {
        item( 61981, "Houndmaster´s Bow", nil),
        item(  7710, "Loksey's Training Stick", 13.96),
        item(  7756, "Dog Training Gloves", 53.66),
        item(  3456, "Dog Whistle", 21.33),
    }),
    boss("Arcanist Doan", {
        item(  7714, "Hypnotic Blade", 39.91),
        item(  7713, "Illusionary Rod", 38.44),
        item( 61980, "Tome of Domination", nil),
        item(  7712, "Mantle of Doan", 41.96),
        item(  7711, "Robe of Doan", 42.86),
    }),
}, "dungeon")

-- =====================================================================
zone("SM Armory", {
    boss("Herod", {
        item(  7719, "Raging Berserker's Helm", 30.62),
        item(  7718, "Herod's Shoulder", 30.82),
        item( 10330, "Scarlet Leggings", 12.75),
        item(  7717, "Ravager", 12.86),
        item( 61976, "Berserker´s Cape", nil),
    }),
    boss("Scarlet Trainee", {
        item( 23192, "Tabard of the Scarlet Crusade", 0.4),
    }),
}, "dungeon")

-- =====================================================================
zone("SM Cathedral", {
    boss("High Inquisitor Fairbanks", {
        item( 19507, "Inquisitor's Shawl", 15.94),
        item( 19508, "Branded Leather Bracers", 16.17),
        item( 19509, "Dusty Mail Boots", 17.24),
        item( 61977, "Mana Twisted Charm", nil),
    }),
    boss("High Inquisitor Whitemane", {
        item(  7720, "Whitemane's Chapeau", 34.01),
        item(  7722, "Triune Amulet", 33.23),
        item(  7721, "Hand of Righteousness", 18.32),
    }),
    boss("Scarlet Commander Mograine", {
        item(  7724, "Gauntlets of Divinity", 17.49),
        item( 10330, "Scarlet Leggings", 12.95),
        item(  7723, "Mograine's Might", 17.13),
        item(  7726, "Aegis of the Scarlet Commander", 38.37),
        item( 61978, "Ring of Hatred", nil),
    }),
}, "dungeon")

-- =====================================================================
zone("Razorfen Downs", {
    boss("Tuten'kash", {
        item( 60434, "Cuffs of the Crypt", nil),
        item( 10776, "Silky Spider Cape", 28.64),
        item( 10777, "Arachnid Gloves", 28.95),
        item( 10775, "Carapace of Tuten'kash", 24.87),
    }),
    boss("Glutton", {
        item( 10774, "Fleshhide Shoulders", 42.15),
        item( 60435, "Putrid Ring", nil),
        item( 10772, "Glutton's Cleaver", 44.22),
    }),
    boss("Ragglesnout", {
        item( 10768, "Boar Champion's Belt", 31.4),
        item( 10758, "X'caliboar", 18.51),
        item( 10767, "Savage Boar's Guard", 35.14),
    }),
    boss("Mordresh Fire Eye", {
        item( 10771, "Deathmage Sash", 27.92),
        item( 60436, "Warmed Boots", nil),
        item( 10769, "Glowing Eye of Mordresh", 29.11),
        item( 10770, "Mordresh's Lifeless Skull", 29.59),
    }),
    boss("Plaguemaw the Rotting", {
        item( 10766, "Plaguerot Sprig", 29.98),
        item( 60432, "Belt of Plaguemaw", nil),
        item( 10760, "Swine Fists", 58.15),
    }),
    boss("Amnennar the Coldbringer", {
        item( 10762, "Robes of the Lich", 29.52),
        item( 60431, "Phylactery of Amnennar", nil),
        item( 10764, "Deathchill Armor", 24.24),
        item( 10763, "Icemetal Barbute", 28.66),
        item( 10761, "Coldrage Dagger", 13.89),
        item( 10765, "Bonefingers", nil),
    }),
    boss("Trash Mobs", {
        item( 10574, "Corpseshroud", 0.01),
        item( 10581, "Death's Head Vestment", 0.02),
        item( 10578, "Thoughtcast Boots", 0.01),
        item( 10583, "Quillward Harness", 0.01),
        item( 10582, "Briar Tredders", 0.02),
        item( 10584, "Stormgale Fists", 0.02),
        item( 10573, "Boneslasher", 0.01),
        item( 10570, "Manslayer", 0.01),
        item( 10571, "Ebony Boneclub", 0.01),
        item( 10567, "Quillshooter", 0.02),
        item( 10572, "Freezing Shard", 0.01),
    }),
}, "dungeon")

-- =====================================================================
zone("Uldaman", {
    boss("Baelog", {
        item(  0, "Nordic Longshank", nil),
        item(  0, "Baelog's Shortbow", nil),
        item(  0, "Conspicuous Urn", nil),
    }),
    boss("Eric 'The Swift'", {
        item(  0, "Horned Viking Helmet", nil),
        item(  0, "Worn Running Boots", nil),
    }),
    boss("Olaf", {
        item(  0, "Olaf's All Purpose Shield", nil),
        item(  0, "Battered Viking Shield", nil),
    }),
    boss("Revelosh", {
        item(  0, "Revelosh's Gloves", nil),
        item(  0, "Revelosh's Spaulders", nil),
        item(  0, "Revelosh's Armguards", nil),
        item(  0, "Revelosh's Boots", nil),
        item(  0, "The Shaft of Tsol", nil),
    }),
    boss("Ironaya", {
        item(  9407, "Stoneweaver Leggings", 31.02),
        item(  9409, "Ironaya's Bracers", 32.71),
        item(  9408, "Ironshod Bludgeon", 17.37),
        item( 60672, "Marred Uldic Hands", nil),
    }),
    boss("Obsidian Sentinel", {
        item( 60673, "Marred Uldic Helm", nil),
    }),
    boss("Ancient Stone Keeper", {
        item(  9410, "Cragfists", 41.61),
        item( 60677, "Regenerative Stone Belt", nil),
        item(  9411, "Rockshard Pauldrons", 43.41),
    }),
    boss("Galgann Firehammer", {
        item(  9412, "Galgann's Fireblaster", 17.1),
        item( 11310, "Flameseer Mantle", 17.35),
        item(  9419, "Galgann's Firehammer", 18.1),
        item( 11311, "Emberscale Cape", 36.52),
    }),
    boss("Grimlok", {
        item( 60674, "Marred Uldic Legplates", nil),
        item(  9415, "Grimlok's Tribal Vestments", 36.51),
        item(  9416, "Grimlok's Charge", 15.05),
        item(  9414, "Oilskin Leggings", 29.78),
    }),
    boss("Archaedas", {
        item( 60671, "Marred Uldic Chestplate", nil),
        item( 11118, "Archaedic Stone", 51.99),
        item(  9418, "Stoneslayer", 10.48),
        item(  9413, "The Rockpounder", 10.94),
        item( 60678, "Tablet of Ancient Wisdom", nil),
    }),
    boss("Mob Trash", {
        item(  9397, "Energy Cloak", 0.01),
        item(  9431, "Papal Fez", 0.01),
        item(  9429, "Miner's Hat of the Deep", 0.01),
        item(  9420, "Adventurer's Pith Helmet", 0.01),
        item(  9406, "Spirewind Fetter", 0.01),
        item(  9428, "Unearthed Bands", 0.01),
        item(  9430, "Spaulders of a Lost Age", 0.0),
        item(  9396, "Legguards of the Vault", nil),
        item(  9432, "Skullplate Bracers", 0.01),
        item(  9393, "Beacon of Hope", 0.01),
        item(  7666, "Shattered Necklace", nil),
        item(  7673, "Talvash's Enhancing Necklace", nil),
        item( 60675, "Marred Uldic Sabatons", nil),
        item( 60676, "Marred Uldic Shoulderpads", nil),
        item(  9384, "Stonevault Shiv", 0.01),
        item(  9392, "Annealed Blade", 0.01),
        item(  9424, "Ginn-su Sword", 0.01),
        item(  9465, "Digmaster 5000", 0.01),
        item(  9383, "Obsidian Cleaver", 0.01),
        item(  9425, "Pendulum of Doom", 0.01),
        item(  9386, "Excavator's Brand", 0.01),
        item(  9427, "Stonevault Bonebreaker", 0.01),
        item(  9423, "The Jackhammer", 0.01),
        item(  9391, "The Shoveler", 0.01),
        item(  9381, "Earthen Rod", 0.01),
        item(  9426, "Monolithic Bow", 0.01),
        item(  9422, "Shadowforge Bushmaster", 0.01),
    }),
}, "dungeon")

-- =====================================================================
zone("Zul'Farrak", {
    boss("Theka the Martyr", {
        item( 62058, "Scarred Leggings", nil),
        item( 62059, "Theka´s Seal of Vigilance", nil),
    }),
    boss("Sezz'ziz", {
        item(  9470, "Bad Mojo Mask", 18.69),
        item(  9473, "Jinxed Hoodoo Skin", 21.12),
        item(  9474, "Jinxed Hoodoo Kilt", 20.95),
        item(  9475, "Diabolic Skiver", 20.06),
    }),
    boss("Chief Ukorz Sandscalp", {
        item(  9479, "Embrace of the Lycan", 8.97),
        item(  9476, "Big Bad Pauldrons", 28.17),
        item(  9478, "Ripsaw", 19.78),
        item(  9477, "The Chief's Enforcer", 22.33),
        item( 11086, "Jang'thraze the Protector", 1.72),
        item(  9372, "Sul'thraze the Lasher", nil),
    }),
    boss("Gahz'rilla", {
        item(  9469, "Gahz'rilla Scale Armor", 36.76),
        item(  9467, "Gahz'rilla Fang", 36.83),
    }),
    boss("Hydromancer Velratha", {
        item( 62054, "Hydromancer´s Crystal", nil),
        item( 62053, "Sandfury Slippers", nil),
        item( 62052, "Sacred Helm", nil),
    }),
    boss("Antu'sul", {
        item(  9640, "Vice Grips", 31.3),
        item(  9641, "Lifeblood Amulet", 30.8),
        item(  9639, "The Hand of Antu'sul", 15.47),
        item(  9379, "Sang'thraze the Deflector", 2.1),
        item(  9372, "Sul'thraze the Lasher", nil),
    }),
    boss("Trash Mobs", {
        item(  9512, "Blackmetal Cape", 0.02),
        item(  9484, "Spellshock Leggings", 0.01),
        item(   862, "Runed Ring", 0.02),
        item(  6440, "Brainlash", 0.01),
        item(  9243, "Shriveled Heart", nil),
        item( 61993, "Canopic Heart", nil),
        item(  9523, "Troll Temper", nil),
        item(  9238, "Uncracked Scarab Shell", nil),
        item(  5616, "Gutwrencher", 0.01),
        item(  9511, "Bloodletter Scalpel", 0.01),
        item(  9481, "The Minotaur", 0.01),
        item(  9480, "Eyegouger", 0.01),
        item(  9482, "Witch Doctor's Cane", 0.01),
        item(  9483, "Flaming Incinerator", 0.01),
        item(  2040, "Troll Protector", 0.02),
    }),
}, "dungeon")

-- =====================================================================
zone("Maraudon", {
    boss("Noxxion", {
        item( 17746, "Noxxion's Shackles", 32.5),
        item( 17744, "Heart of Noxxion", 30.35),
        item( 17745, "Noxious Shooter", 17.53),
        item( 61951, "Vile Twisted Boots", nil),
    }),
    boss("Lord Vyletongue", {
        item( 17755, "Satyrmane Sash", 25.71),
        item( 17754, "Infernal Trickster Leggings", 28.09),
        item( 17752, "Satyr's Lash", 23.14),
        item( 61933, "Intrepid Waistband", nil),
    }),
    boss("Razorlash", {
        item( 61956, "Razor Lined Breastplate", nil),
        item( 17748, "Vinerot Sandals", 20.6),
        item( 17749, "Phytoskin Spaulders", 22.09),
        item( 17751, "Brusslehide Leggings", 21.65),
        item( 17750, "Chloromesh Girdle", 22.93),
    }),
    boss("Meshlok the Harvester", {
        item( 61934, "Fungus Infused Belt", nil),
        item( 17741, "Nature's Embrace", 30.34),
        item( 17742, "Fungus Shroud Armor", 31.37),
        item( 17767, "Bloomsprout Headpiece", 28.32),
    }),
    boss("Celebras the Cursed", {
        item( 61931, "Elemental Trousers", nil),
        item( 17739, "Grovekeeper's Drape", 30.32),
        item( 17740, "Soothsayer's Headdress", 28.59),
        item( 17738, "Claw of Celebras", 28.22),
    }),
    boss("Tinkerer Gizlock", {
        item( 61958, "Tinkerer´s Mantle", nil),
        item( 17719, "Inventor's Focal Sword", 27.44),
        item( 17718, "Gizlock's Hypertech Buckler", 30.61),
        item( 17717, "Megashot Rifle", 27.23),
    }),
    boss("Landslide", {
        item( 61932, "Rock Hardened Pauldrons", nil),
        item( 17736, "Rockgrip Gauntlets", 23.09),
        item( 17734, "Helm of the Mountain", 20.87),
        item( 17737, "Cloud Stone", 19.99),
        item( 17943, "Fist of Stone", 16.58),
    }),
    boss("Rotgrip", {
        item( 17732, "Rotgrip Mantle", 25.73),
        item( 61957, "Rothide Grips", nil),
        item( 17728, "Albino Crocscale Boots", 26.2),
        item( 17730, "Gatorbite Axe", 19.21),
    }),
    boss("Princess Theradras", {
        item( 17780, "Blade of Eternal Darkness", 0.2),
        item( 17715, "Eye of Theradras", 13.47),
        item( 61955, "Theradras´Cuffs", nil),
        item( 17714, "Bracers of the Stone Princess", 20.06),
        item( 17711, "Elemental Rockridge Leggings", 14.96),
        item( 17707, "Gemshard Heart", 15.3),
        item( 17713, "Blackstone Ring", 18.92),
        item( 17710, "Charstone Dirk", 14.24),
        item( 17766, "Princess Theradras' Scepter", 16.44),
    }),
}, "dungeon")

-- =====================================================================
zone("Sunken Temple", {
    boss("Spawn of Hakkar", {
        item( 10801, "Slitherscale Boots", 42.33),
        item( 10802, "Wingveil Cloak", 25.6),
    }),
    boss("Troll Minibosses", {
        item( 10787, "Atal'ai Gloves", 5.25),
        item( 10783, "Atal'ai Spaulders", 3.12),
        item( 10784, "Atal'ai Breastplate", 2.12),
        item( 10785, "Atal'ai Leggings", 4.42),
        item( 10786, "Atal'ai Boots", 6.15),
        item( 10788, "Atal'ai Girdle", 7.17),
    }),
    boss("Atal'alarion", {
        item( 10800, "Darkwater Bracers", 31.73),
        item( 10798, "Atal'alarion's Tusk Ring", 30.53),
        item( 10799, "Headspike", 17.98),
    }),
    boss("Dreamscythe", {
        item( 12465, "Nightfall Drape", 4.42),
        item( 12466, "Dawnspire Cord", 4.16),
        item( 12464, "Bloodfire Talons", 4.99),
        item( 10795, "Drakeclaw Band", 3.68),
        item( 10796, "Drakestone", 4.26),
        item( 10797, "Firebreather", 4.57),
        item( 12463, "Drakefang Butcher", 4.4),
        item( 12243, "Smoldering Claw", 4.5),
    }),
    boss("Weaver", {
        item( 12465, "Nightfall Drape", 4.2),
        item( 12466, "Dawnspire Cord", 3.89),
        item( 12464, "Bloodfire Talons", 4.1),
        item( 10795, "Drakeclaw Band", 4.46),
        item( 10796, "Drakestone", 4.47),
        item( 10797, "Firebreather", 4.08),
        item( 12463, "Drakefang Butcher", 5.0),
        item( 12243, "Smoldering Claw", 4.42),
    }),
    boss("Morphaz", {
        item( 12465, "Nightfall Drape", 4.29),
        item( 12466, "Dawnspire Cord", 4.12),
        item( 12464, "Bloodfire Talons", 4.21),
        item( 10795, "Drakeclaw Band", 4.07),
        item( 10796, "Drakestone", 4.18),
        item( 10797, "Firebreather", 4.24),
        item( 12463, "Drakefang Butcher", 4.35),
        item( 12243, "Smoldering Claw", 4.09),
    }),
    boss("Hazzas", {
        item( 12465, "Nightfall Drape", 4.48),
        item( 12466, "Dawnspire Cord", 4.46),
        item( 12464, "Bloodfire Talons", 5.0),
        item( 10795, "Drakeclaw Band", 4.18),
        item( 10796, "Drakestone", 4.92),
        item( 10797, "Firebreather", 4.5),
        item( 12463, "Drakefang Butcher", 4.58),
        item( 12243, "Smoldering Claw", 4.56),
    }),
    boss("Avatar of Hakkar", {
        item( 12462, "Embrace of the Wind Serpent", 0.15),
        item( 10843, "Featherskin Cape", 31.12),
        item( 10842, "Windscale Sarong", 33.22),
        item( 10846, "Bloodshot Greaves", 32.44),
        item( 10845, "Warrior's Embrace", 30.44),
        item( 10838, "Might of Hakkar", 16.37),
        item( 10844, "Spire of Hakkar", 16.02),
    }),
    boss("Jammal'an the Prophet", {
        item( 10806, "Vestments of the Atal'ai Prophet", 24.13),
        item( 10808, "Gloves of the Atal'ai Prophet", 26.74),
        item( 10807, "Kilt of the Atal'ai Prophet", 23.0),
    }),
    boss("Ogom the Wretched", {
        item( 10805, "Eater of the Dead", 28.27),
        item( 10804, "Fist of the Damned", 30.03),
        item( 10803, "Blade of the Wretched", 28.21),
    }),
    boss("Shade of Eranikus", {
        item( 10847, "Dragon's Call", 0.18),
        item( 10833, "Horns of Eranikus", 25.66),
        item( 10829, "Dragon's Eye", 27.02),
        item( 10828, "Dire Nail", 10.91),
        item( 10837, "Tooth of Eranikus", 10.05),
        item( 10835, "Crest of Supremacy", 19.17),
        item( 10836, "Rod of Corrosion", 21.54),
    }),
}, "dungeon")

-- =====================================================================
zone("Blackrock Depths", {
    boss("Lord Roccor", {
        item( 22234, "Mantle of Lost Hope", 20.48),
        item( 11632, "Earthslag Shoulders", 19.99),
        item( 22397, "Idol of Ferocity", 19.58),
        item( 11631, "Stoneshell Guard", 22.06),
        item( 60245, "Moss-hewn Mace", nil),
        item( 60227, "Earth Lord´s Chain Cap", nil),
        item( 11630, "Rockshard Pellets", 16.82),
    }),
    boss("High Interrogator Gerstahn", {
        item( 11626, "Blackveil Cape", 15.98),
        item( 11624, "Kentic Amice", 22.45),
        item( 22240, "Greaves of Withering Despair", 16.81),
        item( 11625, "Enthralled Sphere", 23.14),
        item( 60224, "Circlet of Ill Intent", nil),
        item( 60234, "Gauntlets of Mercy", nil),
    }),
    boss("Ring of Law - Anub'shiah", {
        item( 11677, "Graverot Cape", 23.07),
        item( 11675, "Shadefiend Boots", 25.84),
        item( 11731, "Savage Gladiator Greaves", 15.14),
        item( 11678, "Carapace of Anub'shiah", 15.78),
    }),
    boss("Ring of Law - Eviscerator", {
        item( 11685, "Splinthide Shoulders", 24.49),
        item( 11686, "Girdle of Beastial Fury", 15.85),
        item( 11679, "Rubicund Armguards", 25.13),
        item( 11730, "Savage Gladiator Grips", 14.12),
    }),
    boss("Ring of Law - Gorosh the Dervish", {
        item( 11726, "Savage Gladiator Chain", 14.52),
        item( 22271, "Leggings of Frenzied Magic", 23.24),
        item( 11729, "Savage Gladiator Helm", 10.08),
        item( 22257, "Bloodclot Band", 26.28),
        item( 22266, "Flarethorn", 17.98),
    }),
    boss("Ring of Law - Grizzle", {
        item( 22257, "Bloodclot Band", 26.28),
        item( 22266, "Flarethorn", 17.98),
        item( 22270, "Entrenching Boots", 11.97),
        item( 11702, "Grizzle's Skinner", 20.62),
    }),
    boss("Ring of Law - Hedrum the Creeper", {
        item( 11634, "Silkweb Gloves", 24.02),
        item( 11633, "Spiderfang Carapace", 20.61),
        item( 11635, "Hookfang Shanker", 17.26),
    }),
    boss("Ring of Law - Ok'thor the Breaker", {
        item( 11662, "Ban'thok Sash", 23.77),
        item( 11665, "Ogreseer Fists", 28.16),
        item( 11728, "Savage Gladiator Leggings", 14.95),
        item( 11824, "Cyclopean Band", 18.37),
    }),
    boss("Ring of Law - Twitches", {
        item( 0, "Used Abomination Stitching", nil),
    }),
    boss("Ring of Law - Zuul", {
        item( 0, "Devilsaur's Right Claws", nil),
        item( 0, "Gavel of Gozer", nil),
    }),
    boss("Ring of Law - Mecha-Chicken 3000", {
        item( 0, "Refillable Egg", nil),
        item( 0, "Mecha X-850 'Squawker' Rifle", nil),
        item( 0, "Gallus Robes", nil),
    }),
    boss("Theldren", {
        item( 22330, "Shroud of Arcane Mastery", 19.73),
        item( 22305, "Ironweave Mantle", 30.39),
        item( 22317, "Lefty's Brass Knuckle", 26.15),
        item( 22318, "Malgen's Long Bow", 22.88),
    }),
    boss("Houndmaster Grebmar", {
        item( 11623, "Spritecaster Cape", 32.09),
        item( 11626, "Blackveil Cape", 0.6),
        item( 11627, "Fleetfoot Greaves", 32.09),
        item( 11628, "Houndmaster's Bow", 12.14),
        item( 11629, "Houndmaster's Rifle", 11.18),
        item( 60266, "Wolf-fang Slicer", nil),
        item( 60218, "Bouquet of Dogwood Blossoms", nil),
    }),
    boss("Pyromancer Loregrain", {
        item( 11747, "Flamestrider Robes", 18.1),
        item( 11749, "Searingscale Leggings", 21.29),
        item( 11750, "Kindling Stave", 16.19),
        item( 11748, "Pyric Caduceus", 30.2),
    }),
    boss("The Vault", {
        item( 0, "Mana Shaping Handwraps", nil),
        item( 0, "Haunting Specter Leggings", nil),
        item( 0, "Deathdealer Breastplate", nil),
        item( 0, "Black Steel Bindings", nil),
        item( 0, "Magma Forged Band", nil),
        item( 0, "Wraith Scythe", nil),
        item( 0, "The Hammer of Grace", nil),
        item( 0, "Wand of Eternal Light", nil),
    }),
    boss("Dark Coffer", {
        item( 0, "Depths Warding Torch", nil),
    }),
    boss("Warder Stilgiss", {
        item( 11782, "Boreal Mantle", 18.38),
        item( 22241, "Dark Warder's Pauldrons", 18.38),
        item( 11783, "Chillsteel Girdle", 20.5),
        item( 11784, "Arbiter's Blade", 21.54),
        item( 60222, "Chillorb Icestaff", nil),
        item( 60264, "Warden's Frost Ward", nil),
    }),
    boss("Verek", {
        item( 22242, "Verek's Leash", 9.78),
        item( 11755, "Verek's Collar", 9.54),
    }),
    boss("Doomgrip", {
        item( 60226, "Doomgrip´s Truncheon", nil),
        item( 60214, "Arcane Locksmith´s Drape", nil),
        item( 60258, "Thief Catcher's Signet", nil),
    }),
    boss("Fineous Darkvire", {
        item( 11839, "Chief Architect's Monocle", 15.28),
        item( 11841, "Senior Designer's Pantaloons", 21.25),
        item( 11842, "Lead Surveyor's Mantle", 20.83),
        item( 22223, "Foreman's Head Protector", 19.73),
        item( 60255, "Staff of Sacred Stars", nil),
        item( 60252, "Shoulderpads of Civic Planning", nil),
        item( 11840, "Master Builder's Shirt", 3.9),
    }),
    boss("Lord Incendius", {
        item( 60238, "Incendius´s Heart", nil),
        item( 60261, "Unmelting Chain", nil),
        item( 11768, "Incendic Bracers", 1.3),
        item( 11766, "Flameweave Cuffs", 18.88),
        item( 11764, "Cinderhide Armsplints", 18.33),
        item( 11765, "Pyremail Wristguards", 18.85),
        item( 11767, "Emberplate Armguards", 19.24),
    }),
    boss("Golem Lord Argelmach", {
        item( 11822, "Omnicast Boots", 26.73),
        item( 11823, "Luminary Kilt", 25.73),
        item( 11669, "Naglering", 22.92),
        item( 11819, "Second Wind", 5.75),
        item( 60241, "Lightning Conductor", nil),
    }),
    boss("Bael'Gar", {
        item( 11807, "Sash of the Burning Heart", 13.59),
        item( 11802, "Lavacrest Leggings", 26.75),
        item( 11805, "Rubidium Hammer", 17.02),
        item( 11803, "Force of Magma", 27.47),
        item( 60219, "Chain of Charged Stones", nil),
        item( 60221, "Chestplate of Cleansing Earth", nil),
    }),
    boss("General Angerforge", {
        item( 11821, "Warstrife Leggings", 16.41),
        item( 11820, "Royal Decorated Armor", 18.55),
        item( 11810, "Force of Will", 12.97),
        item( 11817, "Lord General's Sword", 14.72),
        item( 11816, "Angerforge's Battle Axe", 16.41),
        item( 60230, "Epaulets of the Dwarven Champion", nil),
        item( 60244, "Medic´s Suturing Blade", nil),
    }),
    boss("The Grim Guzzler - Hurley Blackbreath", {
        item( 0, "Ragefury Eyepatch", nil),
        item( 0, "Coal Miner Boots", nil),
        item( 0, "Firemoss Boots", nil),
        item( 0, "Hurley's Tankard", nil),
        item( 0, "Wand of Zealotry", nil),
        item( 0, "Torch of Eternal Justice", nil),
    }),
    boss("The Grim Guzzler - Phalanx", {
        item( 0, "Phalanx's Core-Plate", nil),
        item( 0, "Golem Fitted Pauldrons", nil),
        item( 0, "Fists of Phalanx", nil),
        item( 0, "Bloodfist", nil),
        item( 0, "Auto-Repairing Restraints", nil),
    }),
    boss("The Grim Guzzler - Ribbly Screwspigot", {
        item( 60248, "Ribbly's Boomstick", nil),
        item( 60257, "Tears of the Charlatan Saint", nil),
        item( 60247, "Ribbly's Blackened Armor", nil),
        item( 60225, "Decorative Vial of Antivenom", nil),
        item(  2662, "Ribbly's Quiver", 17.03),
        item(  2663, "Ribbly's Bandolier", 15.73),
    }),
    boss("The Grim Guzzler - Plugger Spazzring", {
        item( 60256, "Stave of All-Purpose Magic", nil),
        item( 60216, "Bartender´s Bracers", nil),
        item( 12793, "Mixologist's Tunic", 24.87),
        item( 12791, "Barman Shanker", 6.97),
    }),
    boss("Ambassador Flamelash", {
        item( 11808, "Circle of Flame", 0.84),
        item( 11812, "Cape of the Fire Salamander", 25.25),
        item( 11814, "Molten Fists", 27.88),
        item( 11832, "Burst of Knowledge", 14.61),
        item( 11809, "Flame Wrath", 18.69),
        item( 60254, "Staff of Fiery Diplomacy", nil),
        item( 60217, "Boots of Natural Fire", nil),
    }),
    boss("Panzor the Invincible", {
        item( 22245, "Soot Encrusted Footwear", 22.06),
        item( 11787, "Shalehusk Boots", 19.96),
        item( 11786, "Stone of the Earth", 20.38),
        item( 11785, "Rock Golem Bulwark", 21.22),
    }),
    boss("Summoner's Tomb", {
        item( 60251, "Shield of Sevens", nil),
        item( 11929, "Haunting Specter Leggings", 22.6),
        item( 11925, "Ghostshroud", 21.63),
        item( 11926, "Deathdealer Breastplate", 22.08),
        item( 11927, "Legplates of the Eternal Guardian", 65.45),
        item( 11922, "Blood-etched Blade", 22.05),
        item( 11920, "Wraith Scythe", 22.61),
        item( 11923, "The Hammer of Grace", 21.29),
        item( 11921, "Impervious Giant", 22.23),
        item( 60231, "Exorcist´s Hammer", nil),
        item( 60249, "Sacred Spectral Raiment", nil),
    }),
    boss("Magmus", {
        item( 11746, "Golem Skull Helm", 20.46),
        item( 11935, "Magmus Stone", 21.26),
        item( 22395, "Totem of Rage", 10.09),
        item( 22400, "Libram of Truth", 9.75),
        item( 22208, "Lavastone Hammer", 22.79),
        item( 60242, "Magma-Heated Iron Rod", nil),
        item( 60236, "Giant-Forged Shoulderguards", nil),
    }),
    boss("Emperor Dagran Thaurissan", {
        item( 11684, "Ironfoe", 0.46),
        item( 11930, "The Emperor's New Cape", 16.16),
        item( 11924, "Robes of the Royal Crown", 15.18),
        item( 22204, "Wristguards of Renown", 12.92),
        item( 22207, "Sash of the Grand Hunt", 15.12),
        item( 11933, "Imperial Jewel", 15.99),
        item( 11934, "Emperor's Seal", 15.41),
        item( 11815, "Hand of Justice", 10.43),
        item( 60239, "Iron Cloak of Magic", nil),
        item( 60237, "Greaves of the Deep Light", nil),
        item( 60220, "Charm of Righteous Anger", nil),
        item( 11931, "Dreadforge Retaliator", 15.76),
        item( 11932, "Guiding Stave of Wisdom", 15.01),
        item( 11928, "Thaurissan's Royal Scepter", 12.86),
    }),
    boss("Princess", {
        item( 12554, "Hands of the Exalted Herald", 11.91),
        item( 12556, "High Priestess Boots", 10.26),
        item( 12557, "Ebonsteel Spaulders", 12.11),
        item( 12553, "Swiftwalker Boots", 11.05),
    }),
    boss("Trash", {
        item( 12552, "Blisterbane Wrap", 0.01),
        item( 12551, "Stoneshield Cloak", 0.01),
        item( 12542, "Funeral Pyre Vestment", 0.02),
        item( 12546, "Aristocratic Cuffs", 0.01),
        item( 12550, "Runed Golem Shackles", 0.02),
        item( 12547, "Mar Alom's Grip", 0.01),
        item( 12549, "Braincage", 0.02),
        item( 12555, "Battlechaser's Greaves", 0.01),
        item( 12531, "Searing Needle", 0.02),
        item( 12535, "Doomforged Straightedge", 0.01),
        item( 12527, "Ribsplitter", 0.02),
        item( 12528, "The Judge's Gavel", 0.02),
        item( 12532, "Spire of the Stoneshaper", 0.01),
    }),
}, "dungeon")

-- =====================================================================
zone("LBRS", {
    boss("Spirestone Butcher (Rare)", {
        item( 12608, "Butcher's Apron", 54.31),
        item( 13286, "Rivenspike", 35.78),
    }),
    boss("Spirestone Battle Lord (Rare)", {
        item( 13284, "Swiftdart Battleboots", 48.68),
        item( 13285, "The Blackrock Slicer", 34.87),
    }),
    boss("Spirestone Lord Magus (Rare)", {
        item( 13282, "Ogreseer Tower Boots", 22.95),
        item( 13283, "Magus Ring", 38.01),
        item( 13261, "Globe of D'sak", 18.07),
    }),
    boss("Highlord Omokk", {
        item( 60412, "Highlord´s Epaulet of Hittin´ Gud", nil),
        item( 13170, "Skyshroud Leggings", 8.52),
        item( 13169, "Tressermane Leggings", 9.52),
        item( 13168, "Plate of the Shaman King", 8.62),
        item( 13166, "Slamshot Shoulders", 7.25),
        item( 13167, "Fist of Omokk", 10.64),
        item( 60403, "Bloodrager", nil),
        item( 16670, "Boots of Elements", 9.35),
    }),
    boss("Shadow Hunter Vosh'gajin", {
        item( 12626, "Funeral Cuffs", 18.74),
        item( 13257, "Demonic Runed Spaulders", 16.84),
        item( 13255, "Trueaim Gauntlets", 18.08),
        item( 12651, "Blackcrow", 8.56),
        item( 12653, "Riphook", 7.99),
        item( 12654, "Doomshot", 23.06),
        item( 60417, "Shadow Hunter´s Salve", nil),
        item( 60419, "Wand of Forest Magic", nil),
        item( 16712, "Shadowcraft Gloves", 11.89),
    }),
    boss("War Master Voone", {
        item( 60421, "Warmaster´s Cuirass", nil),
        item( 22231, "Kayser's Boots of Precision", 15.4),
        item( 13179, "Brazecore Armguards", 16.12),
        item( 13177, "Talisman of Evasion", 15.4),
        item( 12582, "Keris of Zul'Serak", 8.08),
        item( 13173, "Flightblade Throwing Axe", 79.85),
        item( 60419, "Wand of Forest Magic", nil),
        item( 16676, "Beaststalker's Gloves", 9.15),
    }),
    boss("Mor Grayhoof (Summon)", {
        item( 22306, "Ironweave Belt", 20.28),
        item( 22325, "Belt of the Trickster", 20.28),
        item( 22319, "Tome of Divine Right", 20.81),
        item( 22398, "Idol of Rejuvenation", 12.87),
        item( 22322, "The Jaw Breaker", 20.28),
    }),
    boss("Bannok Grimaxe (Rare)", {
        item( 0, "Chiselbrand Girdle", nil),
        item( 0, "Backusarian Gauntlets", nil),
        item( 0, "Demonfork", nil),
        item( 0, "Arcanite Reaper", nil),
    }),
    boss("Crystal Fang", {
        item( 13185, "Sunderseer Mantle", 28.1),
        item( 13184, "Fallbrush Handgrips", 35.48),
        item( 13218, "Fang of the Crystal Spider", 17.62),
    }),
    boss("Urok Doomhowl (Summon)", {
        item( 13258, "Slaghide Gauntlets", 17.09),
        item( 22232, "Marksman's Girdle", 20.6),
        item( 13259, "Ribsteel Footguards", 25.38),
        item( 13178, "Rosewine Circle", 21.48),
        item( 60406, "Doomsayer's Cuffs", nil),
        item( 60411, "Helm of Averted Doom", nil),
    }),
    boss("Quartermaster Zigris", {
        item( 13253, "Hands of Power", 14.22),
        item( 13252, "Cloudrunner Girdle", 15.48),
        item( 60418, "Surplus Sanctified Bracers", nil),
        item( 60416, "Scout's shroud of Preparedness", nil),
    }),
    boss("Halycon", {
        item( 22313, "Ironweave Bracers", 18.16),
        item( 13210, "Pads of the Dread Wolf", 9.88),
        item( 13211, "Slashclaw Bracers", 20.32),
        item( 13212, "Halycon's Spiked Collar", 18.23),
    }),
    boss("Ghok Bashguud (Rare)", {
        item( 0, "Armswake Cloak", nil),
        item( 0, "Hurd Smasher", nil),
        item( 0, "Bashguuder", nil),
        item( 0, "Ring of Furious Redoubt", nil),
    }),
    boss("Burning Felguard (Rare)", {
        item( 13181, "Demonskin Gloves", 14.47),
        item( 13182, "Phase Blade", 11.63),
    }),
    boss("Overlord Wyrmthalak", {
        item( 13143, "Mark of the Dragon Lord", 1.11),
        item( 60410, "Fury of the Black Brood", nil),
        item( 13162, "Reiver Claws", 12.14),
        item( 13164, "Heart of the Scale", 0.73),
        item( 22321, "Heart of Wyrmthalak", 13.87),
        item( 13163, "Relentless Scythe", 14.12),
        item( 13148, "Chillpike", 0.76),
        item( 13161, "Trindlehaven Staff", 10.4),
        item( 60414, "Mark of the Overlord", nil),
        item( 60413, "Mallet of the Black Flight", nil),
        item( 60405, "Darkmage´s Dragonstaff", nil),
        item( 60408, "Electrified Dragon Scale", nil),
        item( 16679, "Beaststalker's Mantle", 9.89),
    }),
    boss("Trash Mobs", {
        item( 14152, "Robe of the Archmage", nil),
    }),
}, "dungeon")

-- =====================================================================
zone("UBRS", {
    boss("Pyroguard Emberseer", {
        item( 12905, "Wildfire Cape", 15.2),
        item( 12927, "TruestrikeShoulders", 17.47),
        item( 12929, "Emberfury Talisman", 15.89),
        item( 12926, "Flaming Band", 18.52),
        item( 60691, "Shard of The Pyroguard", nil),
        item( 16672, "Gauntlets of Elements", 14.23),
    }),
    boss("Solakar Flamewreath", {
        item( 0, "Polychromatic Visionwrap", nil),
        item( 0, "Dustfeather Sash", nil),
        item( 0, "Nightbrace Tunic", nil),
        item( 0, "Crystallized Girdle", nil),
        item( 0, "Hyper-Radiant Flame Reflector", nil),
        item( 0, "Father Flame", nil),
        item( 0, "Devout Mantle", nil),
    }),
    boss("Jed Runewatcher", {
        item( 12604, "Starfire Tiara", 28.64),
        item( 12930, "Briarwood Reed", 26.36),
        item( 12605, "Serpentine Skuller", 32.95),
    }),
    boss("Goraluk Anvilcrack", {
        item( 18047, "Flame Walkers", 18.05),
        item( 13502, "Handcrafted Mastersmith Girdle", 15.78),
        item( 13498, "Handcrafted Mastersmith Leggings", 20.63),
        item( 18048, "Mastersmith's Hammer", 17.26),
    }),
    boss("Warchief Rend Blackhand", {
        item( 12590, "Felstriker", 1.06),
        item( 60681, "Amulet of Chromatic Warding", nil),
        item( 22247, "Faith Healer's Boots", 12.71),
        item( 18102, "Dragonrider Boots", 14.35),
        item( 12587, "Eye of Rend", 14.5),
        item( 12588, "Bonespike Shoulder", 0.85),
        item( 18104, "Feralsurge Girdle", 15.3),
        item( 12936, "Battleborn Armbraces", 16.96),
        item( 12935, "Warmaster Legguards", 15.05),
        item( 18103, "Band of Rumination", 15.38),
        item( 60685, "Brute's Edge", nil),
        item( 16733, "Spaulders of Valor", 13.39),
        item( 16669, "Pauldrons of Elements", 14.77),
        item( 12940, "Dal'Rend's Sacred Charge", 6.79),
        item( 12939, "Dal'Rend's Tribal Guardian", 7.61),
        item( 12583, "Blackhand Doomsaw", 7.44),
        item( 60682, "Battle Healer´s Barrier", nil),
        item( 22225, "Dragonskin Cowl", 11.85),
        item( 12960, "Tribal War Feathers", 15.24),
        item( 12953, "Dragoneye Coif", 15.99),
        item( 12952, "Gyth's Skull", 12.43),
        item( 60684, "Blackhand´s Bracers", nil),
    }),
    boss("The Beast", {
        item( 12752, "Cap of the Scarlet Savant", nil),
        item( 12757, "Breastplate of Bloodthirst", nil),
        item( 12756, "Leggings of Arcana", nil),
        item( 12967, "Bloodmoon Cloak", 18.3),
        item( 12968, "Frostweaver Cape", 14.47),
        item( 12965, "Spiritshroud Leggings", 13.16),
        item( 22311, "Ironweave Boots", 12.31),
        item( 12966, "Blackmist Armguards", 16.06),
        item( 12963, "Blademaster Leggings", 12.74),
        item( 12964, "Tristam Legguards", 18.16),
        item( 12709, "Finkle's Skinner", 6.95),
        item( 12969, "Seeping Willow", 11.49),
        item( 16729, "Lightforge Spaulders", 13.62),
    }),
    boss("Lord Valthalak (Summon)", {
        item( 22337, "Shroud of Domination", 23.37),
        item( 22302, "Ironweave Cowl", 27.72),
        item( 22342, "Leggings of Torment", 23.1),
        item( 22343, "Handguards of Savagery", 20.11),
        item( 22340, "Pendant of Celerity", 17.66),
        item( 22339, "Rune Band of Wizardry", 15.49),
        item( 22335, "Lord Valthalak's Staff of Command", 14.67),
        item( 22336, "Draconian Aegis of the Legion", 17.66),
    }),
    boss("General Drakkisath", {
        item( 12592, "Blackblade of Shahram", 1.08),
        item( 22269, "Shadow Prowler's Cloak", 10.61),
        item( 22267, "Spellweaver's Turban", 15.5),
        item( 13142, "Brigam Girdle", 16.4),
        item( 13141, "Tooth of Gnarr", 16.83),
        item( 13098, "Painweaver Band", 13.51),
        item( 22268, "Draconic Infused Emblem", 4.13),
        item( 22253, "Tome of the Lost", 16.05),
        item( 12602, "Draconian Deflector", 14.52),
        item( 60686, "Crystal Lattice", nil),
        item( 60689, "General's Medallion", nil),
        item( 60690, "Helm of Draconik Leadership", nil),
        item( 15730, "Pattern: Red Dragonscale Breastplate", 3.58),
        item( 15047, "Red Dragonscale Breastplate", nil),
        item( 16688, "Magister's Robes", 7.24),
        item( 16700, "Dreadmist Robe", 8.04),
        item( 16690, "Devout Robe", 6.2),
        item( 16706, "Wildheart Vest", 7.36),
        item( 16721, "Shadowcraft Tunic", 6.09),
        item( 16674, "Beaststalker's Tunic", 6.81),
        item( 16666, "Vest of Elements", 3.03),
        item( 16730, "Breastplate of Valor", 5.83),
        item( 16726, "Lightforge Breastplate", 3.76),
    }),
    boss("Trash Mobs", {
        item( 13260, "Wind Dancer Boots", 0.01),
    }),
}, "dungeon")

-- =====================================================================
--zone("DM East", {
--    boss("Zevrim Thornhoof", {
--        item( 18325, "Satyr's Bow", nil),
--    }),
--   boss("Hydrospawn", {
--        item( 18323, "Tempest Talisman", nil),
--    }),
--    boss("Alzzin the Wildshaper", {
--        item( 18327, "Fiendish Machete", nil),
--        item( 18328, "Energized Chestplate", nil),
--        item( 18329, "Become Briarwood Reed", nil),
--    }),
--})

-- =====================================================================
--zone("DM West", {
--    boss("Tendris Warpwood", {
--        item( 18340, "Ironbark Staff", nil),
--    }),
--    boss("Magister Kalendris", {
--        item( 18341, "Mindtap Talisman", nil),
--        item( 18342, "Senior's Cloak", nil),
--    }),
--    boss("Illyanna Ravenoak", {
--        item( 18343, "Whipvine Cord", nil),
--        item( 18344, "Gloves of Restoration", nil),
--    }),
--    boss("Prince Tortheldrin", {
--        item( 18345, "Thorn Talisman", nil),
--        item( 18346, "Silvermoon Leggings", nil),
--    }),
--})

-- =====================================================================
--zone("DM North", {
--    boss("Guard Mol'dar", {
--        item( 18356, "Mol'dar's Moxie", nil),
--    }),
--    boss("King Gordok", {
--        item( 18358, "Kromcrush's Chestplate", nil),
--        item( 18359, "Gordok Bracers of Power", nil),
--        item( 18360, "Ogre Forged Hauberk", nil),
--    }),
--})

-- =====================================================================
zone("Stratholme", {
    boss("Skul", {
        item( 13395, "Skul's Fingerbone Claws", 36.52),
        item( 13394, "Skul's Cold Embrace", 24.16),
        item( 13396, "Skul's Ghastly Touch", 16.85),
        item( 60493, "Festival's Feathery Crown", nil),
        item( 60507, "Scourge-Touched Strand", nil),
    }),
    boss("The Unforgiven", {
        item( 13409, "Tearfall Bracers", 14.62),
        item( 13404, "Mask of the Unforgiven", 14.96),
        item( 13405, "Wailing Nightbane Pauldrons", 12.1),
        item( 13408, "Soul Breaker", 19.33),
        item( 60500, "Kairoz`s Infused Breastplate", nil),
        item( 60506, "Sash of Cold Stars", nil),
        item( 16717, "Wildheart Gloves", 12.61),
    }),
    boss("Timmy the Cruel", {
        item( 13403, "Grimgore Noose", 16.48),
        item( 13402, "Timmy's Galoshes", 16.74),
        item( 13400, "Vambraces of the Sadist", 14.02),
        item( 13401, "The Cruel Hand of Timmy", 16.87),
        item( 60511, "Timmy´s Riding Gloves", nil),
        item( 60490, "Crusader's Espalier", nil),
        item( 16724, "Lightforge Gauntlets", 10.42),
    }),
    boss("Nerub'enkan", {
        item( 18740, "Thuzadin Sash", 14.72),
        item( 18739, "Chitinous Plate Legguards", 12.19),
        item( 13529, "Husk of Nerub'enkan", 12.62),
        item( 18738, "Carapace Spine Crossbow", 14.17),
        item( 60505, "Rover´s Shoulders", nil),
        item( 60482, "Ancient Nerubian Torc", nil),
        item( 13530, "Fangdrip Runners", 8.49),
        item( 13531, "Crypt Stalker Leggings", 10.17),
        item( 13532, "Darkspinner Claws", 9.69),
        item( 13533, "Acid-etched Pauldrons", 8.11),
        item( 13508, "Eye of Arachnida", 7.39),
        item( 16675, "Beaststalker's Boots", 13.62),
    }),
    boss("Maleki the Pallid", {
        item( 18734, "Pale Moon Cloak", 13.42),
        item( 18735, "Maleki's Footwraps", 15.03),
        item( 13524, "Skull of Burning Shadows", 13.42),
        item( 18737, "Bone Slicing Hatchet", 14.23),
        item( 60510, "Thuzadin Tiara", nil),
        item( 60489, "Cloak of Renewal", nil),
        item( 13525, "Darkbind Fingers", 9.15),
        item( 13526, "Flamescarred Girdle", 9.57),
        item( 13528, "Twilight Void Bracers", 9.49),
        item( 13527, "Lavawalker Greaves", 9.39),
        item( 13509, "Clutch of Foresight", 6.95),
        item( 16691, "Devout Sandals", 13.64),
    }),
    boss("Magistrate Barthilas", {
        item( 13376, "Royal Tribunal Cloak", 12.44),
        item( 18727, "Crimson Felt Hat", 13.82),
        item( 18726, "Magistrate's Cuffs", 12.87),
        item( 18722, "Death Grips", 15.34),
        item( 23198, "Idol of Brutality", 2.37),
        item( 18725, "Peacemaker", 14.22),
        item( 60501, "Magistrate´s Scepter", nil),
        item( 60488, "Breeches of Bruised Flesh", nil),
    }),
    boss("Ramstein the Gorger", {
        item( 13374, "Soulstealer Mantle", 9.87),
        item( 18723, "Animated Chain Necklace", 7.54),
        item( 13373, "Band of Flesh", 8.15),
        item( 13515, "Ramstein's Lightning Bolts", 8.09),
        item( 13372, "Slavedriver's Cane", 8.63),
        item( 13375, "Crest of Retribution", 9.17),
        item( 60503, "Pauldrons of the Fallen Champion", nil),
        item( 60486, "Blightcaller´s Bane", nil),
        item( 16737, "Gauntlets of Valor", 9.58),
    }),
    boss("Baron Rivendare", {
        item( 13505, "Runeblade of Baron Rivendare", 1.0),
        item( 13335, "Deathcharger's Reins", 0.1),
        item( 60509, "The Baroness´s Petticoat", nil),
        item( 13340, "Cape of the Black Baron", 8.75),
        item( 22412, "Thuzadin Mantle", 4.16),
        item( 13346, "Robes of the Exalted", 11.51),
        item( 22409, "Tunic of the Crescent Moon", 4.59),
        item( 13344, "Dracorian Gauntlets", 10.85),
        item( 22410, "Gauntlets of Deftness", 4.98),
        item( 22411, "Helm of the Executioner", 3.8),
        item( 13345, "Seal of Rivendare", 9.5),
        item( 13368, "Bonescraper", 4.32),
        item( 13361, "Skullforge Reaver", 4.25),
        item( 13349, "Scepter of the Unholy", 9.3),
        item( 22408, "Ritssyn's Wand of Bad Mojo", 3.39),
        item( 16687, "Magister's Leggings", 6.79),
        item( 16699, "Dreadmist Leggings", 7.31),
        item( 16694, "Devout Skirt", 7.42),
        item( 16709, "Shadowcraft Pants", 7.76),
        item( 16719, "Wildheart Kilt", 6.58),
        item( 16668, "Kilt of Elements", 3.02),
        item( 16678, "Beaststalker's Pants", 6.16),
        item( 16732, "Legplates of Valor", 5.74),
        item( 16728, "Lightforge Legplates", 4.2),
        item( 60514, "Zeliek´s Trews", nil),
    }),
    boss("Fras Siabi", {
        item( 60498, "Gittelle", nil),
        item( 60497, "Gauntlets of Restoration", nil),
        item( 60513, "Wildkin Shoulder Wrap", nil),
    }),
    boss("Hearthsinger Forresten", {
        item( 13378, "Songbird Blouse", 15.31),
        item( 13383, "Woollies of the Prancing Minstrel", 18.42),
        item( 13384, "Rainbow Girdle", 19.21),
        item( 13379, "Piccolo of the Flaming Fire", 15.13),
        item( 60508, "Stone-Worked Gauntlets", nil),
        item( 16682, "Magister's Boots", 10.86),
    }),
    boss("Postmaster Malown", {
        item( 13390, "The Postmaster's Band", nil),
        item( 13388, "The Postmaster's Tunic", nil),
        item( 13389, "The Postmaster's Trousers", nil),
        item( 13391, "The Postmaster's Treads", nil),
        item( 13392, "The Postmaster's Seal", nil),
    }),
    boss("Cannon Master Willey", {
        item( 22405, "Mantle of the Scarlet Crusade", 16.03),
        item( 22407, "Helm of the New Moon", 13.61),
        item( 18721, "Barrage Girdle", 12.39),
        item( 13381, "Master Cannoneer Boots", 12.86),
        item( 22403, "Diana's Pearl Necklace", 14.27),
        item( 13382, "Cannonball Runner", 12.28),
        item( 22404, "Willey's Back Scratcher", 6.26),
        item( 22406, "Redemption", 7.04),
        item( 13380, "Willey's Portable Howitzer", 10.71),
        item( 60484, "Ardent Shoulderguards", nil),
        item( 60494, "Flame-Proof Pendant", nil),
        item( 13377, "Miniature Cannon Balls", 66.61),
        item( 16708, "Shadowcraft Spaulders", 10.68),
    }),
    boss("Archivist Galford", {
        item( 13386, "Archivist Cape", 18.45),
        item( 18716, "Ash Covered Boots", 16.3),
        item( 13387, "Foresight Girdle", 18.24),
        item( 13385, "Tome of Knowledge", 9.87),
        item( 60485, "Blessed-Thread Gloves", nil),
        item( 16692, "Devout Gloves", 12.46),
    }),
    boss("Balnazzar", {
        item( 13353, "Book of the Dead", 1.37),     
        item( 14154, "Truefaith Vestments", nil),
        item( 18720, "Shroud of the Nathrezim", 10.54),
        item( 13369, "Fire Striders", 14.84),
        item( 13358, "Wyrmtongue Shoulders", 11.58),
        item( 13359, "Crown of Tyranny", 13.94),
        item( 18718, "Grand Crusader's Helm", 10.16),
        item( 12103, "Star of Mystaria", 12.48),
        item( 13360, "Gift of the Elven Magi", 13.66),
        item( 13348, "Demonshear", 13.94),
        item( 18717, "Hammer of the Grand Crusader", 11.91),
        item( 60499, "Grand Crusader´s Cuirass", nil),
        item( 60492, "Fel-Corrupted Holy Water", nil),
        item( 16725, "Lightforge Boots", 11.11),
    }),
    boss("Trash", {
        item( 18743, "Gracious Cape", 0.01),
        item( 17061, "Juno's Shadow", 0.01),
        item( 18745, "Sacred Cloth Leggings", 0.01),
        item( 18744, "Plaguebat Fur Gloves", 0.0),
        item( 18736, "Plaguehound Leggings", 0.0),
        item( 18742, "Stratholme Militia Shoulderguard", 0.0),
        item( 18741, "Morlune's Bracer", 0.01),
        item( 16697, "Devout Bracers", 1.15),
        item( 16702, "Dreadmist Belt", 0.9),
        item( 16685, "Magister's Belt", 0.8),
        item( 16714, "Wildheart Bracers", 1.49),
        item( 16681, "Beaststalker's Bindings", 1.64),
        item( 16671, "Bindings of Elements", 1.9),
        item( 16736, "Belt of Valor", 2.02),
        item( 16723, "Lightforge Belt", 1.83),
        item( 60487, "Bonewyrm Sabatons", nil),
    }),
}, "dungeon")

-- =====================================================================
zone("Scholomance", {
    boss("Kirtonos the Herald", {
        item( 13956, "Clutch of Andros", 15.31),
        item( 13957, "Gargoyle Slashers", 14.4),
        item( 13969, "Loomguard Armbraces", 16.25),
        item( 13967, "Windreaver Greaves", 14.87),
        item( 13955, "Stoneform Shoulders", 14.73),
        item( 13960, "Heart of the Fiend", 16.36),
        item( 14024, "Frightalon", 15.55),
        item( 13983, "Gravestone War Axe", 12.78),
        item( 60448, "Gargoyle's Bane", nil),
        item( 16734, "Boots of Valor", 11.12),
    }),
    boss("Jandice Barov", {
        item( 18689, "Phantasmal Cloak", 7.52),
        item( 14543, "Darkshade Gloves", 0.26),
        item( 14545, "Ghostloom Leggings", 8.81),
        item( 14548, "Royal Cap Spaulders", 10.06),
        item( 18690, "Wraithplate Leggings", 8.59),
        item( 14541, "Barovian Family Sword", 8.27),
        item( 22394, "Staff of Metanoia", 8.67),
        item( 60456, "Noblewoman´s Scepter", nil),
        item( 60464, "Wildkin Legguards", nil),
        item( 13725, "Krastinov's Bag of Horrors", 100.0),
        item( 13523, "Blood of Innocents", 17.8),
        item( 16701, "Dreadmist Mantle", 12.2),
    }),
    boss("Rattlegore", {
        item( 14538, "Deadwalker Mantle", 11.32),
        item( 14539, "Bone Ring Helm", 10.89),
        item( 18686, "Bone Golem Shoulders", 9.04),
        item( 14537, "Corpselight Greaves", 10.22),
        item( 14531, "Frightskull Shaft", 9.55),
        item( 14528, "Rattlecage Buckler", 9.16),
        item( 60303, "Skeletal Hand Puppet", nil),
        item( 13873, "Viewing Room Key", 100.0),
        item( 16711, "Shadowcraft Boots", 14.32),
    }),
    boss("Death Knight Darkreaver", {
        item( 18760, "Necromantic Band", 24.75),
        item( 18758, "Specter's Blade", 15.72),
        item( 18759, "Malicious Axe", 24.75),
        item( 18761, "Oblivion's Touch", 17.17),
    }),
    boss("Marduk Blackpool", {
        item( 18692, "Death Knight Sabatons", 6.29),
        item( 14576, "Ebon Hilt of Marduk", 6.55),
        item( 60455, "Marduk´s Bag o´ Bones", nil),
    }),
    boss("Vectus", {
        item( 14577, "Skullsmoke Pants", 5.24),
        item( 18691, "Dark Advisor's Pendant", 6.16),
        item( 60460, "Vectu´s Vembraces", nil),
    }),
    boss("Instructor Malicia", {
        item( 16710, "Shadowcraft Bracers", 3.51),
        item( 60445, "Eva´s Left Leg", nil),
        item( 60461, "Well-worn Athame", nil),
        item( 60443, "Camilla´s Ruby Necklace", nil),
    }),
    boss("Doctor Theolen Krastinov", {
        item( 16684, "Magister's Gloves", 9.75),
        item( 60440, "Blight Resistant Coreopsis", nil),
        item( 60439, "Astro´s Sward", nil),
        item( 60467, "Wraith´s Edge", nil),
        item( 60451, "Illucia´s Poketwatch", nil),
        item( 99999, "Ghoul Skin Leggings", nil),
        item( 60444, "Doomsledge", nil),
        item( 14617, "Sawbones Shirt", 2.0),
    }),
    boss("Lorekeeper Polkelt", {
        item( 16705, "Dreadmist Wraps", 14.54),
        item( 60452, "Kairoz's Girdle", nil),
        item( 60459, "Sterile Shortpants", nil),
        item( 60467, "Wraith´s Edge", nil),
    }),
    boss("The Ravenian", {
        item( 16716, "Wildheart Belt", 2.6),
        item( 60467, "Wraith´s Edge", nil),
        item( 60443, "Camilla´s Ruby Necklace", nil),
        item( 60444, "Doomsledge", nil),
        item( 60454, "Mam´toth´s Fist", nil),
        item( 60452, "Kairoz's Girdle", nil),
    }),
    boss("Lord Alexei Barov", {
        item( 16722, "Lightforge Bracers", 3.37),
        item( 60452, "Kairoz's Girdle", nil),
        item( 60444, "Doomsledge", nil),
        item( 60302, "Farmhand´s Dung Fork", nil),
        item( 60451, "Illucia's Pocketwatch", nil),
        item( 60467, "Wraith´s Edge", nil),
        item( 60462, "Wight Amulet", nil),
    }),
    boss("Lady Illucia Barov", {
        item( 60454, "Mam´toth´s Fist", nil),
        item( 60452, "Kairoz's Girdle", nil),
        item( 60462, "Wight Amulet", nil),
        item( 60451, "Illucia's Pocketwatch", nil),
        item( 60444, "Doomsledge", nil),
        item( 60467, "Wraith´s Edge", nil),
        item( 60302, "Farmhand´s Dung Fork", nil),
    }),
    boss("Ras Frostwhisper", {
        item( 13314, "Alanna's Embrace", 1.07),
        item( 14340, "Freezing Lich Robes", 12.55),
        item( 18693, "Shivery Handwraps", 12.38),
        item( 14503, "Death's Clutch", 11.73),
        item( 14502, "Frostbite Girdle", 11.2),
        item( 18694, "Shadowy Mail Greaves", 14.63),
        item( 14522, "Maelstrom Leggings", 13.01),
        item( 14525, "Boneclenched Gauntlets", 11.45),
        item( 18695, "Spellbound Tome", 10.86),
        item( 13952, "Iceblade Hacker", 9.74),
        item( 14487, "Bonechill Hammer", 11.92),
        item( 18696, "Intricately Runed Shield", 13.04),
        item( 60438, "Amulet of the Cold Dark", nil),
        item( 60447, "Frost-Rimed Crystal Ball", nil),
        item( 16689, "Magister's Mantle", 11.93),
        item( 13986, "Crown of Caer Darrow", nil),
        item( 13984, "Darrowspike", nil),
        item( 13982, "Warblade of Caer Darrow", nil),
        item( 14002, "Darrowshire Strongguard", nil),
    }),
    boss("Kormok", {
        item( 22303, "Ironweave Pants", 23.33),
        item( 22326, "Amalgam's Band", 16.67),
        item( 22331, "Band of the Steadfast Hero", 15.42),
        item( 22332, "Blade of Necromancy", 25.42),
        item( 22333, "Hammer of Divine Might", 12.5),
    }),
    boss("Classic Basement Loot", {
        item( 14633, "Necropile Mantle", 1.91),
        item( 14626, "Necropile Robe", 2.37),
        item( 14629, "Necropile Cuffs", 1.82),
        item( 14631, "Necropile Boots", 2.42),
        item( 14632, "Necropile Leggings", 2.16),
        item( 14637, "Cadaverous Armor", 2.08),
        item( 14638, "Cadaverous Leggings", 1.93),
        item( 14640, "Cadaverous Gloves", 1.43),
        item( 14636, "Cadaverous Belt", 1.82),
        item( 14641, "Cadaverous Walkers", 1.91),
        item( 18681, "Burial Shawl", 2.81),
        item( 18682, "Ghoul Skin Leggings", 3.14),
        item( 18684, "Dimly Opalescent Ring", 0.85),
        item( 14612, "Bloodmail Legguards", 0.87),
        item( 14616, "Bloodmail Boots", 0.53),
        item( 14615, "Bloodmail Gauntlets", 0.78),
        item( 14614, "Bloodmail Belt", 0.42),
        item( 14611, "Bloodmail Hauberk", 0.79),
        item( 14621, "Deathbone Sabatons", 1.61),
        item( 14620, "Deathbone Girdle", 1.32),
        item( 14622, "Deathbone Gauntlets", 1.52),
        item( 14624, "Deathbone Chestplate", 1.64),
        item( 14623, "Deathbone Legguards", 1.75),
        item( 18683, "Hammer of the Vesper", 2.54),
        item( 18680, "Ancient Bone Bow", 3.21),
        item( 23201, "Libram of Divinity", nil),
        item( 23200, "Totem of Sustaining", 3.5),
    }),
    boss("Darkmaster Gandling", {
        item( 13937, "Headmaster's Charge", 1.11),
        item( 13944, "Tombstone Breastplate", 8.96),
        item( 13398, "Boots of the Shrieker", 10.75),
        item( 60457, "Soul of the Failed Student", nil),
        item( 13950, "Detention Strap", 0.24),
        item( 13951, "Vigorsteel Vambraces", 10.38),
        item( 22433, "Don Mauricio's Band of Domination", 7.72),
        item( 13964, "Witchblade", 9.82),
        item( 13953, "Silent Fang", 9.68),
        item( 13938, "Bonecreeper Stylus", 8.8),
        item( 60450, "Headmaster's Mantle", nil),
        item( 19276, "Ace of Portals", 2.2),
        item( 16698, "Dreadmist Mask", 8.78),
        item( 16686, "Magister's Crown", 8.6),
        item( 16693, "Devout Crown", 7.89),
        item( 16707, "Shadowcraft Cap", 6.65),
        item( 16720, "Wildheart Cowl", 7.09),
        item( 16677, "Beaststalker's Cap", 7.0),
        item( 16667, "Coif of Elements", 2.86),
        item( 16731, "Helm of Valor", 6.54),
        item( 16727, "Lightforge Helm", 5.32),
        item( 14153, "Robe of the Void", nil),
    }),
}, "dungeon")

-- =====================================================================
zone("Glittermurk Mines", {
    boss("Supervisor Grimgash", {
        item( 60389, "Staff of Motivation", nil),
        item( 60380, "Gnoll Cuffs", nil),
        item( 60391, "Tarnished Linked Leggings", nil),
        item( 60383, "Pure Gold Band", nil),
    }),
    boss("Krakken", {
        item( 60378, "Faded Ring of Truestrike", nil),
        item( 60384, "Sash of Aquatic Gliding", nil),
        item( 60376, "Deepsea Coral", nil),
        item( 60366, "Aquablade", nil),
    }),
    boss("Miner Davod", {
        item( 61916, "Davod´s Lantern", nil),
    }),
    boss("Foreman Sprocket", {
        item( 60381, "Heavy Metal Belt", nil),
        item( 60392, "Throwing ´Saws´", nil),
        item( 60386, "Shredder Spaulders", nil),
        item( 60390, "Steel Pickaxe", nil),
        item( 99999, "Foreman's Head", nil),
    }),
    boss("Prismscale", {
        item( 60369, "Chromatic Wand", nil),
        item( 60394, "Unknown Stone Tooth", nil),
        item( 60397, "Warding Scale", nil),
        item( 60396, "Venturing Bracelets", nil),
    }),
    boss("Murklurk", {
        item( 60385, "Shadowcasters Hood", nil),
        item( 60379, "Forgotten Shoulderpads", nil),
        item( 60365, "Amulet of Brawn", nil),
        item( 60387, "Shoud of the Mur'gul", nil),
    }),
    boss("Gnash", {
        item( 60393, "Trident of Nazjatar", nil),
        item( 60382, "Naga Precision", nil),
        item( 60375, "Crown of Tides", nil),
        item( 60377, "Encrusted Fetish", nil),
        item( 60368, "Buckler of Seas", nil),
    }),
}, "dungeon")

-- =====================================================================
zone("Baradin Hold", {
    boss("Morrumus", {
        item( 60535, "Cursed Talisman of Wellbeing", nil),
        item( 60536, "Talisman of Wellbeing", nil),   
        item( 60615, "Voidhound Cloak", nil),
        item( 60533, "Cinch of Magic Repel", nil),
        item( 60532, "Cherryleaf Sash", nil),
        item( 60600, "Shadowheart", nil),
        item( 60518, "Baradin Medic's Polestaff", nil),
        item( 60602, "Shimmering Silver Loop", nil),
    }),
    boss("Helnurath", {
        item( 18757, "Diabolic Mantle", 23.12),
        item( 18754, "Fel Hardened Bracers", 19.24),
        item( 18756, "Dreadguard's Protector", 19.77),
        item( 18755, "Xorothian Firestick", 21.92),
    }),
    boss("Dak'mal", {
        item( 60555, "Imp Belt", nil),
        item( 60546, "Felguard Gauntlets", nil),
        item( 60577, "Orb of Dak'mal", nil),
        item( 60556, "Impenetrable Shoulderpads", nil),
        item( 60524, "Blade of Fel Curses", nil),
        item( 60588, "Rune Warder's Mantle" , nil),
    }),
    boss("Millhouse Manastorm", {
        item( 60570, "Manastorm Wand", nil),
        item( 60572, "Millhouse's Bathrobe", nil),
        item( 60520, "Belt of Conjouring", nil),
        item( 60582, "Prestidigitation", nil),
        item( 60526, "Bonzo's Brass Buttons", nil),
        item( 60571, "Masterwork Salt Shaker", nil),
        item( 60543, "Emergency Escape Plan", nil),
        item( 60548, "Frozen Bite", nil),
    }),
    boss("Isalien", {
        item( 22304, "Ironweave Gloves", 16.24),
        item( 22472, "Boots of Ferocity", 12.55),
        item( 22401, "Libram of Hope", 14.76),
        item( 22345, "Totem of Rebirth", 2.95),
        item( 22315, "Hammer of Revitalization", 13.65),
        item( 22314, "Huntsman's Harpoon", 15.50),
    }),
    boss("Glagut", {
        item( 60552, "Glagut's Rolling Pin", nil),
        item( 60571, "Masterwork Salt Shaker", nil),
        item( 60561, "Kitchen Coveralls", nil),
        item( 60574, "Mixologist's Band", nil),
        item( 60563, "Kitchen Pot", nil),
        item( 60597, "Sapphire Saltwater Trout", nil),
        item( 60562, "Kitchen Discipline", nil),
        item( 60525, "Bloody Cleaver", nil),
        item( 60604, "South Seas Cookbook", nil),
        item( 60551, "Girdle of Extreme Duress", nil),
    }),
    boss("Astilos the Hollow", {
        item( 16682, "Magister's Boots", 10.86),
        item( 60623, "Will o' the Wisps", nil),
        item( 60521, "Black Mold Shoulderpads", nil),
        item( 60534, "Coif of Hollowed Memories", nil),
        item( 60599, "Shadowfrost Scepter", nil),
        item( 60553, "Haunted Bone Armor", nil),

    }),
    boss("Nazrasash", {
        item( 60576, "Nazrasash´s Shoulderguards", nil),
        item( 60516, "Anti-Arcane Sabatons", nil),
        item( 60610, "Sunderer´s Mastery", nil),
        item( 60612, "Tome of Naz´jatar", nil),
        item( 60554, "Idol of Highborne Rejection", nil),
        item( 60598, "Seashell Cuffs", nil),
        item( 60575, "Naga Scale Leggings", nil),
        item( 60603, "Signet of Moonlit Water", nil),
        item( 60578, "Pendant of Marianus", nil),
        item( 60591, "Rune Warden Boots", nil),
    }),
    boss("Calypso", {
        item( 60538, "Daemongaoler", nil),
        item( 60611, "Talons of Calypso", nil),
        item( 60614, "Tough Tail Feathers", nil),
        item( 60547, "Flame Retardant Blankey", nil),
        item( 60531, "Chain of Talons", nil),
        item( 60304, "Siren's Song", nil),
        item( 60568, "Loop of Companionship", nil),
        item( 60544, "Feathered Cap", nil),
        item( 60560, "Iridescent Pin Feather", nil),
        item( 60589, "Rune Warder´s Raiment", nil),
    }),
    boss("Pirate Lord Blackstone", {
        item( 60519, "Baradin's Warden", nil),
        item( 60293, "Stolen Bauble", nil),
        item( 60537, "Cutlass o´ the South Seas", nil),
        item( 60601, "Shawl o' Seaswallowin'", nil),
        item( 60522, "Blackstone's Authority", nil),
        item( 60579, "Pilfered Panoply of Light", nil),
        item( 60565, "Landlubber's Pantaloons", nil),
        item( 60603, "Signet of Moonlit Water", nil),
        item( 60527, "Booty Belt", nil),
        item( 60581, "Portable Surgeon's Kit", nil),
        item( 60613, "Totem of Seas", nil),
        item( 60584, "Quartermaster Bonds Key", nil),
        item( 62028, "Chaos, Touch of Secrets", nil),
        item( 62029, "Prudence, Heirloom of Heroes", nil),
        item( 62030, "Char, Omen of Ash", nil),
        item( 62031, "Clarity, Voice of Valor", nil),
        item( 62032, "Redemption, Hammer of Truth", nil),
    }),
    boss("Mickey G", {
        item( 65705, "Micky's Gnukles", nil),
        item( 65700, "Charm Necklace", nil),
        item( 65698, "Boots of Lamentation", nil),
    }),
    boss("First Mate Malin", {
        item( 65709, "The Keelguard", nil),
        item( 65707, "Sea Shanty Shinkickers", nil),
        item( 65702, "Gold Loop Ring", nil),
    }),
    boss("Head Chef Ramsay", {
        item( 65706, "Mish'lun Chef's Hat", nil),
        item( 65703, "Kitchen Kilt", nil),
        item( 65701, "Gnawed Gnoll", nil),
    }),
}, "dungeon")

-- =====================================================================
--  S E T S   &   C O L L E C T I O N S
--
--  Each "zone" is a set/collection group.

-- =====================================================================

--  Each "boss" is a class or sub-group within that set.
--  Items reuse the same zone/boss/item helpers.
-- =====================================================================

-- =====================================================================

zone("World Bosses", {
    boss("Corruptedancient", {
        item( 64829, "Enchanted Robe", nil),
        item( 64830, "Agile Bracers", nil),
        item( 64831, "Hardened Greaves", nil),
        item( 64832, "Cloak of the Ancient", nil),
        item( 64833, "Sparkling Scepter", nil),
        item( 62911, "Heart of the Ancient", nil),
        item( 62910, "Amulet of the Forest", nil),
    }),
    boss("Gonzor", {
        item( 64780, "Abominable Drape", nil),
        item( 64779, "Sasquatch Signet", nil),
        item( 64778, "Icy Buckle", nil),
        item( 64777, "Bigfoot Handguards", nil),
        item( 64776, "Frostbite Bindings", nil),
        item( 64775, "Glacial Greatsword", nil),
        item( 64774, "Avalanche Slicer", nil),
        item( 64773, "Yeti Crusher", nil),
        item( 64772, "Gonzor´s Lunch", nil),
        item( 64771, "Frostbiter", nil),
    }),
    boss("Kinggnok", {
        item( 64805, "Kingly Pendant", nil),
        item( 64804, "Wild Tassets", nil),
        item( 64803, "Jungle Heartguard", nil),
        item( 64802, "Canopy Shoulders", nil),
        item( 64801, "Silverback Helm", nil),
        item( 64800, "Silverback Smasher", nil),
        item( 64799, "Jungle Channeler", nil),
        item( 64798, "King´s Shot", nil),
        item( 64797, "Thunderous Roar", nil),
        item( 64796, "Vineblade", nil),
    }),
    boss("Silithidlurker", {
        item( 64896, "Jewel of the Lurker", nil),
        item( 64893, "Duskwalker Turban", nil),
        item( 64894, "Sandwalker Gauntlets", nil),
        item( 64895, "Infested Legguards", nil),
        item( 64897, "Lurker´s Brood", nil),
        item( 64892, "Silithid Poker", nil),
    }),
    boss("Winterspring Boss", {
        item( 18704, "Mature Blue Dragon Sinew", nil),
        item( 64906, "Blue Rune", nil),
        item( 62171, "Pattern: Blue Dragonscale Boots", nil),
        item( 62170, "Blue Dragonscale Boots", nil),
        item( 62157, "Schematic: Ley-Stabalized Arcane Reflector", nil),
        item( 62156, "Ley-Stabalized Arcane Reflector", nil),
        item( 62141, "Formula: Spellweaver", nil),
        item( 62140, "Spellweaver", nil),
    }),
    boss("Volchan", {
        item( 64750, "Wildfire Chain Shoulders", nil),
        item( 64742, "Cloak of Convalescence", nil),
        item( 64743, "Crossfire Shoulderguards", nil),
        item( 64744, "Flame-Tempered Shoulderplates", nil),
        item( 64745, "Living Spark Spaulders", nil),
        item( 64746, "Mantle of the Royal Flame", nil),
        item( 64747, "Mountain Breaker", nil),
        item( 64748, "Pyrite-Studded Chain Epaulets", nil),
        item( 64749, "Seethe", nil),
    }),
}, "raid")
-- =====================================================================
zone("Tier 0 - Wildheart (Druid)", {
    boss("Darkmaster Gandling (Scholo)", {
        item( 16720, "Wildheart Cowl", 7.09),
    }),
    boss("Gizrul the Slavener (LBRS)", {
        item( 16718, "Wildheart Spaulders", 11.04),
    }),
    boss("General Drakkisath (UBRS)", {
        item( 16706, "Wildheart Vest", 7.36),
    }),
    boss("Trash Mobs (Stratholme)", {
        item( 16714, "Wildheart Bracers", 1.85),
    }),
    boss("The Unforgiven (Stratholme)", {
        item( 16717, "Wildheart Gloves", 12.61),
    }),
    boss("Trash Mobs (Scholomance)", {
        item( 16716, "Wildheart Belt", 2.6),
    }),
    boss("Baron Rivendare (Stratholme)", {
        item( 16719, "Wildheart Kilt", 6.58),
    }),
    boss("Mother Smolderweb (LBRS)", {
        item( 16715, "Wildheart Boots", 13.03),
    }),
}, "set")

-- =====================================================================
zone("Tier 0 - Beaststalker (Hunter)", {
    boss("Darkmaster Gandling (Scholo)", {
        item( 16677, "Beaststalker's Cap", 7.0),
    }),
    boss("Overlord Wyrmthalak (LBRS)", {
        item( 16679, "Beaststalker's Mantle", 9.89),
    }),
    boss("General Drakkisath (UBRS)", {
        item( 16674, "Beaststalker's Tunic", 6.81),
    }),
    boss("Trash Mobs (Stratholme)", {
        item( 16681, "Beaststalker's Bindings", 1.64),
    }),
    boss("War Master Voone (LBRS)", {
        item( 16676, "Beaststalker's Gloves", 9.15),
    }),
    boss("Trash Mobs (LBRS)", {
        item( 16680, "Beaststalker's Belt", 1.36),
    }),
    boss("Baron Rivendare (Stratholme)", {
        item( 16678, "Beaststalker's Pants", 6.16),
    }),
    boss("Nerub'enkan (Stratholme)", {
        item( 16675, "Beaststalker's Boots", 13.62),
    }),
}, "set")

-- =====================================================================
zone("Tier 0 - Magister's (Mage)", {
    boss("Darkmaster Gandling (Scholo)", {
        item( 16686, "Magister's Crown", 8.6),
    }),
    boss("Ras Frostwhisper (Scholo)", {
        item( 16689, "Magister's Mantle", 11.93),
    }),
    boss("General Drakkisath (UBRS)", {
        item( 16688, "Magister's Robes", 7.24),
    }),
    boss("Trash Mobs (LBRS)", {
        item( 16683, "Magister's Bindings", 1.19),
    }),
    boss("Doctor Theolen Krastinov (Scholo)", {
        item( 16684, "Magister's Gloves", 9.75),
    }),
    boss("Trash Mobs (Stratholme)", {
        item( 16685, "Magister's Belt", 1.32),
    }),
    boss("Baron Rivendare (Stratholme)", {
        item( 16687, "Magister's Leggings", 6.79),
    }),
    boss("Hearthsinger Forresten (Stratholme)", {
        item( 16682, "Magister's Boots", 10.86),
    }),
}, "set")

-- =====================================================================
zone("Tier 0 - Lightforge (Paladin)", {
    boss("Darkmaster Gandling (Scholo)", {
        item( 16727, "Lightforge Helm", 5.32),
    }),
    boss("The Beast (UBRS)", {
        item( 16729, "Lightforge Spaulders", 13.62),
    }),
    boss("General Drakkisath (UBRS)", {
        item( 16726, "Lightforge Breastplate", 3.76),
    }),
    boss("Trash Mobs (Scholomance)", {
        item( 16722, "Lightforge Bracers", 3.37),
    }),
    boss("Timmy the Cruel (Stratholme)", {
        item( 16724, "Lightforge Gauntlets", 10.42),
    }),
    boss("Trash Mobs (Stratholme)", {
        item( 16723, "Lightforge Belt", 1.93),
    }),
    boss("Baron Rivendare (Stratholme)", {
        item( 16728, "Lightforge Legplates", 4.2),
    }),
    boss("Balnazzar (Stratholme)", {
        item( 16725, "Lightforge Boots", 11.11),
    }),
}, "set")

-- =====================================================================
zone("Tier 0 - Devout (Priest)", {
    boss("Darkmaster Gandling (Scholo)", {
        item( 16693, "Devout Crown", 7.89),
    }),
    boss("Solakar Flamewreath (UBRS)", {
        item( 16695, "Devout Mantle", 12.84),
    }),
    boss("General Drakkisath (UBRS)", {
        item( 16690, "Devout Robe", 6.2),
    }),
    boss("Trash Mobs (Stratholme)", {
        item( 16697, "Devout Bracers", 1.13),
    }),
    boss("Archivist Galford (Stratholme)", {
        item( 16692, "Devout Gloves", 12.46),
    }),
    boss("Trash Mobs (LBRS)", {
        item( 16696, "Devout Belt", 2.07),
    }),
    boss("Baron Rivendare (Stratholme)", {
        item( 16694, "Devout Skirt", 7.42),
    }),
    boss("Maleki the Pallid (Stratholme)", {
        item( 16691, "Devout Sandals", 13.64),
    }),
}, "set")

-- =====================================================================
zone("Tier 0 - Shadowcraft (Rogue)", {
    boss("Darkmaster Gandling (Scholo)", {
        item( 16707, "Shadowcraft Cap", 6.65),
    }),
    boss("Cannon Master Willey (Stratholme)", {
        item( 16708, "Shadowcraft Spaulders", 10.68),
    }),
    boss("General Drakkisath (UBRS)", {
        item( 16721, "Shadowcraft Tunic", 6.09),
    }),
    boss("Trash Mobs (Scholomance)", {
        item( 16710, "Shadowcraft Bracers", 3.51),
    }),
    boss("Shadow Hunter Vosh'gajin (LBRS)", {
        item( 16712, "Shadowcraft Gloves", 11.89),
    }),
    boss("Trash Mobs (LBRS)", {
        item( 16713, "Shadowcraft Belt", 1.05),
    }),
    boss("Baron Rivendare (Stratholme)", {
        item( 16709, "Shadowcraft Pants", 7.76),
    }),
    boss("Rattlegore (Scholo)", {
        item( 16711, "Shadowcraft Boots", 14.32),
    }),
}, "set")

-- =====================================================================
zone("Tier 0 - Elements (Shaman)", {
    boss("Darkmaster Gandling (Scholo)", {
        item( 16667, "Coif of Elements", 2.86),
    }),
    boss("Gyth (UBRS)", {
        item( 16669, "Pauldrons of Elements", 14.77),
    }),
    boss("General Drakkisath (UBRS)", {
        item( 16666, "Vest of Elements", 3.03),
    }),
    boss("Trash Mobs (Stratholme)", {
        item( 16671, "Bindings of Elements", 1.59),
    }),
    boss("Pyroguard Emberseer (UBRS)", {
        item( 16672, "Gauntlets of Elements", 14.23),
    }),
    boss("Trash Mobs (LBRS)", {
        item( 16673, "Cord of Elements", 1.06),
    }),
    boss("Baron Rivendare (Stratholme)", {
        item( 16668, "Kilt of Elements", 3.02),
    }),
    boss("Highlord Omokk (LBRS)", {
        item( 16670, "Boots of Elements", 9.35),
    }),
}, "set")

-- =====================================================================
zone("Tier 0 - Dreadmist (Warlock)", {
    boss("Darkmaster Gandling (Scholo)", {
        item( 16698, "Dreadmist Mask", 8.78),
    }),
    boss("Jandice Barov (Scholo)", {
        item( 16701, "Dreadmist Mantle", 12.2),
    }),
    boss("General Drakkisath (UBRS)", {
        item( 16700, "Dreadmist Robe", 8.04),
    }),
    boss("Trash Mobs (LBRS)", {
        item( 16703, "Dreadmist Bracers", 1.68),
    }),
    boss("Lorekeeper Polkelt (Scholo)", {
        item( 16705, "Dreadmist Wraps", 14.54),
    }),
    boss("Trash Mobs (Stratholme)", {
        item( 16702, "Dreadmist Belt", 1.03),
    }),
    boss("Baron Rivendare (Stratholme)", {
        item( 16699, "Dreadmist Leggings", 7.31),
    }),
    boss("Baroness Anastari (Stratholme)", {
        item( 16704, "Dreadmist Sandals", 13.16),
    }),
}, "set")

-- =====================================================================
zone("Tier 0 - Valor (Warrior)", {
    boss("Darkmaster Gandling (Scholo)", {
        item( 16731, "Helm of Valor", 6.54),
    }),
    boss("Warchief Rend Blackhand (UBRS)", {
        item( 16733, "Spaulders of Valor", 13.39),
    }),
    boss("General Drakkisath (UBRS)", {
        item( 16730, "Breastplate of Valor", 5.83),
    }),
    boss("Trash Mobs (LBRS)", {
        item( 16735, "Bracers of Valor", 1.49),
    }),
    boss("Ramstein the Gorger (Stratholme)", {
        item( 16737, "Gauntlets of Valor", 9.58),
    }),
    boss("Trash Mobs (LBRS)", {
        item( 16736, "Belt of Valor", 1.96),
    }),
    boss("Baron Rivendare (Stratholme)", {
        item( 16732, "Legplates of Valor", 5.74),
    }),
    boss("Kirtonos the Herald (Scholo)", {
        item( 16734, "Boots of Valor", 11.12),
    }),
}, "set")

-- =====================================================================
zone("Tier 0.5 - Beastmaster (Hunter)", {
    boss("Beastmaster's Set", {
        item( 22013, "Beastmaster's Cap"),
        item( 22016, "Beastmaster's Mantle"),
        item( 22060, "Beastmaster's Tunic"),
        item( 22011, "Beastmaster's Bindings"),
        item( 22015, "Beastmaster's Gloves"),
        item( 22010, "Beastmaster's Belt"),
        item( 22017, "Beastmaster's Pants"),
        item( 22061, "Beastmaster's Boots"),
    }),
}, "set")

-- =====================================================================
zone("Tier 0.5 - Sorcerer (Mage)", {
    boss("Sorcerer's Set", {
        item( 22065, "Sorcerer's Crown"),
        item( 22068, "Sorcerer's Mantle"),
        item( 22069, "Sorcerer's Robes"),
        item( 22063, "Sorcerer's Bindings"),
        item( 22066, "Sorcerer's Gloves"),
        item( 22062, "Sorcerer's Belt"),
        item( 22067, "Sorcerer's Leggings"),
        item( 22064, "Sorcerer's Boots"),
    }),
}, "set")

-- =====================================================================
zone("Tier 0.5 - Darkmantle (Rogue)", {
    boss("Darkmantle Set", {
        item( 22005, "Darkmantle Cap"),
        item( 22008, "Darkmantle Spaulders"),
        item( 22009, "Darkmantle Tunic"),
        item( 22004, "Darkmantle Bracers"),
        item( 22006, "Darkmantle Gloves"),
        item( 22002, "Darkmantle Belt"),
        item( 22007, "Darkmantle Pants"),
        item( 22003, "Darkmantle Boots"),
    }),
}, "set")

-- =====================================================================
zone("Tier 0.5 - Five Thunders (Shaman)", {
    boss("Five Thunders Set", {
        item( 22097, "Coif of The Five Thunders"),
        item( 22101, "Pauldrons of The Five Thunders"),
        item( 22102, "Vest of The Five Thunders"),
        item( 22095, "Bindings of The Five Thunders"),
        item( 22099, "Gauntlets of The Five Thunders"),
        item( 22098, "Cord of The Five Thunders"),
        item( 22100, "Kilt of The Five Thunders"),
        item( 22096, "Boots of The Five Thunders"),
    }),
    boss("Aftershock Set", {
        item( 60354, "Coif of Aftershock"),
        item( 60353, "Pauldrons of Aftershock"),
        item( 60355, "Vest of Aftershock"),
        item( 60350, "Bindings of Aftershock"),
        item( 60351, "Gauntlets of Aftershock"),
        item( 60349, "Cord of Aftershock"),
        item( 60356, "Kilt of Aftershock"),
        item( 60352, "Boots of Aftershock"),
    }),
    boss("The Great Sea Set", {
        item( 60346, "Coif of the Great Sea"),
        item( 60345, "Pauldrons of the Great Sea"),
        item( 60347, "Vest of the Great Sea"),
        item( 60341, "Bindings of the Great Sea"),
        item( 60343, "Gauntlets of the Great Sea"),
        item( 60348, "Cord of the Great Sea"),
        item( 60344, "Kilt of the Great Sea"),
        item( 60342, "Boots of the Great Sea"),
    }),
}, "set")

-- =====================================================================
zone("Tier 0.5 - Deathmist (Warlock)", {
    boss("Deathmist Set", {
        item( 22074, "Deathmist Mask"),
        item( 22073, "Deathmist Mantle"),
        item( 22075, "Deathmist Robe"),
        item( 22071, "Deathmist Bracers"),
        item( 22077, "Deathmist Wraps"),
        item( 22070, "Deathmist Belt"),
        item( 22072, "Deathmist Leggings"),
        item( 22076, "Deathmist Sandals"),
    }),
}, "set")

-- =====================================================================
zone("Tier 0.5 - Heroism (Warrior)", {
    boss("Battlegear of Heroism", {
        item( 21999, "Helm of Heroism"),
        item( 22001, "Spaulders of Heroism"),
        item( 21997, "Breastplate of Heroism"),
        item( 21996, "Bracers of Heroism"),
        item( 21998, "Gauntlets of Heroism"),
        item( 21994, "Belt of Heroism"),
        item( 22000, "Legplates of Heroism"),
        item( 21995, "Boots of Heroism"),
    }),
    boss("Battlegear of Triumph (Epoch)", {
        item( 60362, "Helm of Triumph"),
        item( 60361, "Spaulders of Triumph"),
        item( 60363, "Breastplate of Triumph"),
        item( 60358, "Bracers of Triumph"),
        item( 60359, "Gauntlets of Triumph"),
        item( 60357, "Belt of Triumph"),
        item( 60364, "Legplates of Triumph"),
        item( 60360, "Boots of Triumph"),
    }),
}, "set")

-- =====================================================================
zone("Tier 0.5 - Soulforge (Paladin)", {
    boss("Soulforge Set", {
        item( 22091, "Soulforge Helm"),
        item( 22093, "Soulforge Spaulders"),
        item( 22089, "Soulforge Breastplate"),
        item( 22088, "Soulforge Bracers"),
        item( 22090, "Soulforge Gauntlets"),
        item( 22086, "Soulforge Belt"),
        item( 22092, "Soulforge Legplates"),
        item( 22087, "Soulforge Boots"),
    }),
    boss("Holyforge Armor", {
        item( 60318, "Holyforge Helm"),
        item( 60317, "Holyforge Spaulders"),
        item( 60319, "Holyforge Breastplate"),
        item( 60313, "Holyforge Bracers"),
        item( 60315, "Holyforge Gauntlets"),
        item( 60320, "Holyforge Belt"),
        item( 60316, "Holyforge Legplates"),
        item( 60314, "Holyforge Boots"),
    }),
    boss("Vigilforge Armor", {
        item( 60310, "Vigilforge Helm"),
        item( 60309, "Vigilforge Spaulders"),
        item( 60311, "Vigilforge Breastplate"),
        item( 60305, "Vigilforge Bracers"),
        item( 60307, "Vigilforge Gauntlets"),
        item( 60312, "Vigilforge Belt"),
        item( 60308, "Vigilforge Legplates"),
        item( 60306, "Vigilforge Boots"),
    }),
}, "set")

-- =====================================================================
zone("Tier 0.5 - Virtuous (Priest)", {
    boss("Vestments of the Virtuous", {
        item( 22080, "Virtuous Crown"),
        item( 22082, "Virtuous Mantle"),
        item( 22083, "Virtuous Robe"),
        item( 22079, "Virtuous Bracers"),
        item( 22081, "Virtuous Gloves"),
        item( 22078, "Virtuous Belt"),
        item( 22085, "Virtuous Skirt"),
        item( 22084, "Virtuous Sandals"),
    }),
    boss("Vestments of the Pious", {
        item( 60326, "Pious Crown"),
        item( 60325, "Pious Mantle"),
        item( 60327, "Pious Robe"),
        item( 60321, "Pious Bracers"),
        item( 60323, "Pious Gloves"),
        item( 60328, "Pious Belt"),
        item( 60324, "Pious Skirt"),
        item( 60322, "Pious Sandals"),
    }),
}, "set")

-- =====================================================================
zone("Epoch Sets - Druid", {
    boss("Treeheart Raiment", {
        item( 60299, "Treeheart Cowl"),
        item( 60298, "Treeheart Spaulders"),
        item( 60300, "Treeheart Vest"),
        item( 60295, "Treeheart Bracers"),
        item( 60296, "Treeheart Gloves"),
        item( 60294, "Treeheart Belt"),
        item( 60301, "Treeheart Kilt"),
        item( 60297, "Treeheart Boots"),
    }),
    boss("Featherheart Raiment", {
        item( 60290, "Featherheart Cowl"),
        item( 60289, "Featherheart Spaulders"),
        item( 60291, "Featherheart Vest"),
        item( 60286, "Featherheart Bracers"),
        item( 60287, "Featherheart Gloves"),
        item( 60285, "Featherheart Belt"),
        item( 60292, "Featherheart Kilt"),
        item( 60288, "Featherheart Boots"),
    }),
    boss("Feralheart Raiment", {
        item( 22109, "Feralheart Cowl"),
        item( 22112, "Feralheart Spaulders"),
        item( 22113, "Feralheart Vest"),
        item( 22108, "Feralheart Bracers"),
        item( 22110, "Feralheart Gloves"),
        item( 22106, "Feralheart Belt"),
        item( 22111, "Feralheart Kilt"),
        item( 22107, "Feralheart Boots"),
    }),
}, "set")

-- =====================================================================
zone("Scholomance Sets", {
    boss("Necropile (Cloth)", {
        item( 14633, "Necropile Mantle", 1.12),
        item( 14626, "Necropile Robe", 1.27),
        item( 14629, "Necropile Cuffs", 1.03),
        item( 14632, "Necropile Leggings", 0.85),
        item( 14631, "Necropile Boots", 0.88),
    }),
    boss("Cadaverous (Leather)", {
        item( 14637, "Cadaverous Armor", 1.51),
        item( 14640, "Cadaverous Gloves", 0.82),
        item( 14636, "Cadaverous Belt", 0.6),
        item( 14638, "Cadaverous Leggings", 1.09),
        item( 14641, "Cadaverous Walkers", 0.67),
    }),
    boss("Bloodmail (Mail)", {
        item( 14611, "Bloodmail Hauberk", 0.54),
        item( 14615, "Bloodmail Gauntlets", 0.09),
        item( 14614, "Bloodmail Belt", 0.6),
        item( 14612, "Bloodmail Legguards", 0.42),
        item( 14616, "Bloodmail Boots", 0.36),
    }),
    boss("Deathbone (Plate)", {
        item( 14624, "Deathbone Chestplate", 0.45),
        item( 14622, "Deathbone Gauntlets", 0.45),
        item( 14620, "Deathbone Girdle", 0.67),
        item( 14623, "Deathbone Legguards", 1.12),
        item( 14621, "Deathbone Sabatons", 0.57),
    }),
}, "set")

-- =====================================================================
zone("Ironweave Battlesuit", {
    boss("Ironweave Set", {
        item( 22302, "Ironweave Cowl", 27.72),
        item( 22305, "Ironweave Mantle", 30.39),
        item( 22301, "Ironweave Robe", 19.0),
        item( 22313, "Ironweave Bracers", 18.16),
        item( 22304, "Ironweave Gloves", 16.24),
        item( 22306, "Ironweave Belt", 20.28),
        item( 22303, "Ironweave Pants", 23.33),
        item( 22311, "Ironweave Boots", 12.31),
    }),
}, "set")

-- =====================================================================
zone("Savage Gladiator (BRD)", {
    boss("Savage Gladiator Set", {
        item( 11729, "Savage Gladiator Helm", 10.08),
        item( 11726, "Savage Gladiator Chain", 14.52),
        item( 11730, "Savage Gladiator Grips", 14.12),
        item( 11728, "Savage Gladiator Leggings", 14.95),
        item( 11731, "Savage Gladiator Greaves", 15.14),
    }),
}, "set")

-- =====================================================================
zone("The Postmaster Set", {
    boss("Postmaster's Set", {
        item( 13390, "The Postmaster's Band"),
        item( 13388, "The Postmaster's Tunic"),
        item( 13389, "The Postmaster's Trousers"),
        item( 13391, "The Postmaster's Treads"),
        item( 13392, "The Postmaster's Seal"),
    }),
}, "set")

-- =====================================================================
zone("Uldic Plate", {
    boss("Uldic Set", {
        item( 60673, "Marred Uldic Helm"),
        item( 60676, "Marred Uldic Shoulderpads"),
        item( 60671, "Marred Uldic Chestplate"),
        item( 60672, "Marred Uldic Hands"),
        item( 60674, "Marred Uldic Legplates"),
        item( 60675, "Marred Uldic Sabatons"),
    }),
}, "set")

-- =====================================================================
zone("Rune Warder Set", {
    boss("Rune Warder", {
        item( 60587, "Rune Warder's Crown"),
        item( 60588, "Rune Warder's Mantle"),
        item( 60589, "Rune Warder's Raiment"),
        item( 60590, "Rune Warder's Gloves"),
        item( 60591, "Rune Warder's Loins"),
        item( 60592, "Rune Warder's Boots"),
    }),
}, "set")

-- =====================================================================
zone("Epoch Sets - Cenarius (Druid T1.5)", {
    boss("Cenarius Set - Feral", {
        item( 61544, "Antlers of Cenarius"),
        item( 61545, "Pauldrons of Cenarius"),
        item( 61546, "Chestpiece of Cenarius"),
        item( 61547, "Britches of Cenarius"),
        item( 61548, "Gloves of Cenarius"),
        item( 61549, "Striders of Cenarius"),
    }),
    boss("Cenarius Set - Balance", {
        item( 61550, "Stag-Helm of Cenarius"),
        item( 61551, "Mantle of Cenarius"),
        item( 61552, "Breastplate of Cenarius"),
        item( 61553, "Greaves of Cenarius"),
        item( 61554, "Gauntlets of Cenarius"),
        item( 61555, "Boots of Cenarius"),
    }),
    boss("Cenarius Set - Resto", {
        item( 61556, "Crown of Cenarius"),
        item( 61557, "Shoulderguards of Cenarius"),
        item( 61558, "Chestguard of Cenarius"),
        item( 61559, "Legguards of Cenarius"),
        item( 61560, "Handguards of Cenarius"),
        item( 61561, "Treads of Cenarius"),
    }),
}, "set")

-- =====================================================================
zone("Epoch Sets - Giantstalker (Hunter T1.5)", {
    boss("Giantstalker's Set", {
        item( 61563, "Giantstalker's Helmet"),
        item( 61566, "Giantstalker's Epaulets"),
        item( 61565, "Giantstalker's Breastplate"),
        item( 61564, "Giantstalker's Leggings"),
        item( 61562, "Giantstalker's Gloves"),
        item( 61567, "Giantstalker's Boots"),
    }),
}, "set")

-- =====================================================================
zone("Epoch Sets - Arcanist (Mage T1.5)", {
    boss("Arcanist Set", {
        item( 61569, "Arcanist Crown"),
        item( 61572, "Arcanist Mantle"),
        item( 61571, "Arcanist Robes"),
        item( 61570, "Arcanist Leggings"),
        item( 61568, "Arcanist Gloves"),
        item( 61573, "Arcanist Boots"),
    }),
}, "set")

-- =====================================================================
zone("Epoch Sets - Lawbringer (Paladin T1.5)", {
    boss("Lawbringer Set - Holy", {
        item( 61574, "Lawbringer Diadem"),
        item( 61575, "Lawbringer Pauldrons"),
        item( 61576, "Lawbringer Chestpiece"),
        item( 61577, "Lawbringer Leggings"),
        item( 61578, "Lawbringer Gloves"),
        item( 61579, "Lawbringer Boots"),
    }),
    boss("Lawbringer Set - Prot", {
        item( 61580, "Lawbringer Faceguard"),
        item( 61581, "Lawbringer Shoulderguards"),
        item( 61582, "Lawbringer Chestguard"),
        item( 61583, "Lawbringer Legguards"),
        item( 61584, "Lawbringer Handguards"),
        item( 61585, "Lawbringer Sabatons"),
    }),
    boss("Lawbringer Set - Ret", {
        item( 61586, "Lawbringer Crown"),
        item( 61587, "Lawbringer Shoulderplates"),
        item( 61588, "Lawbringer Breastplate"),
        item( 61589, "Lawbringer Greaves"),
        item( 61590, "Lawbringer Gauntlets"),
        item( 61591, "Lawbringer Pads"),
    }),
}, "set")

-- =====================================================================
zone("Epoch Sets - Prophecy (Priest T1.5)", {
    boss("Prophecy Set - Shadow", {
        item( 61592, "Circlet of Prophecy"),
        item( 61593, "Light-Mantle of Prophecy"),
        item( 61594, "Robes of Prophecy"),
        item( 61595, "Trousers of Prophecy"),
        item( 61596, "Handwraps of Prophecy"),
        item( 61597, "Boots of Prophecy"),
    }),
    boss("Prophecy Set - Holy", {
        item( 61598, "Wreath of Prophecy"),
        item( 61599, "Soul-Mantle of Prophecy"),
        item( 61600, "Shroud of Prophecy"),
        item( 61601, "Leggings of Prophecy"),
        item( 61602, "Gloves of Prophecy"),
        item( 61603, "Galoshes of Prophecy"),
    }),
}, "set")

-- =====================================================================
zone("Epoch Sets - Nightslayer (Rogue T1.5)", {
    boss("Nightslayer Set", {
        item( 61604, "Nightslayer Cover"),
        item( 61605, "Nightslayer Shoulder Pads"),
        item( 61606, "Nightslayer Chestpiece"),
        item( 61607, "Nightslayer Pants"),
        item( 61608, "Nightslayer Gloves"),
        item( 61609, "Nightslayer Boots"),
    }),
}, "set")

-- =====================================================================
zone("Epoch Sets - Earthfury (Shaman T1.5)", {
    boss("Earthfury Set - Elemental", {
        item( 61610, "Earthfury Faceguard"),
        item( 61611, "Earthfury Shoulderguards"),
        item( 61612, "Earthfury Chestguard"),
        item( 61613, "Earthfury Legguards"),
        item( 61614, "Earthfury Handguards"),
        item( 61615, "Earthfury Boots"),
    }),
    boss("Earthfury Set - Enhancement", {
        item( 61616, "Earthfury Helm"),
        item( 61617, "Earthfury Shoulderplates"),
        item( 61618, "Earthfury Breastplate"),
        item( 61619, "Earthfury War-Kilt"),
        item( 61620, "Earthfury Gauntlets"),
        item( 61621, "Earthfury Sabatons"),
    }),
    boss("Earthfury Set - Resto", {
        item( 61622, "Earthfury Headdress"),
        item( 61623, "Earthfury Shoulderpads"),
        item( 61624, "Earthfury Hauberk"),
        item( 61625, "Earthfury Kilt"),
        item( 61626, "Earthfury Gloves"),
        item( 61627, "Earthfury Pads"),
    }),
}, "set")

-- =====================================================================
zone("Epoch Sets - Felheart (Warlock T1.5)", {
    boss("Felheart Set", {
        item( 61629, "Felheart Horns"),
        item( 61632, "Felheart Shoulder Pads"),
        item( 61631, "Felheart Robes"),
        item( 61630, "Felheart Pants"),
        item( 61628, "Felheart Gloves"),
        item( 61633, "Felheart Slippers"),
    }),
}, "set")

-- =====================================================================
zone("Epoch Sets - Might (Warrior T1.5)", {
    boss("Battlegear of Might - Fury", {
        item( 61634, "Battle-Helm of Might"),
        item( 61635, "Shoulderplates of Might"),
        item( 61636, "Breastplate of Might"),
        item( 61637, "Greaves of Might"),
        item( 61638, "Gauntlets of Might"),
        item( 61639, "Sabatons of Might"),
    }),
    boss("Battlegear of Might - Prot", {
        item( 61640, "Greathelm of Might"),
        item( 61641, "Shoulderguards of Might"),
        item( 61642, "Chestguard of Might"),
        item( 61643, "Legguards of Might"),
        item( 61644, "Handguards of Might"),
        item( 61645, "Sollerets of Might"),
    }),
}, "set")

-- =====================================================================
zone("PvP - Rookie (Level 15)", {
    boss("Rookie's Cloth", {
        item( 60851, "Rookie's Hood"),
        item( 60852, "Rookie's Mantle"),
        item( 60853, "Rookie's Robe"),
        item( 60854, "Rookie's Handcloth"),
        item( 60855, "Rookie's Leggings"),
        item( 60856, "Rookie's Slippers"),
        item( 60857, "Rookie's Wristwraps"),
        item( 60858, "Rookie's Waistband"),
        item( 60859, "Rookie's Cloche"),
        item( 60860, "Rookie's Pads"),
        item( 60861, "Rookie's Leather"),
        item( 60862, "Rookie's Mitts"),
        item( 60863, "Rookie's Pantaloons"),
        item( 60864, "Rookie's Bootlets"),
        item( 60865, "Rookie's Armguards"),
        item( 60866, "Rookie's Strap"),
    }),
    boss("Rookie's Mail/Plate", {
        item( 60875, "Rookie's Coif"),
        item( 60876, "Rookie's Chaindrapes"),
        item( 60877, "Rookie's Links"),
        item( 60878, "Rookie's Demi-gaunts"),
        item( 60879, "Rookie's Leglinks"),
        item( 60880, "Rookie's Bootlinks"),
        item( 60881, "Rookie's Wrists"),
        item( 60882, "Rookie's Buckle"),
        item( 60867, "Rookie's Cap"),
        item( 60868, "Rookie's Shoulders"),
        item( 60869, "Rookie's Tunic"),
        item( 60870, "Rookie's Gloves"),
        item( 60871, "Rookie's Pants"),
        item( 60872, "Rookie's Boots"),
        item( 60873, "Rookie's Cuffs"),
        item( 60874, "Rookie's Belt"),
        item( 60883, "Rookie's Helm"),
        item( 60884, "Rookie's Shoulderguards"),
        item( 60885, "Rookie's Chainmail"),
        item( 60886, "Rookie's Handguards"),
        item( 60887, "Rookie's Legguards"),
        item( 60888, "Rookie's Treads"),
        item( 60889, "Rookie's Bracers"),
        item( 60890, "Rookie's Cinch"),
    }),
    boss("Rookie's Weapons", {
        item( 60911, "Rookie's Dagger"),
        item( 60912, "Rookie's Hatchet"),
        item( 60913, "Rookie's Mallet"),
        item( 60914, "Rookie's Saber"),
        item( 60915, "Rookie's Claw"),
        item( 60916, "Rookie's Spellblade"),
        item( 60917, "Rookie's Frill"),
        item( 60918, "Rookie's Spellfist"),
        item( 60919, "Rookie's Spellhammer"),
        item( 60920, "Rookie's Spellsword"),
        item( 60921, "Rookie's Staff"),
        item( 60926, "Rookie's Battleaxe"),
        item( 60927, "Rookie's Maul"),
        item( 60928, "Rookie's Greatsword"),
        item( 60929, "Rookie's Spellshield"),
        item( 60930, "Rookie's Shield"),
        item( 60931, "Rookie's Axe"),
        item( 60932, "Rookie's Mace"),
        item( 60933, "Rookie's Sword"),
        item( 60934, "Rookie's Knuckles"),
        item( 60922, "Rookie's Rifle"),
        item( 60923, "Rookie's Bow"),
        item( 60924, "Rookie's Crossbow"),
        item( 60925, "Rookie's Knives"),
        item( 60935, "Rookie's Frostflinger"),
        item( 60936, "Rookie's Firestick"),
        item( 60937, "Rookie's Shadowthrower"),
        item( 60938, "Rookie's Arcane Wand"),
        item( 60939, "Rookie's Lightning Rod"),
    }),
    boss("Rookie's Accessories", {
        item( 60907, "Rookie's Band of Physical Potency"),
        item( 60906, "Rookie's Band of Physical Cruelty"),
        item( 60905, "Rookie's Band of Physical Accuracy"),
        item( 60904, "Rookie's Band of Magic Potency"),
        item( 60903, "Rookie's Band of Magic Cruelty"),
        item( 60902, "Rookie's Band of Magic Accuracy"),
        item( 60901, "Rookie's Band of Survival"),
        item( 60900, "Rookie's Amulet of Agility"),
        item( 60899, "Rookie's Amulet of Strength"),
        item( 60898, "Rookie's Amulet of Spellcasting"),
        item( 60897, "Rookie's Cloak of Physical Potency"),
        item( 60896, "Rookie's Cloak of Physical Cruelty"),
        item( 60895, "Rookie's Cloak of Physical Accuracy"),
        item( 60894, "Rookie's Cloak of Magic Potency"),
        item( 60893, "Rookie's Cloak of Magic Cruelty"),
        item( 60892, "Rookie's Cloak of Magic Accuracy"),
        item( 60891, "Rookie's Cloak of Survival"),
        item( 60910, "Rookie's Emblem of Tenacity"),
        item( 60909, "Rookie's Insignia of the Alliance"),
        item( 60908, "Rookie's Insignia of the Horde"),
    }),
}, "set")

-- =====================================================================
zone("PvP - Skirmisher (Level 25)", {
    boss("Skirmisher's Armor", {
        item( 60940, "Skirmisher's Hood"),
        item( 60941, "Skirmisher's Mantle"),
        item( 60942, "Skirmisher's Robe"),
        item( 60943, "Skirmisher's Handcloth"),
        item( 60944, "Skirmisher's Leggings"),
        item( 60945, "Skirmisher's Slippers"),
        item( 60946, "Skirmisher's Wristwraps"),
        item( 60947, "Skirmisher's Waistband"),
        item( 60948, "Skirmisher's Cowl"),
        item( 60949, "Skirmisher's Stole"),
        item( 60950, "Skirmisher's Raiment"),
        item( 60951, "Skirmisher's Hands"),
        item( 60952, "Skirmisher's Legwarmers"),
        item( 60953, "Skirmisher's Bootlets"),
        item( 60954, "Skirmisher's Braceletts"),
        item( 60955, "Skirmisher's Sash"),
        item( 60956, "Skirmisher's Cloche"),
        item( 60957, "Skirmisher's Pads"),
        item( 60958, "Skirmisher's Leather"),
        item( 60959, "Skirmisher's Mitts"),
        item( 60960, "Skirmisher's Pantaloons"),
        item( 60961, "Skirmisher's Riders"),
        item( 60962, "Skirmisher's Armguards"),
        item( 60963, "Skirmisher's Strap"),
        item( 60964, "Skirmisher's Casque"),
        item( 60965, "Skirmisher's Rerebrace"),
        item( 60966, "Skirmisher's Cuirass"),
        item( 60967, "Skirmisher's Palms"),
        item( 60968, "Skirmisher's Breeches"),
        item( 60969, "Skirmisher's Soles"),
        item( 60970, "Skirmisher's Leather Cuffs"),
        item( 60971, "Skirmisher's Leather Belt"),
        item( 60972, "Skirmisher's Cap"),
        item( 60973, "Skirmisher's Shoulders"),
        item( 60974, "Skirmisher's Tunic"),
        item( 60975, "Skirmisher's Gloves"),
        item( 60976, "Skirmisher's Pants"),
        item( 60977, "Skirmisher's Boots"),
        item( 60978, "Skirmisher's Cuffs"),
        item( 60979, "Skirmisher's Belt"),
        item( 60980, "Skirmisher's Coif"),
        item( 60981, "Skirmisher's Chaindrapes"),
        item( 60982, "Skirmisher's Links"),
        item( 60983, "Skirmisher's Demi-gaunts"),
        item( 60984, "Skirmisher's Leglinks"),
        item( 60985, "Skirmisher's Bootlinks"),
        item( 60986, "Skirmisher's Wrists"),
        item( 60987, "Skirmisher's Buckle"),
        item( 60988, "Skirmisher's Chain Cloche"),
        item( 60989, "Skirmisher's Light Pauldrons"),
        item( 60990, "Skirmisher's Hauberk"),
        item( 60991, "Skirmisher's Grips"),
        item( 60992, "Skirmisher's Kilt"),
        item( 60993, "Skirmisher's Stompers"),
        item( 60994, "Skirmisher's Manacles"),
        item( 60995, "Skirmisher's Chain"),
        item( 60996, "Skirmisher's Helm"),
        item( 60997, "Skirmisher's Shoulderguards"),
        item( 60998, "Skirmisher's Chainmail"),
        item( 60999, "Skirmisher's Handguards"),
        item( 61000, "Skirmisher's Legguards"),
        item( 61001, "Skirmisher's Treads"),
        item( 61002, "Skirmisher's Bracers"),
        item( 61003, "Skirmisher's Cinch"),
    }),
    boss("Skirmisher's Weapons", {
        item( 61024, "Skirmisher's Dagger"),
        item( 61025, "Skirmisher's Hatchet"),
        item( 61026, "Skirmisher's Mallet"),
        item( 61027, "Skirmisher's Saber"),
        item( 61028, "Skirmisher's Claw"),
        item( 61029, "Skirmisher's Spellblade"),
        item( 61030, "Skirmisher's Frill"),
        item( 61031, "Skirmisher's Spellfist"),
        item( 61032, "Skirmisher's Spellhammer"),
        item( 61033, "Skirmisher's Spellsword"),
        item( 61034, "Skirmisher's Staff"),
        item( 61039, "Skirmisher's Battleaxe"),
        item( 61040, "Skirmisher's Maul"),
        item( 61041, "Skirmisher's Greatsword"),
        item( 61042, "Skirmisher's Spellshield"),
        item( 61043, "Skirmisher's Shield"),
        item( 61044, "Skirmisher's Axe"),
        item( 61045, "Skirmisher's Mace"),
        item( 61046, "Skirmisher's Sword"),
        item( 61047, "Skirmisher's Knuckles"),
        item( 61035, "Skirmisher's Rifle"),
        item( 61036, "Skirmisher's Bow"),
        item( 61037, "Skirmisher's Crossbow"),
        item( 61038, "Skirmisher's Knives"),
        item( 61048, "Skirmisher's Frostflinger"),
        item( 61049, "Skirmisher's Firestick"),
        item( 61050, "Skirmisher's Shadowthrower"),
        item( 61051, "Skirmisher's Arcane Wand"),
        item( 61052, "Skirmisher's Lightning Rod"),
    }),
    boss("Skirmisher's Accessories", {
        item( 61020, "Skirmisher's Band of Physical Potency"),
        item( 61019, "Skirmisher's Band of Physical Cruelty"),
        item( 61018, "Skirmisher's Band of Physical Accuracy"),
        item( 61017, "Skirmisher's Band of Magic Potency"),
        item( 61016, "Skirmisher's Band of Magic Cruelty"),
        item( 61015, "Skirmisher's Band of Magic Accuracy"),
        item( 61014, "Skirmisher's Band of Survival"),
        item( 61013, "Skirmisher's Amulet of Agility"),
        item( 61012, "Skirmisher's Amulet of Strength"),
        item( 61011, "Skirmisher's Amulet of Spellcasting"),
        item( 61010, "Skirmisher's Cloak of Physical Potency"),
        item( 61009, "Skirmisher's Cloak of Physical Cruelty"),
        item( 61008, "Skirmisher's Cloak of Physical Accuracy"),
        item( 61007, "Skirmisher's Cloak of Magic Potency"),
        item( 61006, "Skirmisher's Cloak of Magic Cruelty"),
        item( 61005, "Skirmisher's Cloak of Magic Accuracy"),
        item( 61004, "Skirmisher's Cloak of Survival"),
        item( 61023, "Skirmisher's Emblem of Tenacity"),
        item( 61022, "Skirmisher's Insignia of the Alliance"),
        item( 61021, "Skirmisher's Insignia of the Horde"),
    }),
}, "set")

-- =====================================================================
zone("PvP - Combatant (Level 35)", {
    boss("Combatant's Armor", {
        item( 61053, "Combatant's Hood"),
        item( 61054, "Combatant's Mantle"),
        item( 61055, "Combatant's Robe"),
        item( 61056, "Combatant's Handcloth"),
        item( 61057, "Combatant's Leggings"),
        item( 61058, "Combatant's Slippers"),
        item( 61059, "Combatant's Wristwraps"),
        item( 61060, "Combatant's Waistband"),
        item( 61061, "Combatant's Cowl"),
        item( 61062, "Combatant's Stole"),
        item( 61063, "Combatant's Raiment"),
        item( 61064, "Combatant's Hands"),
        item( 61065, "Combatant's Legwarmers"),
        item( 61066, "Combatant's Bootlets"),
        item( 61067, "Combatant's Braceletts"),
        item( 61068, "Combatant's Sash"),
        item( 61069, "Combatant's Cloche"),
        item( 61070, "Combatant's Pads"),
        item( 61071, "Combatant's Leather"),
        item( 61072, "Combatant's Mitts"),
        item( 61073, "Combatant's Pantaloons"),
        item( 61074, "Combatant's Riders"),
        item( 61075, "Combatant's Armguards"),
        item( 61076, "Combatant's Strap"),
        item( 61078, "Combatant's Casque"),
        item( 61079, "Combatant's Rerebrace"),
        item( 61080, "Combatant's Cuirass"),
        item( 61081, "Combatant's Palms"),
        item( 61082, "Combatant's Breeches"),
        item( 61083, "Combatant's Soles"),
        item( 61084, "Combatant's Leather Cuffs"),
        item( 61085, "Combatant's Leather Belt"),
        item( 61086, "Combatant's Shoulders"),
        item( 61087, "Combatant's Tunic"),
        item( 61088, "Combatant's Gloves"),
        item( 61089, "Combatant's Pants"),
        item( 61090, "Combatant's Boots"),
        item( 61091, "Combatant's Cuffs"),
        item( 61092, "Combatant's Belt"),
        item( 61093, "Combatant's Coif"),
        item( 61094, "Combatant's Chaindrapes"),
        item( 61095, "Combatant's Links"),
        item( 61096, "Combatant's Demi-gaunts"),
        item( 61097, "Combatant's Leglinks"),
        item( 61098, "Combatant's Bootlinks"),
        item( 61099, "Combatant's Wrists"),
        item( 61100, "Combatant's Buckle"),
        item( 61101, "Combatant's Chain Cloche"),
        item( 61102, "Combatant's Light Pauldrons"),
        item( 61103, "Combatant's Hauberk"),
        item( 61104, "Combatant's Grips"),
        item( 61105, "Combatant's Kilt"),
        item( 61106, "Combatant's Stompers"),
        item( 61107, "Combatant's Manacles"),
        item( 61108, "Combatant's Chain"),
        item( 61109, "Combatant's Helm"),
        item( 61110, "Combatant's Shoulderguards"),
        item( 61111, "Combatant's Chainmail"),
        item( 61112, "Combatant's Handguards"),
        item( 61113, "Combatant's Legguards"),
        item( 61114, "Combatant's Treads"),
        item( 61115, "Combatant's Bracers"),
        item( 61116, "Combatant's Cinch"),
    }),
    boss("Combatant's Weapons", {
        item( 61146, "Combatant's Dagger"),
        item( 61147, "Combatant's Hatchet"),
        item( 61148, "Combatant's Mallet"),
        item( 61149, "Combatant's Saber"),
        item( 61150, "Combatant's Claw"),
        item( 61151, "Combatant's Spellblade"),
        item( 61152, "Combatant's Medical Knife"),
        item( 61153, "Combatant's Frill"),
        item( 61154, "Combatant's Tome"),
        item( 61155, "Combatant's Staff"),
        item( 61156, "Combatant's Stave"),
        item( 61157, "Combatant's Spellfist"),
        item( 61158, "Combatant's Spellhammer"),
        item( 61159, "Combatant's Spellsword"),
        item( 61160, "Combatant's Healing Knuckles"),
        item( 61161, "Combatant's Scepter"),
        item( 61162, "Combatant's Brand"),
        item( 61167, "Combatant's Battleaxe"),
        item( 61168, "Combatant's Maul"),
        item( 61169, "Combatant's Greatsword"),
        item( 61170, "Combatant's Spellshield"),
        item( 61171, "Combatant's Shield"),
        item( 61172, "Combatant's Protector"),
        item( 61173, "Combatant's Axe"),
        item( 61174, "Combatant's Mace"),
        item( 61175, "Combatant's Sword"),
        item( 61176, "Combatant's Knuckles"),
        item( 61163, "Combatant's Rifle"),
        item( 61164, "Combatant's Bow"),
        item( 61165, "Combatant's Crossbow"),
        item( 61166, "Combatant's Knives"),
        item( 61177, "Combatant's Frostflinger"),
        item( 61178, "Combatant's Firestick"),
        item( 61179, "Combatant's Shadowthrower"),
        item( 61180, "Combatant's Arcane Wand"),
        item( 61181, "Combatant's Lightning Rod"),
    }),
    boss("Combatant's Accessories", {
        item( 61136, "Combatant's Band of Physical Potency"),
        item( 61135, "Combatant's Band of Physical Cruelty"),
        item( 61134, "Combatant's Band of Physical Accuracy"),
        item( 61133, "Combatant's Band of Meditation"),
        item( 61132, "Combatant's Band of Magic Potency"),
        item( 61131, "Combatant's Band of Magic Cruelty"),
        item( 61130, "Combatant's Band of Magic Accuracy"),
        item( 61129, "Combatant's Band of Survival"),
        item( 61127, "Combatant's Amulet of Agility"),
        item( 61126, "Combatant's Amulet of Strength"),
        item( 61125, "Combatant's Amulet of Spellcasting"),
        item( 61128, "Combatant's Amulet of Meditation"),
        item( 61124, "Combatant's Cloak of Physical Potency"),
        item( 61123, "Combatant's Cloak of Physical Cruelty"),
        item( 61122, "Combatant's Cloak of Physical Accuracy"),
        item( 61121, "Combatant's Cloak of Meditation"),
        item( 61120, "Combatant's Cloak of Magic Potency"),
        item( 61119, "Combatant's Cloak of Magic Cruelty"),
        item( 61118, "Combatant's Cloak of Magic Accuracy"),
        item( 61117, "Combatant's Cloak of Survival"),
        item( 61139, "Combatant's Emblem of Tenacity"),
        item( 61138, "Combatant's Insignia of the Alliance"),
        item( 61137, "Combatant's Insignia of the Horde"),
    }),
}, "set")

-- =====================================================================
zone("PvP - Aspirant (Level 45)", {
    boss("Aspirant's Armor", {
        item( 61182, "Aspirant's Hood"),
        item( 61183, "Aspirant's Mantle"),
        item( 61184, "Aspirant's Robe"),
        item( 61185, "Aspirant's Handcloth"),
        item( 61186, "Aspirant's Leggings"),
        item( 61187, "Aspirant's Slippers"),
        item( 61188, "Aspirant's Wristwraps"),
        item( 61189, "Aspirant's Waistband"),
        item( 61190, "Aspirant's Cowl"),
        item( 61191, "Aspirant's Stole"),
        item( 61192, "Aspirant's Raiment"),
        item( 61193, "Aspirant's Hands"),
        item( 61194, "Aspirant's Legwarmers"),
        item( 61195, "Aspirant's Bootlets"),
        item( 61196, "Aspirant's Braceletts"),
        item( 61197, "Aspirant's Sash"),
        item( 61198, "Aspirant's Cloche"),
        item( 61199, "Aspirant's Pads"),
        item( 61200, "Aspirant's Leather"),
        item( 61201, "Aspirant's Mitts"),
        item( 61202, "Aspirant's Pantaloons"),
        item( 61203, "Aspirant's Riders"),
        item( 61204, "Aspirant's Armguards"),
        item( 61205, "Aspirant's Strap"),
        item( 61206, "Aspirant's Casque"),
        item( 61207, "Aspirant's Rerebrace"),
        item( 61208, "Aspirant's Cuirass"),
        item( 61209, "Aspirant's Palms"),
        item( 61210, "Aspirant's Breeches"),
        item( 61211, "Aspirant's Soles"),
        item( 61212, "Aspirant's Leather Cuffs"),
        item( 61213, "Aspirant's Leather Belt"),
        item( 61214, "Aspirant's Cap"),
        item( 61215, "Aspirant's Shoulders"),
        item( 61216, "Aspirant's Tunic"),
        item( 61217, "Aspirant's Gloves"),
        item( 61218, "Aspirant's Pants"),
        item( 61219, "Aspirant's Boots"),
        item( 61220, "Aspirant's Cuffs"),
        item( 61221, "Aspirant's Belt"),
        item( 61222, "Aspirant's Skullcap"),
        item( 61223, "Aspirant's Shoulderlinks"),
        item( 61224, "Aspirant's Haubergeon"),
        item( 61225, "Aspirant's Chain Gloves"),
        item( 61226, "Aspirant's Chausses"),
        item( 61227, "Aspirant's Waders"),
        item( 61228, "Aspirant's Ringed Armguards"),
        item( 61229, "Aspirant's Mail Belt"),
        item( 61230, "Aspirant's Coif"),
        item( 61231, "Aspirant's Chaindrapes"),
        item( 61232, "Aspirant's Links"),
        item( 61233, "Aspirant's Demi-gaunts"),
        item( 61234, "Aspirant's Leglinks"),
        item( 61235, "Aspirant's Bootlinks"),
        item( 61236, "Aspirant's Wrists"),
        item( 61237, "Aspirant's Buckle"),
        item( 61238, "Aspirant's Chain Cloche"),
        item( 61239, "Aspirant's Light Pauldrons"),
        item( 61240, "Aspirant's Hauberk"),
        item( 61241, "Aspirant's Grips"),
        item( 61242, "Aspirant's Kilt"),
        item( 61243, "Aspirant's Stompers"),
        item( 61244, "Aspirant's Manacles"),
        item( 61245, "Aspirant's Chain"),
        item( 61246, "Aspirant's Helm"),
        item( 61247, "Aspirant's Shoulderguards"),
        item( 61248, "Aspirant's Chainmail"),
        item( 61249, "Aspirant's Handguards"),
        item( 61250, "Aspirant's Legguards"),
        item( 61251, "Aspirant's Treads"),
        item( 61252, "Aspirant's Bracers"),
        item( 61253, "Aspirant's Cinch"),
        item( 61274, "Aspirant's Dome"),
        item( 61275, "Aspirant's Platepads"),
        item( 61276, "Aspirant's Breastplate"),
        item( 61277, "Aspirant's Plated Fists"),
        item( 61278, "Aspirant's Plate Pants"),
        item( 61279, "Aspirant's Sabatons"),
        item( 61280, "Aspirant's Wristguards"),
        item( 61281, "Aspirant's Girdle"),
        item( 61282, "Aspirant's Helmet"),
        item( 61283, "Aspirant's Shoulderplates"),
        item( 61284, "Aspirant's Chestplate"),
        item( 61285, "Aspirant's Gauntlets"),
        item( 61286, "Aspirant's Legplates"),
        item( 61287, "Aspirant's Greaves"),
        item( 61288, "Aspirant's Armplates"),
        item( 61289, "Aspirant's Waistguard"),
    }),
    boss("Aspirant's Weapons", {
        item( 61305, "Aspirant's Dagger"),
        item( 61306, "Aspirant's Hatchet"),
        item( 61307, "Aspirant's Mallet"),
        item( 61308, "Aspirant's Saber"),
        item( 61309, "Aspirant's Claw"),
        item( 61310, "Aspirant's Spellblade"),
        item( 61311, "Aspirant's Medical Knife"),
        item( 61312, "Aspirant's Frill"),
        item( 61313, "Aspirant's Tome"),
        item( 61314, "Aspirant's Staff"),
        item( 61315, "Aspirant's Stave"),
        item( 61316, "Aspirant's Spellfist"),
        item( 61317, "Aspirant's Spellhammer"),
        item( 61318, "Aspirant's Spellsword"),
        item( 61319, "Aspirant's Healing Knuckles"),
        item( 61320, "Aspirant's Scepter"),
        item( 61321, "Aspirant's Brand"),
        item( 61326, "Aspirant's Battleaxe"),
        item( 61327, "Aspirant's Maul"),
        item( 61328, "Aspirant's Greatsword"),
        item( 61329, "Aspirant's Spellshield"),
        item( 61330, "Aspirant's Shield"),
        item( 61331, "Aspirant's Protector"),
        item( 61332, "Aspirant's Axe"),
        item( 61333, "Aspirant's Mace"),
        item( 61334, "Aspirant's Sword"),
        item( 61335, "Aspirant's Knuckles"),
        item( 61322, "Aspirant's Rifle"),
        item( 61323, "Aspirant's Bow"),
        item( 61324, "Aspirant's Crossbow"),
        item( 61325, "Aspirant's Knives"),
        item( 61336, "Aspirant's Frostflinger"),
        item( 61337, "Aspirant's Firestick"),
        item( 61338, "Aspirant's Shadowthrower"),
        item( 61339, "Aspirant's Arcane Wand"),
        item( 61340, "Aspirant's Lightning Rod"),
    }),
    boss("Aspirant's Accessories", {
        item( 61304, "Aspirant's Emblem of Renewal"),
        item( 61303, "Aspirant's Emblem of Upturn"),
        item( 61302, "Aspirant's Emblem of Power"),
        item( 61301, "Aspirant's Emblem of Alacrity"),
        item( 61300, "Aspirant's Emblem of Dominance"),
        item( 61299, "Aspirant's Emblem of Betterment"),
        item( 61298, "Aspirant's Emblem of Cogitation"),
        item( 61297, "Aspirant's Emblem of Magick"),
        item( 61296, "Aspirant's Emblem of Ferocity"),
        item( 61295, "Aspirant's Emblem of Vigor"),
        item( 61292, "Aspirant's Emblem of Tenacity"),
        item( 61294, "Aspirant's Insignia of Relentlessness"),
        item( 61293, "Aspirant's Insignia of Adaptation"),
        item( 61291, "Aspirant's Insignia of the Alliance"),
        item( 61290, "Aspirant's Insignia of the Horde"),
        item( 61273, "Aspirant's Band of Physical Potency"),
        item( 61272, "Aspirant's Band of Physical Cruelty"),
        item( 61271, "Aspirant's Band of Physical Accuracy"),
        item( 61270, "Aspirant's Band of Meditation"),
        item( 61269, "Aspirant's Band of Magic Potency"),
        item( 61268, "Aspirant's Band of Magic Cruelty"),
        item( 61267, "Aspirant's Band of Magic Accuracy"),
        item( 61266, "Aspirant's Band of Survival"),
        item( 61261, "Cloak of Physical Potency"),
        item( 61260, "Cloak of Physical Cruelty"),
        item( 61259, "Cloak of Physical Accuracy"),
        item( 61258, "Cloak of Meditation"),
        item( 61257, "Cloak of Magic Potency"),
        item( 61256, "Cloak of Magic Cruelty"),
        item( 61255, "Cloak of Magic Accuracy"),
        item( 61254, "Cloak of Survival"),
        item( 61265, "Amulet of Meditation"),
        item( 61264, "Amulet of Agility"),
        item( 61263, "Amulet of Strength"),
        item( 61262, "Amulet of Spellcasting"),
    }),
}, "set")

-- =====================================================================
zone("PvP - Soldier (Level 55)", {
    boss("Soldier's Weapons", {
        item( 61498, "Soldier's Dagger"),
        item( 61499, "Soldier's Hatchet"),
        item( 61500, "Soldier's Mallet"),
        item( 61501, "Soldier's Saber"),
        item( 61502, "Soldier's Claw"),
        item( 61503, "Soldier's Spellblade"),
        item( 61504, "Soldier's Medical Knife"),
        item( 61505, "Soldier's Frill"),
        item( 61506, "Soldier's Tome"),
        item( 61507, "Soldier's Staff"),
        item( 61508, "Soldier's Stave"),
        item( 61509, "Soldier's Spellfist"),
        item( 61510, "Soldier's Spellhammer"),
        item( 61511, "Soldier's Spellsword"),
        item( 61512, "Soldier's Healing Knuckles"),
        item( 61513, "Soldier's Scepter"),
        item( 61514, "Soldier's Brand"),
        item( 61521, "Soldier's Battleaxe"),
        item( 61522, "Soldier's Maul"),
        item( 61523, "Soldier's Greatsword"),
        item( 61524, "Soldier's Spellshield"),
        item( 61525, "Soldier's Shield"),
        item( 61526, "Soldier's Protector"),
        item( 61527, "Soldier's Axe"),
        item( 61528, "Soldier's Mace"),
        item( 61529, "Soldier's Sword"),
        item( 61530, "Soldier's Knuckles"),
        item( 61515, "Soldier's Idol"),
        item( 61516, "Soldier's Libram"),
        item( 61517, "Soldier's Rifle"),
        item( 61518, "Soldier's Bow"),
        item( 61519, "Soldier's Crossbow"),
        item( 61520, "Soldier's Knives"),
        item( 61531, "Soldier's Totem"),
        item( 61532, "Soldier's Frostflinger"),
        item( 61533, "Soldier's Firestick"),
        item( 61534, "Soldier's Shadowthrower"),
        item( 61535, "Soldier's Arcane Wand"),
        item( 61536, "Soldier's Lightning Rod"),
    }),
    boss("Soldier's Accessories", {
        item( 61495, "Emblem of Renewal"),
        item( 61494, "Emblem of Upturn"),
        item( 61493, "Emblem of Power"),
        item( 61492, "Emblem of Alacrity"),
        item( 61491, "Emblem of Dominance"),
        item( 61490, "Emblem of Betterment"),
        item( 61489, "Emblem of Cogitation"),
        item( 61488, "Emblem of Magick"),
        item( 61487, "Emblem of Ferocity"),
        item( 61486, "Emblem of Vigor"),
        item( 61485, "Emblem of Tenacity"),
        item( 61144, "Insignia of Relentlessness"),
        item( 61142, "Insignia of Adaptation"),
        item( 61141, "Insignia of the Alliance"),
        item( 61140, "Insignia of the Horde"),
        item( 61460, "Band of Physical Potency"),
        item( 61459, "Band of Physical Crit"),
        item( 61458, "Band of Physical Accuracy"),
        item( 61457, "Band of Magic Potency"),
        item( 61456, "Band of Magic Cruelty"),
        item( 61455, "Band of Magic Accuracy"),
        item( 61454, "Band of Survival"),
        item( 61453, "Band of Meditation"),
        item( 61452, "Amulet of Spellcasting"),
        item( 90500, "Amulet of Strength"),
        item( 90501, "Amulet of Agility"),
        item( 90502, "Amulet of Meditation"),
        item( 61450, "Cloak of Physical Potency"),
        item( 61449, "Cloak of Physical Cruelty"),
        item( 61448, "Cloak of Physical Accuracy"),
        item( 61447, "Cloak of Magic Potency"),
        item( 61446, "Cloak of Magic Cruelty"),
        item( 61445, "Cloak of Magic Accuracy"),
        item( 61444, "Cloak of Survival"),
        item( 61443, "Cloak of Meditation"),
    }),
    boss("Battlemage's Regalia", {
        item( 61349, "Battlemage Crown"),
        item( 61350, "Battlemage Mantle"),
        item( 61351, "Battlemage Robe"),
        item( 61352, "Battlemage Gloves"),
        item( 61353, "Battlemage Leggings"),
        item( 61354, "Battlemage Boots"),
    }),
    boss("Divined Vestments", {
        item( 61355, "Divined Crown"),
        item( 61356, "Divined Mantle"),
        item( 61357, "Divined Robe"),
        item( 61358, "Divined Gloves"),
        item( 61359, "Divined Skirt"),
        item( 61360, "Divined Sandals"),
    }),
    boss("Vanta Vestments", {
        item( 61361, "Vanta Mask"),
        item( 61362, "Vanta Mantle"),
        item( 61363, "Vanta Robe"),
        item( 61364, "Vanta Wraps"),
        item( 61365, "Vanta Leggings"),
        item( 61366, "Vanta Sandals"),
    }),
    boss("Shadowcaster's Regalia", {
        item( 61367, "Shadowcaster Mask"),
        item( 61368, "Shadowcaster Mantle"),
        item( 61369, "Shadowcaster Robe"),
        item( 61370, "Shadowcaster Wraps"),
        item( 61371, "Shadowcaster Leggings"),
        item( 61372, "Shadowcaster Sandals"),
    }),
    boss("Afflictor's Regalia", {
        item( 61373, "Afflictor Mask"),
        item( 61374, "Afflictor Mantle"),
        item( 61375, "Afflictor Robe"),
        item( 61376, "Afflictor Wraps"),
        item( 61377, "Afflictor Leggings"),
        item( 61378, "Afflictor Sandals"),
    }),
    boss("Animalistic Armor", {
        item( 61379, "Animalistic Cowl"),
        item( 61380, "Animalistic Spaulders"),
        item( 61381, "Animalistic Vest"),
        item( 61382, "Animalistic Gloves"),
        item( 61383, "Animalistic Kilt"),
        item( 61384, "Animalistic Boots"),
    }),
    boss("Astral Armor", {
        item( 61385, "Astral Cowl"),
        item( 61386, "Astral Spaulders"),
        item( 61387, "Astral Vest"),
        item( 61388, "Astral Gloves"),
        item( 61389, "Astral Kilt"),
        item( 61390, "Astral Boots"),
    }),
    boss("Barking Armor", {
        item( 61391, "Barking Cowl"),
        item( 61392, "Barking Spaulders"),
        item( 61393, "Barking Vest"),
        item( 61394, "Barking Gloves"),
        item( 61395, "Barking Kilt"),
        item( 61396, "Barking Boots"),
    }),
    boss("Scouting Armor", {
        item( 61405, "Scouting Cap"),
        item( 61406, "Scouting Spaulders"),
        item( 61407, "Scouting Tunic"),
        item( 61408, "Scouting Gloves"),
        item( 61409, "Scouting Pants"),
        item( 61410, "Scouting Boots"),
        item( 61403, "Wrists of Assault"),
        item( 61399, "Belt of Assault"),
    }),
    boss("Ranger Garb", {
        item( 61419, "Ranger Cap"),
        item( 61420, "Ranger Mantle"),
        item( 61421, "Ranger Tunic"),
        item( 61422, "Ranger Gloves"),
        item( 61423, "Ranger Pants"),
        item( 61424, "Ranger Boots"),
        item( 61418, "Bindings of Assault"),
        item( 61414, "Cord of Assault"),
    }),
    boss("Shockchain Armor", {
        item( 61425, "Shockchain Coif"),
        item( 61426, "Shockchain Pauldrons"),
        item( 61427, "Shockchain Vest"),
        item( 61428, "Shockchain Gauntlets"),
        item( 61429, "Shockchain Kilt"),
        item( 61430, "Shockchain Boots"),
    }),
    boss("Capacitor Armor", {
        item( 61431, "Capacitor Coif"),
        item( 61432, "Capacitor Pauldrons"),
        item( 61433, "Capacitor Vest"),
        item( 61434, "Capacitor Gauntlets"),
        item( 61435, "Capacitor Kilt"),
        item( 61436, "Capacitor Boots"),
    }),
    boss("Tidal Armor", {
        item( 61437, "Tidal Coif"),
        item( 61438, "Tidal Pauldrons"),
        item( 61439, "Tidal Vest"),
        item( 61440, "Tidal Gauntlets"),
        item( 61441, "Tidal Kilt"),
        item( 61442, "Tidal Boots"),
    }),
    boss("Righteous Armor", {
        item( 61467, "Righteous Helm"),
        item( 61468, "Righteous Spaulders"),
        item( 61469, "Righteous Breastplate"),
        item( 61470, "Righteous Gauntlets"),
        item( 61471, "Righteous Legplates"),
        item( 61472, "Righteous Boots"),
    }),
    boss("Truthful Armor", {
        item( 61473, "Truthful Helm"),
        item( 61474, "Truthful Spaulders"),
        item( 61475, "Truthful Breastplate"),
        item( 61476, "Truthful Gauntlets"),
        item( 61477, "Truthful Legplates"),
        item( 61478, "Truthful Boots"),
    }),
    boss("Plated Battlegear", {
        item( 61479, "Plated Helm"),
        item( 61480, "Plated Spaulders"),
        item( 61481, "Plated Breast"),
        item( 61482, "Plated Gauntlets"),
        item( 61483, "Plated Legs"),
        item( 61484, "Plated Boots"),
    }),
}, "set")

-- =====================================================================
zone("World Epics", {
    boss("Cloth & Armor", {
        item(   867, "Gloves of Holy Might"),
        item(  1981, "Icemail Jerkin"),
        item(  1980, "Underworld Band"),
        item( 60799, "Satyr's Grimoire"),
        item( 60802, "Umbral Frostcloak"),
        item(  3075, "Eye of Flame"),
        item(   940, "Robes of Insight"),
        item( 14551, "Edgemaster's Handguards"),
        item( 17007, "Stonerender Gauntlets"),
        item( 14549, "Boots of Avoidance"),
        item(  1315, "Lei of Lilies"),
        item(   942, "Freezing Band"),
        item(  1447, "Ring of Saviors"),
        item( 60803, "Windshear Cloak"),
        item( 60804, "Stalkerhide Jerkin"),
        item( 60807, "Ancient Highborne Vestments"),
        item( 60808, "Band of Restoration"),
        item( 60811, "Sigil of Lordaeron"),
        item( 60813, "Cinderflux Tunic"),
        item( 60817, "Ironbark Chestplate"),
        item(  1443, "Jeweled Amulet of Cainwyn"),
        item(  2245, "Helm of Narv"),
        item(  2246, "Myrmidon's Signet"),
        item(   833, "Lifestone"),
        item( 14552, "Stockade Pauldrons"),
        item(  3475, "Cloak of Flames"),
        item( 14558, "Lady Maye's Pendant"),
        item( 14557, "The Lion Horn of Stormwind"),
        item( 14554, "Cloudkeeper Legplates"),
        item( 60819, "Kirin Tor Skeleton Key"),
        item( 14553, "Sash of Mercy"),
    }),
    boss("Weapons", {
        item(   869, "Dazzling Longsword"),
        item(  1982, "Nightblade"),
        item(   870, "Fiery War Axe"),
        item(   868, "Ardent Custodian"),
        item(   873, "Staff of Jordan"),
        item(  1204, "The Green Tower"),
        item(  2825, "Bow of Searing Arrows"),
        item( 60798, "Knightsblade"),
        item( 60800, "Formidable Dagger"),
        item( 60801, "Fleshrender"),
        item(  2164, "Gut Ripper"),
        item(  2163, "Shadowblade"),
        item(   809, "Bloodrazor"),
        item(   871, "Flurry Axe"),
        item(  2291, "Kang the Decapitator"),
        item(   810, "Hammer of the Northern Wind"),
        item(  2915, "Taran Icebreaker"),
        item(   812, "Glowing Brightwood Staff"),
        item(   943, "Warden Staff"),
        item(  1169, "Blackskull Shield"),
        item(  1979, "Wall of the Dead"),
        item(  2824, "Hurricane"),
        item(  2100, "Precisely Calibrated Boomstick"),
        item( 60805, "Spellcarved Blade"),
        item( 60806, "Lightwarden's Bulwark"),
        item( 60809, "Frostwake"),
        item( 60810, "Stormtouch"),
        item(  1263, "Brain Hacker"),
        item( 60816, "Verdant Benediction"),
        item(  1168, "Skullflame Shield"),
        item( 60815, "Huntsman's Pike"),
        item(  2099, "Dwarven Hand Cannon"),
        item( 60814, "Skullbore"),
        item(   647, "Destiny"),
        item(   811, "Axe of the Deep Woods"),
        item(  2244, "Krol Blade"),
        item( 60812, "Blessed Quarrelcaster"),
        item(  1728, "Teebu's Blazing Longsword"),
        item( 60821, "Starwell"),
        item( 60820, "Obsidian Halberd"),
        item(  2801, "Blade of Hanna"),
        item( 14555, "Alcor's Sunrazor"),
        item(  2243, "Hand of Edward the Odd"),
        item(   944, "Elemental Mage Staff"),
        item( 60818, "Stormhowler"),
    }),
}, "set")
