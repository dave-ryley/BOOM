local S = {}
	local function spawn()
		local g = require "globals"
		local satan_DownWalkSheetOptions =
		{
			width = 730,
			height = 690,
			numFrames = 12
		}
		local satan_DownSideWalkSheetOptions =
		{
			width = 710,
			height = 690,
			numFrames = 12
		}
		local satan_SideWalkSheetOptions =
		{
			width = 690,
			height = 700,
			numFrames = 12
		}
		local satan_UpWalkSheetOptions =
		{
			width = 704,
			height = 725,
			numFrames = 12
		}
		local satan_UpSideWalkSheetOptions =
		{
			width = 690,
			height = 680,
			numFrames = 12
		}

		local satan_sheetDownWalk 	= graphics.newImageSheet( g.animationPath..
															"Satan/walk_down.png", 
															satan_DownWalkSheetOptions )
		local satan_sheetDownRight	= graphics.newImageSheet( g.animationPath..
															"Satan/walk_downSide.png", 
															satan_DownSideWalkSheetOptions )
		local satan_sheetRight 		= graphics.newImageSheet( g.animationPath..
															"Satan/walk_side.png", 
															satan_SideWalkSheetOptions )
		local satan_sheetUpRight	 = graphics.newImageSheet( g.animationPath..
															"Satan/walk_upSide.png", 
															satan_UpSideWalkSheetOptions)
		local satan_sheetUp		 	= graphics.newImageSheet( g.animationPath..
															"Satan/walk_up.png", 
															satan_UpWalkSheetOptions  )
		local satan_sheetLeft		= graphics.newImageSheet( g.animationPath..
															"Satan/walk_side.png", 
															satan_SideWalkSheetOptions )
		local satan_sheetUpLeft		= graphics.newImageSheet( g.animationPath..
															"Satan/walk_upSide.png", 
															satan_UpSideWalkSheetOptions)
		local satan_sheetDownLeft	= graphics.newImageSheet( g.animationPath..
															"Satan/walk_downSide.png", 
															satan_DownSideWalkSheetOptions )
		--satan_sheetLeft.xScale = -1
		--satan_sheetUpLeft.xScale = -1
		--satan_sheetDownLeft.xScale = -1


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
			},
			{
				name = "downRightWalk",
				sheet = satan_sheetDownRight,
				start = 1,
				count = 12,
				time = 1800,
				loopCount = 0,
				loopDirection = "forward"
			},
			{
				name = "rightWalk",
				sheet = satan_sheetRight,
				start = 1,
				count = 12,
				time = 1800,
				loopCount = 0,
				loopDirection = "forward"
			},
			{
				name = "upRightWalk",
				sheet = satan_sheetUpRight,
				start = 1,
				count = 12,
				time = 1800,
				loopCount = 0,
				loopDirection = "forward"
			},
			{
				name = "upWalk",
				sheet = satan_sheetUp,
				start = 1,
				count = 12,
				time = 1800,
				loopCount = 0,
				loopDirection = "forward"
			},
			{
				name = "downLeftWalk",
				sheet = satan_sheetDownLeft,
				start = 1,
				count = 12,
				time = 1800,
				loopCount = 0,
				loopDirection = "forward"
			},
			{
				name = "leftWalk",
				sheet = satan_sheetLeft,
				start = 1,
				count = 12,
				time = 1800,
				loopCount = 0,
				loopDirection = "forward"
			},
			{
				name = "upLeftWalk",
				sheet = satan_sheetUpLeft,
				start = 1,
				count = 12,
				time = 1800,
				loopCount = 0,
				loopDirection = "forward"
			},
		}


		satan_sprite = display.newSprite( satan_sheetDownWalk, satan_seq )

		return satan_sprite
	end
	S.spawn = spawn
return S
	