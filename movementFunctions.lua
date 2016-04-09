M = {}

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

M.calculateAngle = calculateAngle

return M