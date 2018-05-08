local composer = require( "composer" )
local scene = composer.newScene()
local controller_mapping = require "controller_mapping"
local buttonMaker = require "button"
local buttons = {}
local buttonSelect = 0
local canSelect = true

local function onPauseAxisEvent( event )
	--print("axis event running")
	-- Map event data to simple variables
	if g.pause == true and string.sub( event.device.descriptor, 1 , 7 ) == "Gamepad" then
		local axis = controller_mapping.axis[event.axis.number]
		if "left_y" == axis then
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
				for i=1, #buttons do
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

local function onPauseKeyPress( event )
	if g.pause == true then
		local phase = event.phase
		local keyName = event.keyName

		if (phase == "down") then
			if (keyName == "buttonA") then
				buttonFunction(buttonSelect)
			end
		end
	end
	return false
end


function scene:create( event )
	local sceneGroup = self.view
	parent = event.parent
	-- Called when the scene's view does not exist.
	-- INSERT code here to initialize the scene
	if(system.getInfo("platformName") ~= "Android") then
    	-- code in here to highlight the first button
	end
	myText = display.newText( "PAUSED", g.ccx, g.ccy-200, g.zombieFont, 80 )
	myText:setFillColor(1,1,0,1)

	function buttonPress( self, event )
		if event.phase == "began" then
			buttonFunction(self.id)
			return true
		end
	end

	local buttonLabels = {"RESUME","MAIN MENU"}
	for i=1,2 do
		buttons[i] = buttonMaker.spawn(g.ccx,g.ccy+(i-1)*200,buttonLabels[i])
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

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	if phase == "will" then
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
	parent:unpause()

	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end
end

function scene:destroy( event )
	local sceneGroup = self.view
	for i = 1,2 do
		buttons[i]:removeEventListener( "touch", buttons[1] )
		display.remove( buttons[1] )
	end
	buttons = nil
	myText:removeSelf()
	myText = nil
	Runtime:removeEventListener( "axis", onPauseAxisEvent )
	Runtime:removeEventListener( "key", onPauseKeyPress )
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
Runtime:addEventListener( "key", onPauseKeyPress )
Runtime:addEventListener( "axis", onPauseAxisEvent )

-----------------------------------------------------------------------------------------

return scene
