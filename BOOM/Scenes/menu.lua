local composer = require("composer")
-- local controller_mapping = require("controller_mapping")
local Button = require("button")
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
	
	-- Wrap the selection
	selected = (selected > 0) and selected or #buttons
	selected = (selected <= #buttons) and selected or 1

	-- Select the button
	buttons[selected]:select()
end

------------------------------------------------------------------------------------
-- Button Functions
------------------------------------------------------------------------------------

local function play()
	composer.gotoScene( GLOBAL_scenePath.."game" )
end

local function leaderboard()
	composer.gotoScene( GLOBAL_scenePath.."leaderboard" )
end

local function levelEditor()
	composer.gotoScene( GLOBAL_scenePath.."level_editor_scene" )
end

local function credits()
	composer.gotoScene( GLOBAL_scenePath.."credits" )
end

local function quit()
	native.requestExit()
end

------------------------------------------------------------------------------------
-- Event Listeners
------------------------------------------------------------------------------------

local function onAxisEvent(e)
	if string.sub( e.device.descriptor, 1 , 7 ) == "Gamepad" then
		local axis = controller_mapping.axis[e.axis.number]
		if ( "left_x" == axis ) then
			if e.normalizedValue < 0.1 and e.normalizedValue > -0.1 then
				canSelect = true
			elseif canSelect then
				canSelect = false
				local direction = e.normalizedValue > 0 and 1 or -1
				selectButton(direction)
			end
		end
	end
end

local function onKeyPress(e)
	if (e.phase == "down") then
		if (e.keyName == "buttonA") then
			buttons[selected].callback()
		elseif(e.keyName == "enter") then
			buttons[selected].callback()
		elseif(e.keyName == "left") then
			selectButton(-1)
		elseif(e.keyName == "right") then
			selectButton(1)
		end
	end
end

------------------------------------------------------------------------------------
-- Scene Functions
------------------------------------------------------------------------------------

function scene:create( event )
	composer.removeScene(GLOBAL_scenePath.."leaderboard")
	GLOBAL_shotgun = 10
	GLOBAL_speed = 1000.0
	GLOBAL_time = 0.0
	GLOBAL_deaths = 0
	GLOBAL_kills = 0
	GLOBAL_level = 1
	local sceneGroup = self.view
	-- Called when the scene's view does not exist.
	-- INSERT code here to initialize the scene
	local background = display.newImageRect(
		GLOBAL_UIPath.."MenuBackground.png",
		GLOBAL_cw,
		GLOBAL_ch
	)

	sceneGroup:insert(background)
	local numOfButtons = 5
	if GLOBAL_android then -- TODO: Need to change this to have the buttons know whether or not to show up.
		numOfButtons = 4
	end

	-- Set up the button text and callbacks
	local buttonData = 
	{
		{ text = "PLAY", callback = play }, 
		{ text = "SCOREBOARD", callback = leaderboard }, 
		{ text = "LEVEL EDITOR", callback = levelEditor },
		{ text = "CREDITS", callback = credits },
		{ text = "QUIT", callback = quit }
	}

	-- Set up the buttons
	for i = 1,numOfButtons do
		local xPos = GLOBAL_acw/(numOfButtons*2) + (i-1)*GLOBAL_acw/numOfButtons
		local yPos = GLOBAL_ach - 100
		buttons[i] = Button:new(xPos, yPos, buttonData[i].text, buttonData[i].callback)
		buttons[i]:insertIntoScene(sceneGroup)
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
		-- Called when the scene is now on screen
		composer.removeScene( GLOBAL_scenePath .. "intro", false )
		composer.removeScene( GLOBAL_scenePath .. "leaderboard", false )
		composer.removeScene( GLOBAL_scenePath .. "credits", false )
		composer.removeScene( GLOBAL_scenePath .. "game", false )
		composer.removeScene( GLOBAL_scenePath .. "death", false )
		composer.removeScene( GLOBAL_scenePath .. "levelEditorScene", false )
		composer.removeScene( GLOBAL_scenePath .. "levelTransition", false )
		composer.removeScene( GLOBAL_scenePath .. "pauseMenu", false )
		composer.removeScene( GLOBAL_scenePath .. "win", false )
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
end

------------------------------------------------------------------------------------
-- Scene Listener Setup
------------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

------------------------------------------------------------------------------------
return scene