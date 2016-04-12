
F = {}
local physics = require "physics"

function spawn(angle, x, y)
    local fireballSheetOptions =
    {
        width = 120,
        height = 160,
        numFrames = 8
    }
    local fireballSheet = graphics.newImageSheet( "Graphics/Animation/fireball.png", fireballSheetOptions )
    local fireballSeq =
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

    fireball = display.newSprite( fireballSheet, fireballSeq )
    fireball:play()
    fireball.x = math.cos(math.rad(angle - 90))*200 + x -- need to determine actual angle
    fireball.y = math.sin(math.rad(angle - 90))*200 + y -- need to determine actual angle
    fireball.myName = "fireball"

    local fireballShape = { -80,-70, 80,-70, 80,120, -80,120 }
    local fireballData = {   
                    physicsData =   {
                                shape=fireballShape,
                                density=1.0, 
                                friction=0.0, 
                                bounce=0.0,
                                isFixedRotation=true
                                    }
                                }
    fireball.rotation = angle

    physics.addBody( fireball, "dynamic", fireballData )
    xForce = math.cos(math.rad(angle - 90))*5
    yForce = math.sin(math.rad(angle - 90))*5
    fireball:applyLinearImpulse( xForce, yForce, x, y )
    return fireball
end

F.spawn = spawn

return F