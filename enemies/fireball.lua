F = {}
--local physics = require "physics"
local g = require "globals"
function spawn(angle, x, y)
    local col = require "collisionFilters"
    local fireballSheetOptions =
    {
        width = 120,
        height = 160,
        numFrames = 8
    }
    local fireballSheet = graphics.newImageSheet(g.animationPath.."fireball.png", fireballSheetOptions )
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

    local fireball = display.newSprite( fireballSheet, fireballSeq )
    fireball:play()
    fireball.x = math.cos(math.rad(angle - 90))*100 + x -- need to determine actual angle
    fireball.y = math.sin(math.rad(angle - 90))*100 + y -- need to determine actual angle
    fireball.myName = "p_fireball"
    --local fireballShape = { -80,-70, 80,-70, 80,120, -80,120 }
    local fireballShape = { -30,-30, 30,-30, 30,30, -30,30 }
    local fireballData = {   
                    physicsData =   {
                                shape=fireballShape,
                                density=0.025, 
                                friction=0.0, 
                                bounce=0.0,
                                isFixedRotation=true,
                                filter=col.projCol
                                    }
                                }
    fireball.rotation = angle
    fireball.isFixedRotation=true
--[[
    physics.addBody( fireball, "dynamic", fireballData.physicsData )
    xForce = math.cos(math.rad(angle - 90))*200
    yForce = math.sin(math.rad(angle - 90))*200
    ]]
    physics.addBody( fireball, "dynamic", fireballData.physicsData )
    xForce = math.cos(math.rad(angle - 90))*2
    yForce = math.sin(math.rad(angle - 90))*2
    fireball:applyLinearImpulse( xForce, yForce, x, y )
    fireball.super = fireball

    fireball.onCollision = function (event)
        if (event.phase == "began" and event.other ~= nil) then
            local other = event.other.super
            if(other.myName == "player") then
                print("Fireball killing player")
            end
            fireball:removeSelf( )
        end
    end
    fireball:addEventListener( "collision", fireball.onCollision )
    return fireball
    end
    F.spawn = spawn

return F