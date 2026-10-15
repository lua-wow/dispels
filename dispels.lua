local _, ns = ...
local Dispels = ns.Dispels

-- Lua
local format = string.format

-- Blizzard
local GetInstanceInfo = _G.GetInstanceInfo
local IsInInstance = _G.IsInInstance
local CombatLogGetCurrentEventInfo = C_CombatLog.GetCurrentEventInfo
local CombatLog_Object_IsA = C_CombatLog.DoesObjectMatchFilter
local GetSpellLink = C_Spell and C_Spell.GetSpellLink or _G.GetSpellLink
local SendChatMessage = C_ChatInfo.SendChatMessage
local COMBATLOG_FILTER_ME = _G.COMBATLOG_FILTER_ME
local COMBATLOG_FILTER_MY_PET = _G.COMBATLOG_FILTER_MY_PET

local spells = ns.spells

local CombatEvents = {
    ["SPELL_DISPEL"] = true,
    ["SPELL_STOLEN"] = true,
    ["SPELL_DISPEL_FAILED"] = true
}

function Dispels:ImportInstanceData(dest, instanceID)
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

    local isInInstance = IsInInstance()
    local _, instanceType, _, _, _, _, _, instanceID = GetInstanceInfo()

    if isInInstance and (instanceType == "raid" or instanceType == "party") then
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
    local _, eventType, _, _, _, sourceFlags, _, _, destName, _, _,
        _, _, _, extraSpellID = CombatLogGetCurrentEventInfo()

    -- filter combat events type
    if (not CombatEvents[eventType]) then return end

    -- filter casters, only player or belong to player
    -- https://github.com/Gethe/wow-ui-source/blob/live/Interface/AddOns/Blizzard_FrameXMLBase/Constants.lua
    local isMine = CombatLog_Object_IsA(sourceFlags, COMBATLOG_FILTER_ME) or CombatLog_Object_IsA(sourceFlags, COMBATLOG_FILTER_MY_PET)
    if not isMine then return end

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
