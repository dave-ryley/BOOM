local composer = require( "composer" )
local scene = composer.newScene()
 
local buttonMaker = require "button"
local canPress = false
---------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE
-- unless "composer.removeScene()" is called.
---------------------------------------------------------------------------------

-- local forward references should go here

---------------------------------------------------------------------------------

local function onCredKeyPress( event )
	local phase = event.phase
	local keyName = event.keyName

	if (phase == "down" and canPress) then
		if (keyName == "buttonA") then
			audio.play(press, {channel = 31})
    		composer.gotoScene( g.scenePath.."menu" )
		end
	elseif (phase == "up") then
		canPress = true
	end

	return false
end

-- "scene:create()"
function scene:create( event )
	composer.removeScene(g.scenePath.."menu")
	local sceneGroup = self.view
	creditsImage = display.newImage( sceneGroup,
						"Graphics/Art/ChaseArt.png", 
						g.cw - 500,g.ccy - 100 )
	creditsImage.xScale = creditsImage.xScale*3/7
	creditsImage.yScale = creditsImage.yScale*3/7
	myText = display.newText( 	"Created By:\n\n".. 
								"Dave Ryan\n".. 
								"Dave Ryley\n".. 
								"Chris Brady\n"..
								"\nMusic by Ciaran Ryan",
								g.cw/3, 
								g.ccy, 
								800, 
								0,
								g.comicBookFont, 
								70 )
	myText:setFillColor( 1,1,0 )
	sceneGroup:insert(myText)

	function buttonPress( self, event )
    	if event.phase == "began" then
    		audio.play(press, {channel = 31})
    		composer.gotoScene( g.scenePath.."menu" )
    		return true
    	end
	end

	button = buttonMaker.spawn(g.acw-300, g.ach - 100, "BACK")
	sceneGroup:insert(button)
	sceneGroup:insert(button.text)
	sceneGroup:insert(button.flames)
	button:toFront()
	button.text:toFront()
	button.highlight(true)
	button.touch = buttonPress
	button:addEventListener( "touch", button )
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