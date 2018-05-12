local composer = require( "composer" )
local scene = composer.newScene()
local Button = require "button"
local canPress = false
---------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE
-- unless "composer.removeScene()" is called.
---------------------------------------------------------------------------------

-- local forward references should go here

---------------------------------------------------------------------------------

local function back()
	composer.gotoScene( GLOBAL_scenePath.."menu" )
end

local function onCredKeyPress( event )
	local phase = event.phase
	local keyName = event.keyName

	if (phase == "down" and canPress) then
		if (keyName == "buttonA") then
			audio.play(press, {channel = 31})
    		composer.gotoScene( GLOBAL_scenePath.."menu" )
		end
	elseif (phase == "up") then
		canPress = true
	end

	return false
end

-- "scene:create()"
function scene:create( event )
	composer.removeScene(GLOBAL_scenePath.."menu")
	local sceneGroup = self.view
	creditsImage = display.newImage( sceneGroup,
						GLOBAL_graphicsPath.."/Art/ChaseArt.png",
						GLOBAL_cw - 500,GLOBAL_ccy - 100 )
	creditsImage.xScale = creditsImage.xScale*3/7
	creditsImage.yScale = creditsImage.yScale*3/7
	myText = display.newText(
		"Created By:\n\n"..
		"Dave Ryan\n"..
		"Dave Ryley\n"..
		"Chris Brady\n\n"..
		"Music by Ciaran Ryan",
		GLOBAL_cw/3,
		GLOBAL_ccy,
		800,
		0,
		GLOBAL_comicBookFont,
		70
	)
	myText:setFillColor( 1,1,0 )
	sceneGroup:insert(myText)

	button = Button:new(GLOBAL_acw-300, GLOBAL_ach - 100, "BACK", back)
	button:insertIntoScene(sceneGroup)
	
	button:select()
end

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

function scene:destroy( event )

	local sceneGroup = self.view
	Runtime:removeEventListener( "key", onCredKeyPress )
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
Runtime:addEventListener( "key", onCredKeyPress )

---------------------------------------------------------------------------------

return scene
