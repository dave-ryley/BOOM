local json = require("json")

---- PATHS ----
GLOBAL_animationPath = "Resources/Graphics/Animation/"
GLOBAL_gorePath = "Resources/Graphics/Animation/Gore/"
GLOBAL_backgroundPath = "Resources/Graphics/Background/"
GLOBAL_soundsPath = "Resources/Sounds/"
GLOBAL_musicPath = "Resources/Sounds/Music/"
GLOBAL_UIPath = "Resources/Graphics/UI/"
GLOBAL_levelsPath = "Resources/Levels/"
GLOBAL_file_save_highscores = "highscores_new.txt"
GLOBAL_fontPath = "Resources/Fonts/"

---- COMMON VALUES ----
GLOBAL_cw = display.contentWidth
GLOBAL_ch = display.contentHeight
GLOBAL_acw = display.actualContentWidth
GLOBAL_ach = display.actualContentHeight
GLOBAL_ccx = display.contentCenterX
GLOBAL_ccy = display.contentCenterY

---- PLAYER STATS ----
GLOBAL_shotgun = 10
GLOBAL_speed = 1000.0
GLOBAL_time = 0.0
GLOBAL_deaths = 0
GLOBAL_kills = 0
GLOBAL_goldTime = 360000 -- 6 minutes.. time needed in milliseconds to gain a gold medal
GLOBAL_silverTime = 600000 -- 10 minutes.. time in milliseconds to gain a silver medal

---- HIGHSCORES ----

GLOBAL_highscores = {
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
GLOBAL_level = 1
GLOBAL_health = 3
GLOBAL_maxGore = 20
GLOBAL_lastLevel = 4
GLOBAL_gameState = "intro" --intro/introTrans/win/
GLOBAL_pause = false

-- To replace with config!
---- FONT NAMES -----
GLOBAL_bloodyFont = GLOBAL_fontPath .. "Bloody"
GLOBAL_comicBookFont = GLOBAL_fontPath .. "Avengeance Mightiest Avenger"
GLOBAL_zombieFont = GLOBAL_fontPath .. "Curse of the Zombie"
GLOBAL_lcdFont = GLOBAL_fontPath .. "LCD2 Bold"

---- OTHER -----
GLOBAL_drawMode = "normal"
GLOBAL_android = (system.getInfo("platformName") == "Android")
--GLOBAL_android = true

function GLOBAL_load_highscores ()
	print ("Loading Highscores")
	local path = system.pathForFile( GLOBAL_file_save_highscores, system.DocumentsDirectory )
	local file, errorString = io.open( path, "r" )
	if not file then 
		print ("File Error:" .. errorString)
		return 
	end
	local read_in = file:read( "*all" )
	if read_in == nil then return end
	GLOBAL_highscores = json.decode( read_in )
	file:close()
end

function GLOBAL_save_highscores ()
	print ("Saving highscores")
	local path = system.pathForFile( GLOBAL_file_save_highscores, system.DocumentsDirectory )
	local f, errorString = io.open( path, "w" )
	if not f then
		print ("File Error:" .. errorString)
	else
		local write_out = json.encode( GLOBAL_highscores )
		f:write( write_out )
		f:close()
	end
end