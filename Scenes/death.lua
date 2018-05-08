local composer = require( "composer" )
local scene = composer.newScene()
local controller_mapping = require "controller_mapping"
local buttonMaker = require "button"
local buttons = {}
local buttonSelect = 0
local canSelect = true
---------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE
-- unless "composer.removeScene()" is called.
---------------------------------------------------------------------------------


local function onDeathAxisEvent( event )
	-- Map event data to simple variables
	if string.sub( event.device.descriptor, 1 , 7 ) == "Gamepad" then
		local axis = controller_mapping.axis[event.axis.number]
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
		composer.removeScene( g.scenePath.."death", false )
		composer.gotoScene( g.scenePath.."game" )
	elseif key == 2 then
		composer.removeScene( g.scenePath.."death", false )
    	composer.gotoScene( g.scenePath.."menu" )
	end
end

local function onDeathKeyPress( event )
	local phase = event.phase
	local keyName = event.keyName

	if (phase == "down") then
		if (keyName == "buttonA") then
			buttonFunction(buttonSelect)
		end
	end

	return false
end

-- local forward references should go here
local myText1
local myText2
local deathImage
---------------------------------------------------------------------------------

-- "scene:create()"
function scene:create( event )
	composer.removeScene( g.scenePath.."game", false )
	g.speed = 1000.0
	g.shotgun = 10
	local killer = event.params.killer
	local sceneGroup = self.view
	deathImage = display.newImage( sceneGroup,
						g.graphicsPath.."Death/"..killer..".png",
						g.ccx,g.ccy ,
						isFullResolution )

	myText1 = display.newText(
		sceneGroup,
		"YOU",
		g.ccx-500,
		g.ccy,
		g.bloodyFont,
		300
	)
	myText2 = display.newText(
		sceneGroup,
		"DIED",
		g.ccx+500,
		g.ccy,
		g.bloodyFont,
		300
	)
	myText1:setFillColor(1,0,0)
	myText2:setFillColor(1,0,0)

	function buttonPress( self, event )
		if event.phase == "began" then
			buttonFunction(self.id)
			return true
		end
	end

	local buttonLabels = {"RETRY","MAIN MENU"}
	for i = 1 , 2 do
		buttons[i] = buttonMaker.spawn(g.acw/(4) + (i-1)*g.acw/2, g.ach - 100, buttonLabels[i])
		sceneGroup:insert(buttons[i])
		sceneGroup:insert(buttons[i].text)
		sceneGroup:insert(buttons[i].flames)
		buttons[i]:toFront()
		buttons[i].text:toFront()
		buttons[i].id = i
		buttons[i].touch = buttonPress
		buttons[i]:addEventListener( "touch", buttons[i] )
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
	Runtime:removeEventListener( "axis", onDeathAxisEvent )
	Runtime:removeEventListener( "key", onDeathKeyPress )
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
Runtime:addEventListener( "key", onDeathKeyPress )
Runtime:addEventListener( "axis", onDeathAxisEvent )

---------------------------------------------------------------------------------

return scene
