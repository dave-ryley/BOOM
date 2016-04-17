local inputDevices = system.getInputDevices()
print(#inputDevices)
	for i = 1, #inputDevices do
		print(inputDevices[i].type )
		if ( "joystick" == inputDevices[i].type ) then
			return true
		end
	end



local g = require "globals"
if(system.getInfo("platformName") == "Android") then
    display.setStatusBar( display.HiddenStatusBar )
    system.activate( "multitouch" )
end
local composer = require "composer"
--composer.gotoScene( g.scenePath.."levelEditorScene" )
composer.gotoScene( g.scenePath.."intro" )  