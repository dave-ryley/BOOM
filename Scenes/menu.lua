local composer = require( "composer" )
local g = require "globals"
local buttonMaker = require "button"

local scene = composer.newScene()

function scene:create( event )
	local sceneGroup = self.view
	-- Called when the scene's view does not exist.
	-- INSERT code here to initialize the scene
	local background = display.newImageRect( 	"Graphics/UI/menuBackground.png", 
												g.cw, 
												g.ch )
	sceneGroup:insert(background)
	numOfButtons = 5
	if(g.android) then
		numOfButtons = 4
	else
		-- code in here to highlight the first button
	end

	local press = audio.loadSound( "Sounds/GUI/ButtonPress.ogg")

	function buttonPress( self, event )
		if event.phase == "began" then
			audio.play(press, {channel = 31})
			if self.id == 1 then
				composer.gotoScene( g.scenePath.."game" )
			elseif self.id == 2 then
				composer.gotoScene( g.scenePath.."leaderboard" )
			elseif self.id == 3 then
				composer.gotoScene( g.scenePath.."levelEditorScene" )
			elseif self.id == 4 then
				composer.gotoScene( g.scenePath.."credits" )
			elseif self.id == 5 then
				native.requestExit()
			end
			return true
		end
	end
	buttonText = {"PLAY", "SCOREBOARD", "LEVEL EDITOR","CREDITS","QUIT"}
	buttons = {}
	for i=1,numOfButtons do 
		buttons[i] = buttonMaker.spawn(g.acw/(numOfButtons*2) + (i-1)*g.acw/numOfButtons, g.ach - 100, buttonText[i])
		sceneGroup:insert(buttons[i])
		sceneGroup:insert(buttons[i].text)
		sceneGroup:insert(buttons[i].flames)
		buttons[i]:toFront()
		buttons[i].text:toFront()
		buttons[i].id = i
		buttons[i].touch = buttonPress
		buttons[i]:addEventListener( "touch", buttons[i] )
	end


	background.anchorX = 0
	background.anchorY = 0
	background.x, background.y = 0, 0
	
	

end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	if phase == "will" then
		
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		composer.removeScene( g.scenePath.."intro", false )
		buttons[1].highlight(true)
		--composer.removeScene( "game", false )
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