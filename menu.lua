local composer = require( "composer" )
local globals = require "globals"

local scene = composer.newScene()

function scene:create( event )
	local sceneGroup = self.view
	-- Called when the scene's view does not exist.
	-- INSERT code here to initialize the scene
	local background = display.newImageRect( "Graphics/Art/Boom.jpg", display.contentWidth, display.contentHeight )
	numOfButtons = 5
	if(globals.android) then
    	numOfButtons = 4
    else
    	-- code in here to highlight the first button
	end

	local press = audio.loadSound( "Sounds/GUI/ButtonPress.ogg")

	function buttonPress( self, event )
    	if event.phase == "began" then
    		audio.play(press, {channel = 31})
    		if self.id == 1 then
    			composer.gotoScene( "game" )
    		elseif self.id == 2 then
    			composer.gotoScene( "leaderboard" )
    		elseif self.id == 3 then
    			composer.gotoScene( "levelEditorScene" )
    		elseif self.id == 4 then
    			composer.gotoScene( "credits" )
    		elseif self.id == 5 then
    			native.requestExit()
    		end
    		return true
    	end
	end

	buttons = {}
	for i=1,numOfButtons do 
		buttons[i] = display.newRect(display.actualContentWidth/(numOfButtons*2) + (i-1)*display.actualContentWidth/numOfButtons,display.actualContentHeight - 100,display.actualContentWidth*3/20,100)
		sceneGroup:insert(buttons[i])
		buttons[i]:setFillColor( 1, 0, 0 )
		buttons[i].id = i
		buttons[i].touch = buttonPress
		buttons[i]:addEventListener( "touch", buttons[i] )
	end


	background.anchorX = 0
	background.anchorY = 0
	background.x, background.y = 0, 0
	
	sceneGroup:insert(background)

end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	if phase == "will" then
		for i=1,numOfButtons do 
			sceneGroup:insert(buttons[i])
		end
		buttonText = {"PLAY", "SCOREBOARD", "LEVEL EDITOR","CREDITS","QUIT"}
		text = {}
		for i=1,numOfButtons do
			text[i] = display.newText(buttonText[i], display.actualContentWidth/(numOfButtons*2) + (i-1)*display.actualContentWidth/numOfButtons,display.actualContentHeight - 100, "Curse of the Zombie.ttf",40)
			text[i]:setFillColor( 1, 1, 0 )
			sceneGroup:insert(text[i])
		end
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		composer.removeScene( "intro", false )
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