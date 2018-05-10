require("globals")

GLOBAL_load_highscores()

native.setProperty("windowMode", "fullscreen")

if system.getInfo("platformName") == "Android" then
    display.setStatusBar( display.HiddenStatusBar )
    system.activate( "multitouch" )
end

local composer = require "composer"
composer.gotoScene( GLOBAL_scenePath.."menu" )
