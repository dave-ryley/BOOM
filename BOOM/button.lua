local B = {}

local flamesSeq =
{
	{
		name = "default",
		start = 1,
		count = 6,
		time = 600,
		loopCount = 0,
		loopDirection = "forward"
	}
}

local flamesOptions =
{
	width = 370,
	height = 250,
	numFrames = 6
}

function B:new(x, y, text, callback)
	local button = display.newImage( GLOBAL_UIPath.."Button.png", x, y )
	button.text = display.newText(text, x, y-10, GLOBAL_zombieFont, 35)
	button.text:setFillColor( 0, 0, 0 )

	local flamesSheet = graphics.newImageSheet( GLOBAL_UIPath.."ButtonFire.png", flamesOptions )
	button.flames = display.newSprite( flamesSheet, flamesSeq )
	button.flames.x, button.flames.y = x, y -80
	button.flames:play( )
	button.flames.alpha = 0.0
	button.flames:toBack()

	button.callback = callback

	function button:touch( event )
		if event.phase == "began" then
			self.callback()
			return true
		end
	end

	button:addEventListener( "touch", button )

	function button:select()
		self.flames.alpha = 1.0
		self.text:setFillColor( 1, 1, 0 )
	end

	function button:deselect()
		self.flames.alpha = 0.0
		self.text:setFillColor( 0, 0, 0 )
	end

	function button:insertIntoScene(scene)
		scene:insert(self.flames)
		scene:insert(self)
		scene:insert(self.text)
	end

	return button
end

return B
