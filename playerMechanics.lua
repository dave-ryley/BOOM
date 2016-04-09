local P = {}

    P.visuals = require "playerVisuals"
    P.movementFunctions = require "movementFunctions"
    P.myName = "player"
    P.shotgun = require("shotgun")
    P.parent = display.newGroup()
    P.parent.x = display.contentCenterX
    P.parent.y = display.contentCenterY
    P.canShoot = true
    P.isMovingX = 0
    P.isMovingY = 0
    P.isRotatingX = 0
    P.isRotatingY = 0
    P.thisAimAngle = 0
    P.thisDirectionAngle = 0
    P.velocity = 20
    P.isAlive = true
    P.shotgunPower = 50
    P.lookDirection = display.newGroup()
    P.parent:insert ( P.lookDirection )
    P.parent:insert( P.visuals.lowerBody )
    P.parent:insert( P.visuals.upperBody )

    -- Collision object setup
    P.bounds = display.newRect(0,0,150,170)
    P.bounds.alpha = 0.0
    P.bounds.myName = "P"
    physics.addBody( P.bounds, "dynamic", {density=0.5, friction=1.0, bounce=0.0})
    P.bounds.isFixedRotation=true
    P.bounds.x = display.contentCenterX
    P.bounds.y = display.contentCenterY + 20

    -- Camera lock object setup
    P.cameraLock = display.newRect(0,-200,50,50)
    P.cameraLock.alpha = 0.50
    P.cameraLock.x = P.parent.x
    P.cameraLock.y = P.parent.y
    
    local sounds = function( event )
        currentFrame = P.visuals.lowerBodyRun_sprite.frame
        --print("frame: ",currentFrame)
        if(P.isMovingX ~= 0 or P.isMovingY ~=0) then
            if(currentFrame == 3)then
                audio.play( P.visuals.sounds.step1, { channel = 1, loops=0})
            elseif(currentFrame == 7)then
                audio.play( P.visuals.sounds.step2, { channel = 3, loops=0})
            end
        end
    end
    Runtime:addEventListener( "enterFrame", sounds )

    local update = function( event )
        --if(P.bounds.velocity > 0) then

        --end
    end
    Runtime:addEventListener( "enterFrame", update )
    
    local function movePlayer()

        -- Set the .isMovingX and .isMovingY values in our event handler
        -- If this number isn't 0 (stopped moving), move the 

        if ( P.isMovingX ~= 0 ) then
            P.bounds.x = P.bounds.x + P.isMovingX
            P.parent.x = P.bounds.x
        end

        if ( P.isMovingY ~= 0 ) then
            P.bounds.y = P.bounds.y + P.isMovingY
            P.parent.y = P.bounds.y - 20
            P.cameraLock.y = P.parent.y + P.isMovingY*10
        end

        P.cameraLock.x = P.parent.x + P.isRotatingX*250
        P.cameraLock.y = P.parent.y + P.isRotatingY*250
        P.visuals.animate(P.thisAimAngle, P.thisDirectionAngle, math.abs(P.isMovingX) + math.abs(P.isMovingY), P.velocity)
    end

    P.movePlayer = movePlayer

    --Test shotgun
    local function shootDelay( event )
        P.canShoot = true;
        P.shotgun.bounds.isAwake = false
        print("can shoot: " ..  tostring(P.canShoot))
    end

    local shoot = function( event )
        if (event.phase == "down" and event.keyName == "space" and P.canShoot == true) then
            P.shotgun.bounds.alpha = 1
            P.shotgun.bounds.isAwake = true
            P.shotgun.bounds.x = P.bounds.x
            P.shotgun.bounds.y = P.bounds.y
            P.shotgun.bounds.rotation = P.thisAimAngle
            print(P.thisAimAngle)
            --print(Shot: " ..P.shotgun.bounds.x .. " : " .. P.shotgun.bounds.y)
            P.canShoot = false
            --P.bounds:applyLinearImpulse(50, 0, 0, 0)
            audio.play(P.boomStick,{channel = 3})
            timer.performWithDelay( 1800, shootDelay )

            print("can shoot: " .. tostring(P.canShoot))
        end
    end
    Runtime:addEventListener( "key" , shoot)

    ----- Started adding in functions

    local function playerAxis( axis, value )
        -- Map event data to simple variables
        local abs = math.abs

        if ( "left_x" == axis ) then
           if ( abs(value) > 0.15 ) then
               P.isMovingX = value * P.velocity
               P.thisDirectionAngle = math.floor( P.movementFunctions.calculateAngle(P.isMovingX, P.isMovingY, P.thisDirectionAngle) )
           else
               P.isMovingX = 0
           end
        elseif ( "left_y" == axis ) then
           if ( abs(value) > 0.15 ) then
               P.isMovingY = value * P.velocity
               P.thisDirectionAngle = math.floor( P.movementFunctions.calculateAngle(P.isMovingX, P.isMovingY, P.thisDirectionAngle) )
           else
               P.isMovingY = 0
           end
        elseif ( "right_x" == axis ) then
            P.isRotatingX = value
            P.thisAimAngle = math.floor( P.movementFunctions.calculateAngle(P.isRotatingX, P.isRotatingY, P.thisAimAngle) )
        elseif ( "right_y" == axis ) then
            P.isRotatingY = value
            P.thisAimAngle = math.floor( P.movementFunctions.calculateAngle(P.isRotatingX, P.isRotatingY, P.thisAimAngle) )
        elseif ( "left_trigger" or "right_trigger" == axis ) then
            -- call the shoot function
        end
        return true
    end

    P.playerAxis = playerAxis

return P