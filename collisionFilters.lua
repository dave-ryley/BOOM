local C = {}
	C.playerCol =	{ categoryBits=1, 	maskBits=60 }
	C.shotgunCol= 	{ categoryBits=2, 	maskBits=4	}
	C.enemyCol 	=	{ categoryBits=4, 	maskBits=23	}
	C.sensorCol	=	{ categoryBits=8, 	maskBits=1	}
	C.wallCol	=	{ categoryBits=16,	maskBits=37	}
	C.projCol	=	{ categoryBits=32,	maslBits=17	}
return C
--[[

						1	2	4	8	16	32	64	128	|	SUM
==============================================================
Player	||category||	X								|	1
		||collides||			X	X	X				|	60
==============================================================
shotgun	||category||		X							|	2
		||collides||			X						|	4
==============================================================
Enemy	||category||			X						|	4
		||collides||	X	X	X		X				|	23
=============================================================
Sens	||category||				X					|	8
		||collides|| 	X								|	1
============================================================
Wall	||category||					X				|	16
		||collides|| 	X		X			X			|	37
============================================================
Proj	||category||						X			|	32
		||collides|| 	X				X				|	17
============================================================
--]]