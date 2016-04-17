G = {}
	G.android = (system.getInfo("platformName") == "Android")
	--G.android = true
	G.pause = false
	G.scenePath = "Scenes."
	G.animationPath = "Graphics/Animation/"
	G.gorePath = "Graphics/Animation/Gore/"
	G.backgroundPath = "Graphics/Background/"
	G.musicPath = "Sounds/Music/"
	G.cw = display.contentWidth
	G.ch = display.contentHeight
	G.acw = display.actualContentWidth
	G.ach = display.actualContentHeight
	G.ccx = display.contentCenterX
	G.ccy = display.contentCenterY
	G.level = 1
	G.health = 3
	G.maxGore = 20
	G.drawMode = "normal"
	G.lastLevel = 2
	G.gameState = "intro" --intro/introTrans/win/

return G