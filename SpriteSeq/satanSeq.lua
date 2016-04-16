local g = require "globals"
local satan_DownWalkSheetOptions =
{
	width = 730,
	height = 690,
	numFrames = 12
}
local satan_sheetDownWalk = graphics.newImageSheet( g.animationPath.."Satan/walk_down.png", 
																	satan_DownWalkSheetOptions )
local satan_seq = 
{
	{
		name = "downWalk",
		sheet = satan_sheetDownWalk,
		start = 1,
		count = 12,
		time = 1800,
		loopCount = 0,
		loopDirection = "forward"
	}
}

satan_sprite = display.newSprite( satan_sheetDownWalk, satan_seq )

return satan_sprite