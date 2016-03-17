local P = {}

P.image = display.newImage( "TestFace.png" )
P.image:setFillColor( 1, 0, 0 )
P.image.x = display.contentCenterX
P.image.y = display.contentCenterY
P.isMovingX = 0
P.isMovingY = 0
P.isRotatingX = 0
P.isRotatingY = 0
P.thisAngle = 0
P.image.color = "red"
P.velocity = 10

local function calculateAngle( sideX, sideY )

    local angle
    if ( math.abs( sideX ) < 0.1 and math.abs( sideY ) < 0.1 ) then
        angle = P.thisAngle
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