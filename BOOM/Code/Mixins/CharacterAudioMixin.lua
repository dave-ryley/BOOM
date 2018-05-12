local Audio = require("Code.Services.AudioService")
local ConfigBuilder = require("Code.Services.ConfigBuilder")
local CharacterAudio = {}

local function onFootstep(self, e)
    local key = "FOOTSTEP"
    if e.floorType then
        key = key .. "_" .. e.floorType
    end
    Audio:oneShot(self.soundData[key])
end

local function onDeath(self, e)
    local key = "DEATH"
    if e.deathType then
        key = key .. "_" .. e.deathType
    end
    Audio:oneShot(self.soundData[key])
end

local function onAttack(self, e)
    local key = "ATTACK"
    if e.attackType then
        key = key .. "_" .. e.attackType
    end
    Audio:oneShot(self.soundData[key])
end

function CharacterAudio:new()
    local audio = {}
    audio.onFootstep = onFootstep
    audio.onDeath = onDeath
    audio.onAttack = onAttack
    return audio
end

function CharacterAudio:mixin(o)
    local audio = CharacterAudio:new()

    local config = ConfigBuilder.fromId(o.configId)
    local soundData = config.audio
    audio.soundData = {}

    for k, v in pairs(soundData) do
        audio.soundData[k] = v
    end

    o:addEventListener("onFootstep", audio)
    o:addEventListener("onDeath", audio)
    o:addEventListener("onAttack", audio)
    o.audio = audio
end

return CharacterAudio