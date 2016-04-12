
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

    local fireballShape = { -50,-50, 50,-50, 50,50, -50,50 }
    local fireballData = {
                            shape=fireballShape,
                            density=0.0, 
                            friction=0.0, 
                            bounce=0.0,
                            isFixedRotation=true
                            }
    fireball.rotation = angle
    fireball.isFixedRotation=true

    physics.addBody( fireball, "dynamic", fireballData )
    xForce = math.cos(math.rad(angle - 90))*3
    yForce = math.sin(math.rad(angle - 90))*3
    fireball:applyLinearImpulse( xForce, yForce, x, y )
    return fireball
end

F.spawn = spawn

return F