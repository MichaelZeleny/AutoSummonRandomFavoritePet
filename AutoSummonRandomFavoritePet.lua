local db
local addonLoadedEvent = "ADDON_LOADED"
local addonName = "AutoSummonRandomFavoritePet"
local events = {"PLAYER_ENTERING_WORLD", "ZONE_CHANGED", "ZONE_CHANGED_INDOORS", "ZONE_CHANGED_INDOORS",
                "ZONE_CHANGED_NEW_AREA", "PLAYER_MOUNT_DISPLAY_CHANGED", "PLAYER_ALIVE", "PLAYER_UNGHOST" }
local defaultSavedVars = {
    global = {
        disableOverwriteExistingPet = false,
        disableSummonInCombat = true,
        disableInStealth = false,

},}
SLASH_AUTO_SUMMON_RANDOM_FAVORITE_PET1 = "/asrfp"
SLASH_AUTO_SUMMON_RANDOM_FAVORITE_PET2 = "/autoSummonPet"

local dbName = "AutoSummonRandomFavoritePetDB"

local function isEventActive(val)
    for index, value in ipairs(events) do
        if value == val then
            return true
        end
    end
    return false
end

SlashCmdList["AUTO_SUMMON_RANDOM_FAVORITE_PET"] = function(msg)
    if msg == "disableOverwriteExistingPet" then
        db.disableOverwriteExistingPet = true
    elseif msg == "enableOverwriteExistingPet" then
        db.disableOverwriteExistingPet = false
    elseif msg == "disableSummonInCombat" then
        db.disableSummonInCombat = true
    elseif msg == "enableSummonInCombat" then
        db.disableSummonInCombat = false
    elseif msg == "disableInStealth" then
        db.disableInStealth = true
    elseif msg == "enableInStealth" then
        db.disableInStealth = false
    end
end

function wantToSummonNewPet()
    if IsMounted() or isInvisible() then
        return false
    elseif db.disableSummonInCombat and UnitAffectingCombat("player") then
        return false
    elseif db.disableInStealth and IsStealthed() then
        return false
    elseif db.disableOverwriteExistingPet and C_PetJournal.GetSummonedPetGUID() ~= nil then
        return false
    end
    return true
end

function autoSummonRandomFavoritePet_OnEvent(self, event, ...)
    if event == addonLoadedEvent and ... == addonName then
        db = LibStub("AceDB-3.0"):New(dbName, defaultSavedVars).global
        self:UnregisterEvent(addonLoadedEvent)
    elseif isEventActive(event) and wantToSummonNewPet() then
        C_PetJournal.SummonRandomPet(true)
    end
end

function autoSummonRandomFavoritePet_OnLoad(self)
    self:RegisterEvent(addonLoadedEvent)
    for index, value in ipairs(events) do
        self:RegisterEvent(value)
    end
end

function isInvisible()
    for i=1,40 do
        local auraName=UnitAura("player",i)
        if auraName == nil then
            return false
        elseif auraName == 'Dimensional Shifter' or auraName == 'Invisible' or auraName == 'Greater Invisibility' or auraName == 'Invisibility' then
            return true
        end
    end
    return false
end