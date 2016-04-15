local col = require "collisionFilters"
local composer = require( "composer" )
local g = require "globals"
local scene = composer.newScene()
local joysticks = require "joystick"
local spot = require("spot")
local perspective = require("perspective")
local camera = perspective.createView()
local levelName = "level.BOOMMAP"
local enemy = require "enemy"
local imp = require "imp"
local move = require "movementFunctions"
local imps = display.newGroup()
local spots = display.newGroup()
local minotaurs = display.newGroup()
local level = display.newGroup( )
local map = {}
local enemies = {group = display.newGroup()}
local physics = require "physics"
physics.start()
physics.setGravity(0,0)
physics.setDrawMode( "normal" )

-----Map-----
local size = 5
local function getVertices(type,rotation)
	if(type <= 1)then
		vertices = {0*size,0*size,0*size,128*size,128*size,128*size,128*size,0*size}
		if(rotation == 1)then

		elseif(rotation == 2)then

		elseif(rotation == 3)then

		else

		end
	elseif(type == 2)then
		if(rotation == 1)then
			vertices = {64*size,64*size,0*size,128*size,128*size,128*size,128*size,0}
		elseif(rotation == 2)then
			vertices = {0*size,0*size,0*size,128*size,128*size,128*size,64*size,64*size}
		elseif(rotation == 3)then
			vertices = {0*size,0*size,0*size,128*size,64*size,64*size,128*size,0*size}
		else
			vertices = {0*size,0*size,64*size,64*size,128*size,128*size,128*size,0}
		end
	elseif(type == 3)then

	end
	return vertices
end

local floor = display.newRect(g.ccx, g.ccy,500000,500000)
display.setDefault( "textureWrapX", "repeat" )
display.setDefault( "textureWrapY", "repeat" )
floor.fill = {type = "image",filename ="/Graphics/Background/FloorTile.png"}
floor.fill.scaleX = 0.001
floor.fill.scaleY = 0.001

local path = system.pathForFile(levelName,system.ResourceDirectory)
local file = io.open(path,"r")
function explode(div,str)
	if (div=='') then 
		return false 
	end
	local pos,arr = 0,{}
	for st,sp in function() return string.find(str,div,pos,true) end do
		table.insert(arr,string.sub(str,pos,st-1))
		pos = sp + 1
	end
	table.insert(arr,string.sub(str,pos))
	return arr
end
local counter = 1
for line in file:lines()do
	map[counter] = explode(",",line)
	counter = counter + 1
	--print (counter)
end
io.close(file)

local physlevel = {}
for mapCounter=1,table.getn(map),1 do
	if (tonumber(map[mapCounter][1]) <11 and tonumber(map[mapCounter][1]) >0) then
		physlevel[mapCounter] = display.newPolygon( level, 
													tonumber((map[mapCounter][3])-448)*size,
													tonumber((map[mapCounter][4])-448)*size, 
													getVertices(tonumber(map[mapCounter][1]),
													tonumber(map[mapCounter][2])))
		--physlevel[mapCounter]:setFillColor(0.5,0,0,1)
		physlevel[mapCounter].fill = { 	type="image", 
										filename="/Graphics/Background/LavaTile1.png" }
		physics.addBody( 	physlevel[mapCounter], 
							"static", 
							{
								friction = 0, 
								bounce = 0.3, 
								filter=col.wallCol
							}
						)
		physlevel[mapCounter].myName = "Wall"
		physlevel[mapCounter].super = physlevel[mapCounter]
	elseif(tonumber(map[mapCounter][1]) <21)then
		local enemyType = tonumber(map[mapCounter][1])
		local location = 	{
								tonumber((map[mapCounter][3])-448)*size,
								tonumber((map[mapCounter][4])-448)*size
							}
		if(enemyType == 11)then
			enemies.group:insert(imp.spawn(location[1],location[2]).parent)
		elseif(enemyType == 12)then
			--spawn dog
		elseif(enemyType == 13)then
			--spawn rosy
		end
	elseif(tonumber(map[mapCounter][1]) <31)then
		--spawn items/deco
	elseif(tonumber(map[mapCounter][1]) <41)then
		--satans trailpath
	end
end

zerozero = display.newRect( level, 0, 0, 100, 100 )
zerozero:setFillColor( 0,0,1 )

local controllerMapping = require "controllerMapping"
local player = require "playerMechanics"
local slowtrap = require "Traps.slowtrap"
--local s1 = slowtrap.spawn(500, 0)
--local imp = require "imp"
local sausage = require "sausage"
--local wintile = win.spawn(1)
local satan = require "satan"
--local satan1 = satan.spawn()
player.bounds:translate(0,0)

--enemies.group:insert(imp.spawn(-1500, 500).parent)
--enemies.group:insert(imp.spawn(1000, 1000).parent)
--player.bounds:translate(-2000, 500)


local spot = require "spot"
local puppy = spot.spawn(300, 0)


-- (1) move square to bottom right corner; subtract half side-length
print ("player x: " .. player.bounds.x .. ", player y: " .. player.bounds.y )
camera:add(puppy.parent, 2)
--camera:add(satan1.bounds, 2)
--print(satan1.path[1].x)
--transition.to( satan1.bounds, satan1.path[1] )
--camera:add(s1.bounds, 3)
camera:add(player.parent, 1)
camera:add(player.cameraLock, 1)
camera:add(player.shotgun.blast, 1)
camera:add(player.shotgun.bounds, 1)
camera:add(player.bounds, 1)
camera:add(level, 3)
camera:add(floor,5)
camera:add(player.torchLight, 5)
camera:add(imps, 2)
camera:add(spots, 2)
camera:add(minotaurs, 2)
camera:add(enemies.group, 2)

-- INITIALIZING CAMERA
camera:prependLayer()
camera.damping = 10
camera:setFocus(player.cameraLock)
camera:track()

---------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE
-- unless "composer.removeScene()" is called.
---------------------------------------------------------------------------------

-- local forward references should go here
-- "scene:create()"
local sceneGroup
function scene:create( event )
	sceneGroup = self.view
	sceneGroup:insert(camera)
	
	local bgOptions =
	{
		channel = 20,
		loops = -1,
		fadein = 1000,
	}
	audio.setVolume( 0.2, { channel=20 } )
	local bgMusic = audio.loadStream( "Sounds/Music/HeadShredder.mp3")
	audio.play(bgMusic,bgOptions)
	
	function buttonPress( self, event )
		if event.phase == "began" then
			audio.play(press, {channel = 31})
			if self.id == 1 then
				g.pause = true
				composer.showOverlay(g.scenePath.."pauseMenu")
			end
			return true
		end
	end
	if(g.android) then
		rightJoystick = joysticks.joystick(sceneGroup, 
							"Graphics/Animation/analogStickHead.png", 200, 200, 
							"Graphics/Animation/analogStickBase.png", 280, 280, 2.5 )
		rightJoystick.x = g.acw -250
		rightJoystick.y = g.ach -250
		rightJoystick.activate()
		leftJoystick = joysticks.joystick(sceneGroup, 
							"Graphics/Animation/analogStickHead.png", 200, 200, 
							"Graphics/Animation/analogStickBase.png", 280, 280, 1.0 )
		leftJoystick.x = 250
		leftJoystick.y = g.ach -250
		leftJoystick.activate()
	end
	local pauseButton = display.newCircle(0,0,200)
	sceneGroup:insert(pauseButton)
	pauseButton.id = 1
	pauseButton.touch = buttonPress
	pauseButton:addEventListener( "touch", pauseButton )
	local press = audio.loadSound( "Sounds/GUI/ButtonPress.ogg")
	-- Initialize the scene here.
	-- Example: add display objects to "sceneGroup", add touch listeners, etc.
end

function updateGUI()
	sceneGroup:insert(player.shotgun.displayPower())
end
-- "scene:show()"
function scene:show( event )

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

-- Called prior to the removal of scene's view ("sceneGroup").
-- Insert code here to clean up the scene.
-- Example: remove display objects, save state, etc.
end
---------------------------------------------------------------------------------

local function onAxisEvent( event )
	-- Map event data to simple variables
	if string.sub( event.device.descriptor, 1 , 7 ) == "Gamepad" then
		local axis = controllerMapping.axis[event.axis.number]
		--if g.pause then print("g.pause = true") else print("g.pause = false") end
		if(g.pause == false) then
			player.playerAxis(axis, event.normalizedValue)
		end
	end
	return true
end

local function onKeyEvent( event )
	local phase = event.phase
	local keyName = event.keyName
	local axis = ""
	local value = 0

	if (event.phase == "down") then
		-- Adjust velocity for testing, remove for final game        
		if ( event.keyName == "[" or event.keyName == "rightShoulderButton1" ) then
			if (player.velocity > 0 ) then
			--player.velocity = player.velocity - 1
				player.shotgun.powerUp(-1)
			end
		elseif ( event.keyName == "]" or event.keyName == "leftShoulderButton1" ) then
			--player.velocity = player.velocity + 1
			player.shotgun.powerUp(1)
		end
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
		elseif ( event.keyName == "space") then
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
		end
	end

	if (g.pause == false) then 
		player.playerAxis(axis, value) 
	end

	return false
end

local function makeGore( event )
	timer.performWithDelay( 10, 
		function ()
			local g = event.splat(player.thisAimAngle, event.bounds.x, event.bounds.y)
			camera:add(g, 4)
		end
	)
end
Runtime:addEventListener( "makeGore", makeGore)

local function getPlayerLocation( event )
	return event.updatePlayerLocation(player.bounds.x, player.bounds.y)
end
Runtime:addEventListener( "getPlayerLocation", getPlayerLocation)

local function gameLoop( event )
	local shotgunOMeter = player.shotgun.displayPower()
	updateGUI()
	if g.pause == false and axis ~= "" then
		if(g.android) then
			player.virtualJoystickInput(leftJoystick.angle, leftJoystick.xLoc/70, leftJoystick.yLoc/70, rightJoystick.angle, rightJoystick.distance/70, rightJoystick.xLoc/70, rightJoystick.yLoc/70)
		end
		player.movePlayer()
--[[
		for k,v in pairs(enemies) do
			if(v.health <= 0 ) then
				print("killing: "..v.bounds.myName)
				local gore = v.splat(player.getAimAngle(), v.getX(), v.getY())
				camera:add(gore, 2)
				v.parent:removeSelf( )
				table.remove( enemies, k )
			end
		end
	]]		--v.updatePlayerLocation(player.getX(), player.getY())
	end
	return true
end
---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
if(g.android == false) then 
  Runtime:addEventListener( "key", onKeyEvent )
  Runtime:addEventListener( "axis", onAxisEvent )
end
Runtime:addEventListener( "enterFrame", gameLoop )
---------------------------------------------------------------------------------

return scene