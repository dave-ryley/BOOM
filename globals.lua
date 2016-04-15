G = {}
	G.android = (system.getInfo("platformName") == "Android")
	--G.android = true
	G.pause = false
	G.scenePath = "Scenes."
	G.animationPath = "Graphics/Animation/"
	G.cw = display.contentWidth
	G.ch = display.contentHeight
	G.acw = display.actualContentWidth
	G.ach = display.actualContentHeight
	G.ccx = display.contentCenterX
	G.ccy = display.contentCenterY

return G