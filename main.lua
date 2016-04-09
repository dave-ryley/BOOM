if(system.getInfo("platformName") == "Android") then
    display.setStatusBar( display.HiddenStatusBar )
    system.activate( "multitouch" )
end
local composer = require "composer"
composer.gotoScene( "intro" ) 