local S = {}

	local function spawn()
				local spot_sheetOptions =
				{
					width = 300,
					height = 300,
					numFrames = 64
				}

		local spot_sheet_nice = graphics.newImageSheet( g.animationPath.."SpotRun.png",
														spot_sheetOptions )
		local spot_sheet_evil = graphics.newImageSheet( g.animationPath.."SpotTransformHit.png",
														spot_sheetOptions )

		local spot_seq =
		{
			{
				name = "UpRun",
				sheet=spot_sheet_nice,
				start = 1,
				count = 8,
				time = 800,
				loopCount = 0,
				loopDirection = "forward"
			},
			{
				name = "UpRightRun",
				sheet=spot_sheet_nice,
				start = 9,
				count = 8,
				time = 800,
				loopCount = 0,
				loopDirection = "forward"
			},
			{
				name = "RightRun",
				sheet=spot_sheet_nice,
				start = 17,
				count = 8,
				time = 800,
				loopCount = 0,
				loopDirection = "forward"
			},
			{
				name = "DownRightRun",
				sheet=spot_sheet_nice,
				start = 25,
				count = 8,
				time = 800,
				loopCount = 0,
				loopDirection = "forward"
			},
			{
				name = "DownRun",
				sheet=spot_sheet_nice,
				start = 33,
				count = 8,
				time = 800,
				loopCount = 0,
				loopDirection = "forward"
			},
			{
				name = "UpLeftRun",
				sheet=spot_sheet_nice,
				start = 41,
				count = 8,
				time = 800,
				loopCount = 0,
				loopDirection = "forward"
			},
			{
				name = "LeftRun",
				sheet=spot_sheet_nice,
				start = 49,
				count = 8,
				time = 800,
				loopCount = 0,
				loopDirection = "forward"
			},
			{
				name = "DownLeftRun",
				sheet=spot_sheet_nice,
				start = 57,
				count = 8,
				time = 800,
				loopCount = 0,
				loopDirection = "forward"
			},
			{
				name = "UpRunEvil",
				sheet=spot_sheet_evil,
				start = 1,
				count = 6,
				time = 600,
				loopCount = 1,
				loopDirection = "forward"
			},
			{
				name = "UpRightRunEvil",
				sheet=spot_sheet_evil,
				start = 9,
				count = 6,
				time = 600,
				loopCount = 1,
				loopDirection = "forward"
			},
			{
				name = "RightRunEvil",
				sheet=spot_sheet_evil,
				start = 17,
				count = 6,
				time = 600,
				loopCount = 1,
				loopDirection = "forward"
			},
			{
				name = "DownRightRunEvil",
				sheet=spot_sheet_evil,
				start = 25,
				count = 6,
				time = 600,
				loopCount = 1,
				loopDirection = "forward"
			},
			{
				name = "DownRunEvil",
				sheet=spot_sheet_evil,
				start = 33,
				count = 6,
				time = 600,
				loopCount = 1,
				loopDirection = "forward"
			},
			{
				name = "UpLeftRunEvil",
				sheet=spot_sheet_evil,
				start = 41,
				count = 6,
				time = 600,
				loopCount = 1,
				loopDirection = "forward"
			},
			{
				name = "LeftRunEvil",
				sheet=spot_sheet_evil,
				start = 49,
				count = 6,
				time = 600,
				loopCount = 1,
				loopDirection = "forward"
			},
			{
				name = "DownLeftRunEvil",
				sheet=spot_sheet_evil,
				start = 57,
				count = 6,
				time = 600,
				loopCount = 1,
				loopDirection = "forward"
			},
			--HIT ANIMATIONS
			{
				name = "UpRunHit",
				sheet=spot_sheet_evil,
				start = 7,
				count = 2,
				time = 200,
				loopCount = 1,
				loopDirection = "forward"
			},
			{
				name = "UpRightRunHit",
				sheet=spot_sheet_evil,
				start = 15,
				count = 2,
				time = 200,
				loopCount = 1,
				loopDirection = "forward"
			},
			{
				name = "RightRunHit",
				sheet=spot_sheet_evil,
				start = 23,
				count = 2,
				time = 200,
				loopCount = 1,
				loopDirection = "forward"
			},
			{
				name = "DownRightRunHit",
				sheet=spot_sheet_evil,
				start = 31,
				count = 2,
				time = 200,
				loopCount = 1,
				loopDirection = "forward"
			},
			{
				name = "DownRunHit",
				sheet=spot_sheet_evil,
				start = 39,
				count = 2,
				time = 200,
				loopCount = 1,
				loopDirection = "forward"
			},
			{
				name = "UpLeftRunHit",
				sheet=spot_sheet_evil,
				start = 47,
				count = 2,
				time = 200,
				loopCount = 1,
				loopDirection = "forward"
			},
			{
				name = "LeftRunHit",
				sheet=spot_sheet_evil,
				start = 55,
				count = 2,
				time = 200,
				loopCount = 1,
				loopDirection = "forward"
			},
			{
				name = "DownLeftRunHit",
				sheet=spot_sheet_evil,
				start = 63,
				count = 2,
				time = 200,
				loopCount = 1,
				loopDirection = "forward"
			}
		}
		return spot_seq
	end
	S.spawn = spawn
return S
