local B = {}

	function spawn (x, y, text)
		local b = {}
		b.button = display.newImage( "Graphics/UI/Button.png", x, y )
		b.button.text = display.newText(text, x, y-10, "Curse of the Zombie", 35)
		b.button.text:setFillColor( 1, 1, 0 )
		b.button.sound = audio.loadSound( "Sounds/GUI/ButtonPress.ogg")

		return b
	end

B.spawn = spawn

return B