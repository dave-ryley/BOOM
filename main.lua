local perspective = require("perspective")

local camera = perspective.createView()

local physics = require "physics"
physics.start()
physics.setGravity(0,0)
physics.setDrawMode( "hybrid" )

-- Map the names to identify an axis with a device's physical inputs
local axisMap = {}
axisMap["OUYA Game Controller"] = {}
axisMap["OUYA Game Controller"][1] = "left_x"
axisMap["OUYA Game Controller"][2] = "left_y"
axisMap["OUYA Game Controller"][3] = "left_trigger"
axisMap["OUYA Game Controller"][4] = "right_x"
axisMap["OUYA Game Controller"][5] = "right_y"
axisMap["OUYA Game Controller"][6] = "right_trigger"

-- Create table to map each controller's axis number to a usable name
local axis = {}
axis["Gamepad 1"] = {}
axis["Gamepad 1"]["left_x"] = 1
axis["Gamepad 1"]["left_y"] = 2
axis["Gamepad 1"]["left_trigger"] = 5
axis["Gamepad 1"]["right_x"] = 3
axis["Gamepad 1"]["right_y"] = 4
axis["Gamepad 1"]["right_trigger"] = 6

-- Determines which input is used for the controller
local tempFloor = display.newRect( display.contentCenterX, display.contentCenterY, 5000, 5000 )
tempFloor.myName = "floor"
display.setDefault( "textureWrapX", "repeat" )
display.setDefault( "textureWrapY", "repeat" )
tempFloor.fill = { type="image", filename="Graphics/Temp/dungeonFloor.png" }
tempFloor.fill.scaleX = 0.1
tempFloor.fill.scaleY = 0.1
local player = require "player"
local block = require "collisionTest"
--local blast = require "shotgun"
--blast.name = "blast"



camera:add(player.parent, 1)
camera:add(player.cameraLock, 1)
camera:add(tempFloor, 2)
camera:add(block.collisionBody, 2)
camera:add(player.bodyCollision, 1)
camera:add(player.shotgun.collisionBody, 1)
--camera:add(blast.collisionBody, 1)
camera:prependLayer()
camera.damping = 10
camera:setFocus(player.cameraLock)
camera:track()

-- Setting up display thumbsticks

local thumbsticks = require "visualThumbsticks"

-- These UI elements show the current keypress and axis information

local myKeyDisplayText = display.newText( "", 100, 200, 300, 0, native.systemFont, 20 )
myKeyDisplayText.x = display.contentWidth / 2
myKeyDisplayText.y = 50

local myAxisDisplayText = display.newText( "", 0, 0, 300, 0, native.systemFont, 20 )
myAxisDisplayText.x = display.contentWidth / 2
myAxisDisplayText.y = 100

--Sound Stuff
local stepCount = 0
local Torchidle = audio.loadSound( "/Sounds/Player/Torchidle.ogg" )
local Step1 = audio.loadSound( "Sounds/Player/Step1.ogg" )
local Step2 = audio.loadSound( "Sounds/Player/Step2.ogg" )






-- Since controllers don't generate constant values, but simply events when
-- the values change, we need to set a movement amount when the event happens,
-- and also have the game loop continuously apply it

-- We can also calculate our rotation angle here



local function onAxisEvent( event )

    -- Display some info on the screen about this axis event
    local message = "Axis '" .. event.axis.descriptor .. "' was moved " .. tostring( event.normalizedValue )
    myAxisDisplayText.text = message

    -- Map event data to simple variables
    local abs = math.abs
    local controller = event.device.descriptor
    local thisAxis = event.axis.number

    -- Check which controller this is coming from; you can trust the names
    -- "Joystick 1" and "Joystick 2" to represent player 1, player 2, etc.
    -- Based on the controller for this event, pick the object to manipulate

    -- Now that we know which controller it is, determine which axis to measure
    -- Because the "right trigger" might be 6 on one brand of controller
    -- but 14 on another, we use the mapping system described above

    if ( axis[controller]["left_x"] == thisAxis ) then

        -- This helps handle noisy sticks and sticks that don't settle back to 0 exactly
        -- You can adjust the value based on the sensitivity of the stick
        -- If the stick is moved far enough, then move the player, else force it to
        -- settle back to a zero value

        -- Set the X distance in the player object so the enterFrame function can move it

       if ( abs(event.normalizedValue) > 0.15 ) then
           player.isMovingX = event.normalizedValue * player.velocity
           player.thisDirectionAngle = math.floor( player.calculateAngle(player.isMovingX, player.isMovingY, player.thisDirectionAngle) )
       else
           player.isMovingX = 0
       end

       thumbsticks.leftThumbstickHead.x = event.normalizedValue * 10

    elseif ( axis[controller]["left_y"] == thisAxis ) then

       -- Just like X, now handle the Y axis

       if ( abs(event.normalizedValue) > 0.15 ) then
           player.isMovingY = event.normalizedValue * player.velocity
           player.thisDirectionAngle = math.floor( player.calculateAngle(player.isMovingX, player.isMovingY, player.thisDirectionAngle) )
       else
           player.isMovingY = 0
       end

       thumbsticks.leftThumbstickHead.y = event.normalizedValue * 10

    elseif ( axis[controller]["right_x"] == thisAxis ) then

        -- We will use the right stick to rotate our player
        player.isRotatingX = event.normalizedValue
        print(player.isRotatingX .. player.isRotatingY)
        player.thisAimAngle = math.floor( player.calculateAngle(player.isRotatingX, player.isRotatingY, player.thisAimAngle) )

        -- Move the thumbstick
        thumbsticks.rightThumbstickHead.x = event.normalizedValue * 10

    elseif ( axis[controller]["right_y"] == thisAxis ) then

        -- Repeat for the Y axis on the right stick
        player.isRotatingY = event.normalizedValue
        player.thisAimAngle = math.floor( player.calculateAngle(player.isRotatingX, player.isRotatingY, player.thisAimAngle) )

        -- Move the thumbstick
        thumbsticks.rightThumbstickHead.y = event.normalizedValue * 10

    elseif ( axis[controller]["left_trigger"] or axis[controller]["right_trigger"] == thisAxis ) then

        -- Use the analog triggers to gradually change the color of the player
        -- No trigger pressure will be full brightness
        -- The more you squeeze the trigger, the darker the square gets

        local value = 1 * (1 - event.normalizedValue)
    end

    return true
end

-- Fetch all input devices currently connected to the system
local inputDevices = system.getInputDevices()

-- Traverse all input devices
for deviceIndex = 1, #inputDevices do

    -- Fetch the input device's axes
    print( deviceIndex, "androidDeviceid", inputDevices[deviceIndex].androidDeviceId )
    print( deviceIndex, "canVibrate", inputDevices[deviceIndex].canVibrate )
    print( deviceIndex, "connectionState", inputDevices[deviceIndex].connectionState )
    print( deviceIndex, "descriptor", inputDevices[deviceIndex].descriptor )
    print( deviceIndex, "displayName", inputDevices[deviceIndex].displayName )
    print( deviceIndex, "isConnected", inputDevices[deviceIndex].isConnected )
    print( deviceIndex, "permenantid", tostring(inputDevices[deviceIndex].permanentId) )
    print( deviceIndex, "type", inputDevices[deviceIndex].type )

    -- OUYA may append the controller name to the end of the display name in a future update
    -- Future-proof this by looking at the first few characters and, if necessary, parse it

    local displayName = inputDevices[deviceIndex].displayName

    if ( string.sub(displayName,1,14) == "XInput Gamepad" ) then
        displayName = string.sub( displayName,1,14 )
    end
    local descriptor = inputDevices[deviceIndex].descriptor
    local inputAxes = inputDevices[deviceIndex]:getAxes()

    -- Only look for gamepads at the moment and map the controllers
    if ( inputDevices[deviceIndex].type == "gamepad" ) then
        print( "We have a gamepad; let's find some analog inputs!" )
        if ( #inputAxes > 0 ) then
            local controller = 0

            for axisIndex = 1, #inputAxes do
                if ( axisMap[displayName] and axisMap[displayName][axisIndex] ) then
                    axis[descriptor][axisMap[displayName][axisIndex]] = axisIndex
                    print( "mapped axis[" .. axisMap[displayName][axisIndex] .. "] to ", axisIndex )
                end
            end
        else
            -- Device does not have any axes!
            print( inputDevices[deviceIndex].descriptor .. ": No axes found." )
        end

    else
        print( "Not a gamepad" )
    end
end

-- Keys were handled in a previous blog post, but let's handle them to
-- demonstrate how some axis values map to key events

local function onKeyEvent( event )
   local phase = event.phase
   local keyName = event.keyName
   local message = "Key '" .. event.keyName .. "' was pressed " .. event.phase
   myKeyDisplayText.text = message

    if (event.phase == "down") then

        -- Adjust velocity for testing, remove for final game        
        if ( event.keyName == "[" or event.keyName == "rightShoulderButton1" ) then
            if (player.velocity > 0 ) then
                player.velocity = player.velocity - 1
            end
        elseif ( event.keyName == "]" or event.keyName == "leftShoulderButton1" ) then
            player.velocity = player.velocity + 1
            print("] was pressed")
        end
        -- WASD and ArrowKeys pressed down
        if ( event.keyName == "w" ) then
            player.isMovingY = -1 * player.velocity
            player.thisDirectionAngle = math.floor( player.calculateAngle(player.isMovingX, player.isMovingY, player.thisDirectionAngle) )
        elseif ( event.keyName == "s") then
            player.isMovingY = 1 * player.velocity
            player.thisDirectionAngle = math.floor( player.calculateAngle(player.isMovingX, player.isMovingY, player.thisDirectionAngle) )
        elseif ( event.keyName == "a") then
            player.isMovingX = -1 * player.velocity
            player.thisDirectionAngle = math.floor( player.calculateAngle(player.isMovingX, player.isMovingY, player.thisDirectionAngle) )
        elseif ( event.keyName == "d") then
            player.isMovingX = 1 * player.velocity
            player.thisDirectionAngle = math.floor( player.calculateAngle(player.isMovingX, player.isMovingY, player.thisDirectionAngle) )
        elseif ( event.keyName == "up") then
            player.isRotatingY = -1
            player.thisAimAngle = math.floor( player.calculateAngle(player.isRotatingX, player.isRotatingY, player.thisAimAngle) )
        elseif ( event.keyName == "down") then
            player.isRotatingY = 1
            player.thisAimAngle = math.floor( player.calculateAngle(player.isRotatingX, player.isRotatingY, player.thisAimAngle) )
        elseif ( event.keyName == "left") then
            player.isRotatingX = -1
            player.thisAimAngle = math.floor( player.calculateAngle(player.isRotatingX, player.isRotatingY, player.thisAimAngle) )
        elseif ( event.keyName == "right") then
            player.isRotatingX = 1
            player.thisAimAngle = math.floor( player.calculateAngle(player.isRotatingX, player.isRotatingY, player.thisAimAngle) )
        elseif ( event.keyName == "space") then
            
            --code for shooting
        end
    else
        -- WASD and Arrow keys pressed up
        if ( event.keyName == "w" and player.isMovingY < 0) then
            player.isMovingY = 0
            player.thisDirectionAngle = math.floor( player.calculateAngle(player.isMovingX, player.isMovingY, player.thisDirectionAngle) )
        elseif ( event.keyName == "s" and player.isMovingY > 0 ) then
            player.isMovingY = 0
            player.thisDirectionAngle = math.floor( player.calculateAngle(player.isMovingX, player.isMovingY, player.thisDirectionAngle) )
        elseif ( event.keyName == "a" and player.isMovingX < 0 ) then
            player.isMovingX = 0
            player.thisDirectionAngle = math.floor( player.calculateAngle(player.isMovingX, player.isMovingY, player.thisDirectionAngle) )
        elseif ( event.keyName == "d" and player.isMovingX > 0 ) then
            player.isMovingX = 0
            player.thisDirectionAngle = math.floor( player.calculateAngle(player.isMovingX, player.isMovingY, player.thisDirectionAngle) )
        elseif ( event.keyName == "up" and player.isRotatingY < 0 ) then
            player.isRotatingY = 0
            player.thisAimAngle = math.floor( player.calculateAngle(player.isRotatingX, player.isRotatingY, player.thisAimAngle) )
        elseif ( event.keyName == "down" and player.isRotatingY > 0 ) then
            player.isRotatingY = 0
            player.thisAimAngle = math.floor( player.calculateAngle(player.isRotatingX, player.isRotatingY, player.thisAimAngle) )
        elseif ( event.keyName == "left" and player.isRotatingX < 0 ) then
            player.isRotatingX = 0
            player.thisAimAngle = math.floor( player.calculateAngle(player.isRotatingX, player.isRotatingY, player.thisAimAngle) )
        elseif ( event.keyName == "right" and player.isRotatingX > 0 ) then
            player.isRotatingX = 0
            player.thisAimAngle = math.floor( player.calculateAngle(player.isRotatingX, player.isRotatingY, player.thisAimAngle) )
        end
    end

   return false
end

local function onInputDeviceStatusChanged( event )

    -- Handle the input device change
    if ( event.connectionStateChanged ) then
        print( event.device.displayName .. ": " .. event.device.connectionState, event.device.descriptor, event.device.type, event.device.canVibrate )
    end
end



Runtime:addEventListener( "inputDeviceStatus", onInputDeviceStatusChanged )

Runtime:addEventListener( "key", onKeyEvent )

Runtime:addEventListener( "axis", onAxisEvent )

