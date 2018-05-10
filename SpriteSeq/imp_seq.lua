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
		name = "UpStand",
		sheet = imp_sheet_stand,
		start = 1,
		count = 8,
		time = 800,
		loopCount = 0,
		loopDirection = "forward"
	},
	{
		name = "UpRightStand",
		sheet = imp_sheet_stand,
		start = 9,
		count = 8,
		time = 800,
		loopCount = 0,
		loopDirection = "forward"
	},
	{
		name = "RightStand",
		sheet = imp_sheet_stand,
		start = 17,
		count = 8,
		time = 800,
		loopCount = 0,
		loopDirection = "forward"
	},
	{
		name = "DownRightStand",
		sheet = imp_sheet_stand,
		start = 25,
		count = 8,
		time = 800,
		loopCount = 0,
		loopDirection = "forward"
	},
	{
		name = "DownStand",
		sheet = imp_sheet_stand,
		start = 33,
		count = 8,
		time = 800,
		loopCount = 0,
		loopDirection = "forward"
	},
	{
		name = "UpLeftStand",
		sheet = imp_sheet_stand,
		start = 41,
		count = 8,
		time = 800,
		loopCount = 0,
		loopDirection = "forward"
	},
	{
		name = "LeftStand",
		sheet = imp_sheet_stand,
		start = 49,
		count = 8,
		time = 800,
		loopCount = 0,
		loopDirection = "forward"
	},
	{
		name = "DownLeftStand",
		sheet = imp_sheet_stand,
		start = 57,
		count = 8,
		time = 800,
		loopCount = 0,
		loopDirection = "forward"
	},
	{
		name = "UpShoot",
		sheet = imp_sheet_shoot,
		start = 1,
		count = 7,
		time = 700,
		loopCount = 0,
		loopDirection = "forward"
	},
	{
		name = "UpRightShoot",
		sheet = imp_sheet_shoot,
		start = 8,
		count = 7,
		time = 700,
		loopCount = 0,
		loopDirection = "forward"
	},
	{
		name = "RightShoot",
		sheet = imp_sheet_shoot,
		start = 15,
		count = 7,
		time = 700,
		loopCount = 0,
		loopDirection = "forward"
	},
	{
		name = "DownRightShoot",
		sheet = imp_sheet_shoot,
		start = 22,
		count = 7,
		time = 700,
		loopCount = 0,
		loopDirection = "forward"
	},
	{
		name = "DownShoot",
		sheet = imp_sheet_shoot,
		start = 29,
		count = 7,
		time = 700,
		loopCount = 0,
		loopDirection = "forward"
	},
	{
		name = "UpLeftShoot",
		sheet = imp_sheet_shoot,
		start = 36,
		count = 7,
		time = 700,
		loopCount = 0,
		loopDirection = "forward"
	},
	{
		name = "lLeftShoot",
		sheet = imp_sheet_shoot,
		start = 43,
		count = 7,
		time = 700,
		loopCount = 0,
		loopDirection = "forward"
	},
	{
		name = "DownLeftShoot",
		sheet = imp_sheet_shoot,
		start = 50,
		count = 7,
		time = 700,
		loopCount = 0,
		loopDirection = "forward"
	},
	{
		name = "UpHit",
		sheet = imp_sheet_hit,
		start = 1,
		count = 2,
		time = 200,
		loopCount = 1,
		loopDirection = "forward"
	},
	{
		name = "UpRightHit",
		sheet = imp_sheet_hit,
		start = 3,
		count = 2,
		time = 200,
		loopCount = 1,
		loopDirection = "forward"
	},
	{
		name = "RightHit",
		sheet = imp_sheet_hit,
		start = 5,
		count = 2,
		time = 200,
		loopCount = 1,
		loopDirection = "forward"
	},
	{
		name = "DownRightHit",
		sheet = imp_sheet_hit,
		start = 7,
		count = 2,
		time = 200,
		loopCount = 1,
		loopDirection = "forward"
	},
	{
		name = "DownHit",
		sheet = imp_sheet_hit,
		start = 9,
		count = 2,
		time = 200,
		loopCount = 1,
		loopDirection = "forward"
	},
	{
		name = "UpLeftHit",
		sheet = imp_sheet_hit,
		start = 11,
		count = 2,
		time = 200,
		loopCount = 1,
		loopDirection = "forward"
	},
	{
		name = "LeftHit",
		sheet = imp_sheet_hit,
		start = 13,
		count = 2,
		time = 200,
		loopCount = 1,
		loopDirection = "forward"
	},
	{
		name = "DownLeftHit",
		sheet = imp_sheet_hit,
		start = 15,
		count = 2,
		time = 200,
		loopCount = 1,
		loopDirection = "forward"
	}
}
return imp_seq
