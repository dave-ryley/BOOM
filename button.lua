B = {}

	function spawn (x, y, text) {
		local button = display.newImage( "Graphics/UI/Button.p", x, y )
		local buttonText = display.newText(text, x, y, "Curse of the Zombie", 40)
		buttonText:setFillColor( 1, 1, 0 )
		
		local pressSound = audio.loadSound( "Sounds/GUI/ButtonPress.ogg")
	}

end

B.spawn = spawn



function buttonPress( self, event )
		if event.phase == "began" then
			audio.play(press, {channel = 31})
			if self.id == 1 then
				composer.gotoScene( g.scenePath.."game" )
			elseif self.id == 2 then
				composer.gotoScene( g.scenePath.."leaderboard" )
			elseif self.id == 3 then
				composer.gotoScene( g.scenePath.."levelEditorScene" )
			elseif self.id == 4 then
				composer.gotoScene( g.scenePath.."credits" )
			elseif self.id == 5 then
				native.requestExit()
			end
			return true
		end
	end

	buttons = {}
	for i=1,numOfButtons do 
		buttons[i] = display.newRect(	g.acw/(numOfButtons*2) + (i-1)*g.acw/numOfButtons,
										g.ach - 100,
										g.acw*3/20,
										100)
		sceneGroup:insert(buttons[i])
		buttons[i]:setFillColor( 1, 0, 0 )
		buttons[i].id = i
		buttons[i].touch = buttonPress
		buttons[i]:addEventListener( "touch", buttons[i] )
	end

	if phase == "will" then
		for i=1,numOfButtons do 
			sceneGroup:insert(buttons[i])
		end
		buttonText = {"PLAY", "SCOREBOARD", "LEVEL EDITOR","CREDITS","QUIT"}
		text = {}
		for i=1,numOfButtons do
			text[i] = display.newText(	buttonText[i], 
										g.acw/(numOfButtons*2) + (i-1)*g.acw/numOfButtons,
										g.ach - 100, 
										"Curse of the Zombie",
										40)
			text[i]:setFillColor( 1, 1, 0 )
			sceneGroup:insert(text[i])
		end

return B