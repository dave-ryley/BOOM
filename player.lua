local P = {}

P.parent = display.newGroup()
P.parent.x = display.contentCenterX
P.parent.y = display.contentCenterY
P.isMovingX = 0
P.isMovingY = 0
P.isRotatingX = 0
P.isRotatingY = 0
P.thisAimAngle = 0
P.thisDirectionAngle = 0
P.velocity = 10
P.lowerBodyAnim = ""
P.upperBodyAnim = ""

-- Setting up the lower body animation
P.lowerBody = display.newGroup()
P.parent:insert( P.lowerBody )
local runSheetOptions =
{
    width = 140,
    height = 110,
    numFrames = 64
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
    numFrames = 64
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