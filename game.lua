local composer = require( "composer" )
local globals = require "globals"
local scene = composer.newScene()

local perspective = require("perspective")

local camera = perspective.createView()

local physics = require "physics"
physics.start()
physics.setGravity(0,0)
physics.setDrawMode( "normal" )

------TEMPORARY! TO BE DELETED!-----------
local tempFloor = display.newRect( display.contentCenterX, display.contentCenterY, 5000, 5000 )
tempFloor.myName = "floor"
display.setDefault( "textureWrapX", "repeat" )
display.setDefault( "textureWrapY", "repeat" )
tempFloor.fill = { type="image", filename="Graphics/Temp/dungeonFloor.png" }
tempFloor.fill.scaleX = 0.1
tempFloor.fill.scaleY = 0.1
-------------------------------------------
controllerMapping = require "controllerMapping"
player = require "playerMechanics"

-- SETTING UP OBJECTS IN THE CAMERA
camera:add(player.parent, 1)
camera:add(player.cameraLock, 1)
camera:add(player.shotgun.bounds, 1)
camera:add(tempFloor, 2)
camera:add(player.bounds, 1)

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
 
---------------------------------------------------------------------------------
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
   print(event.device.descriptor .. " + " .. event.axis.number)
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

   print (event.keyName)

   if (event.phase == "down") then

        -- Adjust velocity for testing, remove for final game        
        if ( event.keyName == "[" or event.keyName == "rightShoulderButton1" ) then
            if (player.velocity > 0 ) then
                player.velocity = player.velocity - 1
            end
        elseif ( event.keyName == "]" or event.keyName == "leftShoulderButton1" ) then
            player.velocity = player.velocity + 1
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
   -- Map event data to simple variables
   if globals.pause == false and axis ~= "" then
      player.movePlayer()
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