require("globals")
require("Code.Utilities.global_utils")

local ConfigService = require("Code.Services.config_service")
local AudioService = require("Code.Services.audio_service")

ConfigService:init()
AudioService:init()

GLOBAL_load_highscores()

native.setProperty("windowMode", "fullscreen")

if system.getInfo("platformName") == "Android" then
    display.setStatusBar( display.HiddenStatusBar )
    system.activate( "multitouch" )
end

local composer = require "composer"
composer.gotoScene( GLOBAL_scenePath.."menu" )
