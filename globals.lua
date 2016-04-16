G = {}
	G.android = (system.getInfo("platformName") == "Android")
	--G.android = true
	G.pause = false
	G.scenePath = "Scenes."
	G.animationPath = "Graphics/Animation/"
	G.gorePath = "Graphics/Animation/Gore/"
	G.backgroundPath = "Graphics/Background/"
	G.cw = display.contentWidth
	G.ch = display.contentHeight
	G.acw = display.actualContentWidth
	G.ach = display.actualContentHeight
	G.ccx = display.contentCenterX
	G.ccy = display.contentCenterY
	G.level = 1
	G.health = 2
	G.maxGore = 20

return G