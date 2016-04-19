local composer = require( "composer" )
local scene = composer.newScene()
local g = require "globals"
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

local function updateLeaderboard( name )
	local ldb = {}
	ldb.medal = {}
	ldb.name = {}
	ldb.time = {}
	ldb.deaths = {}
	ldb.kills = {}
	local i = 1
	-- READING IN THE LEADERBOARD
	local path = system.pathForFile( "LeaderBoard.BOOMFILE", system.DocumentsDirectory )

	-- Open the file handle
	local file, errorString = io.open( path, "r" )

	if not file then
	    -- Error occurred; output the cause
	    print( "File error: " .. errorString )
	else
	    for line in file:lines() do
	    	print(line)
	    	local split = mysplit(line, ",")
	    	ldb.medal[i] = tonumber(split[1])
			ldb.name[i] = split[2]
			ldb.time[i] = tonumber(split[3])
			ldb.deaths[i] = tonumber(split[4])
			ldb.kills[i] = tonumber(split[5])
	    	i = i + 1
	    end
	    -- Close the file handle
	    io.close( file )
	end

	local playerMedal = 3
	if g.time <= g.goldTime then
		playerMedal = 1
	elseif g.time <= g.silverTime then
		playerMedal = 2
	end

	file = nil
	--CHECKING IF PLAYER MADE THE LEADERBOARD
	local notYetInserted = true
	for i = 1, #ldb.medal do
		if notYetInserted and ldb.time[i] > g.time then
			table.insert( ldb.medal , i, playerMedal )
			table.insert( ldb.name , i, name )
			table.insert( ldb.time , i, g.time )
			table.insert( ldb.deaths , i, g.deaths )
			table.insert( ldb.kills , i, g.kills )
			notYetInserted = false
		end
	end

	-- CREATING THE FILE TO WRITE
	local saveData = ""

	for i = 1, 10 do
		saveData = saveData .. ldb.medal[i] .. ","
		saveData = saveData .. ldb.name[i] .. ","
		saveData = saveData .. ldb.time[i] .. ","
		saveData = saveData .. ldb.deaths[i] .. ","
		saveData = saveData .. ldb.kills[i] .. "\n"
	end
	print(saveData)

	--WRITING THE LEADERBOARD
	local file2, errorString = io.open( path, "w" )
	
	if not file2 then
    	-- Error occurred; output the cause
    	print( "File error: " .. errorString )
	else
	    -- Write data to file
	    file2:write( saveData )
	    -- Close the file handle
	    io.close( file2 )
	end

	file2 = nil

end

-- "scene:create()"

function scene:create( event )

	local sceneGroup = self.view
	winText = display.newText( "YOU WIN! ", 
									g.ccx, 
									g.ccy - 160, 
									"Avengeance Mightiest Avenger", 
									200 )
	winText:setFillColor(1,1,0)
	winImage = display.newImage( sceneGroup,
						"Graphics/Art/win.png", 
						g.ccx,g.ccy )

	enterText = display.newText( "Enter your Name: ", 
									400, 
									g.ach - 200, 
									"Avengeance Mightiest Avenger", 
									50 )
	enterText:setFillColor(1,0,0)
	local userInputOptions = 
	{
	    --parent = textGroup,
	    text = "",     
	    x = g.ccx,
	    y = g.ach - 200,
	    width = 650,     --required for multi-line and alignment
	    font = "Avengeance Mightiest Avenger",   
	    fontSize = 100,
	    align = "left"  --new alignment parameter
	}

	userInput = display.newText( userInputOptions )
	userInput:setFillColor(1,1,0)

	function buttonPress( self, event )
    	if event.phase == "began" then
    		updateLeaderboard( userInput.text )
			composer.removeScene("win", false)
    		composer.gotoScene( g.scenePath.."leaderboard" )
    		return true
    	end
	end

	button = buttonMaker.spawn(g.acw - 400, g.ach - 200, "ACCEPT")
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
	print(keyName)
	if (phase == "down" and canPress) then
		canPress = false
		if (keyName == "buttonA" or keyName == "enter") then
			audio.play(press, {channel = 31})
			updateLeaderboard( userInput.text )
			composer.removeScene("win", false)
    		composer.gotoScene( g.scenePath.."leaderboard" )
    		--NEED CODE FOR SENDING DATA TO LEADERBOARD
		elseif( string.match("qwertyuiopasdfghjklzxcvbnm", string.lower(keyName)) ~= nil or keyName == "deleteBack" or keyName == "space" ) then
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
	composer.removeScene( g.scenePath.."game", false )
	g.level = 1
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