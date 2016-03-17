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

local player = display.newImage( "TestFace.png" )
player:setFillColor( 1, 0, 0 )
player.x = display.contentCenterX
player.y = display.contentCenterY
player.isMovingX = 0
player.isMovingY = 0
player.isRotatingX = 0
player.isRotatingY = 0
player.thisAngle = 0
player.rotationDistance = 0
player.isGrowing = 0
player.color = "red"
player.velocity = 10


-- Setting up display thumbsticks

local rightThumbstick = display.newGroup()

local rightThumbstickHead = display.newCircle( 0, 0, 14 )
rightThumbstickHead:setFillColor( 1 )
rightThumbstickHead.alpha = 0.5

local rightThumbstickBase = display.newCircle( 0, 0, 20 )
rightThumbstickBase:setFillColor( 1 )
rightThumbstickBase.alpha = 0.5

rightThumbstick:insert( rightThumbstickBase )
rightThumbstick:insert( rightThumbstickHead )

local leftThumbstick = display.newGroup()

local leftThumbstickHead = display.newCircle( 0, 0, 14 )
leftThumbstickHead:setFillColor( 1 )
leftThumbstickHead.alpha = 0.5

local leftThumbstickBase = display.newCircle( 0, 0, 20 )
leftThumbstickBase:setFillColor( 1 )
leftThumbstickBase.alpha = 0.5

leftThumbstick:insert( leftThumbstickBase )
leftThumbstick:insert( leftThumbstickHead )


rightThumbstick.x = display.contentWidth/2 + 50
rightThumbstick.y = display.contentHeight - 200
leftThumbstick.x = display.contentWidth/2 - 50
leftThumbstick.y = display.contentHeight - 200



-- Calculate the angle to rotate the square. Using simple right angle math, we can
-- determine the base and height of a right triangle where one point is 0,0
-- (stick center) and the values returned from the two axis numbers returned
-- from the stick

-- This will give us a 0-90 value, so we have to map it to the quadrant
-- based on if the values for the two axis are positive or negative
-- Negative Y, positive X is top-right area
-- Positive X, Positive Y is bottom-right area
-- Negative X, positive Y is bottom-left area
-- Negative x, negative y is top-left area

-- These UI elements show the current keypress and axis information


local myKeyDisplayText = display.newText( "", 100, 200, 300, 0, native.systemFont, 20 )
myKeyDisplayText.x = display.contentWidth / 2
myKeyDisplayText.y = 50

local myAxisDisplayText = display.newText( "", 0, 0, 300, 0, native.systemFont, 20 )
myAxisDisplayText.x = display.contentWidth / 2
myAxisDisplayText.y = 100

local function calculateAngle( sideX, sideY )

    local angle
    if ( math.abs( sideX ) < 0.1 and math.abs( sideY ) < 0.1 ) then
        angle = player.thisAngle
    elseif ( sideX == 0 ) then
        if ( sideY < 0 ) then
            angle = 0
        else
            angle = 180
        end
    elseif ( sideY == 0 ) then
        if ( sideX < 0 ) then
            angle = 270
        else
            angle = 90
        end
    else
        local tanX = math.abs( sideY ) / math.abs( sideX )
        local atanX = math.atan( tanX )  -- Result in radians
        angle = atanX * 180 / math.pi  -- Converted to degrees

        if ( sideY < 0 ) then
            angle = angle * -1
        end

        if ( sideX < 0 and sideY < 0 ) then
            angle = 270 + math.abs( angle )
        elseif ( sideX < 0 and sideY > 0 ) then
            angle = 270 - math.abs( angle )
        elseif ( sideX > 0 and sideY > 0 ) then
            angle = 90 + math.abs( angle )
        else
            angle = 90 - math.abs( angle )
        end
    end
    return angle
end

-- Since controllers don't generate constant values, but simply events when
-- the values change, we need to set a movement amount when the event happens,
-- and also have the game loop continuously apply it

-- We can also calculate our rotation angle here

local function moveplayer()

    -- Set the .isMovingX and .isMovingY values in our event handler
    -- If this number isn't 0 (stopped moving), move the player
    if ( player.isMovingX ~= 0 ) then
        player.x = player.x + player.isMovingX
    end
    if ( player.isMovingY ~= 0 ) then
        player.y = player.y + player.isMovingY
    end

    player.rotation = player.thisAngle
end

local function onAxisEvent( event )

    -- Display some info on the screen about this axis event
    local message = "Axis '" .. event.axis.descriptor .. "' was moved " .. tostring( event.normalizedValue )
    myAxisDisplayText.text = message

    -- Map event data to simple variables
    local abs = math.abs
    local controller = event.device.descriptor
    local thisAxis = event.axis.number
    local thisPlayer = player

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
           thisPlayer.isMovingX = event.normalizedValue * thisPlayer.velocity
       else
           thisPlayer.isMovingX = 0
       end

       leftThumbstickHead.x = event.normalizedValue * 10

    elseif ( axis[controller]["left_y"] == thisAxis ) then

       -- Just like X, now handle the Y axis

       if ( abs(event.normalizedValue) > 0.15 ) then
           thisPlayer.isMovingY = event.normalizedValue * thisPlayer.velocity
       else
           thisPlayer.isMovingY = 0
       end

       leftThumbstickHead.y = event.normalizedValue * 10

    elseif ( axis[controller]["right_x"] == thisAxis ) then

        -- We will use the right stick to rotate our player
        thisPlayer.isRotatingX = event.normalizedValue
        thisPlayer.thisAngle = math.floor( calculateAngle(thisPlayer.isRotatingX, thisPlayer.isRotatingY) )

        -- Draw the blue dot around the center to show how far you actually moved the stick
       rightThumbstickHead.x = event.normalizedValue * 10

    elseif ( axis[controller]["right_y"] == thisAxis ) then

        -- Repeat for the Y axis on the right stick
        thisPlayer.isRotatingY = event.normalizedValue
        thisPlayer.thisAngle = math.floor( calculateAngle(thisPlayer.isRotatingX, thisPlayer.isRotatingY) )

        -- Move the blue dot
       rightThumbstickHead.y = event.normalizedValue * 10

    elseif ( axis[controller]["left_trigger"] or axis[controller]["right_trigger"] == thisAxis ) then

        -- Use the analog triggers to gradually change the color of the player
        -- No trigger pressure will be full brightness
        -- The more you squeeze the trigger, the darker the square gets

        local color = 1 * (1 - event.normalizedValue)
        if ( color < 0.125 ) then
            color = 0.125
        elseif ( color >= 1 ) then
            color = 1
        end

        thisPlayer:setFillColor( 0, color, 0 )
    end

    return true
end

-- Fetch all input devices currently connected to the system
local inputDevices = system.getInputDevices()

-- Traverse all input devices
for deviceIndex = 1, #inputDevices do

    -- Fetch the input device's axes
    print( deviceIndex, "andoridDeviceid", inputDevices[deviceIndex].androidDeviceId )
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
        if ( event.keyName == "[" or event.keyName == "rightShoulderButton1" ) then
            if (player.velocity > 0 ) then
                player.velocity = player.velocity - 1
            end
        elseif ( event.keyName == "]" or event.keyName == "leftShoulderButton1" ) then
            player.velocity = player.velocity + 1
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

Runtime:addEventListener( "enterFrame", moveplayer )