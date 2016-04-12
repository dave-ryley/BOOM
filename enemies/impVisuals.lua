V = {}

    V.anim = ""
    V.sounds = {}
    local imp_sheetOptions =
    {
        width = 300,
        height = 240,
        numFrames = 136
    }
    local imp_sheet = graphics.newImageSheet( "Graphics/Animation/Imp.png", imp_sheetOptions )
    local imp_sequences = require "SpriteSeq.impSeq"
    V.bounds = display.newSprite( imp_sheet, imp_sequences )

    local function animate(angle, ext) -- angle i.e 90, ext is the extension onto the animation, i.e "Shoot" or "Stand"
        -- Animate Upper Body
        print("animating " .. ext .. " at angle " .. angle)
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

        anim = anim .. ext

        if V.anim ~= anim then
            V.bounds:setSequence(anim)
            V.bounds:play()
            V.anim = anim
        end
    end

    V.animate = animate

return V