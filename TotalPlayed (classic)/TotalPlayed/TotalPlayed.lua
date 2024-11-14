local TotalPlayed = {}
TotalPlayedDB = TotalPlayedDB or {}

-- Function to update the character's /played time
local function UpdatePlayedTime()
    RequestTimePlayed() -- Requests current /played time for this character
end

-- Event frame to listen for the TIME_PLAYED_MSG event
local frame = CreateFrame("Frame")
frame:RegisterEvent("TIME_PLAYED_MSG")
frame:RegisterEvent("PLAYER_LOGIN")

frame:SetScript("OnEvent", function(self, event, ...)
    if event == "TIME_PLAYED_MSG" then
        local totalPlayed, levelPlayed = ...
        local name = UnitName("player")
        local realm = GetRealmName()
        local characterID = realm .. "-" .. name

        -- Save /played time in seconds for this character
        TotalPlayedDB[characterID] = totalPlayed
    elseif event == "PLAYER_LOGIN" then
        -- Request /played time when player logs in
        UpdatePlayedTime()
    end
end)

-- Slash command to display total /played time
SLASH_TOTALPLAYED1 = "/totalplayed"
SlashCmdList["TOTALPLAYED"] = function()
    local totalTime = 0
    for _, timePlayed in pairs(TotalPlayedDB) do
        totalTime = totalTime + timePlayed
    end
    local days = math.floor(totalTime / 86400)
    local hours = math.floor((totalTime % 86400) / 3600)
    local minutes = math.floor((totalTime % 3600) / 60)
    print(string.format("Total /played time across all tracked characters: %d days, %d hours, %d minutes", days, hours, minutes))
end

