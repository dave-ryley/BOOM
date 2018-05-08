local composer = require( "composer" )
local controller_mapping = require "controller_mapping"
local buttonMaker = require "button"
local buttons = {}
local buttonSelect = 0
local canSelect = true
local scene = composer.newScene()

local function onAxisEvent( event )
	-- Map event data to simple variables
	if string.sub( event.device.descriptor, 1 , 7 ) == "Gamepad" then
		local axis = controller_mapping.axis[event.axis.number]
		--if g.pause then print("g.pause = true") else print("g.pause = false") end
		if "left_x" == axis then
			if event.normalizedValue < 0.1 and event.normalizedValue > -0.1 then
				canSelect = true
			elseif canSelect then
				canSelect = false
				local value = 0
				if event.normalizedValue > 0 then
					value = 1
				else
					value = (-1)
				end
				buttonSelect = (((buttonSelect-1 + value) + #buttons) % #buttons) + 1
				for i = 1, #buttons do
					if i ~= buttonSelect then
						buttons[i].highlight(false)
					else
						buttons[i].highlight(true)
					end
				end
			end

		end
	end
	return true
end

local function buttonFunction( key )
	local press = audio.loadSound( g.soundsPath.."GUI/ButtonPress.ogg")
	if key ~= 0 then
		audio.play(press, {channel = 31})
	end
	if key == 1 then
		composer.gotoScene( g.scenePath.."game" )
	elseif key == 2 then
		composer.gotoScene( g.scenePath.."leaderboard" )
	elseif key == 3 then
		composer.gotoScene( g.scenePath.."level_editor_scene" )
	elseif key == 4 then
		--print("credits")
		composer.gotoScene( g.scenePath.."credits" )
	elseif key == 5 then
		native.requestExit()
	end
end

local function onKeyPress( event )
	local phase = event.phase
	local keyName = event.keyName

	if (phase == "down") then
		if (keyName == "buttonA") then
			buttonFunction(buttonSelect)
		end
	end

	return false
end

function scene:create( event )
	composer.removeScene(g.scenePath.."leaderboard")
	g.shotgun = 10
	g.speed = 1000.0
	g.time = 0.0
	g.deaths = 0
	g.kills = 0
	g.level = 1
	local sceneGroup = self.view
	-- Called when the scene's view does not exist.
	-- INSERT code here to initialize the scene
	local background = display.newImageRect(
		g.UIPath.."MenuBackground.png",
		g.cw,
		g.ch
	)

	sceneGroup:insert(background)
	local numOfButtons = 5
	if g.android then
		numOfButtons = 4
	else
		-- code in here to highlight the first button
	end

	function buttonPress( self, event )
		if event.phase == "began" then
			buttonFunction(self.id)
			return true
		end
	end

	local buttonText = {"PLAY", "SCOREBOARD", "LEVEL EDITOR","CREDITS","QUIT"}
	for i = 1,numOfButtons do
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
		composer.removeScene( g.scenePath.."leaderboard", false )
		composer.removeScene( g.scenePath.."credits", false )
		composer.removeScene( g.scenePath.."game", false )
		composer.removeScene( g.scenePath.."death", false )
		composer.removeScene( g.scenePath.."levelEditorScene", false )
		composer.removeScene( g.scenePath.."levelTransition", false )
		composer.removeScene( g.scenePath.."pauseMenu", false )
		composer.removeScene( g.scenePath.."win", false )
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
	Runtime:removeEventListener( "axis", onAxisEvent )
	Runtime:removeEventListener( "key", onKeyPress )
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
Runtime:addEventListener( "key", onKeyPress )
Runtime:addEventListener( "axis", onAxisEvent )

-----------------------------------------------------------------------------------------

return scene
