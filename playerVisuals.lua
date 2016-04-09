V = {}

    V.lowerBodyAnim = ""
    V.upperBodyAnim = ""
    V.sounds = {}
    V.sounds.boomStick = audio.loadSound("Sounds/Player/BOOMSTICK.ogg")
    V.sounds.step1 = audio.loadSound( "Sounds/Player/Step1.ogg" )
    V.sounds.step2 = audio.loadSound( "Sounds/Player/Step2.ogg" )
    V.sounds.torchIdle = audio.loadSound( "/Sounds/Player/Torchidle.ogg" )
    audio.play(V.sounds.torchIdle, { channel = 2, loops = -1, fadein = 0})

    -- Setting up the lower body animation
    V.lowerBody = display.newGroup()

    local runSheetOptions =
    {
        width = 140,
        height = 110,
        numFrames = 152
    }
    V.lowerBodyRun_sheet = graphics.newImageSheet( "Graphics/Animation/RunnerLegs.png", runSheetOptions )
    lowerBodyRun_sequences = require "runnerLegsSeq"
    V.lowerBodyRun_sprite = display.newSprite( V.lowerBody, V.lowerBodyRun_sheet, lowerBodyRun_sequences )
    V.lowerBodyRun_sprite.y = 50

    -- Setting up the upper Body Animation
    V.upperBody = display.newGroup()

    local runUpperSheetOptions =
    {
        width = 210,
        height = 220,
        numFrames = 88
    }
    V.upperBodyRun_sheet = graphics.newImageSheet( "Graphics/Animation/RunnerTorso.png", runUpperSheetOptions )
    upperBodyRun_sequences = require "runnerTorsoSeq"

    V.upperBodyRun_sprite = display.newSprite( V.upperBody, V.upperBodyRun_sheet, upperBodyRun_sequences )

    -- Setting up the torch Animation
    V.torch = display.newGroup()
    V.upperBody:insert( V.torch )
    local torchSheetOptions =
    {
        width = 120,
        height = 220,
        numFrames = 8
    }
    V.torch_sheet = graphics.newImageSheet( "Graphics/Animation/torch.png", torchSheetOptions )
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

    V.torch_sprite = display.newSprite( V.torch, V.torch_sheet, torch_sequences )
    V.torch_sprite:play()

    local function animate(aimAngle, directionAngle, moving, velocity)
        -- Animate Upper Body
        local upperBodyAnim = ""
        local lowerBodyAnim = ""
        if aimAngle > 337 or aimAngle < 23 then
            upperBodyAnim = "up"
            V.torch.x = -70
            V.torch.y = -100
        elseif aimAngle < 68 then
            upperBodyAnim = "upRight"
            V.torch.x = -65
            V.torch.y = -120
        elseif aimAngle < 113 then
            upperBodyAnim = "right"
            V.torch.x = 65
            V.torch.y = -135
        elseif aimAngle < 158 then
            upperBodyAnim = "downRight"
            V.torch.x = 65
            V.torch.y = -125
        elseif aimAngle < 203 then
            upperBodyAnim = "down"
            V.torch.x = 60
            V.torch.y = -105
        elseif aimAngle < 248 then
            upperBodyAnim = "downLeft"
            V.torch.x = 30
            V.torch.y = -120
        elseif aimAngle < 293 then
            upperBodyAnim = "left"
            V.torch.x = -10
            V.torch.y = -115
        else
            upperBodyAnim = "upLeft"
            V.torch.x = -45
            V.torch.y = -105
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
            lowerBodyAnim = lowerBodyAnim .. "Back"
        end

        if V.upperBodyAnim ~= upperBodyAnim then
            V.upperBodyRun_sprite:setSequence(upperBodyAnim)
            V.upperBodyRun_sprite:play()
            V.upperBodyAnim = upperBodyAnim
        end
        if V.lowerBodyAnim ~= lowerBodyAnim then
            V.lowerBodyRun_sprite:setSequence(lowerBodyAnim)
            V.lowerBodyRun_sprite:play()
            V.lowerBodyAnim = lowerBodyAnim
        end
        if moving >= 0.1 then
            V.upperBodyRun_sprite.timeScale = math.min(velocity*moving/200.0, 2.0)
            V.lowerBodyRun_sprite.timeScale = math.min(velocity*moving/200.0, 2.0)
        else
            V.upperBodyRun_sprite.timeScale = 1.0
            V.lowerBodyRun_sprite.timeScale = 1.0
        end
    end

    V.animate = animate

return V