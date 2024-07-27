local _, ns = ...
local Dispels = ns.Dispels

-- Lua
local band = bit.band
local format = string.format
local tinsert = table.insert
local tremove = table.remove

-- Blizzard
-- LE_EXPANSION_LEVEL_CURRENT
local LE_EXPANSION_CLASSIC = _G.LE_EXPANSION_CLASSIC or 0                               -- Vanilla / Classic Era
local LE_EXPANSION_BURNING_CRUSADE = _G.LE_EXPANSION_BURNING_CRUSADE or 1	            -- The Burning Crusade
local LE_EXPANSION_WRATH_OF_THE_LICH_KING = _G.LE_EXPANSION_WRATH_OF_THE_LICH_KING or 2 -- Wrath of the Lich King
local LE_EXPANSION_CATACLYSM = _G.LE_EXPANSION_CATACLYSM or 3	                        -- Cataclysm
local LE_EXPANSION_MISTS_OF_PANDARIA = _G.LE_EXPANSION_MISTS_OF_PANDARIA or 4	        -- Mists of Pandaria
local LE_EXPANSION_WARLORDS_OF_DRAENOR = _G.LE_EXPANSION_WARLORDS_OF_DRAENOR or 5	    -- Warlords of Draenor
local LE_EXPANSION_LEGION = _G.LE_EXPANSION_LEGION or 6	                                -- Legion
local LE_EXPANSION_BATTLE_FOR_AZEROTH = _G.LE_EXPANSION_BATTLE_FOR_AZEROTH or 7	        -- Battle for Azeroth
local LE_EXPANSION_SHADOWLANDS = _G.LE_EXPANSION_SHADOWLANDS or 8                       -- Shadowlands
local LE_EXPANSION_DRAGONFLIGHT = _G.LE_EXPANSION_DRAGONFLIGHT or 9	                    -- Dragonflight
local LE_EXPANSION_11_0 = _G.LE_EXPANSION_11_0 or 10                                    -- War WithIn

local GetInstanceInfo = _G.GetInstanceInfo
local IsInInstance = _G.IsInInstance
local IsInGroup = _G.IsInGroup
local IsInRaid = _G.IsInRaid
local CombatLogGetCurrentEventInfo = _G.CombatLogGetCurrentEventInfo
local GetSpellLink = C_Spell and C_Spell.GetSpellLink or _G.GetSpellLink
local GetSpellInfo = C_Spell and C_Spell.GetSpellInfo or _G.GetSpellInfo
local GetSpellName = C_Spell and C_Spell.GetSpellName or _G.GetSpellInfo
local SendChatMessage = _G.SendChatMessage
local COMBATLOG_OBJECT_AFFILIATION_MINE = _G.COMBATLOG_OBJECT_AFFILIATION_MINE  -- 0x00000001
local COMBATLOG_OBJECT_TYPE_PET = _G.COMBATLOG_OBJECT_TYPE_PET                  -- 0x00001000

local spells = {}
spells[0] = {}      -- General this auras are applyed for all instances, even open world

do
    -- General
    local general = spells[0]

    if Dispels.isRetail then
        -- Mithyc+ Affixes
        general[395938] = true          -- Necrotic Decay
        general[395946] = true          -- Putrid Bolt Poison
        general[395950] = true          -- Festeing Burst Poison
        general[409472] = true          -- Diseased Spirit

        -- for testing, Ohn'ahran Plains - Nethazan Ruin, above Maruukai
        general[375359] = true          -- Frenzy! (Enrage)
    end

    -- Clasic
    if Dispels.isClassic or (LE_EXPANSION_LEVEL_CURRENT > LE_EXPANSION_CLASSIC) then
        -- [33] Shadowfang Keep
        -- [34] The Stockade
        -- [36] The Deadmines
        -- [43] Wailing Caverns
        -- [47] Razorfen Kraul
        -- [48] Blackfathom Deeps
        -- [70] Uldaman
        -- [90] Gnomeregan
        -- [109] The Temple of Atal'Hakkar
        -- [129] Razorfen Downs
        -- [209] Zul'Farrak
        -- [229] Blackrock Spire
        -- [230] Blackrock Depths
        -- [309] Zul'Gurub
        -- [329] Stratholme
        -- [349] Maraudon
        -- [389] Ragefire Chasm
        -- [429] Dire Maul
        -- [409] Molten Core
        -- [469] Blackwing Lair
        -- [509] Ruins of Ahn'Qiraj
        -- [531] Ahn'Qiraj Temple
        -- [1001] Scarlet Halls
        -- [1004] Scarlet Monastery
        -- [1007] Scholomance
        -- [3456] Naxxramas
    end

    -- The Burning Crusade
    if Dispels.isBCC or (LE_EXPANSION_LEVEL_CURRENT > LE_EXPANSION_BURNING_CRUSADE) then
        -- [269] The Black Morass
        -- [540] The Shattered Halls
        -- [542] The Blood Furnace
        -- [543] Hellfire Ramparts
        -- [545] The Steamvault
        -- [546] The Underbog
        -- [547] The Slave Pens
        -- [552] The Arcatraz
        -- [553] The Botanica
        -- [554] The Mechanar
        -- [555] Shadow Labyrinth
        -- [556] Sethekk Halls
        -- [557] Mana-Tombs
        -- [558] Auchenai Crypts
        -- [560] Old Hillsbrad Foothills
        -- [585] Magisters' Terrace
        -- [532] Karazhan
        -- [534] The Battle for Mount Hyjal
        -- [544] Magtheridon's Lair
        -- [548] Serpentshrine Cavern
        -- [550] Tempest Keep: The Eye
        -- [564] Black Temple
        -- [565] Gruul's Lair
        -- [580] Sunwell Plateau
    end

    -- The Wrath of the Lich King
    if Dispels.isWotLK or (LE_EXPANSION_LEVEL_CURRENT > LE_EXPANSION_WRATH_OF_THE_LICH_KING) then
        -- [574] Utgarde Keep
        -- [575] Utgarde Pinnacle
        -- [576] The Nexus
        -- [578] The Oculus
        -- [595] The Culling of Stratholme
        -- [599] Halls of Stone
        -- [600] Drak'Tharon Keep
        -- [601] Azjol-Nerub
        -- [602] Halls of Lightning
        -- [604] Gundrak
        -- [608] The Violet Hold
        -- [619] Ahn'kahet: The Old Kingdom
        -- [632] The Forge of Souls
        -- [650] Trial of the Champion
        -- [658] Pit of Saron
        -- [668] Halls of Reflection
        -- [249] Onyxia's Lair
        -- [533] Naxxramas
        -- [603] Ulduar
        -- [615] The Obsidian Sanctum
        -- [616] The Eye of Eternity
        -- [624] Vault of Archavon
        -- [631] Icecrown Citadel
        -- [649] Trial of the Crusader
        -- [724] The Ruby Sanctum
    end

    -- Cataclysm
    if Dispels.isCata or (LE_EXPANSION_LEVEL_CURRENT > LE_EXPANSION_CATACLYSM) then
        -- The Vortex Pinnacle
        spells[657] = {
            [87618] = true              -- Static Cling
        }

        -- [568] Zul'Aman
        -- [643] Throne of the Tides
        -- [644] Halls of Origination
        -- [645] Blackrock Caverns
        -- [670] Grim Batol
        -- [725] The Stonecore
        -- [755] Lost City of the Tol'vir
        -- [859] Zul'Gurub
        -- [938] End Time
        -- [939] Well of Eternity
        -- [940] Hour of Twilight
        -- [669] Blackwing Descent
        -- [671] The Bastion of Twilight
        -- [720] Firelands
        -- [754] Throne of the Four Winds
        -- [757] Baradin Hold
        -- [967] Dragon Soul
    end

    -- Mists of Pandaria
    if (LE_EXPANSION_LEVEL_CURRENT > LE_EXPANSION_MISTS_OF_PANDARIA) then
        -- Temple of the Jade Serpent
        spells[960] = {
            [106113] = true             -- Touch of Nothingness
        }

        -- Terrace of Endless Spring
        spells[996] = {
            [117398] = true,            -- Lightning Prison
            [117235] = true,            -- Purified
            [123011] = true             -- Terrorize
        }

        -- Mogu'shan Vaults
        spells[1008] = {
            [117961] = true,            -- Impervious Shield
            [117697] = true,            -- Shield of Darkness
            [117837] = true,            -- Delirious
            [117949] = true             -- Closed Circuit
        }

        -- Heart of Fear
        spells[1009] = {
            [122149] = true,            -- Quickening
            [124862] = true             -- Visions of Demise
        }

        -- Siege of Orgrimmar
        spells[1136] = {
            [143791] = true             -- Corrosive Blood
        }

        -- [959] Shado-pan Monastery
        -- [961] Stormstout Brewery
        -- [962] Gate of the Setting Sun
        -- [994] Mogu'Shan Palace
        -- [1011] Siege of Niuzao Temple
        -- [1098] Throne of Thunder
    end

    -- Warlords of Draenor
    if (LE_EXPANSION_LEVEL_CURRENT > LE_EXPANSION_WARLORDS_OF_DRAENOR) then
        -- [1182] Auchindoun
        -- [1175] Bloodmaul Slag Mines
        -- [1176] Shadowmoon Burial Grounds
        -- [1195] Iron Docks
        -- [1208] Grimrail Depot
        -- [1209] Skyreach
        -- [1279] The Everbloom
        -- [1358] Upper Blackrock Spire
        -- [1205] Blackrock Foundry
        -- [1228] Highmaul
        -- [1448] Hellfire Citadel
    end

    -- Legion
    if (LE_EXPANSION_LEVEL_CURRENT > LE_EXPANSION_LEGION) then
        -- [1456] Eye of Azshara
        -- [1458] Neltharion's Lair
        -- [1466] Darkheart Thicket
        -- [1477] Halls of Valor
        -- [1492] Maw of Souls
        -- [1493] Vault of the Wardens
        -- [1501] Black Rook Hold
        -- [1516] The Arcway
        -- [1544] Violet Hold
        -- [1571] Court of Stars
        -- [1651] Return to Karazhan
        -- [1677] Cathedral of Eternal Night
        -- [1753] Seat of the Triumvirate
        -- [1520] The Emerald Nightmare
        -- [1530] The Nighthold
        -- [1648] Trial of Valor
        -- [1676] Tomb of Sargeras
        -- [1712] Antorus, the Burning Throne
    end

    -- Battle for Azeroth
    if (LE_EXPANSION_LEVEL_CURRENT > LE_EXPANSION_BATTLE_FOR_AZEROTH) then
        -- Freehold
        spells[1754] = {
            [257908] = true             -- Oiled Blade
        }

        -- [1594] The MOTHERLODE!!
        -- [1762] Kings' Rest
        -- [1763] Atal'Dazar
        -- [1771] Tol Dagor
        -- [1822] Siege of Boralus
        -- [1841] The Underrot
        -- [1862] Waycrest Manor
        -- [1864] Shrine of the Storm
        -- [1877] Temple of Sethraliss
        -- [2097] Operation: Mechagon
        -- [1861] Uldir
        -- [2070] Battle of Dazar'alor
        -- [2096] Crucible of Storms
        -- [2164] The Eternal Palace
        -- [2217] Ny'alotha
    end

    -- Shadowlands
    if (LE_EXPANSION_LEVEL_CURRENT > LE_EXPANSION_SHADOWLANDS) then
        -- [2284] Sanguine Depths
        -- [2285] Spires of Ascension
        -- [2286] The Necrotic Wake
        -- [2287] Halls of Atonement
        -- [2289] Plaguefall
        -- [2290] Mists of Tirna Scithe
        -- [2291] De Other Side
        -- [2293] Theater of Pain
        -- [2441] Tazavesh the Veiled Market
        -- [2296] Castle Nathria
        -- [2450] Sanctum of Domination
        -- [2481] Sepulcher of the First Ones
    end

    -- Dragonflight
    if (LE_EXPANSION_LEVEL_CURRENT > LE_EXPANSION_DRAGONFLIGHT) then
        -- The Azure Vault
        spells[2515] = {
            [374778] = true,            -- Brilliant Scale
            [375602] = true,            -- Erratic Growth
            [377488] = true,            -- Icy Bindings
            [387564] = false,           -- Mystic Vapor
        }

        -- The Nokhud Offensive
        spells[2516] = {
            -- Trash
            [334610] = true,            -- Hunt Prey (Enrage)
            [376827] = true,            -- Conductive Strike
            [383823] = true,            -- Rally the Clan (Enrage)
            [386025] = true,            -- Tempest
            [386223] = true,            -- Stormshield
            [387596] = true,            -- Swift Wind
            [387614] = true,            -- Chant of the Dead (Enrage)
            [379033] = true,            -- Vicious Howl (Enrage)
        }

        -- Neltharus
        spells[2519] = {
            [372461] = true,            -- Imbued Magma
            [378149] = true             -- Granite Shell
        }

        -- Brackenhide Hollow
        spells[2520] = {
            -- Trash
            [382555] = true,            -- Ragestorm (Enrage)

            -- Hackclaw's War-Band
            [381379] = true             -- Decayed Senses
        }

        -- Ruby Life Pools
        spells[2521] = {
            -- Trash
            [372749] = true,            -- Ice Shield
            [373589] = true,            -- Primal Chill
            [373972] = true,            -- Blaze of Glory

            -- Melidrussa Chillworm
            [372682] = true             -- Primal Chill
        }

        -- Algeth'ar Academy
        spells[2526] = {
            -- Trash
            [390938] = true,            -- Agitation (Enrage)
            [377389] = true,            -- Call of the Flock (Enrage)

            -- Overgrown Ancient
            [389033] = true             -- Lasher Toxin
        }

        -- Halls of Infusion
        spells[2527] = {
            -- Trash
            [374724] = true,            -- Molten Subduction
            [375384] = true,            -- Rumbling Earth
            [391634] = false,           -- Deep Chill

            -- Gulping Goliath
            [385743] = true,            -- Hangry (Enrage)

            -- Primal Tsunami
            [383204] = true,            -- Crashing Tsunami
        }

        -- Uldaman: Legacy of Tyr
        spells[2451] = {
            [369365] = true,            -- Curse of Stone
            [369366] = true,            -- Trapped in Stone
            [369400] = true             -- Earthen Ward
        }

        -- [2579] Dawn of the Infinite
        -- [2522] Vault of the Incarnates
        -- [2569] Aberrus, the Shadowed Crucible
        -- [2549] Amidrassil, the Dream's Hope
    end

    if Dispels.isRetail then
        -- patch 11.0.0
    end
end

local CombatEvents = {
    ["SPELL_DISPEL"] = true,
    ["SPELL_STOLEN"] = true,
    ["SPELL_DISPEL_FAILED"] = true
}

function Dispels:print(...)
    print("|cffff8000Dispels:|r", ...)
end

function Dispels:error(...)
    print("|cffff4500Dispels:|r", ...)
end

function Dispels:ImportInstanceData(dest, instanceID)
    if not instanceID then
        instanceID = 0
    end
    if not spells[instanceID] then return end
    for spellID, enabled in next, spells[instanceID] do
        if enabled then
            dest[spellID] = true
        end
    end
end

function Dispels:PLAYER_LOGIN()
    self.unit = "player"
    self.guid = UnitGUID(self.unit)
    self.chatType = "SAY"

    for zoneID, zoneData in next, spells do
        for spellID, enabled in next, zoneData do
            local name = GetSpellName(spellID)
            if not name then
                self:error("[" .. zoneID .. "] Spell " .. spellID .. " do not exists")
                spells[zoneID][spellID] = nil
            end
        end
    end
end

function Dispels:PLAYER_ENTERING_WORLD()
    self.auras = table.wipe(self.auras or {})

    local isInInstance, instanceType = IsInInstance()
    local instanceName, instanceType, _, _, _, _, _, instanceID, _, _ = GetInstanceInfo()
    
    if isInInstance and (instanceType == "raid" or instanceType == "party") then
        -- copy general auras
        self:ImportInstanceData(self.auras)

        -- import instance auras
        -- https://wowpedia.fandom.com/wiki/InstanceID
        self:ImportInstanceData(self.auras, instanceID)

        -- start listening to combat log
        self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
    else
        -- stop listening to combat log
        self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
    end
end

function Dispels:SendChatMessage(fmt, ...)
    local text = format(fmt, ...)
    SendChatMessage(text, self.chatType or "SAY")
end

function Dispels:COMBAT_LOG_EVENT_UNFILTERED()
    local timestamp, eventType, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags,
        destGUID, destName, destFlags, destRaidFlags = CombatLogGetCurrentEventInfo()

    -- filter combat events type
    if (not CombatEvents[eventType]) then return end

    -- filter casters, only player or belong to player
    local isPlayer = (band(sourceFlags, COMBATLOG_OBJECT_AFFILIATION_MINE) ~= COMBATLOG_OBJECT_AFFILIATION_MINE) or (sourceGUID == self.guid)
    local isPet = (band(sourceFlags, COMBATLOG_OBJECT_TYPE_PET) ~= COMBATLOG_OBJECT_TYPE_PET) or (sourceGUID == UnitGUID("pet"))
    if not (isPlayer or isPet) then return end
    
    local spellID, spellName, spellSchool, extraSpellID, extraSpellName, extraSchool,
        auraType = select(12, CombatLogGetCurrentEventInfo())

    if self.auras[extraSpellID] then
        local extraSpellLink = GetSpellLink(extraSpellID)
        if (eventType == "SPELL_DISPEL") then
            self:SendChatMessage("%s %s dispeled!", destName, extraSpellLink)
        elseif (eventType == "SPELL_STOLEN") then
            self:SendChatMessage("%s's %s stolen!", destName, extraSpellLink)
        elseif (eventType == "SPELL_DISPEL_FAILED") then
            self:SendChatMessage("%s's %s dispel FAILED!", destName, extraSpellLink)
        end
    end
end 

Dispels:RegisterEvent("PLAYER_LOGIN")
Dispels:RegisterEvent("PLAYER_ENTERING_WORLD")
Dispels:SetScript("OnEvent", function(self, event, ...)
    -- call one of the event handlers
    self[event](self, ...)
end)
