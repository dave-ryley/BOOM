local composer = require( "composer" )
local scene = composer.newScene()

local buttonMaker = require "button"
local canPress = false
---------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE
-- unless "composer.removeScene()" is called.
---------------------------------------------------------------------------------
local userInput

-- local forward references should go here

local winText
local winImage
local enterText
local button
---------------------------------------------------------------------------------
local function compare( a, b )
	return a.time < b.time
end

local function updateHighscores ( player_name )
	local medal_earned = 3
	if GLOBAL_time <= GLOBAL_goldTime then
		medal_earned = 1
	elseif GLOBAL_time <= GLOBAL_silverTime then
		medal_earned = 2
	end
	GLOBAL_highscores[11] =
	{
		medal = medal_earned,
		name = player_name,
		time = GLOBAL_time,
		deaths = GLOBAL_deaths,
		kills = GLOBAL_kills
	}
	table.sort(GLOBAL_highscores, compare)
	table.remove(GLOBAL_highscores, 11)
	GLOBAL_save_highscores()
end

function scene:create( event )

	local sceneGroup = self.view
	winText = display.newText(
		"YOU WIN! ",
		GLOBAL_ccx,
		GLOBAL_ccy - 160,
		GLOBAL_comicBookFont,
		200
	)
	winText:setFillColor(1,1,0)
	winImage = display.newImage(
		sceneGroup,
		GLOBAL_graphicsPath.."Art/Win.png",
		GLOBAL_ccx,
		GLOBAL_ccy
	)

	enterText = display.newText(
		"Enter your Name: ",
		400,
		GLOBAL_ach - 200,
		GLOBAL_comicBookFont,
		50
	)
	enterText:setFillColor(1,0,0)
	local userInputOptions =
	{
		text = "",
		x = GLOBAL_ccx,
		y = GLOBAL_ach - 200,
		width = 650,	--required for multi-line and alignment
		font = GLOBAL_comicBookFont,
		fontSize = 100,
		align = "left"	--new alignment parameter
	}

	userInput = display.newText( userInputOptions )
	userInput:setFillColor(1,1,0)

	function buttonPress( self, event )
		if event.phase == "began" then
			updateHighscores( userInput.text )
			composer.removeScene("win", false)
			composer.gotoScene( GLOBAL_scenePath.."leaderboard" )
			return true
		end
	end

	button = buttonMaker.spawn(GLOBAL_acw - 400, GLOBAL_ach - 200, "ACCEPT")
	sceneGroup:insert(button)
	sceneGroup:insert(button.text)
	sceneGroup:insert(button.flames)
	button:toFront()
	button.text:toFront()
	button.highlight(true)
	button.touch = buttonPress
	button:addEventListener( "touch", button )


	sceneGroup:insert(winText)
	sceneGroup:insert(winImage)
	sceneGroup:insert(enterText)
	sceneGroup:insert(userInput)

	-- Initialize the scene here.
	-- Example: add display objects to "sceneGroup", add touch listeners, etc.
end

local function updateText( key )
	if key == "deleteBack" then
		userInput.text = string.sub(userInput.text,1,-2)
	elseif string.len(userInput.text) < 10 then
		if key == "space" then
			userInput.text = userInput.text .. " "
		else
			userInput.text = userInput.text .. key
		end
	end
end

local function onWinKeyPress( event )
	local phase = event.phase
	local keyName = event.keyName
	canPress = true
	if (phase == "down" and canPress) then
		canPress = false
		if (keyName == "buttonA" or keyName == "enter") then
			audio.play(press, {channel = 31})
			updateHighscores( userInput.text )
			composer.removeScene("win", false)
			composer.gotoScene( GLOBAL_scenePath.."leaderboard" )
			--NEED CODE FOR SENDING DATA TO LEADERBOARD
		elseif( string.match("qwertyuiopasdfghjklzxcvbnm", string.lower(keyName)) or keyName == "deleteBack" or keyName == "space" ) then
			updateText( keyName )
		end
	elseif (phase == "up") then
		canPress = true
	end

	return false
end

-- REFERENCE: http://stackoverflow.com/questions/1426954/split-string-in-lua
function mysplit(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t={}
	local i=1
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		t[i] = str
		i = i + 1
	end
	return t
end

-- "scene:show()"
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase
	if ( phase == "will" ) then
	-- Called when the scene is still off screen (but is about to come on screen).
	elseif ( phase == "did" ) then
	composer.removeScene( GLOBAL_scenePath.."game", false )
	GLOBAL_level = 1
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
	display.remove( winText )
	display.remove( winImage )
	display.remove( enterText )
	display.remove( button )
	winText:removeSelf()
	winImage:removeSelf()
	enterText:removeSelf()
	userInput:removeSelf()
	button:removeSelf()
	winText:removeSelf()
	button:removeEventListener( "touch", button )
	winText = nil
	winImage = nil
	enterText = nil
	userInput = nil
	button = nil
	winText = nil
	Runtime:removeEventListener( "key", onWinKeyPress )
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
Runtime:addEventListener( "key", onWinKeyPress )

---------------------------------------------------------------------------------

return scene
