local V = {}

    V.lowerBodyAnim = ""
    V.upperBodyAnim = ""
    V.sounds = {}
    V.sounds.boomStick = audio.loadSound("Sounds/Player/BOOMSTICK.ogg")
    V.sounds.step1 = audio.loadSound( "Sounds/Player/Step1.ogg" )
    V.sounds.step2 = audio.loadSound( "Sounds/Player/Step2.ogg" )
    V.sounds.torchIdle = audio.loadSound( "Sounds/Player/Torchidle.ogg" )
    audio.play(V.sounds.torchIdle, { channel = 2, loops = -1, fadein = 0})
    audio.setVolume( 0.1, {channel = 2} )
    audio.setVolume( 1, {channel = 3} )
    -- Setting up the lower body Animation
    V.lowerBody = display.newGroup()

    local runSheetOptions =
    {
        width = 140,
        height = 110,
        numFrames = 152
    }
    local lowerBodyRun_sheet = graphics.newImageSheet( "Graphics/Animation/RunnerLegs.png", runSheetOptions )
    local lowerBodyRun_sequences = require "SpriteSeq.runnerLegsSeq"
    lowerBodyRun_sprite = display.newSprite( V.lowerBody, lowerBodyRun_sheet, lowerBodyRun_sequences )
    lowerBodyRun_sprite.y = 50

    -- Setting up the upper Body Animation
    V.upperBody = display.newGroup()
    -- Setting up the upper Body Animation

    local runUpperSheetOptions =
    {
        width = 210,
        height = 220,
        numFrames = 88
    }
    local upperBodyRun_sequences = require "SpriteSeq.runnerTorsoSeq"
    local upperBodyRun_sheet = graphics.newImageSheet( "Graphics/Animation/RunnerTorso.png", runUpperSheetOptions )

    upperBodyRun_sprite = display.newSprite( V.upperBody, upperBodyRun_sheet, upperBodyRun_sequences )

    -- Setting up the torch Animation

    local torchSheetOptions =
    {
        width = 120,
        height = 220,
        numFrames = 8
    }
    torch_sheet = graphics.newImageSheet( "Graphics/Animation/torch.png", torchSheetOptions )
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

    torch = display.newSprite( torch_sheet, torch_sequences )
    torch:play()
    V.upperBody:insert( torch )


    local function animate(aimAngle, directionAngle, moving, velocity)
        -- Animate Upper Body
        local upperBodyAnim = ""
        local lowerBodyAnim = ""
        if aimAngle > 337 or aimAngle < 23 then
            upperBodyAnim = "up"
            torch.x = -70
            torch.y = -100
        elseif aimAngle < 68 then
            upperBodyAnim = "upRight"
            torch.x = -65
            torch.y = -120
        elseif aimAngle < 113 then
            upperBodyAnim = "right"
            torch.x = 65
            torch.y = -135
        elseif aimAngle < 158 then
            upperBodyAnim = "downRight"
            torch.x = 65
            torch.y = -125
        elseif aimAngle < 203 then
            upperBodyAnim = "down"
            torch.x = 60
            torch.y = -105
        elseif aimAngle < 248 then
            upperBodyAnim = "downLeft"
            torch.x = 30
            torch.y = -120
        elseif aimAngle < 293 then
            upperBodyAnim = "left"
            torch.x = -10
            torch.y = -115
        else
            upperBodyAnim = "upLeft"
            torch.x = -45
            torch.y = -105
        end
        -- Animate Lower Body
        -- 1. Get the direction moving compared to the direction facing
        -- 2. Set the animation based on the direction facing
        local reverse = false
        local localAngle = (aimAngle+360 - directionAngle) % 360
        if localAngle > 110 and localAngle < 250 and moving >= 0.1 then
            reverse = true
        end
        if directionAngle > 337 or directionAngle < 23 then
            lowerBodyAnim = "up"
        elseif directionAngle < 68 then
            lowerBodyAnim = "upRight"
        elseif directionAngle < 113 then
            lowerBodyAnim = "right"
        elseif directionAngle < 158 then
            lowerBodyAnim = "downRight"
        elseif directionAngle < 203 then
            lowerBodyAnim = "down"
        elseif directionAngle < 248 then
            lowerBodyAnim = "downLeft"
        elseif directionAngle < 293 then
            lowerBodyAnim = "left"   
        else
            lowerBodyAnim = "upLeft" 
        end

        if moving < 0.1 then
            --lowerBodyAnim = lowerBodyAnim .. "Stand"
            upperBodyAnim = upperBodyAnim .. "Stand"
            lowerBodyAnim = upperBodyAnim
        elseif reverse then
            lowerBodyAnim = lowerBodyAnim .. "Back" .. "Run"
        else
            lowerBodyAnim = lowerBodyAnim .. "Run"
        end

        if V.upperBodyAnim ~= upperBodyAnim then
            upperBodyRun_sprite:setSequence(upperBodyAnim)
            upperBodyRun_sprite:play()
            V.upperBodyAnim = upperBodyAnim
        end
        if V.lowerBodyAnim ~= lowerBodyAnim then
            lowerBodyRun_sprite:setSequence(lowerBodyAnim)
            lowerBodyRun_sprite:play()
            V.lowerBodyAnim = lowerBodyAnim
        end
        if moving >= 0.1 then
            upperBodyRun_sprite.timeScale = math.min(moving/100, 2.0)
            lowerBodyRun_sprite.timeScale = math.min(moving/100, 2.0)
        else
            upperBodyRun_sprite.timeScale = 1.0
            lowerBodyRun_sprite.timeScale = 1.0
        end
    end

    V.animate = animate

    function animateShotgunBlast(aimAngle)
        local anim = ""
        if aimAngle > 337 or aimAngle < 23 then
            anim = "up"
            torch.x = -70
            torch.y = -100
        elseif aimAngle < 68 then
            anim = "upRight"
            torch.x = -65
            torch.y = -120
        elseif aimAngle < 113 then
            anim = "right"
            torch.x = 65
            torch.y = -135
        elseif aimAngle < 158 then
            anim = "downRight"
            torch.x = 65
            torch.y = -125
        elseif aimAngle < 203 then
            anim = "down"
            torch.x = 60
            torch.y = -105
        elseif aimAngle < 248 then
            anim = "downLeft"
            torch.x = 30
            torch.y = -120
        elseif aimAngle < 293 then
            anim = "left"
            torch.x = -10
            torch.y = -115
        else
            anim = "upLeft"
            torch.x = -45
            torch.y = -105
        end
        anim = anim .. "Shoot"
        upperBodyRun_sprite:setSequence(anim)
        lowerBodyRun_sprite:setSequence(anim)
        upperBodyRun_sprite:play()
        lowerBodyRun_sprite:play()
        V.upperBodyAnim = anim
        V.lowerBodyAnim = anim
    end

    V.animateShotgunBlast = animateShotgunBlast

    local function footsteps()
        if string.sub( lowerBodyRun_sprite.sequence, -3 ) == "Run" then
            --print("run")
            if(lowerBodyRun_sprite.frame == 3)then
                audio.play( V.sounds.step1, { channel = 1, loops=0})
            elseif(lowerBodyRun_sprite.frame == 7)then
                --print("playing")
                audio.play( V.sounds.step2, { channel = 3, loops=0})
            end
        end
    end
    V.footsteps = footsteps

return V