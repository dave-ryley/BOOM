json = require "json"

G = {}

	---- PATHS ----
	G.scenePath = "Scenes."
	G.animationPath = "Graphics/Animation/"
	G.gorePath = "Graphics/Animation/Gore/"
	G.backgroundPath = "Graphics/Background/"
	G.musicPath = "Sounds/Music/"
	G.UIPath = "Graphics/UI/"
	G.file_save_highscores = "highscores_new.txt"

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
	G.time = 0.0
	G.deaths = 0
	G.kills = 0
	G.goldTime = 360000 -- 6 minutes.. time needed in milliseconds to gain a gold medal
	G.silverTime = 600000 -- 10 minutes.. time in milliseconds to gain a silver medal

	---- HIGHSCORES ----

	G.highscores = {
		{
			medal = 1,
			name = "Dave",
			time = 100000,
			deaths = 21,
			kills = 46
		},
		{
			medal = 3,
			name = "Roger",
			time = 600000,
			deaths = 99,
			kills = 99
		},
		{
			medal = 3,
			name = "Esther",
			time = 600000,
			deaths = 99,
			kills = 99
		},
		{
			medal = 3,
			name = "Gary",
			time = 600000,
			deaths = 99,
			kills = 99
		},
		{
			medal = 3,
			name = "Gary",
			time = 600000,
			deaths = 99,
			kills = 99
		},
		{
			medal = 3,
			name = "Gary",
			time = 600000,
			deaths = 99,
			kills = 99
		},
		{
			medal = 3,
			name = "Gary",
			time = 600000,
			deaths = 99,
			kills = 99
		},
		{
			medal = 3,
			name = "Gary",
			time = 600000,
			deaths = 99,
			kills = 99
		},
		{
			medal = 3,
			name = "Gary",
			time = 600000,
			deaths = 99,
			kills = 99
		},
		{
			medal = 3,
			name = "Gary",
			time = 600000,
			deaths = 99,
			kills = 99
		}
	}

	---- GAME INFO -----
	G.level = 1
	G.health = 3
	G.maxGore = 20
	G.lastLevel = 4
	G.gameState = "intro" --intro/introTrans/win/
	G.pause = false

	---- FONT NAMES -----
	G.bloodyFont = "Bloody"
	G.comicBookFont = "Avengeance Mightiest Avenger"
	G.zombieFont = "Curse of the Zombie"
	G.lcdFont = "LCD2 Bold"

	---- OTHER -----
	G.drawMode = "normal"
	G.android = (system.getInfo("platformName") == "Android")
	--G.android = true

	local function load_highscores ()
		print ("Loading Highscores")
		local path = system.pathForFile( G.file_save_highscores, system.DocumentsDirectory )
		local file, errorString = io.open( path, "r" )
		if not file then 
			print ("File Error:" .. errorString)
			return 
		end
    	local read_in = file:read( "*all" )
    	if read_in == nil then return end
    	G.highscores = json.decode( read_in )
    	file:close()
	end

	G.load_highscores = load_highscores

	local function save_highscores ()
		print ("Saving highscores")
    	local path = system.pathForFile( G.file_save_highscores, system.DocumentsDirectory )
    	local f, errorString = io.open( path, "w" )
    	if not f then
    		print ("File Error:" .. errorString)
    	else
    		local write_out = json.encode( G.highscores )
    		f:write( write_out )
    		f:close()
    	end
    end

    G.save_highscores = save_highscores

return G