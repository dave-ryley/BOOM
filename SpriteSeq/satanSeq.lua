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
		local satan_sheetDownSide 	= graphics.newImageSheet( g.animationPath..
															"Satan/walk_downSide.png", 
															satan_DownSideWalkSheetOptions )
		local satan_sheetSide 		= graphics.newImageSheet( g.animationPath..
															"Satan/walk_side.png", 
															satan_SideWalkSheetOptions )
		local satan_sheetUp		 	= graphics.newImageSheet( g.animationPath..
															"Satan/walk_up.png", 
															satan_UpWalkSheetOptions  )
		local satan_sheetUpSide	 	= graphics.newImageSheet( g.animationPath..
															"Satan/walk_upSide.png", 
															satan_UpSideWalkSheetOptions)
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
				sheet = satan_sheetDownSide,
				start = 1,
				count = 12,
				time = 1800,
				loopCount = 0,
				loopDirection = "forward"
			},
			{
				name = "rightWalk",
				sheet = satan_sheetSide,
				start = 1,
				count = 12,
				time = 1800,
				loopCount = 0,
				loopDirection = "forward"
			},
			{
				name = "upRightWalk",
				sheet = satan_sheetUpSide,
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
			}
		}


		satan_sprite = display.newSprite( satan_sheetDownWalk, satan_seq )

		return satan_sprite
	end
	S.spawn = spawn
return S
	