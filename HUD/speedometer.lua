local N = {}

	local function spawn()

		local number_sheetOptions =
		{
			width = 150,
			height = 160,
			numFrames = 10
		}
		local number_sheet = graphics.newImageSheet( g.graphicsPath.."UI/NumberFont.png",
														number_sheetOptions )
		local number_seq =
		{
			{
				name = "0",
				start = 1,
				count = 1,
				time = 1,
				loopCount = 1,
				loopDirection = "forward"
			},
			{
				name = "1",
				start = 2,
				count = 1,
				time = 1,
				loopCount = 1,
				loopDirection = "forward"
			},
			{
				name = "2",
				start = 3,
				count = 1,
				time = 1,
				loopCount = 1,
				loopDirection = "forward"
			},
			{
				name = "3",
				start = 4,
				count = 1,
				time = 1,
				loopCount = 1,
				loopDirection = "forward"
			},
			{
				name = "4",
				start = 5,
				count = 1,
				time = 1,
				loopCount = 1,
				loopDirection = "forward"
			},
			{
				name = "5",
				start = 6,
				count = 1,
				time = 1,
				loopCount = 1,
				loopDirection = "forward"
			},
			{
				name = "6",
				start = 7,
				count = 1,
				time = 1,
				loopCount = 1,
				loopDirection = "forward"
			},
			{
				name = "7",
				start = 8,
				count = 1,
				time = 1,
				loopCount = 1,
				loopDirection = "forward"
			},
			{
				name = "8",
				start = 9,
				count = 1,
				time = 1,
				loopCount = 1,
				loopDirection = "forward"
			},
			{
				name = "9",
				start = 10,
				count = 1,
				time = 1,
				loopCount = 1,
				loopDirection = "forward"
			}
		}

		local number = display.newGroup( )
		number.tens = display.newSprite( number_sheet, number_seq )
		number.units = display.newSprite( number_sheet, number_seq )
		number.tens.x = -70
		number.units.x = 50
		number:insert( number.tens )
		number:insert( number.units )

		local function set( num )
				number.tens:setSequence( "" .. math.floor(num/10) )
				number.units:setSequence("" .. num % 10)
		end

		number.set = set

		return number
	end

N.spawn = spawn

return N
