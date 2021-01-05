
local events = {"PLAYER_ENTERING_WORLD", "ZONE_CHANGED", "ZONE_CHANGED_INDOORS", "ZONE_CHANGED_INDOORS", "ZONE_CHANGED_NEW_AREA"}

local function isEventActive(val)
    for value in events do
        if value == val then
            return true
        end
    end
    return false
end

function autoSummonRandomFavoritePet_OnEvent(self, event, ...)
    if isEventActive(event) then
        C_PetJournal.SummonRandomPet(true)
    end
end

function autoSummonRandomFavoritePet_OnLoad(self)
    for value in events do
        self:RegisterEvent(value)
    end
end

