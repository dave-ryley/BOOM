local composer = require( "composer" )
local scene = composer.newScene()
local col = require "collisionFilters"
local g = require "globals"
local joysticks = require "joystick"
local hud = require "hud"
local perspective = require("perspective")
local goreCount = 0
local physics = require "physics"
local playerBuilder = require "playerMechanics"
local satanBuilder = require "satan"
local speedUp = require "Powerups.speedUp"
local powerUp = require "Powerups.powerUp"
local playerTextSpeed
local controllerMapping = require "controllerMapping"
local levelBuilder = require "levelBuilder"
local camera = perspective.createView()
local pauseButton
local timeOffset = 0
local gameTime = 0
local pauseTime = 0
local music = {
	"HeadShredder.mp3",
	"DeathCell.mp3",
	"HeadShredder.mp3",
	"HeadShredder.mp3",
	"HeadShredder.mp3",
	"HeadShredder.mp3",
	"HeadShredder.mp3",
	"HeadShredder.mp3",
}

local satanVFX = {
	"ImComingHaHa.ogg",
	"Laugh.ogg",
	"RunMortal.ogg",
	"YouCannotEscape.ogg",
	"YourSoulIsMine.ogg"
}

local map = {
	params = {},
	enemies = {},
	slowTraps = {},
	deathTraps = {},
	player = {},
	satan = {},
	level = display.newGroup( ),
	floor = display.newGroup( ),
	slowTrapsDisplay = display.newGroup( ),
	deathTrapsDisplay = display.newGroup( ),
	enemiesDisplay = display.newGroup( ),
	gore = {},
	fireballs = {},
	powerups = {}
}


function createMap()
	map.params = levelBuilder.buildLevel(g.level)
	map.enemies = map.params.enemies
	map.slowTraps = map.params.slowTraps
	map.deathTraps = map.params.deathTraps
	map.level = map.params.level
	map.floor = map.params.floor
	map.player = playerBuilder.spawn()
	g.gameState = "intro"
	for i = 1, #map.enemies do
		map.enemiesDisplay:insert(map.enemies[i].parent)
	end

	for i = 1, #map.slowTraps do
		map.slowTrapsDisplay:insert(map.slowTraps[i].bounds)
	end

	for i = 1, #map.deathTraps do
		map.deathTrapsDisplay:insert(map.deathTraps[i].bounds)
	end

	map.satan = satanBuilder.spawn(map.params.satanPath)
	map.satan.start()
	map.player.bounds:translate(0,0)

	-- INITIALIZING CAMERA
	camera:add(map.level, 3)
	camera:add(map.enemiesDisplay, 2)
	camera:add(map.slowTrapsDisplay, 5)
	camera:add(map.deathTrapsDisplay, 4)
	camera:add(map.floor,6)
	camera:add(map.player.torchLight, 5)
	--print ("player x: " .. player.bounds.x .. ", player y: " .. player.bounds.y )
	camera:prependLayer()
	camera.damping = 10
	camera:setFocus(map.player.cameraLock)
	camera:track()


	camera:add(map.player.parent, 1)
	camera:add(map.player.bounds, 1)
	camera:add(map.player.shotgun.blast, 1)
	camera:add(map.player.shotgun.bounds, 1)
	camera:add(map.satan.parent, 1)
	--camera:add(hud.satanIndicatorGroup,1)
end

local function onAxisEvent( event )
	-- Map event data to simple variables
	--print("axis: "..event.axis.number)
	if string.sub( event.device.descriptor, 1 , 7 ) == "Gamepad" then
		local axis = controllerMapping.axis[event.axis.number]
		--if g.pause then print("g.pause = true") else print("g.pause = false") end
		if(g.gameState == "playing") then
			map.player.playerAxis(axis, event.normalizedValue)
		end
	end
	return true
end

local function youDied( event )
	--print("you Died")
	g.gameState = "dead"
	g.pause = true
	--print("your killer is"..event.killer)
	composer.gotoScene( g.scenePath.."death",{params = {killer = event.killer}})
end

local function youWin( event )
	g.pause = true
	audio.fade( { channel=20, time=3000, volume=0 } )
	map.player.bounds:removeSelf()
	--print("you win")
	local nextLevel = ""
	g.level = g.level + 1
	g.gameState = "win"
	g.time = gameTime
	g.speed = map.player.maxSpeed
	g.shotgun = map.player.shotgun.power
	-- Player runs off screen
	map.player.visuals.animate(90, 90, 100, 1.0)
	transition.to( 	map.player.torchLight, 
					{time = 3000, 
					x = map.player.parent.x + 3000, 
					y = map.player.parent.y})
	transition.to( 	map.player.parent, 
					{time = 3000, 
					x = map.player.parent.x + 3000, 
					y = map.player.parent.y, 
					onComplete = 
						-- Game begins
						function()
							--print(g.level .. " : " .. g.lastLevel)
							if(g.level > g.lastLevel) then
								nextLevel = "win"
							else
								nextLevel = "levelTransition"
							end
							composer.gotoScene( g.scenePath..nextLevel)
						end
					} )
end

local function onKeyEvent( event )
	local phase = event.phase
	local keyName = event.keyName
	local axis = ""
	local value = 0
	print(event.keyName)
	if (event.phase == "down") then
		-- Adjust velocity for testing, remove for final game        
		--[[if ( event.keyName == "[" ) then
			if (map.player.velocity > 0 ) then
			map.player.maxSpeed = map.player.maxSpeed - 50
				map.player.shotgun.powerUp(-1)
			end
		elseif ( event.keyName == "]" or event.keyName == "leftShoulderButton1" ) then
			map.player.maxSpeed = map.player.maxSpeed + 50
			map.player.shotgun.powerUp(1)
			if (map.player.velocity > 0 ) then
			--player.velocity = player.velocity - 1
				--map.player.shotgun.powerUp(-1)
			end
		end]]
		-- WASD and ArrowKeys pressed down
		if ( event.keyName == "w" ) then
			value = -1.0
			axis = "left_y"
		elseif ( event.keyName == "s") then
			value = 1
			axis = "left_y"
		elseif ( event.keyName == "a") then
			value = -1
			axis = "left_x"
		elseif ( event.keyName == "d") then
			value = 1
			axis = "left_x"
		elseif ( event.keyName == "up") then
			value = -1
			axis = "right_y"
		elseif ( event.keyName == "down") then
			value = 1
			axis = "right_y"
		elseif ( event.keyName == "left") then
			value = -1
			axis = "right_x"
		elseif ( event.keyName == "right") then
			value = 1
			axis = "right_x"
		elseif ( event.keyName == "space" or event.keyName == "rightShoulderButton1" ) then
			value = 1
			axis = "left_trigger"
		end
	else
		-- WASD and Arrow keys pressed up
		if ( event.keyName == "w" ) then
			value = 0
			axis = "left_y"
		elseif ( event.keyName == "s") then
			value = 0
			axis = "left_y"
		elseif ( event.keyName == "a") then
			value = 0
			axis = "left_x"
		elseif ( event.keyName == "d") then
			value = 0
			axis = "left_x"
		elseif ( event.keyName == "up") then
			value = 0
			axis = "right_y"
		elseif ( event.keyName == "down") then
			value = 0
			axis = "right_y"
		elseif ( event.keyName == "left") then
			value = 0
			axis = "right_x"
		elseif ( event.keyName == "right") then
			value = 0
			axis = "right_x"
		elseif (event.keyName == "l") then
			--composer.gotoScene( g.scenePath.."death")
			youWin()
		elseif (event.keyName == "k") then
			--composer.gotoScene( g.scenePath.."death")
			youDied()
		elseif (event.keyName == "buttonStart") then
			if(g.pause == false) then
				scene:pause()
			else
				scene:unpause()
			end
		end
	end

	if (g.pause == false) then 
		--print(map.player.myName)
		map.player.playerAxis(axis, value) 
	end

	return false
end

local function makeGore( event )
	local x = event.x
	local y = event.y
	math.randomseed( os.time() )
	local r = math.random(1, 25)
	if(r < 6) then
		if(map.powerups ~= nil) then
			map.powerups[#map.powerups + 1] = powerUp.spawn(x, y)
			camera:add(map.powerups[#map.powerups].bounds, 2)
		end
		--print("adding powerup at: "..x .." , " .. y)
	elseif(r < 12) then
		if(map.powerups ~= nil) then
			map.powerups[#map.powerups + 1] = speedUp.spawn(x, y)
			camera:add(map.powerups[#map.powerups].bounds, 2)
		end
		--print("adding powerup at: "..x .." , " .. y)
	end
	goreCount = goreCount + 1
	if(map.gore[math.fmod(goreCount, g.maxGore)] ~= nil) then
		map.gore[math.fmod(goreCount, g.maxGore)]:removeSelf()
		map.gore[math.fmod(goreCount, g.maxGore)] = nil
	end
		map.gore[math.fmod(goreCount, g.maxGore)] = event.gore
	if(map.gore[math.fmod(goreCount, g.maxGore)] ~= nil)then
		print("making gore")
		camera:add(map.gore[math.fmod(goreCount, g.maxGore)], 4)
	end
end

local function fireball( event )
	map.fireballs[#map.fireballs + 1] = event.f
	if(map.fireballs[#map.fireballs] ~= nil)then
		camera:add(map.fireballs[#map.fireballs].fireball , 3)
	end
end

local function getPlayerLocation( event )
	if(map.player.isAlive == true) then
		local p = event.updatePlayerLocation(map.player.bounds.x, map.player.bounds.y)
		return p
	end
end

local function gameLoop( event )
	if g.pause == false and g.gameState == "playing" then
		if(g.android) then
			map.player.virtualJoystickInput(leftJoystick.angle, 
											leftJoystick.xLoc/70, 
											leftJoystick.yLoc/70, 
											rightJoystick.angle, 
											rightJoystick.distance/70,
											rightJoystick.xLoc/70, 
											rightJoystick.yLoc/70)
		end
		hud.updateSatanPointer(map.satan.bounds.x,map.satan.bounds.y,map.player.bounds.x,map.player.bounds.y,map.player.cameraLock.x,map.player.cameraLock.y)
		gameTime = system.getTimer() - timeOffset
		hud.updateTimer( gameTime )
		map.player.update()
	elseif g.gameState == "intro" then
		map.player.cameraLock.x, map.player.cameraLock.y = map.satan.bounds.x, map.satan.bounds.y - 300
	end
	return true
end

function scene:pause()
	hud.satanIndicator:pause()
	pauseTime = system.getTimer()
	g.pause = true	
	pauseButton.change(2)
	pauseButton.id = 2
	physics.pause( )
	map.player.pause()
	map.satan.pause()
	audio.pause()
	for i = 1, #map.enemies do
		if(map.enemies[i] ~= nil) then
			map.enemies[i].pause()
		end
	end
	for i = 1, #map.fireballs do
		if(map.fireballs[i] ~= nil) then
			map.fireballs[i].pause()
		end
	end
	composer.showOverlay(g.scenePath.."pauseMenu")
end

function scene:unpause()
	hud.satanIndicator:play()
	print("unpaused")
	timeOffset = system.getTimer() - gameTime
	g.pause = false
	pauseButton.change(1)
	pauseButton.id = 1
	physics.start( )
	map.player.unpause()
	map.satan.unpause()
	audio.resume()
	for i = 1, #map.enemies do
		if(map.enemies[i] ~= nil) then
			map.enemies[i].unpause()
		end
	end
	for i = 1, #map.fireballs do
		if(map.fireballs[i] ~= nil) then
			map.fireballs[i].unpause()
		end
	end
	composer.hideOverlay(g.scenePath.."pauseMenu")
end

function buttonPress( self, event )
	if event.phase == "began" then
		audio.play(press, {channel = 31})
		if self.id == 1 then
			scene:pause()
		else
			scene:unpause()
		end
		return true
	end
end

---------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE
-- unless "composer.removeScene()" is called.
---------------------------------------------------------------------------------

-- local forward references should go here
-- "scene:create()"
function scene:create( event )
	physics.start()
	physics.setGravity(0,0)
	physics.setDrawMode( g.drawMode)
	g.pause = false
	sceneGroup = self.view
	createMap()
	sceneGroup:insert(camera)
	
	local bgOptions =
	{
		channel = 20,
		loops = -1,
		fadein = 1000,
	}
	audio.setVolume( 0.2, { channel=20 } )
	local bgMusic = audio.loadStream( g.musicPath..music[g.level])
	audio.play(bgMusic,bgOptions)
	
	if(g.android) then
		rightJoystick = joysticks.joystick(sceneGroup, 
							"Graphics/UI/analogStickHead.png", 200, 200, 
							"Graphics/UI/analogStickBase.png", 280, 280, 2.5 )
		rightJoystick.x = g.acw -250
		rightJoystick.y = g.ach -250
		rightJoystick.activate()
		leftJoystick = joysticks.joystick(sceneGroup, 
							"Graphics/UI/analogStickHead.png", 200, 200, 
							"Graphics/UI/analogStickBase.png", 280, 280, 1.0 )
		leftJoystick.x = 250
		leftJoystick.y = g.ach -250
		leftJoystick.activate()
	end
	
	-- PAUSE BUTTON ---
	local pButtonMaker = require "HUD.pauseButton"
	pauseButton = pButtonMaker.spawn()
	pauseButton.x = -200
	pauseButton.y = -200
	pauseButton.id = 1
	pauseButton.touch = buttonPress
	sceneGroup:insert(pauseButton)
	pauseButton:addEventListener( "touch", pauseButton )


	-- BEGIN GAME
	local voice = audio.loadSound("Sounds/Satan/"..satanVFX[math.random(5)])
	audio.setVolume( 0.5, {channel = 6} )
	audio.play(voice,{channel = 6})
	timer.performWithDelay(2000, 
		-- Stays on satan for 2 seconds
		function() 
			audio.dispose(voice)
			g.gameState = "introTransition" 
			-- Pans over to the player
			hud.initializeHUD()
			hud.updateShotgunOMeter(g.shotgun)
			transition.to( 	pauseButton, {time = 1000, x = 100, y = 100,} )
			transition.to( 	map.player.cameraLock, 
				{time = 1000, 
				x = map.player.bounds.x, 
				y = map.player.bounds.y,
				onComplete = 
					-- Game begins
					function()
						g.gameState = "playing"
						timeOffset = system.getTimer() - g.time
					end
				} )
		end
	)
end

-- "scene:show()"
function scene:show( event )
	print("in scene show")
	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
	-- Called when the scene is still off screen (but is about to come on screen).
	elseif ( phase == "did" ) then
		composer.removeScene( g.scenePath.."menu", false )
		g.pause = false
	-- Called when the scene is now on screen.
	-- Insert code here to make the scene come alive.
	-- Example: start timers, begin animation, play audio, etc.
	end
end

-- "scene:hide()"
function scene:hide( event )
	print("in scene hide")

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

	camera.destroy()
	g.pause = true
	hud.killHUD()
	audio.stop( 20 )
	print("here in destroy")
	timer.performWithDelay( 10, 
		function()
			Runtime:removeEventListener( "enterFrame", gameLoop )
			Runtime:removeEventListener( "key", onKeyEvent )
			Runtime:removeEventListener( "axis", onAxisEvent )
			Runtime:removeEventListener( "makeGore", makeGore)
			Runtime:removeEventListener( "fireball", fireball)
			Runtime:removeEventListener( "youWin", youWin)
			Runtime:removeEventListener( "youDied", youDied)
			Runtime:removeEventListener( "getPlayerLocation", getPlayerLocation)
			map.player.die()
			map.player = nil
			map.player = {}
			for i = 1, #map.powerups do
				if(map.powerups[i] ~= nil) then
					display.remove(map.powerups.bounds)
					map.powerups[i] = nil
				end
			end
			map.powerups = nil
			for i = 1, #map.slowTraps do
				if(map.slowTraps[i] ~= nil) then
					map.slowTraps[i] = nil
				end
			end
			for i = 1, #map.deathTraps do
				if(map.deathTraps[i] ~= nil) then
					map.deathTraps[i] = nil
				end
			end

			for i = 1, #map.enemies do
				if(map.enemies[i] ~= nil) then
					map.enemies[i].hasTarget = false
					--map.enemies[i].die(false, 0)
					map.enemies[i] = nil
				end
			end

			display.remove( map.enemiesDisplay )
			display.remove( map.slowTrapsDisplay )
			display.remove( map.deathTrapsDisplay )
			display.remove( map.level )
			transition.cancel( map.satan.bounds )
			display.remove( map.satan.bounds )
			map.satan = nil
			map.satan = {}
			display.remove( map.floor )
			map.params = nil
			map.params = {}
			for i = 1, #map.gore do
				if(map.gore[i] ~= nil) then
					display.remove(map.gore[i])
					map.gore[i] = nil
				end
			end
			for i = 1, #map.fireballs do
				if(map.fireballs[i] ~= nil) then
					map.fireballs[i].die()
					map.fireballs[i] = nil
				end
			end
			physics.stop()
		
			end
		 )
	
	--scene:removeEventListener( "create", scene )
	--scene:removeEventListener( "show", scene )
	--scene:removeEventListener( "hide", scene )
	--scene:removeEventListener( "destroy", scene )
	--]]
	
-- Called prior to the removal of scene's view ("sceneGroup").
-- Insert code here to clean up the scene.
-- Example: remove display objects, save state, etc.
end
---------------------------------------------------------------------------------


---------------------------------------------------------------------------------

-- Listener setup
Runtime:addEventListener( "makeGore", makeGore)
Runtime:addEventListener( "fireball", fireball)
Runtime:addEventListener( "youWin", youWin)
Runtime:addEventListener( "youDied", youDied)
Runtime:addEventListener( "getPlayerLocation", getPlayerLocation)
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
Runtime:addEventListener( "enterFrame", gameLoop )
if(g.android == false) then 
  Runtime:addEventListener( "key", onKeyEvent )
  Runtime:addEventListener( "axis", onAxisEvent )
end
---------------------------------------------------------------------------------

return scene