local SFXConfig = require("Config.Sound.SFXConfig")
local MusicConfig = require("Config.Sound.MusicConfig")

local AudioService = {}
local SFXAssets = {}
local MusicAssets = {}

local MUSIC_CHANNEL = 20

------------------------------------------------------------------------------------
-- Services
------------------------------------------------------------------------------------

function AudioService:oneShot(configId)
    local asset = SFXConfig[configId]
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

function AudioService:playMusic(configId)
    local asset = MusicConfig[configId]
    if type(asset) == "table" then
        asset = asset[math.random(#asset)]
    end

    -- TODO: Handle crossfading between tracks

    if asset then
        audio.play(
            SFXAssets[asset],
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

local function initializeConfig(Config, Assets, stream)
    local loadFunction = (stream and audio.loadStream) or audio.loadSound
    for k, v in pairs(Config) do
        if type(v) == "table" then
            initializeConfig(v, Assets, stream)
        else
            Assets[v] = loadFunction(v)
        end
    end
    for i = 1, #Config do
        Assets[Config[i]] = loadFunction(Config[i])
    end
end

function AudioService:init()
    initializeConfig(SFXConfig, SFXAssets, false)
    initializeConfig(MusicConfig, MusicAssets, true)
end
------------------------------------------------------------------------------------
return AudioService