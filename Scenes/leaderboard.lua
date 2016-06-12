local composer = require( "composer" )
local g = require "globals"
local scene = composer.newScene()
local buttonMaker = require "button"
local canPress = false

---------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE
-- unless "composer.removeScene()" is called.
---------------------------------------------------------------------------------

-- local forward references should go here
local leaderBoard = {}

local function onLBKeyPress( event )
	local phase = event.phase
	local keyName = event.keyName

	if (phase == "down" and canPress) then
		if (keyName == "buttonA") then
			audio.play(press, {channel = 31})
    		composer.gotoScene( g.scenePath.."menu" )
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

--[[local function generateLeaderboard()
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
	file = nil

	return ldb

end]]
---------------------------------------------------------------------------------

-- "scene:create()"
function scene:create( event )
-----Map-----
	local sceneGroup = self.view
	composer.removeScene(g.scenePath.."menu")
	--lbData = generateLeaderboard()
	local title = display.newText( "HIGH SCORES", g.ccx, 100 , g.comicBookFont , 80 )
	title:setFillColor( 1,1,0 )
	sceneGroup:insert(title)
	local ldb = {}
	ldb.medal = {}
	ldb.name = {}
	ldb.time = {}
	ldb.deaths = {}
	ldb.kills = {}
	ldb.timeIcons = {}
	ldb.deathsIcons = {}
	ldb.killsIcons = {}
	for i = 1, 10 do

		ldb.medal[i] = display.newImage( "Graphics/Leaderboard/medal".. g.highscores[i].medal ..".png",  400, 150 + i*65 )
		ldb.timeIcons[i] = display.newImage( "Graphics/Leaderboard/time.png",  800, 150 + i*65 )
		ldb.deathsIcons[i] = display.newImage( "Graphics/Leaderboard/deaths.png",  1200, 150 + i*65 )
		ldb.killsIcons[i] = display.newImage( "Graphics/Leaderboard/kills.png",  1400, 150 + i*65 )

		local nameOptions = 
		{
		    text = g.highscores[i].name,     
		    x = 775,
		    y = 150 + i*65,
		    width = 650,     --required for multi-line and alignment
		    font = g.comicBookFont,   
		    fontSize = 50,
		    align = "left"  --new alignment parameter
		}
		ldb.name[i] = display.newText( nameOptions )
		local timeOptions = 
		{
		    text = "" .. math.floor(g.highscores[i].time/600000) .. math.floor((g.highscores[i].time/60000)%10) .." : " 
		    .. math.floor((g.highscores[i].time/10000)%6) .. math.floor((g.highscores[i].time/1000)%10) .. " : " .. math.floor((g.highscores[i].time/100)%10) .. math.floor((g.highscores[i].time/10)%10),     
		    x = 990,
		    y = 150 + i*65,
		    width = 300,     --required for multi-line and alignment
		    font = g.comicBookFont,   
		    fontSize = 50,
		    align = "left"  --new alignment parameter
		}
		ldb.time[i] = display.newText( timeOptions )
		local deathsOptions = 
		{
		    text = g.highscores[i].deaths,     
		    x = 1320,
		    y = 150 + i*65,
		    width = 150,     --required for multi-line and alignment
		    font = g.comicBookFont,   
		    fontSize = 50,
		    align = "left"  --new alignment parameter
		}
		ldb.deaths[i] = display.newText( deathsOptions )
		local killsOptions = 
		{
		    text = g.highscores[i].kills,     
		    x = 1520,
		    y = 150 + i*65,
		    width = 150,     --required for multi-line and alignment
		    font = g.comicBookFont,   
		    fontSize = 50,
		    align = "left"  --new alignment parameter
		}
		ldb.kills[i] = display.newText( killsOptions )

		if g.highscores[i].kills == g.kills and g.highscores[i].time == g.time and g.highscores[i].deaths == g.deaths then
			ldb.name[i]:setFillColor( 1,1,0 )
			ldb.time[i]:setFillColor( 1,1,0 )
			ldb.deaths[i]:setFillColor( 1,1,0 )
			ldb.kills[i]:setFillColor( 1,1,0 )
		else
			ldb.name[i]:setFillColor( 1,0,0 )
			ldb.time[i]:setFillColor( 1,0,0 )
			ldb.deaths[i]:setFillColor( 1,0,0 )
			ldb.kills[i]:setFillColor( 1,0,0 )
		end
		sceneGroup:insert(ldb.medal[i])
		sceneGroup:insert(ldb.name[i])
		sceneGroup:insert(ldb.time[i])
		sceneGroup:insert(ldb.deaths[i])
		sceneGroup:insert(ldb.kills[i])
		sceneGroup:insert(ldb.timeIcons[i])
		sceneGroup:insert(ldb.deathsIcons[i])
		sceneGroup:insert(ldb.killsIcons[i])

	end

	local dogImage = display.newImage( "Graphics/Leaderboard/dog.png",  415, g.ch - 215 )
	sceneGroup:insert(dogImage)

	function buttonPress( self, event )
    	if event.phase == "began" then
    		audio.play(press, {channel = 31})
    		composer.gotoScene( g.scenePath.."menu" )
    		return true
    	end
	end

	button = buttonMaker.spawn(g.acw-300, g.ach - 100, "MAIN MENU")
	sceneGroup:insert(button)
	sceneGroup:insert(button.text)
	sceneGroup:insert(button.flames)
	button:toFront()
	button.text:toFront()
	button.highlight(true)
	button.touch = buttonPress
	button:addEventListener( "touch", button )
end

-- "scene:show()"
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
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

	local sceneGroup = self.view
		path = nil
		file = nil
	Runtime:removeEventListener( "key", onLBKeyPress )
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
Runtime:addEventListener( "key", onLBKeyPress )

---------------------------------------------------------------------------------

return scene