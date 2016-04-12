local P = {}
    --local col = require "collisionFilters"
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
    P.velocity = 10.0
    P.maxSpeed = 1
    P.isAlive = true
   
    P.parent:insert( P.visuals.lowerBody )
    P.parent:insert( P.visuals.upperBody )

    -- Collision object setup
    P.bounds = display.newRect(0,0,70,70)
    P.bounds.alpha = 0.0
    P.bounds.myName = "player"

    physics.addBody( P.bounds, "dynamic", 
                                {
                                    density=0.5, 
                                    friction=0.3, 
                                    bounce=0.0}
                                )

    P.bounds.isFixedRotation=true
    P.bounds.x = display.contentCenterX
    P.bounds.y = display.contentCenterY
    P.bounds.linearDamping = 5
    -- Camera lock object setup
    P.cameraLock = display.newRect(0,-200,50,50)
    P.cameraLock.alpha = 0.00
    P.cameraLock.x = P.parent.x
    P.cameraLock.y = P.parent.y
    
    --[[local sounds = function( event )
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
    P.sounds = sounds]]

    local update = function( event )
        --if(P.bounds.velocity > 0) then
        --P.sounds(event)
        --end
        P.parent.x = P.bounds.x
        P.parent.y = P.bounds.y
        P.cameraLock.x = P.parent.x + P.isRotatingX*250
        P.cameraLock.y = P.parent.y + P.isRotatingY*250
    end
    Runtime:addEventListener( "enterFrame", update )
    
    local function movePlayer()

        if ( P.isMovingX ~= 0 and P.isMovingY ~= 0 ) then
            local x, y = P.bounds:getLinearVelocity()
            P.bounds:setLinearVelocity( x + P.isMovingX*P.velocity, y + P.isMovingY*P.velocity )
            P.parent.x, P.parent.y = P.bounds.x, P.bounds.y
        end

        -- placing the shotgun

        if(P.shotgun.shooting == false) then
            P.visuals.animate(P.thisAimAngle, P.thisDirectionAngle, math.abs(P.isMovingX) + math.abs(P.isMovingY), P.velocity*P.maxSpeed)
            P.shotgun.place(P.thisAimAngle, P.parent.x, P.parent.y)
        else
            P.shotgun.place( P.shotgun.bounds.rotation , P.parent.x, P.parent.y)
        end

    end

    local function movePlayerOld()
        if ( P.isMovingX ~= 0 ) then
            P.bounds.x = P.bounds.x + P.isMovingX
            P.parent.x = P.bounds.x
        end

        if ( P.isMovingY ~= 0 ) then
            P.bounds.y = P.bounds.y + P.isMovingY
            P.parent.y = P.bounds.y - 20
        end

        -- placing the shotgun

        if(P.shotgun.shooting == false) then
            P.visuals.animate(P.thisAimAngle, P.thisDirectionAngle, math.abs(P.isMovingX) + math.abs(P.isMovingY), P.velocity*P.maxSpeed)
            P.shotgun.place(P.thisAimAngle, P.parent.x, P.parent.y)
        else
            P.shotgun.place( P.shotgun.bounds.rotation , P.parent.x, P.parent.y)
        end
    end


    P.movePlayer = movePlayer

    local function blastDisppear( event )
        P.shotgun.bounds.isAwake = false
        P.shotgun.blast.alpha = 0
        P.shotgun.shooting = false
        physics.removeBody( P.shotgun.bounds )
    end

    local function shootDelay( event )
        P.canShoot = true;
        P.shotgun.bounds.isAwake = false    
    end

    local function shoot()
        P.shotgun.createBlastBounds()
        P.shotgun.bounds.isAwake = true
        P.canShoot = false
        P.bounds:applyLinearImpulse(    
                    math.cos(math.rad(P.thisAimAngle + 90))*P.shotgun.force, 
                    math.sin(math.rad(P.thisAimAngle + 90))*P.shotgun.force, 
                    0, 0)
        audio.stop(3)
        audio.play(P.visuals.sounds.boomStick,{channel = 3})
        P.shotgun.blast_sprite:play()
        P.shotgun.blast.alpha = 1
        P.shotgun.blast_sprite.alpha = 1
        P.shotgun.shooting = true
        P.visuals.animateShotgunBlast(P.thisAimAngle )
        timer.performWithDelay(200, blastDisppear)
        timer.performWithDelay(800, shootDelay)
    end

    P.shoot = shoot

    local function getAimAngle()
        return P.shotgun.bounds.aimAngle
    end
    P.getAimAngle = getAimAngle

    local function getX()
        return P.bounds.x
    end
    P.getX = getX

    local function getY()
        return P.bounds.y
    end
    P.getY = getY
    ----- Started adding in functions
    
    local function playerAxis( axis, value )
        -- Map event data to simple variables
        local abs = math.abs
        local floor = math.floor

        if ( "left_x" == axis ) then
           if ( abs(value) > 0.15 ) then
               P.isMovingX = value * P.velocity*P.maxSpeed
               P.thisDirectionAngle = floor( P.movementFunctions.calculateAngle(P.isMovingX, P.isMovingY, P.thisDirectionAngle) )
           else
               P.isMovingX = 0
           end
        elseif ( "left_y" == axis ) then
           if ( abs(value) > 0.15 ) then
               P.isMovingY = value * P.velocity*P.maxSpeed
               P.thisDirectionAngle = floor( P.movementFunctions.calculateAngle(P.isMovingX, P.isMovingY, P.thisDirectionAngle) )
           else
               P.isMovingY = 0
           end
        elseif ( "right_x" == axis ) then
            P.isRotatingX = value
            P.thisAimAngle = floor( P.movementFunctions.calculateAngle(P.isRotatingX, P.isRotatingY, P.thisAimAngle) )
        elseif ( "right_y" == axis ) then
            P.isRotatingY = value
            P.thisAimAngle = floor( P.movementFunctions.calculateAngle(P.isRotatingX, P.isRotatingY, P.thisAimAngle) )
        elseif ( "left_trigger" == axis or "right_trigger" == axis ) then
            if(P.canShoot) then
                P.shoot()
            end
        end
        return true
    end

    P.playerAxis = playerAxis

    
    P.onCollision = function( event )
        print("player collided with: ".. event.other.myName)
            if (event.phase == "began") then
                if (event.other.myName == "trap_fire") then
                        --print("reloading: "..event.object1.reloading)
                    print("Killed by: " .. event.other.myName) 
                    --P.bounds:removeSelf()
                    --P.bounds:applyLinearImpulse( 2000, 0, 50, 50 )
                    --C[event.object2.id].parent:removeSelf( )
                elseif (event.other.myName == "trap_win") then
                    print("GOOD JOB CHRIS THAT WAS GOOD WELL DONE")
                end
                
                if(event.other.myName == "trap_slow") then
                    print("Slowed by: " .. event.other.myName)
                    P.maxSpeed = P.maxSpeed/2
                end

            end
        end
    P.bounds:addEventListener( "collision", P.onCollision )
    

    function virtualJoystickInput(ljsAngle, ljsX, ljsY, rjsAngle, rjsDistance, rjsX, rjsY)
        if rjsDistance > 0.9 and P.canShoot then
            P.shoot()
        end
        P.isMovingX = ljsX * P.velocity*P.maxSpeed
        P.isMovingY = ljsY * P.velocity*P.maxSpeed
        P.isRotatingX = rjsX
        P.isRotatingY = rjsY
        P.thisDirectionAngle = (720-(ljsAngle-90)) % 360
        P.thisAimAngle = (720-(rjsAngle-90)) % 360
    end

    P.virtualJoystickInput = virtualJoystickInput

return P