local composer = require( "composer" )
local scene = composer.newScene()
local g = require "globals"
---------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE
-- unless "composer.removeScene()" is called.
---------------------------------------------------------------------------------

-- local forward references should go here
local myText1
local myText2
local buttons = {}
local buttonLabels = {"RETRY","MAIN MENU"}
local buttonText = {}
local deathImage
---------------------------------------------------------------------------------

-- "scene:create()"
function scene:create( event )
	local killer = event.params.killer
	print (killer)
	local sceneGroup = self.view
	deathImage = display.newImage( sceneGroup,
						"Graphics/Death/"..killer..".png", 
						g.ccx,g.ccy ,
						isFullResolution )

	myText1 = display.newText(sceneGroup, "YOU", 
									g.ccx-500, 
									g.ccy, 
									"BLOODY", 
									300 )
	myText2 = display.newText(sceneGroup, "DIED", 
									g.ccx+500, 
									g.ccy, 
									"BLOODY", 
									300 )
	myText1:setFillColor(1,0,0)
	myText2:setFillColor(1,0,0)

	function buttonPress( self, event )
    	if event.phase == "began" then
    		audio.play(press, {channel = 31})
    		if self.id == 1 then
    			composer.removeScene( g.scenePath.."death", false )
				composer.gotoScene( g.scenePath.."game" )
    		elseif self.id == 2 then
    			composer.removeScene( g.scenePath.."death", false )
    			composer.gotoScene( g.scenePath.."menu" )
    		end
    		return true
    	end
	end

	
	for i=1,2 do 
		buttons[i] = display.newRect(sceneGroup,
									g.ccx-300+(i%2*600),
									g.ccy+400,500,150)
		buttons[i]:setFillColor( 1, 0, 0 )
		buttons[i].id = i
		buttons[i].touch = buttonPress
		buttons[i]:addEventListener( "touch", buttons[i] )
		
		buttonText[i] = display.newText(sceneGroup,buttonLabels[i], 
										g.ccx-300+(i%2*600),
										g.ccy+400, 
										"Curse of the Zombie", 
										50 )
		buttonText[i]:setFillColor(1,1,0)
	end
end


-- "scene:show()"
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase
	composer.removeScene( g.scenePath.."game", false )
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
	buttons[1]:removeEventListener( "touch", buttons[1] )
	buttons[2]:removeEventListener( "touch", buttons[2] )
	display.remove( myText1 )
	display.remove( myText2 )
	display.remove( buttons[1] )
	display.remove( buttons[2] )
	display.remove( deathImage )
	buttons = nil
	buttonLabels = nil
	buttonText = nil
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
--R:addEventListener( "key", onKeyPress )

---------------------------------------------------------------------------------

return scene