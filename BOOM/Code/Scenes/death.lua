local composer = require( "composer" )
local scene = composer.newScene()
local controller_mapping = require "controller_mapping"

local Button = require "button"
local buttons = {}
local selected = 0
local canSelect = true

local myText1
local myText2
local deathImage

------------------------------------------------------------------------------------
-- Local Functions
------------------------------------------------------------------------------------

local function selectButton( direction )
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

local function retry()
	composer.gotoScene( GLOBAL_scenePath.."game" )
end

local function menu()
    composer.gotoScene( GLOBAL_scenePath.."menu" )
end

------------------------------------------------------------------------------------
-- Event Listeners
------------------------------------------------------------------------------------

local function onAxisEvent( event )
	if string.sub( event.device.descriptor, 1 , 7 ) == "Gamepad" then
		local axis = controller_mapping.axis[event.axis.number]
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
end

local function onKeyPress( event )
	if (event.phase == "down") then
		if (event.keyName == "buttonA") then
			buttons[selected].callback()
		elseif(event.keyName == "enter") then
			buttons[selected].callback()
		elseif(event.keyName == "left") then
			selectButton(-1)
		elseif(event.keyName == "right") then
			selectButton(1)
		end
	end
end

---------------------------------------------------------------------------------

function scene:create( event )
	composer.removeScene( GLOBAL_scenePath.."game", false )
	GLOBAL_speed = 1000.0
	GLOBAL_shotgun = 10
	local killer = event.params.killer
	local sceneGroup = self.view
	deathImage = display.newImage(
		sceneGroup,
		GLOBAL_graphicsPath.."Death/"..killer..".png",
		GLOBAL_ccx,GLOBAL_ccy
	)

	myText1 = display.newText(
		sceneGroup,
		"YOU",
		GLOBAL_ccx-500,
		GLOBAL_ccy,
		GLOBAL_bloodyFont,
		300
	)
	myText2 = display.newText(
		sceneGroup,
		"DIED",
		GLOBAL_ccx+500,
		GLOBAL_ccy,
		GLOBAL_bloodyFont,
		300
	)
	myText1:setFillColor(1,0,0)
	myText2:setFillColor(1,0,0)

	local buttonData = {
		{ text = "RETRY", callback = retry },
		{ text = "MAIN MENU", callback = menu },
	}
	for i = 1 , 2 do
		buttons[i] = Button.new(GLOBAL_acw/(4) + (i-1)*GLOBAL_acw/2, GLOBAL_ach - 100, buttonData[i].text, buttonData[i].callback)
		buttons[i]:insertIntoScene(sceneGroup)
		buttons[i].id = i
	end
end


-- "scene:show()"
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase
	composer.removeScene( GLOBAL_scenePath.."game", false )

	if ( phase == "will" ) then

	elseif ( phase == "did" ) then
		Runtime:addEventListener( "key", onKeyPress )
		Runtime:addEventListener( "axis", onAxisEvent )
	end
end

-- "scene:hide()"
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		Runtime:removeEventListener( "axis", onAxisEvent )
		Runtime:removeEventListener( "key", onKeyPress )
	elseif ( phase == "did" ) then

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
