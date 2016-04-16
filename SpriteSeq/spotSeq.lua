local g = require "globals"
local spot_sheetOptions =
		{
			width = 300,
			height = 300,
			numFrames = 64
		}

local spot_sheet_nice = graphics.newImageSheet( g.animationPath.."spotRun.png", 
												spot_sheetOptions )        
local spot_sheet_evil = graphics.newImageSheet( g.animationPath.."spotTransformHit.png",
												spot_sheetOptions )
		
local spot_seq = 
{
	{
		name = "upRun",
		sheet=spot_sheet_nice,
		start = 1,
		count = 8,
		time = 800,
		loopCount = 0,
		loopDirection = "forward"
	},
	{
		name = "upRightRun",
		sheet=spot_sheet_nice,
		start = 9,
		count = 8,
		time = 800,
		loopCount = 0,
		loopDirection = "forward"
	},
	{
		name = "rightRun",
		sheet=spot_sheet_nice,
		start = 17,
		count = 8,
		time = 800,
		loopCount = 0,
		loopDirection = "forward"
	},
	{
		name = "downRightRun",
		sheet=spot_sheet_nice,
		start = 25,
		count = 8,
		time = 800,
		loopCount = 0,
		loopDirection = "forward"
	},
	{
		name = "downRun",
		sheet=spot_sheet_nice,
		start = 33,
		count = 8,
		time = 800,
		loopCount = 0,
		loopDirection = "forward"
	},
	{
		name = "upLeftRun",
		sheet=spot_sheet_nice,
		start = 41,
		count = 8,
		time = 800,
		loopCount = 0,
		loopDirection = "forward"
	},
	{
		name = "leftRun",
		sheet=spot_sheet_nice,
		start = 49,
		count = 8,
		time = 800,
		loopCount = 0,
		loopDirection = "forward"
	},
	{
		name = "downLeftRun",
		sheet=spot_sheet_nice,
		start = 57,
		count = 8,
		time = 800,
		loopCount = 0,
		loopDirection = "forward"
	},
	{
		name = "upRunEvil",
		sheet=spot_sheet_evil,
		start = 1,
		count = 6,
		time = 600,
		loopCount = 1,
		loopDirection = "forward"
	},
	{
		name = "upRightRunEvil",
		sheet=spot_sheet_evil,
		start = 9,
		count = 6,
		time = 600,
		loopCount = 1,
		loopDirection = "forward"
	},
	{
		name = "rightRunEvil",
		sheet=spot_sheet_evil,
		start = 17,
		count = 6,
		time = 600,
		loopCount = 1,
		loopDirection = "forward"
	},
	{
		name = "downRightRunEvil",
		sheet=spot_sheet_evil,
		start = 25,
		count = 6,
		time = 600,
		loopCount = 1,
		loopDirection = "forward"
	},
	{
		name = "downRunEvil",
		sheet=spot_sheet_evil,
		start = 33,
		count = 6,
		time = 600,
		loopCount = 1,
		loopDirection = "forward"
	},
	{
		name = "upLeftRunEvil",
		sheet=spot_sheet_evil,
		start = 41,
		count = 6,
		time = 600,
		loopCount = 1,
		loopDirection = "forward"
	},
	{
		name = "leftRunEvil",
		sheet=spot_sheet_evil,
		start = 49,
		count = 6,
		time = 600,
		loopCount = 1,
		loopDirection = "forward"
	},
	{
		name = "downLeftRunEvil",
		sheet=spot_sheet_evil,
		start = 57,
		count = 6,
		time = 600,
		loopCount = 1,
		loopDirection = "forward"
	},
	--HIT ANIMATIONS
	{
		name = "upRunHit",
		sheet=spot_sheet_evil,
		start = 7,
		count = 2,
		time = 200,
		loopCount = 1,
		loopDirection = "forward"
	},
	{
		name = "upRightRunHit",
		sheet=spot_sheet_evil,
		start = 15,
		count = 2,
		time = 200,
		loopCount = 1,
		loopDirection = "forward"
	},
	{
		name = "rightRunHit",
		sheet=spot_sheet_evil,
		start = 23,
		count = 2,
		time = 200,
		loopCount = 1,
		loopDirection = "forward"
	},
	{
		name = "downRightRunHit",
		sheet=spot_sheet_evil,
		start = 31,
		count = 2,
		time = 200,
		loopCount = 1,
		loopDirection = "forward"
	},
	{
		name = "downRunHit",
		sheet=spot_sheet_evil,
		start = 39,
		count = 2,
		time = 200,
		loopCount = 1,
		loopDirection = "forward"
	},
	{
		name = "upLeftRunHit",
		sheet=spot_sheet_evil,
		start = 47,
		count = 2,
		time = 200,
		loopCount = 1,
		loopDirection = "forward"
	},
	{
		name = "leftRunHit",
		sheet=spot_sheet_evil,
		start = 55,
		count = 2,
		time = 200,
		loopCount = 1,
		loopDirection = "forward"
	},
	{
		name = "downLeftRunHit",
		sheet=spot_sheet_evil,
		start = 63,
		count = 2,
		time = 200,
		loopCount = 1,
		loopDirection = "forward"
	}
}
return spot_seq