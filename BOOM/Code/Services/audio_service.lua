local ConfigService = require("Code.Services.config_service")

local AudioService = {}
local SFXAssets
local MusicAssets

local MUSIC_CHANNEL = 20

------------------------------------------------------------------------------------
-- Services
------------------------------------------------------------------------------------
function AudioService:oneShot(configId)
    local config = ConfigService:fromId(configId)
    local asset = config.asset
    if type(asset) == "table" then
        asset = asset[math.random(#asset)]
    end

    if asset then
        local c = audio.findFreeChannel()
        audio.play(
            SFXAssets[asset],
            {
                channel = c,
                loops = 0,
                fadein = 0,
            }
        )
    end
end

function AudioService:playMusic(id)
    local configId = "MUSIC." .. id
    local config = ConfigService:fromId(configId)
    local asset = config.asset
    if type(asset) == "table" then
        asset = asset[math.random(#asset)]
    end

    -- TODO: Handle crossfading between tracks

    if asset then
        audio.play(
            MusicAssets[asset],
            {
                channel = MUSIC_CHANNEL,
                loops = -1,
                fadein = 1000,
            }
        )
    end
end

------------------------------------------------------------------------------------
-- Initialization
------------------------------------------------------------------------------------

function AudioService:init()
    SFXAssets = ConfigService:buildAssetTable("SFX", "asset", audio.loadSound)
    MusicAssets = ConfigService:buildAssetTable("MUSIC", "asset", audio.loadStream)
end

------------------------------------------------------------------------------------
return AudioService
