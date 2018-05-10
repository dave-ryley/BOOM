 
local imp_sheetOptions =
{
	width = 300,
	height = 240,
	numFrames = 64
}
local imp_sheet_stand = graphics.newImageSheet( g.animationPath.."ImpStand.png", 
												imp_sheetOptions )
imp_sheetOptions.numFrames = 56
local imp_sheet_shoot = graphics.newImageSheet( g.animationPath.."ImpShoot.png", 
												imp_sheetOptions )
imp_sheetOptions.numFrames = 16
local imp_sheet_hit = graphics.newImageSheet( g.animationPath.."ImpHit.png", 
												imp_sheetOptions )
local imp_seq = 
{
	{
		name = "upStand",
		sheet = imp_sheet_stand,
		start = 1,
		count = 8,
		time = 800,
		loopCount = 0,
		loopDirection = "forward"
	},
	{
		name = "upRightStand",
		sheet = imp_sheet_stand,
		start = 9,
		count = 8,
		time = 800,
		loopCount = 0,
		loopDirection = "forward"
	},
	{
		name = "rightStand",
		sheet = imp_sheet_stand,
		start = 17,
		count = 8,
		time = 800,
		loopCount = 0,
		loopDirection = "forward"
	},
	{
		name = "downRightStand",
		sheet = imp_sheet_stand,
		start = 25,
		count = 8,
		time = 800,
		loopCount = 0,
		loopDirection = "forward"
	},
	{
		name = "downStand",
		sheet = imp_sheet_stand,
		start = 33,
		count = 8,
		time = 800,
		loopCount = 0,
		loopDirection = "forward"
	},
	{
		name = "upLeftStand",
		sheet = imp_sheet_stand,
		start = 41,
		count = 8,
		time = 800,
		loopCount = 0,
		loopDirection = "forward"
	},
	{
		name = "leftStand",
		sheet = imp_sheet_stand,
		start = 49,
		count = 8,
		time = 800,
		loopCount = 0,
		loopDirection = "forward"
	},
	{
		name = "downLeftStand",
		sheet = imp_sheet_stand,
		start = 57,
		count = 8,
		time = 800,
		loopCount = 0,
		loopDirection = "forward"
	},
	{
		name = "upShoot",
		sheet = imp_sheet_shoot,
		start = 1,
		count = 7,
		time = 700,
		loopCount = 0,
		loopDirection = "forward"
	},
	{
		name = "upRightShoot",
		sheet = imp_sheet_shoot,
		start = 8,
		count = 7,
		time = 700,
		loopCount = 0,
		loopDirection = "forward"
	},
	{
		name = "rightShoot",
		sheet = imp_sheet_shoot,
		start = 15,
		count = 7,
		time = 700,
		loopCount = 0,
		loopDirection = "forward"
	},
	{
		name = "downRightShoot",
		sheet = imp_sheet_shoot,
		start = 22,
		count = 7,
		time = 700,
		loopCount = 0,
		loopDirection = "forward"
	},
	{
		name = "downShoot",
		sheet = imp_sheet_shoot,
		start = 29,
		count = 7,
		time = 700,
		loopCount = 0,
		loopDirection = "forward"
	},
	{
		name = "upLeftShoot",
		sheet = imp_sheet_shoot,
		start = 36,
		count = 7,
		time = 700,
		loopCount = 0,
		loopDirection = "forward"
	},
	{
		name = "leftShoot",
		sheet = imp_sheet_shoot,
		start = 43,
		count = 7,
		time = 700,
		loopCount = 0,
		loopDirection = "forward"
	},
	{
		name = "downLeftShoot",
		sheet = imp_sheet_shoot,
		start = 50,
		count = 7,
		time = 700,
		loopCount = 0,
		loopDirection = "forward"
	},
	{
		name = "upHit",
		sheet = imp_sheet_hit,
		start = 1,
		count = 2,
		time = 200,
		loopCount = 1,
		loopDirection = "forward"
	},
	{
		name = "upRightHit",
		sheet = imp_sheet_hit,
		start = 3,
		count = 2,
		time = 200,
		loopCount = 1,
		loopDirection = "forward"
	},
	{
		name = "rightHit",
		sheet = imp_sheet_hit,
		start = 5,
		count = 2,
		time = 200,
		loopCount = 1,
		loopDirection = "forward"
	},
	{
		name = "downRightHit",
		sheet = imp_sheet_hit,
		start = 7,
		count = 2,
		time = 200,
		loopCount = 1,
		loopDirection = "forward"
	},
	{
		name = "downHit",
		sheet = imp_sheet_hit,
		start = 9,
		count = 2,
		time = 200,
		loopCount = 1,
		loopDirection = "forward"
	},
	{
		name = "upLeftHit",
		sheet = imp_sheet_hit,
		start = 11,
		count = 2,
		time = 200,
		loopCount = 1,
		loopDirection = "forward"
	},
	{
		name = "leftHit",
		sheet = imp_sheet_hit,
		start = 13,
		count = 2,
		time = 200,
		loopCount = 1,
		loopDirection = "forward"
	},
	{
		name = "downLeftHit",
		sheet = imp_sheet_hit,
		start = 15,
		count = 2,
		time = 200,
		loopCount = 1,
		loopDirection = "forward"
	}
}
return imp_seq