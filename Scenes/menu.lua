local composer = require("composer")
local controllerMapping = require("controllerMapping")
local buttonMaker = require("button")

local buttons = {}
local selected = 0
local canSelect = true
local scene = composer.newScene()

------------------------------------------------------------------------------------
-- Local Functions
------------------------------------------------------------------------------------

local function selectButton(direction)
	-- Deselect previous button
	if buttons[selected] then
		buttons[selected]:deselect()
	end
	selected = selected + direction
	
	-- Cap the selection
	selected = selected > 0 and selected or #buttons
	selected = selected <= #buttons and selected or 1

	-- Select the button
	buttons[selected]:select()
end

------------------------------------------------------------------------------------
-- Event Listeners
------------------------------------------------------------------------------------

local function onAxisEvent( event )
	-- Map event data to simple variables
	print("Axis Event")
	if string.sub( event.device.descriptor, 1 , 7 ) == "Gamepad" then
		local axis = controllerMapping.axis[event.axis.number]

		if ( "left_x" == axis ) then
			if event.normalizedValue < 0.1 and event.normalizedValue > -0.1 then
				canSelect = true
			elseif canSelect then
				canSelect = false
				local direction = event.normalizedValue > 0 and 1 or -1
				selectButton(direction)
			end
		end
	end
	return true -- If consuming the event? Why are we returning true?
end

local function buttonFunction( key )
	local press = audio.loadSound( "Sounds/UI/ButtonPress.ogg")
	if key ~= 0 then
		audio.play(press, {channel = 31})
	end
	if key == 1 then
		composer.gotoScene( g.scenePath.."game" )
	elseif key == 2 then
		composer.gotoScene( g.scenePath.."leaderboard" )
	elseif key == 3 then
		composer.gotoScene( g.scenePath.."levelEditorScene" )
	elseif key == 4 then
		--print("credits")
		composer.gotoScene( g.scenePath.."credits" )
	elseif key == 5 then
		native.requestExit()
	end
end

local function onKeyPress( event )
	print("Key Pressed:", event.keyName)
	local phase = event.phase
	local keyName = event.keyName

	if (phase == "down") then
		if (keyName == "buttonA") then
			buttonFunction(buttonSelect)
		elseif (keyName == "left") then
			selectButton(-1)
		elseif (keyName == "right") then
			selectButton(1)
		end
	end

	return false
end

------------------------------------------------------------------------------------
-- Scene Functions
------------------------------------------------------------------------------------

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
	local background = display.newImageRect( 	"Graphics/UI/menuBackground.png", 
												g.cw, 
												g.ch )
	sceneGroup:insert(background)
	local numOfButtons = 5
	if(g.android) then
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
		Runtime:addEventListener( "key", onKeyPress )
		Runtime:addEventListener( "axis", onAxisEvent )
	end	
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		Runtime:removeEventListener( "axis", onAxisEvent )
		Runtime:removeEventListener( "key", onKeyPress )
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

-----------------------------------------------------------------------------------------

return scene