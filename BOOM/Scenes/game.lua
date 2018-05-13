
local composer = require "composer"
local joysticks = require "joystick"
local hud = require "hud"
local perspective = require "perspective"
local physics = require "physics"
local playerBuilder = require "player_mechanics"
local satanBuilder = require "satan"
local speedUp = require "Powerups.speed_up"
local powerUp = require "Powerups.power_up"
local controller_mapping = require "controller_mapping"
local levelBuilder = require "level_builder"
local scene = composer.newScene()
local camera = perspective.createView()
local pauseButton
local goreCount = 0
local timeOffset = 0
local gameTime = 0
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
	map.params = levelBuilder.buildLevel(GLOBAL_level)
	map.enemies = map.params.enemies
	map.slowTraps = map.params.slowTraps
	map.deathTraps = map.params.deathTraps
	map.level = map.params.level
	map.floor = map.params.floor
	map.player = playerBuilder.spawn()
	GLOBAL_gameState = "intro"

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
	camera:prependLayer()
	camera.damping = 10
	camera:setFocus(map.player.cameraLock)
	camera:track()

	camera:add(map.player.parent, 1)
	camera:add(map.player.bounds, 1)
	camera:add(map.player.shotgun.blast, 1)
	camera:add(map.player.shotgun.bounds, 1)
	camera:add(map.satan.parent, 1)
end

local function onAxisEvent( event )
	-- Map event data to simple variables
	if string.sub( event.device.descriptor, 1 , 7 ) == "Gamepad" then
		local axis = controller_mapping.axis[event.axis.number]
		if(GLOBAL_gameState == "playing") then
			map.player.playerAxis(axis, event.normalizedValue)
		end
	end
	return true
end

local function youDied( event )
	GLOBAL_gameState = "dead"
	GLOBAL_pause = true
	composer.gotoScene( GLOBAL_scenePath.."death",{params = {killer = event.killer}})
end

local function youWin( event )
	GLOBAL_pause = true
	audio.fade( { channel=20, time=3000, volume=0 } )
	map.player.bounds:removeSelf()
	local nextLevel = ""
	GLOBAL_level = GLOBAL_level + 1
	GLOBAL_gameState = "win"
	GLOBAL_time = gameTime
	GLOBAL_speed = map.player.maxSpeed
	GLOBAL_shotgun = map.player.shotgun.power
	-- Player runs off screen
	map.player.visuals.animate(90, 90, 100, 1.0)
	transition.to(
		map.player.torchLight,
		{
			time = 3000,
			x = map.player.parent.x + 3000,
			y = map.player.parent.y
		}
	)
	transition.to(
		map.player.parent,
		{
			time = 3000,
			x = map.player.parent.x + 3000,
			y = map.player.parent.y,
			onComplete = function()
				-- Game begins
				if GLOBAL_level > GLOBAL_lastLevel then
					nextLevel = "win"
				else
					nextLevel = "level_transition"
				end
				composer.gotoScene( GLOBAL_scenePath..nextLevel)
			end
		}
	)
end

local function onKeyEvent( event )
	local axis = ""
	local value = 0
	if (event.phase == "down") then
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
			youWin()
		elseif (event.keyName == "k") then
			youDied()
		elseif (event.keyName == "buttonStart") then
			-- prevent pausing during intro and transition
			if (GLOBAL_gameState == "playing") then
				if (GLOBAL_pause == false) then
					scene:pause()
				else
					scene:unpause()
				end
			end
		end
	end

	if (GLOBAL_pause == false) then
		map.player.playerAxis(axis, value)
	end

	return false
end

local function makeGore( event )
	local x = event.x
	local y = event.y
	math.randomseed( os.time() )
	local r = math.random(1, 25)
	if r < 6 then
		if map.powerups then
			map.powerups[#map.powerups + 1] = powerUp.spawn(x, y)
			camera:add(map.powerups[#map.powerups].bounds, 2)
		end
	elseif r < 12 then
		if map.powerups then
			map.powerups[#map.powerups + 1] = speedUp.spawn(x, y)
			camera:add(map.powerups[#map.powerups].bounds, 2)
		end
	end
	goreCount = goreCount + 1
	if map.gore[math.fmod(goreCount, GLOBAL_maxGore)] then
		map.gore[math.fmod(goreCount, GLOBAL_maxGore)]:removeSelf()
		map.gore[math.fmod(goreCount, GLOBAL_maxGore)] = nil
	end
		map.gore[math.fmod(goreCount, GLOBAL_maxGore)] = event.gore
	if map.gore[math.fmod(goreCount, GLOBAL_maxGore)] then
		camera:add(map.gore[math.fmod(goreCount, GLOBAL_maxGore)], 4)
	end
end

local function fireball( event )
	map.fireballs[#map.fireballs + 1] = event.f
	if map.fireballs[#map.fireballs] then
		camera:add(map.fireballs[#map.fireballs].fireball , 3)
	end
end

local function getPlayerLocation( event )
	if map.player.isAlive == true then
		local p = event.updatePlayerLocation(map.player.bounds.x, map.player.bounds.y)
		return p
	end
end

local function gameLoop( event )
	if GLOBAL_pause == false and GLOBAL_gameState == "playing" then
		if GLOBAL_android then
			map.player.virtualJoystickInput(
				leftJoystick.angle,
				leftJoystick.xLoc/70,
				leftJoystick.yLoc/70,
				rightJoystick.angle,
				rightJoystick.distance/70,
				rightJoystick.xLoc/70,
				rightJoystick.yLoc/70
			)
		end
		hud.updateSatanPointer(
			map.satan.bounds.x,
			map.satan.bounds.y,
			map.player.bounds.x,
			map.player.bounds.y,
			map.player.cameraLock.x,
			map.player.cameraLock.y
		)
		gameTime = system.getTimer() - timeOffset
		hud.updateTimer( gameTime )
		map.player.update()
	elseif GLOBAL_gameState == "intro" then
		map.player.cameraLock.x, map.player.cameraLock.y = map.satan.bounds.x, map.satan.bounds.y - 300
	end
	return true
end

function scene:pause()
	hud.satanIndicator:pause()
	GLOBAL_pause = true
	pauseButton.change(2)
	pauseButton.id = 2
	physics.pause( )
	map.player.pause()
	map.satan.pause()
	audio.pause()
	for i = 1, #map.enemies do
		if(map.enemies[i]) then
			map.enemies[i].pause()
		end
	end
	for i = 1, #map.fireballs do
		if(map.fireballs[i]) then
			map.fireballs[i].pause()
		end
	end
	composer.showOverlay(GLOBAL_scenePath.."pause_menu")
end

function scene:unpause()
	hud.satanIndicator:play()
	timeOffset = system.getTimer() - gameTime
	GLOBAL_pause = false
	pauseButton.change(1)
	pauseButton.id = 1
	physics.start( )
	map.player.unpause()
	map.satan.unpause()
	audio.resume()
	for i = 1, #map.enemies do
		if(map.enemies[i]) then
			map.enemies[i].unpause()
		end
	end
	for i = 1, #map.fireballs do
		if(map.fireballs[i]) then
			map.fireballs[i].unpause()
		end
	end
	composer.hideOverlay(GLOBAL_scenePath.."pause_menu", true)
end

function buttonPress( self, event )
	if event.phase == "began" then
		--audio.play(press, {channel = 31}) --TODO load sound properly here
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
	physics.setDrawMode( GLOBAL_drawMode)
	GLOBAL_pause = false
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
	local bgMusic = audio.loadStream( GLOBAL_musicPath..music[GLOBAL_level])
	audio.play(bgMusic,bgOptions)

	if GLOBAL_android then
		rightJoystick = joysticks.joystick(sceneGroup,
							GLOBAL_UIPath.."AnalogStickHead.png", 200, 200,
							GLOBAL_UIPath.."AnalogStickBase.png", 280, 280, 2.5 )
		rightJoystick.x = GLOBAL_acw -250
		rightJoystick.y = GLOBAL_ach -250
		rightJoystick.activate()
		leftJoystick = joysticks.joystick(sceneGroup,
							GLOBAL_UIPath.."AnalogStickHead.png", 200, 200,
							GLOBAL_UIPath.."AnalogStickBase.png", 280, 280, 1.0 )
		leftJoystick.x = 250
		leftJoystick.y = GLOBAL_ach -250
		leftJoystick.activate()
	end

	-- PAUSE BUTTON ---
	local pButtonMaker = require "HUD.pause_button"
	pauseButton = pButtonMaker.spawn()
	pauseButton.x = -200
	pauseButton.y = -200
	pauseButton.id = 1
	pauseButton.touch = buttonPress
	sceneGroup:insert(pauseButton)
	pauseButton:addEventListener( "touch", pauseButton )


	-- BEGIN GAME
	local voice = audio.loadSound(GLOBAL_soundsPath.."Satan/"..satanVFX[math.random(5)])
	audio.setVolume( 0.5, {channel = 6} )
	audio.play(voice,{channel = 6})
	timer.performWithDelay(2000,
		-- Stays on satan for 2 seconds
		function()
			audio.dispose(voice)
			GLOBAL_gameState = "intro_transition"
			-- Pans over to the player
			hud.initializeHUD()
			hud.updateShotgunOMeter(GLOBAL_shotgun)
			transition.to( 	pauseButton, {time = 1000, x = 100, y = 100,} )
			transition.to( 	map.player.cameraLock,
				{time = 1000,
				x = map.player.bounds.x,
				y = map.player.bounds.y,
				onComplete =
					-- Game begins
					function()
						GLOBAL_gameState = "playing"
						timeOffset = system.getTimer() - GLOBAL_time
					end
				}
			)
		end
	)
end

-- "scene:show()"
function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
	-- Called when the scene is still off screen (but is about to come on screen).
	elseif ( phase == "did" ) then
		composer.removeScene( GLOBAL_scenePath.."menu", false )
		GLOBAL_pause = false
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

	camera.destroy()
	GLOBAL_pause = true
	hud.killHUD()
	audio.stop( 20 )
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
				if map.powerups[i] then
					display.remove(map.powerups.bounds)
					map.powerups[i] = nil
				end
			end
			map.powerups = nil
			for i = 1, #map.slowTraps do
				if map.slowTraps[i] then
					map.slowTraps[i] = nil
				end
			end
			for i = 1, #map.deathTraps do
				if map.deathTraps[i] then
					map.deathTraps[i] = nil
				end
			end

			for i = 1, #map.enemies do
				if map.enemies[i] then
					map.enemies[i].hasTarget = false
					map.enemies[i].cleanup()
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
				if map.gore[i] then
					display.remove(map.gore[i])
					map.gore[i] = nil
				end
			end
			for i = 1, #map.fireballs do
				if map.fireballs[i] then
					map.fireballs[i].cleanup()
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
if GLOBAL_android == false then
	Runtime:addEventListener( "key", onKeyEvent )
	Runtime:addEventListener( "axis", onAxisEvent )
end
---------------------------------------------------------------------------------

return scene
