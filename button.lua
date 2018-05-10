 
local B = {}

	function spawn (x, y, text)
		local button = display.newImage( g.UIPath.."Button.png", x, y )
		button.text = display.newText(text, x, y-10, g.zombieFont, 35)
		button.text:setFillColor( 0, 0, 0 )

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
		local flamesSheet = graphics.newImageSheet( g.UIPath.."ButtonFire.png", flamesOptions )
		button.flames = display.newSprite( flamesSheet, flamesSeq )
		button.flames.x, button.flames.y = x, y -80
		button.flames:play( )
		button.flames.alpha = 0.0

		function highlight( boolean )
			if boolean then
				button.flames.alpha = 1.0
				button.text:setFillColor( 1, 1, 0 )
			else
				button.flames.alpha = 0.0
				button.text:setFillColor( 0, 0, 0 )
			end

		end

		button.highlight = highlight

		return button
	end

B.spawn = spawn

return B