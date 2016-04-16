local composer = require( "composer" )
local scene = composer.newScene()
local g = require "globals"
---------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE
-- unless "composer.removeScene()" is called.
---------------------------------------------------------------------------------

-- local forward references should go here

---------------------------------------------------------------------------------

-- "scene:create()"
function scene:create( event )

	local sceneGroup = self.view
	myText = display.newText( 	"Credits", 
								g.ccx, 
								g.ccy, 
								native.systemFont, 
								80 )
	sceneGroup:insert(myText)
	-- Initialize the scene here.
	-- Example: add display objects to "sceneGroup", add touch listeners, etc.

	
	function buttonPress( self, event )
    	if event.phase == "began" then
    		audio.play(press, {channel = 31})
    		if self.id == 1 then
    			composer.gotoScene( g.scenePath.."menu" )
    		end
    		return true
    	end
	end

	button = display.newRect(250,75,500,150)
	button:setFillColor( 1, 0, 0 )
	button.id = 1
	button.touch = buttonPress
	button:addEventListener( "touch", button )
		
	buttonText = display.newText( "MAIN MENU", 250,75, "Curse of the Zombie", 50 )
	buttonText:setFillColor(1,1,0)
	sceneGroup:insert(button)
	sceneGroup:insert(buttonText)
end

-- "scene:show()"
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
	-- Called when the scene is still off screen (but is about to come on screen).
	elseif ( phase == "did" ) then
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

	local sceneGroup = self.view

-- Called prior to the removal of scene's view ("sceneGroup").
-- Insert code here to clean up the scene.
-- Example: remove display objects, save state, etc.
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

---------------------------------------------------------------------------------

return scene