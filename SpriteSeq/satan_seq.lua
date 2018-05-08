local S = {}
	local function spawn()
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
															"Satan/WalkDown.png",
															satan_DownWalkSheetOptions )
		local satan_sheetDownRight	= graphics.newImageSheet( g.animationPath..
															"Satan/WalkDownSide.png",
															satan_DownSideWalkSheetOptions )
		local satan_sheetRight 		= graphics.newImageSheet( g.animationPath..
															"Satan/WalkSide.png",
															satan_SideWalkSheetOptions )
		local satan_sheetUpRight	 = graphics.newImageSheet( g.animationPath..
															"Satan/WalkUpSide.png",
															satan_UpSideWalkSheetOptions)
		local satan_sheetUp		 	= graphics.newImageSheet( g.animationPath..
															"Satan/WalkUp.png",
															satan_UpWalkSheetOptions  )
		local satan_sheetLeft		= graphics.newImageSheet( g.animationPath..
															"Satan/WalkSide.png",
															satan_SideWalkSheetOptions )
		local satan_sheetUpLeft		= graphics.newImageSheet( g.animationPath..
															"Satan/WalkUpSide.png",
															satan_UpSideWalkSheetOptions)
		local satan_sheetDownLeft	= graphics.newImageSheet( g.animationPath..
															"Satan/WalkDownSide.png",
															satan_DownSideWalkSheetOptions )

		local satan_seq =
		{
			{
				name = "DownWalk",
				sheet = satan_sheetDownWalk,
				start = 1,
				count = 12,
				time = 1800,
				loopCount = 0,
				loopDirection = "forward"
			},
			{
				name = "DownRightWalk",
				sheet = satan_sheetDownRight,
				start = 1,
				count = 12,
				time = 1800,
				loopCount = 0,
				loopDirection = "forward"
			},
			{
				name = "RightWalk",
				sheet = satan_sheetRight,
				start = 1,
				count = 12,
				time = 1800,
				loopCount = 0,
				loopDirection = "forward"
			},
			{
				name = "UpRightWalk",
				sheet = satan_sheetUpRight,
				start = 1,
				count = 12,
				time = 1800,
				loopCount = 0,
				loopDirection = "forward"
			},
			{
				name = "UpWalk",
				sheet = satan_sheetUp,
				start = 1,
				count = 12,
				time = 1800,
				loopCount = 0,
				loopDirection = "forward"
			},
			{
				name = "DownLeftWalk",
				sheet = satan_sheetDownLeft,
				start = 1,
				count = 12,
				time = 1800,
				loopCount = 0,
				loopDirection = "forward"
			},
			{
				name = "LeftWalk",
				sheet = satan_sheetLeft,
				start = 1,
				count = 12,
				time = 1800,
				loopCount = 0,
				loopDirection = "forward"
			},
			{
				name = "UpLeftWalk",
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
