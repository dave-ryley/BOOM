local P = {}
    --P.collisionFilter = {categoryBits = 1, maskBits = 4}
    P.myName = "player"
    P.shotgun = require "shotgun"
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
    P.velocity = 10
    P.lowerBodyAnim = ""
    P.upperBodyAnim = ""
    P.isAlive = true
    P.shooting = 0
    P.shotgunPower = 50
    P.lookDirection = display.newGroup()
    P.parent:insert (P.lookDirection )
    P.parent:insert(P.shotgun.bounds)
    -- Collision object setup
    P.bounds = display.newRect(0,0,150,170)
    P.bounds.alpha = 0.0
    P.bounds.myName = "player"
    physics.addBody( P.bounds,  "dynamic", 
                                {density=0.5, 
                                friction=0.7, 
                                bounce=0.0
                                --,filter=P.collisionFilter
                                })
    --P.bounds.filter = P.collisionFilter
    P.bounds.linearDamping = 5
    P.bounds.isFixedRotation=true
    P.bounds.x = display.contentCenterX
    P.bounds.y = display.contentCenterY + 20

    -- Setting up audio
    P.boomStick = audio.loadSound("Sounds/Player/BOOMSTICK.ogg")
    P.step1 = audio.loadSound( "Sounds/Player/Step1.ogg" )
    P.step2 = audio.loadSound( "Sounds/Player/Step2.ogg" )
    P.torchIdle = audio.loadSound( "/Sounds/Player/Torchidle.ogg" )
    -- Setting up the lower body animation
    P.lowerBody = display.newGroup()
    P.parent:insert( P.lowerBody )
    local runSheetOptions =
    {
        width = 140,
        height = 110,
        numFrames = 152
    }
    P.lowerBodyRun_sheet = graphics.newImageSheet( "Graphics/Animation/RunnerLegs.png", runSheetOptions )
    lowerBodyRun_sequences = require "runnerLegsSeq"

    P.lowerBodyRun_sprite = display.newSprite( P.lowerBody, P.lowerBodyRun_sheet, lowerBodyRun_sequences )
    P.lowerBodyRun_sprite.y = 50

    -- Setting up the upper Body Animation
    P.upperBody = display.newGroup()
    P.parent:insert( P.upperBody )
    local runUpperSheetOptions =
    {
        width = 210,
        height = 220,
        numFrames = 88
    }
    P.upperBodyRun_sheet = graphics.newImageSheet( "Graphics/Animation/RunnerTorso.png", runUpperSheetOptions )
    upperBodyRun_sequences = require "runnerTorsoSeq"

    P.upperBodyRun_sprite = display.newSprite( P.upperBody, P.upperBodyRun_sheet, upperBodyRun_sequences )

    -- Setting up the torch Animation
    P.torch = display.newGroup()
    P.upperBody:insert( P.torch )
    local torchSheetOptions =
    {
        width = 120,
        height = 220,
        numFrames = 8
    }
    P.torch_sheet = graphics.newImageSheet( "Graphics/Animation/torch.png", torchSheetOptions )
    torch_sequences =
    {
        {
            name = "default",
            start = 1,
            count = 8,
            time = 800,
            loopCount = 0,
            loopDirection = "forward"
        }
    }

    P.torch_sprite = display.newSprite( P.torch, P.torch_sheet, torch_sequences )
    P.torch_sprite:play()




    -- Camera lock object setup
    P.cameraLock = display.newRect(0,-200,50,50)
    P.cameraLock.alpha = 0.0
    P.cameraLock.x = P.parent.x
    P.cameraLock.y = P.parent.y



    local sounds = function( event )
        if(P.isAlive)then audio.play(Torchidle, { channel = 2, loops = -1, fadein = 0}) end
        currentFrame = P.lowerBodyRun_sprite.frame
        --print("frame: ",currentFrame)
        if(P.isMovingX ~= 0 or P.isMovingY ~=0) then
            if(currentFrame == 3)then
                audio.play( P.step1, { channel = 1, loops=0})
            elseif(currentFrame == 7)then
                audio.play( P.step2, { channel = 1, loops=0})
            end
        end
    end
    Runtime:addEventListener( "enterFrame", sounds )

    local update = function( event )
        --if(P.bounds.velocity > 0) then

        --end
    end
    Runtime:addEventListener( "enterFrame", update )

    local movePlayer = function( event)

        -- Set the .isMovingX and .isMovingY values in our event handler
        -- If this number isn't 0 (stopped moving), move the P
        if (P.shooting > 0) then
            -- need to change to P aim direction
            P.isMovingX = -P.shooting
            P.isMovingY = P.shooting
            P.shooting = P.shooting - (P.shooting/15 + 1)
        end
        if ( P.isMovingX ~= 0 ) then
            P.bounds.x = P.bounds.x + P.isMovingX
            P.parent.x = P.bounds.x
            P.cameraLock.x = P.parent.x + P.isMovingX*10
        else
            P.cameraLock.x = P.parent.x
        end
        if ( P.isMovingY ~= 0 ) then
            P.bounds.y = P.bounds.y + P.isMovingY
            P.parent.y = P.bounds.y - 20
            P.cameraLock.y = P.parent.y + P.isMovingY*10
        else
            P.cameraLock.y = P.parent.y
        end

        -- Animate Upper Body
        local upperBodyAnim = ""
        if P.thisAimAngle > 337 or P.thisAimAngle < 23 then
            upperBodyAnim = "up"
            P.torch.x = -70
            P.torch.y = -100
        elseif P.thisAimAngle < 68 then
            upperBodyAnim = "upRight"
            P.torch.x = -65
            P.torch.y = -120
        elseif P.thisAimAngle < 113 then
            upperBodyAnim = "right"
            P.torch.x = 65
            P.torch.y = -135
        elseif P.thisAimAngle < 158 then
            upperBodyAnim = "downRight"
            P.torch.x = 65
            P.torch.y = -125
        elseif P.thisAimAngle < 203 then
            upperBodyAnim = "down"
            P.torch.x = 60
            P.torch.y = -105
        elseif P.thisAimAngle < 248 then
            upperBodyAnim = "downLeft"
            P.torch.x = 30
            P.torch.y = -120
        elseif P.thisAimAngle < 293 then
            upperBodyAnim = "left"
            P.torch.x = -10
            P.torch.y = -115
        else
            upperBodyAnim = "upLeft"
            P.torch.x = -45
            P.torch.y = -105
        end

        if P.upperBodyAnim ~= upperBodyAnim then
            P.upperBodyRun_sprite:setSequence(upperBodyAnim)
            P.upperBodyRun_sprite:play()
            P.upperBodyAnim = upperBodyAnim
        end

        -- Animate Lower Body
        local lowerBodyAnim = "idle"
        if math.abs(P.isMovingX) + math.abs(P.isMovingY) >= 0.1 then
            

            -- 1. Get the direction moving compared to the direction facing
            -- 2. Set the animation based on the direction facing
            local reverse = false
            local localAngle = (P.thisAimAngle+360 - P.thisDirectionAngle) % 360
            if localAngle > 110 and localAngle < 250 then
                reverse = true
            end
            --myKeyDisplayText.text = P.thisDirectionAngle
            if P.thisDirectionAngle > 337 or P.thisDirectionAngle < 23 then
                if reverse then
                    lowerBodyAnim = "downBack"
                else
                    lowerBodyAnim = "upAhead"
                end
            elseif P.thisDirectionAngle < 68 then
                if reverse then
                    lowerBodyAnim = "downLeftBack"
                else
                    lowerBodyAnim = "upRightAhead"
                end
            elseif P.thisDirectionAngle < 113 then
                if reverse then
                    lowerBodyAnim = "leftBack"
                else
                    lowerBodyAnim = "rightAhead"                
                end
            elseif P.thisDirectionAngle < 158 then
                if reverse then
                    lowerBodyAnim = "upLeftBack"
                else
                    lowerBodyAnim = "downRightAhead"                
                end
            elseif P.thisDirectionAngle < 203 then
                if reverse then
                    lowerBodyAnim = "upBack"
                else
                    lowerBodyAnim = "downAhead"                
                end
            elseif P.thisDirectionAngle < 248 then
                if reverse then
                    lowerBodyAnim = "upRightBack"
                else
                    lowerBodyAnim = "downLeftAhead"                
                end
            elseif P.thisDirectionAngle < 293 then
                if reverse then
                    lowerBodyAnim = "rightBack"
                else
                    lowerBodyAnim = "leftAhead"                
                end
            else
                if reverse then
                    lowerBodyAnim = "downRightBack"
                else
                    lowerBodyAnim = "upLeftAhead"                
                end
            end
        else
        end

        if P.lowerBodyAnim ~= lowerBodyAnim then
            P.lowerBodyRun_sprite:setSequence(lowerBodyAnim)
            P.lowerBodyRun_sprite:play()
            P.lowerBodyAnim = lowerBodyAnim
        end
        P.parent.x = P.bounds.x
        P.parent.y = P.bounds.y
       -- P.shotgun.bounds.x = P.bounds.x + 100
       -- P.shotgun.bounds.y = P.bounds.y + 100
        --P.shotgun.bounds.isAwake = false

        
    end
    Runtime:addEventListener( "enterFrame", movePlayer )

    --Test shotgun
    local function shootDelay( event )
        P.canShoot = true;
        P.shotgun.bounds.reloading = false
        --P.shotgun.bounds:removeSelf( )
        
       -- P.shotgun.bounds.isAwake = false
        P.shotgun.bounds.alpha = 0
        print(event.name)
        print("can shoot: " ..  tostring(P.canShoot))
    end

    local function blastDisppear( event )
        --P.shotgun.bounds.x = -1000
        --P.shotgun.bounds.y = -1000
        timer.performWithDelay( 1500, shootDelay )
        P.shotgun.isAwake = false
        P.shotgun.bounds.alpha = 0
    end

    local shoot = function( event )
        if (event.phase == "down" and event.keyName == "space" and P.canShoot == true) then
           
            P.shotgun.bounds.isAwake = true
            P.shotgun.bounds.alpha = 1
            P.shotgun.bounds.x = P.bounds.x
            P.shotgun.bounds.y = P.bounds.y
            P.shotgun.bounds.rotation = P.thisAimAngle - 90
            --print(P.thisAimAngle)
            --print(Shot: " ..P.shotgun.bousands.x .. " : " .. P.shotgun.bounds.y)
            P.canShoot = false
            P.bounds:applyLinearImpulse(200, 0, 0, 0)
            timer.performWithDelay(400, blastDisppear)
            audio.play(P.boomStick,{channel = 3})
            P.shotgun.bounds.reloading = true
            
            
        end
    end
    Runtime:addEventListener( "key" , shoot)
    -- Test image

    -- Calculate the angle to rotate. Using simple right angle math, we can
    -- determine the base and height of a right triangle where one point is 0,0
    -- (stick center) and the values returned from the two axis numbers returned
    -- from the stick

    -- This will give us a 0-90 value, so we have to map it to the quadrant
    -- based on if the values for the two axis are positive or negative
    -- Negative Y, positive X is top-right area
    -- Positive X, Positive Y is bottom-right area
    -- Negative X, positive Y is bottom-left area
    -- Negative x, negative y is top-left area

    local function calculateAngle( sideX, sideY, currentAngle )

        local angle
        if ( math.abs( sideX ) < 0.1 and math.abs( sideY ) < 0.1 ) then
            angle = currentAngle
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

    P.calculateAngle = calculateAngle

return P