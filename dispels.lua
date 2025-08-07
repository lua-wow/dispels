local _, ns = ...
local Dispels = ns.Dispels

-- Lua
local band = bit.band
local bor = bit.bor
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
local LE_EXPANSION_WAR_WITHIN = _G.LE_EXPANSION_WAR_WITHIN or 10                        -- War WithIn

local GetInstanceInfo = _G.GetInstanceInfo
local IsInInstance = _G.IsInInstance
local IsInGroup = _G.IsInGroup
local IsInRaid = _G.IsInRaid
local CombatLogGetCurrentEventInfo = _G.CombatLogGetCurrentEventInfo
local GetSpellLink = C_Spell and C_Spell.GetSpellLink or _G.GetSpellLink
local GetSpellInfo = C_Spell and C_Spell.GetSpellInfo or _G.GetSpellInfo
local GetSpellName = C_Spell and C_Spell.GetSpellName or _G.GetSpellInfo
local SendChatMessage = _G.SendChatMessage

local COMBATLOG_FILTER_ME = _G.COMBATLOG_FILTER_ME or bor(
    _G.COMBATLOG_OBJECT_AFFILIATION_MINE,
    _G.COMBATLOG_OBJECT_REACTION_FRIENDLY,
    _G.COMBATLOG_OBJECT_CONTROL_PLAYER,
    _G.COMBATLOG_OBJECT_TYPE_PLAYER
)

local COMBATLOG_FILTER_MINE = _G.COMBATLOG_FILTER_MINE or bor(
    _G.COMBATLOG_OBJECT_AFFILIATION_MINE,
    _G.COMBATLOG_OBJECT_REACTION_FRIENDLY,
    _G.COMBATLOG_OBJECT_CONTROL_PLAYER,
    _G.COMBATLOG_OBJECT_TYPE_PLAYER,
    _G.COMBATLOG_OBJECT_TYPE_OBJECT
)

local spells = {
    --------------------------------------------------
    -- Clasic
    --------------------------------------------------
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

    --------------------------------------------------
    -- The Burning Crusade
    --------------------------------------------------
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

    --------------------------------------------------
    -- The Wrath of the Lich King
    --------------------------------------------------
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
    
    --------------------------------------------------
    -- Cataclysm
    --------------------------------------------------
    -- The Vortex Pinnacle
    [657] = {
        [87618] = true                  -- Static Cling
    },
    -- Grim Batol
    [670] = {
        [451040] = true,                -- Rage (Enrage - Twilight Enforcer)
    },
    -- [568] Zul'Aman
    -- [643] Throne of the Tides
    -- [644] Halls of Origination
    -- [645] Blackrock Caverns
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

    --------------------------------------------------
    -- Mists of Pandaria
    --------------------------------------------------
    -- Temple of the Jade Serpent
    [960] = {
        [106113] = true             -- Touch of Nothingness
    },
    -- Terrace of Endless Spring
    [996] = {
        [117398] = true,            -- Lightning Prison
        [117235] = true,            -- Purified
        [123011] = true             -- Terrorize
    },
    -- Mogu'shan Vaults
    [1008] = {
        [117961] = true,            -- Impervious Shield
        [117697] = true,            -- Shield of Darkness
        [117837] = true,            -- Delirious
        [117949] = true             -- Closed Circuit
    },
    -- Heart of Fear
    [1009] = {
        [122149] = true,            -- Quickening
        [124862] = true             -- Visions of Demise
    },
    -- Siege of Orgrimmar
    [1136] = {
        [143791] = true             -- Corrosive Blood
    },
    -- [959] Shado-pan Monastery
    -- [961] Stormstout Brewery
    -- [962] Gate of the Setting Sun
    -- [994] Mogu'Shan Palace
    -- [1011] Siege of Niuzao Temple
    -- [1098] Throne of Thunder

    --------------------------------------------------
    -- Warlords of Draenor
    --------------------------------------------------
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

    --------------------------------------------------
    -- Legion
    --------------------------------------------------
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

    --------------------------------------------------
    -- Battle for Azeroth
    --------------------------------------------------
    -- [1594] The MOTHERLODE!!
    [1594] = {
        [259853] = true, -- Chemical Burn (Magic)
        [262092] = true, -- Inhale Vapors (Enrage)
        [263215] = true, -- Tectonic Barrier (Magic)
        [268797] = true, -- Transmute: Enemy to Goo (Magic)
        [268846] = true, -- Echo Blade (Magic)
        [269298] = false, -- Toxic Blades (Poison)
        [280604] = true, -- Iced Spritzer (Magic)
        [1213139] = true, -- Overtime! (Enrage)
    },
    -- Freehold
    [1754] = {
        [257908] = true             -- Oiled Blade
    },
    -- Siege of Boralus
    [1822] = {
        [274991] = true,            -- Putrid Waters
    },
    -- Operation: Mechagon
    [2097] = {
        -- Trash
        [293930] = true,            -- Overclock (Magic)
        [294195] = true,            -- Arcing Zap (Magic)
        [297133] = true,            -- Defensive Countermeasure (Magic)
        [1215415] = true,           -- Sticky Sludge (Disease)
        [1217821] = true,           -- Fiery Jaws (Magic)

        -- K.U.-J.0
        [294929] = true,            -- Blazing Chomp (Magic)

        -- Mechanist's Garden
        [285460] = true,            -- Discom-BOMB-ulator (Magic)
    },
    
    -- [1762] Kings' Rest
    -- [1763] Atal'Dazar
    -- [1771] Tol Dagor
    -- [1841] The Underrot
    -- [1862] Waycrest Manor
    -- [1864] Shrine of the Storm
    -- [1877] Temple of Sethraliss
    -- [1861] Uldir
    -- [2070] Battle of Dazar'alor
    -- [2096] Crucible of Storms
    -- [2164] The Eternal Palace
    -- [2217] Ny'alotha
    
    --------------------------------------------------
    -- Shadowlands
    --------------------------------------------------
    -- The Necrotic Wake
    [2286] = {
        [320012] = true,            -- Unholy Frenzy (Enrage)
        [320788] = true,            -- Frozen Binds (Magic)
        [323365] = true,            -- Clinging Darkness (Magic)
        [324293] = true,            -- Rasping Scream (Magic / Fear)
        [335141] = true,            -- Dark Shroud (Magic)
    },
    -- Mists of Tirna Scithe
    [2290] = {
        [322557] = true,            -- Soul Split
        [324737] = true,            -- Enraged (Enreage)
        [324776] = true,            -- Bramblethorn Coat (Magic)
    },
    -- Theater of Pain
    [2293] = {
        [330725] = true,            -- Shadow Vulnerability (Curse)
        [333293] = true,            -- Bone Shield (Magic)
        [1215600] = true,           -- Withering Touch (Magic)
    },
    --  Halls of Atonement
    [2287] = {
        [319611] = true,            -- Turned to Stone (Magic)
        [322977] = true,            -- Sinlight Visions (Fear)
        [325701] = true,            -- Siphon Life (Magic)
        [325876] = true,            -- Mark of Obliteration (Magic)
        [326450] = true,            -- Loyal Beasts (Enrage)
        [1235060] = true,           -- Anima Tainted Armor (Magic)
        [1236513] = true,           -- Unstable Anime (Magic)
        [1236514] = true,           -- Unstable Anime (Magic)
    },
    -- Tazavesh: Streets of Wonder
    [2441] = {
        -- Streets of Wonder
        [347775] = true,            -- Spam Filter (Mafic)
        [349954] = true,            -- Purification Protocol
        [353706] = true,            -- Rowdy (Enrage)
        [355641] = true,            -- Sintillate (Magic)
        [355888] = true,            -- Hard Light Baton (Magic)
        [355915] = true,            -- Glyph of Restraint (Magic)
        [355934] = true,            -- Hard Light Barrier (Magic)
        [355980] = true,            -- Refraction Shield (Magic)
        [356407] = true,            -- Ancient Dread (Curse)
        [356943] = true,            -- Lockdown (Magic)
        [357029] = true,            -- Hyperlight Bomb (Magic)
    
        -- So'leash's Gambit
        [347149] = true,            -- Infinite Breath (Magic / Stun)
        [355057] = true,            -- Cry of Mrrggllrrgg (Enrage)
        [356133] = true,            -- Super Saison (Enrage)
        [1240097] = true,           -- Time Bomb (Magic)
        [1240214] = true,           -- Double Time (Magic)
    },

    -- [2284] Sanguine Depths
    -- [2285] Spires of Ascension
    -- [2289] Plaguefall
    -- [2291] De Other Side
    -- [2441] Tazavesh the Veiled Market
    -- [2296] Castle Nathria
    -- [2450] Sanctum of Domination
    -- [2481] Sepulcher of the First Ones
    
    --------------------------------------------------
    -- Dragonflight
    --------------------------------------------------
    -- The Azure Vault
    [2515] = {
        [374778] = true,            -- Brilliant Scale
        [375602] = true,            -- Erratic Growth
        [377488] = true,            -- Icy Bindings
        [387564] = false,           -- Mystic Vapor
    },
    -- The Nokhud Offensive
    [2516] = {
        -- Trash
        [334610] = true,            -- Hunt Prey (Enrage)
        [376827] = true,            -- Conductive Strike
        [383823] = true,            -- Rally the Clan (Enrage)
        [386025] = true,            -- Tempest
        [386223] = true,            -- Stormshield
        [387596] = true,            -- Swift Wind
        [387614] = true,            -- Chant of the Dead (Enrage)
        [379033] = true,            -- Vicious Howl (Enrage)
    },
    -- Neltharus
    [2519] = {
        [372461] = true,            -- Imbued Magma
        [378149] = true             -- Granite Shell
    },
    -- Brackenhide Hollow
    [2520] = {
        -- Trash
        [382555] = true,            -- Ragestorm (Enrage)

        -- Hackclaw's War-Band
        [381379] = true             -- Decayed Senses
    },
    -- Ruby Life Pools
    [2521] = {
        -- Trash
        [372749] = true,            -- Ice Shield
        [373589] = true,            -- Primal Chill
        [373972] = true,            -- Blaze of Glory

        -- Melidrussa Chillworm
        [372682] = true             -- Primal Chill
    },
    -- Algeth'ar Academy
    [2526] = {
        -- Trash
        [390938] = true,            -- Agitation (Enrage)
        [377389] = true,            -- Call of the Flock (Enrage)

        -- Overgrown Ancient
        [389033] = true             -- Lasher Toxin
    },
    -- Halls of Infusion
    [2527] = {
        -- Trash
        [374724] = true,            -- Molten Subduction
        [375384] = true,            -- Rumbling Earth
        [391634] = false,           -- Deep Chill

        -- Gulping Goliath
        [385743] = true,            -- Hangry (Enrage)

        -- Primal Tsunami
        [383204] = true,            -- Crashing Tsunami
    },
    -- Uldaman: Legacy of Tyr
    [2451] = {
        [369365] = true,            -- Curse of Stone
        [369366] = true,            -- Trapped in Stone
        [369400] = true             -- Earthen Ward
    },
    -- [2579] Dawn of the Infinite
    -- [2522] Vault of the Incarnates
    -- [2569] Aberrus, the Shadowed Crucible
    -- [2549] Amidrassil, the Dream's Hope

    ----------------------------------------------------------
    -- The War Within
    ----------------------------------------------------------
    --  The Rookery
    [2648] = {
        [427260] = true,            -- Lightning Surge / Enrage Rook (Enrage)
        [469956] = true,            -- Lightning-Infused (Magic)
        [430179] = true,            -- Seeping Corruption (Curse)
        [429493] = true,            -- Unstable Corruption (Magic)
    },
    -- Priory of the Sacred Frame
    [2649] = {
        [435148] = true,            -- Blazing Stike (Magic)
        [427346] = true,            -- Inner Fire (Magic)
    },
    -- Darkflame Cleft
    [2651] = {
        [424650] = true,            -- Panicked! (Enrage)
        [425704] = true,            -- Enrage
        [426145] = true,            -- Paranoid Mind (Magic + Fear)
        [426295] = true,            -- Flaming Tether (Magic)
        [427929] = true,            -- Nasty Nibble (Disease)
        [428019] = true,            -- Flashpoint (Magic)
    },
    -- The Stonevault
    [2652] = {
        -- Trash
        [426308] = true,            -- Void Infection (Curse)
        [427382] = false,           -- Concussive Smash (Magic / Slow)
        [429545] = true,            -- Censoring Gear (Magic / Silence)
        [449455] = true,            -- Howling Fear (Magic / Fear)
        [469620] = true,            -- Creeping Shadow (Magic)

        -- E.D.N.A
        [424889] = true,            -- Seismic Reverberation (Magic)
    },
    -- Ara-Kara, City of Echoes
    [2660] = {
        [434802] = true,            -- Horrifying Shrill (Magic / Fear)
    },
    -- Cinderbrew Meadery
    [2661] = {
        -- Trash
        [436640] = true,            -- Burning Ricochet (Magic)
        [437956] = true,            -- Erupting Inferno (Magic)
        [439325] = true,            -- Burning Fermentation (Magic)
        [441397] = true,            -- Bee Venom (Slow)
        [441627] = true,            -- Rejuvenating Honey (Magic)
        [442589] = true,            -- Beeswax (Magic + Stun)

        -- Goldie Baronbottom
        [436640] = true,            -- Burning Ricochet (Magic)
    },
    -- The Dawnbreaker
    [2662] = {
        [426735] = true,            -- Burning Shadows (Magic)
        [431493] = true,            -- Darkblade (Magic)
        [432448] = true,            -- Stygian Seed (Magic)
    },
    -- City of Threads
    [2669] = {
        [443437] = true,            -- Shadows of Doubt (Magic)
        [440238] = true,            -- Ice Sickles (Magic)
    },
    -- Nerub-ar Palace
    [2657] = {
        -- THe Silken Court
        [441772] = true,               -- Void Bolt
        [438708] = true,               -- Stinging Swarm

        -- Queen Ansurek
        [447967] = true,               -- Gloom Touch
    },
    -- Operation: Floodgate
    [2773] = {
        [465604] = true,                -- Battery Bolt
    },
    -- Eco'Dome Al'dani
    [2830] = {
        [1221483] = true,               -- Arcing Energy (Magic)
        [1231608] = true,               -- Alacrity (Magic)
        [1223000] = true,               -- Embrace of K'aresh (Magic)
        [1221133] = true,               -- Hungering Rage (Enrage)
    }
}

if Dispels.isRetail then
    spells[0] = {
        -- Mithyc+ Affixes
        [395938] = true,            -- Necrotic Decay
        [395946] = true,            -- Putrid Bolt Poison
        [395950] = true,            -- Festeing Burst Poison
        [409472] = true,            -- Diseased Spirit
        [440313] = true,            -- Void Rift

        -- debugging
        [375359] = true,            -- Frenzy! (Enrage) - location: Ohn'ahran Plains - Nethazan Ruin, above Maruukai
        [114803] = true,            -- Throw Torch (Magic) - location: Temple of the Jade Serpent
    }
else
    spells[0] = {}
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
    -- https://github.com/Gethe/wow-ui-source/blob/live/Interface/AddOns/Blizzard_FrameXMLBase/Constants.lua
    local isMine = CombatLog_Object_IsA(sourceFlags, COMBATLOG_FILTER_ME) or CombatLog_Object_IsA(sourceFlags, COMBATLOG_FILTER_MY_PET)
    if not isMine then return end

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
