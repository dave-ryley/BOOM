local composer = require( "composer" )
local scene = composer.newScene()
local controller_mapping = require "controller_mapping"
local Button = require "button"
local buttons = {}
local selected = 0
local canSelect = true
local myText = {}
local press = audio.loadSound( GLOBAL_soundsPath.."GUI/ButtonPress.ogg")

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
-- Button Functions
------------------------------------------------------------------------------------

local function resume()
	composer.hideOverlay(true)
end

local function menu()
	composer.gotoScene( GLOBAL_scenePath.."menu" )
end

------------------------------------------------------------------------------------
-- Event Listeners
------------------------------------------------------------------------------------

local function onAxisEvent( event )
	-- Map event data to simple variables
	if GLOBAL_pause == true and string.sub( event.device.descriptor, 1 , 7 ) == "Gamepad" then
		local axis = controller_mapping.axis[event.axis.number]
		if ( "left_y" == axis ) then
			if event.normalizedValue < 0.1 and event.normalizedValue > -0.1 then
				canSelect = true
			elseif canSelect then
				canSelect = false
				local direction = event.normalizedValue > 0 and 1 or -1
				selectButton(direction)
			end
		end
	end
	return true
end

local function onKeyPress( event )
	if GLOBAL_pause == true then
		local phase = event.phase
		local keyName = event.keyName
		if (phase == "down") then
			if (keyName == "buttonA") then
				audio.play(press, {channel = 31})
				buttons[selected].callback()
			elseif(event.keyName == "up") then
				selectButton(-1)
			elseif(event.keyName == "down") then
				selectButton(1)
			end
		end
	end
	return false
end

---------------------------------------------------------------------------------

function scene:create( event )
	local sceneGroup = self.view
	parent = event.parent
	buttons = {}
	-- Called when the scene's view does not exist.
	-- INSERT code here to initialize the scene

	myText = display.newText( "PAUSED", GLOBAL_ccx, GLOBAL_ccy-200, GLOBAL_zombieFont, 80 )
	myText:setFillColor(1,1,0,1)

	local buttonData =
	{
		{ text = "RESUME", callback = resume },
		{ text = "MAIN MENU", callback = menu }
	}

	for i=1,2 do
		local xPos = GLOBAL_ccx
		local yPos = GLOBAL_ccy+(i-1)*200
		buttons[i] = Button:new(xPos, yPos, buttonData[i].text, buttonData[i].callback)
		buttons[i]:insertIntoScene(sceneGroup)
	end
	selectButton(1)
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	if phase == "will" then
		Runtime:addEventListener( "axis", onAxisEvent )
		Runtime:addEventListener( "key", onKeyPress )
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
	local parent = event.parent


	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		Runtime:removeEventListener( "axis", onAxisEvent )
		Runtime:removeEventListener( "key", onKeyPress )
		parent:unpause()
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end
end

function scene:destroy( event )
	Runtime:removeEventListener( "axis", onAxisEvent )
	Runtime:removeEventListener( "key", onKeyPress )
	local sceneGroup = self.view
	for i = 1,2 do
		Button:dispose(buttons[i])
	end
	buttons = {}
	myText:removeSelf()
	myText = nil
	selected = 0
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
