local T = {}

    local function spawn()
        local V = {}
        V.anim = ""
        V.sounds = {}
        local spot_sheetOptions =
        {
            width = 300,
            height = 300,
            numFrames = 64
        }
        local spot_sheet_nice = graphics.newImageSheet( "Graphics/Animation/spotRun.png", spot_sheetOptions )
        local spot_sequences = require "SpriteSeq.spotSeq"
        
        V.bounds = display.newSprite( spot_sheet_nice, spot_sequences )

        local function animate(angle, ext, param) -- angle i.e 90, ext is the extension onto the animation, i.e "Shoot" or "Stand"
            -- Animate Upper Body
            --print("animating " .. ext .. " at angle " .. angle)
            print("testing param: "..param)
            local anim = ""
            if angle > 337 or angle < 23 then
                anim = "up"
            elseif angle < 68 then
                anim = "upRight"
            elseif angle < 113 then
                anim = "right"
            elseif angle < 158 then
                anim = "downRight"
            elseif angle < 203 then
                anim = "down"
            elseif angle < 248 then
                anim = "downLeft"
            elseif angle < 293 then
                anim = "left"
            else
                anim = "upLeft"
            end

            anim = anim .. ext .. param

            if V.anim ~= anim then
                V.bounds:setSequence(anim)
                V.bounds:play()
                V.anim = anim
            end
        end
        V.animate = animate
        return V
    end
    T.spawn = spawn
return T