local P = {}

local function spawn()

	local pause_sheetOptions =
	{
		width = 230,
		height = 230,
		numFrames = 2
	}
	local pause_sheet = graphics.newImageSheet( g.UIPath.."PausePlay.png", 
													pause_sheetOptions )
	local pause_seq = 
	{
		{
			name = "default",
			start = 1,
			count = 1,
			time = 1,
			loopCount = 1,
			loopDirection = "forward"
		},
		{
			name = "play",
			start = 2,
			count = 1,
			time = 1,
			loopCount = 1,
			loopDirection = "forward"
		}
	}

	local pauseButton = display.newSprite( pause_sheet, pause_seq )

	local function change( id )
		if id == 2 then
			pauseButton:setSequence( "play" )
		else
			pauseButton:setSequence( "default" )
		end
	end

	pauseButton.change = change

	return pauseButton
end

P.spawn = spawn

return P