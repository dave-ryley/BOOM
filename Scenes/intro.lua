local composer = require( "composer" )
local scene = composer.newScene()
local g = require "globals"
local cinematics = true
local effects = ""
local myText = ""
---------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE
-- unless "composer.removeScene()" is called.
---------------------------------------------------------------------------------

-- local forward references should go here
local options = {
	effect = "fade",
	time = 500
}
---------------------------------------------------------------------------------

-- "scene:create()"
function scene:create( event )

	local sceneGroup = self.view
	cinematics = true
	myText = display.newText( "INTRO CINEMATICS.", g.ccx, g.ccy, "Curse of the Zombie", 80 )
	-- Initialize the scene here.
	-- Example: add display objects to "sceneGroup", add touch listeners, etc.
end

-- "scene:show()"
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase


	if ( phase == "will" ) then
	-- Called when the scene is still off screen (but is about to come on screen).
	elseif ( phase == "did" ) then
		sceneGroup:insert(myText)
	-- Called when the scene is now on screen.
	-- Insert code here to make the scene come alive.
	-- Example: start timers, begin animation, play audio, etc.
	end
end

-- "scene:hide()"
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
	-- Called when the scene is on screen (but is about to go off screen).
	-- Insert code here to "pause" the scene.
	-- Example: stop timers, stop animation, stop audio, etc.
	elseif ( phase == "did" ) then

	-- Called immediately after scene goes off screen.
	end
end

-- "scene:destroy()"
function scene:destroy( event )
	myText:removeSelf()
	myText = nil
	Runtime:removeEventListener( "key", skipEvent )
	Runtime:removeEventListener( "tap", skipEvent )
	local sceneGroup = self.view
	-- Called prior to the removal of scene's view ("sceneGroup").
	-- Insert code here to clean up the scene.
	-- Example: remove display objects, save state, etc.
end

local function skipEvent( event )
	if cinematics then
		composer.gotoScene( g.scenePath.."menu", options )
		cinematics = false
		return true
	end
end
---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
Runtime:addEventListener( "key", skipEvent )
Runtime:addEventListener( "tap", skipEvent )
---------------------------------------------------------------------------------

return scene