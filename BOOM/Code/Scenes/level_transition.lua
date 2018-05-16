local composer = require( "composer" )
local scene = composer.newScene()

---------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE
-- unless "composer.removeScene()" is called.
---------------------------------------------------------------------------------

-- local forward references should go here
local myText
---------------------------------------------------------------------------------

-- "scene:create()"
function scene:create( event )

	local sceneGroup = self.view
	local transImage = display.newImage(
		sceneGroup,
		GLOBAL_graphicsPath.."Art/MorgueConcept.png",
		GLOBAL_ccx,GLOBAL_ccy-50
	)

	myText = display.newText(
		"Entering level "..GLOBAL_level .. "  ",
		GLOBAL_ccx - 250,
		GLOBAL_ccy + 250,
		GLOBAL_comicBookFont,
		100
	)
	myText:setFillColor( 1,1,0 )
	sceneGroup:insert(myText)

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
		composer.removeScene( GLOBAL_scenePath.."game", false )
		myText.text = "Entering level "..GLOBAL_level .. "  "
		myText.x = GLOBAL_ccx - 250
		myText.y = GLOBAL_ccy + 250
		transition.to( 	myText,
				{time = 2000,
				x = myText.x + 500,
				y = myText.y,
				onComplete =
					-- Game begins
					function()
						composer.gotoScene( GLOBAL_scenePath.."game")
					end
				} )
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
