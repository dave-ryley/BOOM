local C = {}
	C.playerCol =	{ categoryBits=1, 	maskBits=252 	}
	C.shotgunCol= 	{ categoryBits=2, 	maskBits=132	}
	C.enemyCol 	=	{ categoryBits=4, 	maskBits=83		}
	C.sensorCol	=	{ categoryBits=8, 	maskBits=1		}
	C.wallCol	=	{ categoryBits=16,	maskBits=133	}
	C.projCol	=	{ categoryBits=32,	maskBits=1		}
	C.satanCol	=	{ categoryBits=64,	maskBits=133	}
	C.goreCol	=	{ categoryBits=128,	maskBits=211	}
return C
--[[

						1	2	4	8	16	32	64	128	|	SUM
==============================================================
Player	||category||	X								|	1
		||collides||			X	X	X	X	X	X	|	252
==============================================================
shotgun	||category||		X							|	2
		||collides||			X					X	|	132
==============================================================
Enemy	||category||			X						|	4
		||collides||	X	X			X		X		|	83
=============================================================
Sens	||category||				X					|	8
		||collides|| 	X								|	1
============================================================
Wall	||category||					X				|	16
		||collides|| 	X		X					X	|	133
============================================================
Proj	||category||						X			|	32
		||collides|| 	X								|	1
============================================================
Satan	||category||							X		|	64
		||collides|| 	X		X					X	|	133
============================================================
Gore	||category||								X	|	128
		||collides|| 	X	X			X		X	X	|	211
============================================================
--]]