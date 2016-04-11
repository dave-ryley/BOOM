local fireballSheetOptions =
{
    width = 120,
    height = 160,
    numFrames = 8
}
local fireballSheet = graphics.newImageSheet( "Graphics/Animation/fireball.png", blastSheetOptions )
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

return fireball