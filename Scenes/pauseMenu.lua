local composer = require( "composer" )
local g = require "globals"

local scene = composer.newScene()

function scene:create( event )
	local sceneGroup = self.view
	-- Called when the scene's view does not exist.
	-- INSERT code here to initialize the scene
	if(system.getInfo("platformName") ~= "Android") then
    	-- code in here to highlight the first button
	end
	myText = display.newText( "PAUSED", g.ccx, g.ccy-200, "Curse of the Zombie", 80 )
	myText:setFillColor(1,1,0,1)
	local press = audio.loadSound( "Sounds/GUI/ButtonPress.ogg")
	function buttonPress( self, event )
    	if event.phase == "began" then
    		audio.play(press, {channel = 31})
    		if self.id == 1 then
    			g.pause = false
    			composer.hideOverlay()
    		elseif self.id == 2 then
    			composer.gotoScene( g.scenePath.."menu" )
    		end
    		return true
    	end
	end
	buttonLabels = {"RESUME","MAIN MENU"}
	buttonText = {}
	buttons = {}
	for i=1,2 do 
		buttons[i] = display.newRect(g.ccx,g.ccy+(i-1)*200,500,150)
		buttons[i]:setFillColor( 1, 0, 0 )
		buttons[i].id = i
		buttons[i].touch = buttonPress
		buttons[i]:addEventListener( "touch", buttons[i] )
		
		buttonText[i] = display.newText( buttonLabels[i], g.ccx,g.ccy+(i-1)*200, "Curse of the Zombie", 50 )
		buttonText[i]:setFillColor(1,1,0)
	end
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	if phase == "will" then
		for i=1,2 do 
			sceneGroup:insert(buttons[i])
			sceneGroup:insert(buttonText[i])
		end
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
		-- 
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
	end	
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end	
end

function scene:destroy( event )
	local sceneGroup = self.view
	for i=1,2 do 
		buttons[i]:removeSelf()
		buttons[i] = nil
	end
	myText:removeSelf()
	myText = nil
	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.

	
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
--Runtime:addEventListener( "key", onKeyPress )

-----------------------------------------------------------------------------------------

return scene