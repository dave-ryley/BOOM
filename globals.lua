G = {}

	---- PATHS ----
	G.scenePath = "Scenes."
	G.animationPath = "Graphics/Animation/"
	G.gorePath = "Graphics/Animation/Gore/"
	G.backgroundPath = "Graphics/Background/"
	G.musicPath = "Sounds/Music/"
	G.UIPath = "Graphics/UI/"

	---- COMMON VALUES ----
	G.cw = display.contentWidth
	G.ch = display.contentHeight
	G.acw = display.actualContentWidth
	G.ach = display.actualContentHeight
	G.ccx = display.contentCenterX
	G.ccy = display.contentCenterY

	---- PLAYER STATS ----
	G.shotgun = 10
	G.speed = 1000.0
	G.time = 500.0
	G.deaths = 0
	G.kills = 0
	G.goldTime = 100 -- time needed in seconds to gain a gold medal
	G.silverTime = 200 -- time needed in seconds to gain a silver medal

	---- GAME INFO -----
	G.level = 1
	G.health = 3
	G.maxGore = 20
	G.lastLevel = 2
	G.gameState = "intro" --intro/introTrans/win/
	G.pause = false

	---- OTHER -----
	G.drawMode = "normal"
	G.android = (system.getInfo("platformName") == "Android")
	--G.android = true

return G