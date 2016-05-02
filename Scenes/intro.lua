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
	local path = system.pathForFile( "LeaderBoard.BOOMFILE", system.DocumentsDirectory )

	-- Open the file handle
	local file, errorString = io.open( path, "w" )

	local saveData = ""

	for i = 1, 10 do
		saveData = saveData .. "3,Gary,600000,99,99\n"
	end

	if not file then
	    -- Error occurred; output the cause
	    file:write( saveData )
	    print( "File error: " .. errorString )
	else
	    -- Close the file handle
	    -- Need to get rid of this line once we want our scoreboard to stay
	    file:write( saveData )
	    io.close( file )
	end
	file = nil

	local sceneGroup = self.view
	cinematics = true
	local options = {
	    text = "NARCOLEPTICK GAMES \nPRESENTS",
	    font=g.zombieFont,
	    fontSize = 80,
	    align = "center"  
	}
	myText = display.newText( options )
	myText:setFillColor(1,0,0)
	myText.x = g.ccx
	myText.y = g.ccy
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