ignore = {"131"}

files["BOOM/globals.lua"] = {ignore = {"111"}}
files["**/Scenes/*.lua"] = {ignore = {"211/sceneGroup", "542"}}
exclude_files = {"**/External/*.lua"}
allow_defined = true

globals = {
-- Corona globals -----------------
	"audio",
	"application",
	"display",
	"graphics",
	"lfs",
	"native",
	"media",
	"physics",
	"system",
	"timer",
	"transition",
	"Runtime",
-- BOOM globals -------------------
	"UNUSED_ARGUMENT",
	"GLOBAL_graphicsPath",
	"GLOBAL_animationPath",
	"GLOBAL_gorePath",
	"GLOBAL_backgroundPath",
	"GLOBAL_soundsPath",
	"GLOBAL_musicPath",
	"GLOBAL_UIPath",
	"GLOBAL_levelsPath",
	"GLOBAL_file_save_highscores",
	"GLOBAL_fontPath",
	"GLOBAL_scenePath",
	"GLOBAL_cw",
	"GLOBAL_ch",
	"GLOBAL_acw",
	"GLOBAL_ach",
	"GLOBAL_ccx",
	"GLOBAL_ccy",
	"GLOBAL_shotgun",
	"GLOBAL_speed",
	"GLOBAL_time",
	"GLOBAL_deaths",
	"GLOBAL_kills",
	"GLOBAL_goldTime",
	"GLOBAL_silverTime",
	"GLOBAL_highscores",
	"GLOBAL_level",
	"GLOBAL_health",
	"GLOBAL_maxGore",
	"GLOBAL_lastLevel",
	"GLOBAL_gameState",
	"GLOBAL_pause",
	"GLOBAL_bloodyFont",
	"GLOBAL_comicBookFont",
	"GLOBAL_zombieFont",
	"GLOBAL_lcdFont",
	"GLOBAL_drawMode",
	"GLOBAL_android",
	"GLOBAL_load_highscores",
	"GLOBAL_save_highscores"
}
