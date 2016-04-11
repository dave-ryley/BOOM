   local col = require "collisionFilters"
   local composer = require( "composer" )
   local globals = require "globals"
   local scene = composer.newScene()


   local joysticks = require "joystick"
   local spot = require("spot")


   local perspective = require("perspective")

   local camera = perspective.createView()

   local levelName = "level.BOOMMAP"

   local imps = display.newGroup()
   local spots = display.newGroup()
   local minotaurs = display.newGroup()

   local level = display.newGroup( )
   local map = {}


  local physics = require "physics"
  physics.start()
  physics.setGravity(0,0)
  physics.setDrawMode( "hybrid" )


   -----Map-----
   local path = system.pathForFile(levelName,system.ResourceDirectory)
   local file = io.open(path,"r")
   i = 1

   function explode(div,str)
    if (div=='') then return false end
    local pos,arr = 0,{}
    for st,sp in function() return string.find(str,div,pos,true) end do
        table.insert(arr,string.sub(str,pos,st-1))
        pos = sp + 1
    end
    table.insert(arr,string.sub(str,pos))
    return arr
   end

   for line in file:lines()do
   map[i] = explode(",",line)
   i = i + 1
   end
   io.close(file)

  size = 5
  for i=2,table.getn(map),1 do
    if(tonumber(map[i][3])==10)then
      lineWall = display.newLine(level,tonumber(map[i-1][1])*size,tonumber(map[i-1][2])*size,tonumber(map[i][1])*size,tonumber(map[i][2])*size )
      lineWall.strokeWidth = 20
      corners = display.newCircle(level,tonumber(map[i-1][1])*size,tonumber(map[i-1][2])*size,10)
      corners:setFillColor(1,1,1,1)

      physics.addBody( lineWall, "static", {chain= tonumber(map[i][1])*size,tonumber(map[i][2])*size} )
      physics.addBody( corners, "static",{friction = 0,bounce = 0.3} )
    elseif(tonumber(map[i][3])==1)then--imp
      imp = display.newRect(imps,tonumber(map[i-1][1]*size), tonumber(map[i-1][2])*size, 10*size, 10*size )
      imp:setFillColor(0,0,1,1)
    elseif(tonumber(map[i][3])==2)then--spot
      spot = display.newRect(spots,tonumber(map[i-1][1]*size), tonumber(map[i-1][2])*size, 10*size, 10*size )
      spot:setFillColor(0,1,0,1)
    elseif(tonumber(map[i][3])==3)then--rosy
      minotaur = display.newRect(minotaurs,tonumber(map[i-1][1]*size), tonumber(map[i-1][2])*size, 10*size, 10*size )
      minotaur:setFillColor(0,1,1,1)
    end
  end



   ------TEMPORARY! TO BE DELETED!-----------
   local tempfloor = display.newRect( display.contentCenterX, display.contentCenterY, 5000, 5000 )
   tempfloor.myName = "floor"
   display.setDefault( "textureWrapX", "repeat" )
   display.setDefault( "textureWrapY", "repeat" )
   tempfloor.fill = { type="image", filename="Graphics/Temp/dungeonFloor.png" }
   tempfloor.fill.scaleX = 0.1
   tempfloor.fill.scaleY = 0.1
   -------------------------------------------
   controllerMapping = require "controllerMapping"
   player = require "playerMechanics"
   fireTrap = require ("Traps.fireTrap")
   slowTrap = require("Traps.slowTrap")
   --traps = {}
   --traps[0] = fireTrap.spawn(0)
   --traps[0].bounds:translate( 1000, 500)
   --traps[1] = slowTrap.spawn(1)
   --[[
   spot = require "spot"
   
   enemies[1] = spotpies.spawn(1)
  enemies[2] = spotpies.spawn(2)
   enemies[1].bounds:translate(800, 800)
  enemies[2].bounds:translate(500, 500)
     camera:add(enemies[1].parent, 1)
   camera:add(enemies[2].parent, 1)
  ]]
  --local win = require "win"
  local imptest = require "imp"
  local sausage = require "sausage"
  --local wintile = win.spawn(1)
  player.parent:translate(500, 500)
  enemies = {}
  enemies[1] = imptest.spawn(1, 0, 0)
  --enemies[1].parent:translate( 1000, -500 )
  --enemies[1].parent:translate(500, 500)
   -- SETTING UP OBJECTS IN THE CAMERA
   camera:add(player.parent, 1)
   camera:add(player.cameraLock, 1)
   camera:add(player.shotgun.blast, 1)
   camera:add(player.shotgun.bounds, 1)
   camera:add(tempfloor, 3)
   camera:add(player.bounds, 1)
   camera:add(enemies[1].parent, 2)
   --camera:add(wintile.bounds, 2)
   --camera:add(traps[0].bounds, 2)
   --camera:add(traps[1].bounds, 2)

   camera:add(level, 2)
   camera:add(imps, 2)
   camera:add(spots, 2)
   camera:add(minotaurs, 2)

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
function scene:create( event )
 
   local sceneGroup = self.view
   sceneGroup:insert(camera)
   function buttonPress( self, event )
      if event.phase == "began" then
         audio.play(press, {channel = 31})
         if self.id == 1 then
            globals.pause = true
            composer.showOverlay("pauseMenu")
         end
         return true
      end
   end
   if(globals.android) then
      rightJoystick = joysticks.joystick(sceneGroup, "Graphics/Animation/analogStickHead.png", 200, 200, "Graphics/Animation/analogStickBase.png", 280, 280)
      rightJoystick.x = display.actualContentWidth -250
      rightJoystick.y = display.actualContentHeight -250
      rightJoystick.activate()
      leftJoystick = joysticks.joystick(sceneGroup, "Graphics/Animation/analogStickHead.png", 200, 200, "Graphics/Animation/analogStickBase.png", 280, 280)
      leftJoystick.x = 250
      leftJoystick.y = display.actualContentHeight -250
      leftJoystick.activate()
   end
   --[[buttons = {}
   for i=1,1 do 
      buttons[i] = display.newRect(display.contentCenterX,display.contentCenterY+(i-1)*200,500,150)
      sceneGroup:insert(buttons[i])
      buttons[i]:setFillColor( 1, 0, 0 )
      buttons[i].id = i
      buttons[i].touch = buttonPress
      buttons[i]:addEventListener( "touch", buttons[i] )
   end]]
   pauseButton = display.newCircle(0,0,200)
   sceneGroup:insert(pauseButton)
   pauseButton.id = 1
   pauseButton.touch = buttonPress
   pauseButton:addEventListener( "touch", pauseButton )
   local press = audio.loadSound( "Sounds/GUI/ButtonPress.ogg")
   -- Initialize the scene here.
   -- Example: add display objects to "sceneGroup", add touch listeners, etc.
   end

   -- "scene:show()"
   function scene:show( event )

   local sceneGroup = self.view
   local phase = event.phase

   if ( phase == "will" ) then
      -- Called when the scene is still off screen (but is about to come on screen).
   elseif ( phase == "did" ) then
      composer.removeScene( "menu", false )
      globals.pause = false
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
      --if globals.pause then print("globals.pause = true") else print("globals.pause = false") end
      if(globals.pause == false) then
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

   if (globals.pause == false) then 
      player.playerAxis(axis, value) 
   end

   return false
   end


local function gameLoop( event )
   if globals.pause == false and axis ~= "" then
      if(globals.android) then
         player.virtualJoystickInput(leftJoystick.angle, leftJoystick.xLoc/70, leftJoystick.yLoc/70, rightJoystick.angle, rightJoystick.distance/70, rightJoystick.xLoc/70, rightJoystick.yLoc/70)
      end
      player.movePlayer()

      for k,v in pairs(enemies) do
        if(v.bounds.health <= 0 ) then
            print("killing: "..v.bounds.myName)
            local gore = v.splat(player.getAimAngle(), v.getX(), v.getY())
            v.bounds.die()
            camera:add(gore, 1)
            v.bounds.parent:removeSelf( )
            table.remove( enemies, k )
            end
            --v.bounds.updatePlayerLocation(player.bounds.x, player.bounds.y)
          end
       end
   return true
   end

   ---------------------------------------------------------------------------------

   -- Listener setup
   scene:addEventListener( "create", scene )
   scene:addEventListener( "show", scene )
   scene:addEventListener( "hide", scene )
   scene:addEventListener( "destroy", scene )
   Runtime:addEventListener( "key", onKeyEvent )
   Runtime:addEventListener( "axis", onAxisEvent )
   Runtime:addEventListener( "enterFrame", gameLoop )
   ---------------------------------------------------------------------------------

return scene