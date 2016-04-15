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

    local function calculateLineAngle( x1, y1, x2, y2 )
         local angle = 0
            local deltaX = x2 - x1
            local deltaY = y2 - y1
            local angle = math.atan2( deltaY, deltaX )
            --print("x1: "..x1.."\ty1: "..y1.."\tx2: "..x2.."\ty2: "..y2)
            if(angle < 0 ) then
                --angle = angle + math.pi*3/4
            end
            --print("calculatedAngle: " .. angle*180/math.pi)
                return math.fmod((angle*180/math.pi + 90 + 360), 360)
            end
    M.calculateLineAngle = calculateLineAngle

    local function calculateDistance( x1, y1, x2, y2 )

        local deltaX = x2 - x1
        local deltaY = y2 - y1
        local distance = math.sqrt( math.pow( deltaX, 2 ) + math.pow(deltaY, 2))
        return distance
    end
    M.calculateDistance = calculateDistance

return M