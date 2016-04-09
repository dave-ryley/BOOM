if(system.getInfo("platformName") == "Android") then
    display.setStatusBar( display.HiddenStatusBar )
end
local composer = require "composer"
composer.gotoScene( "intro" ) 