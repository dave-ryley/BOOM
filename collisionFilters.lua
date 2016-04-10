local C = {}
	C.playerCol =	{ categoryBits=1, maskBits=28 }
	C.shotgunCol= 	{ categoryBits=2, maskBits=20}
	C.enemyCol 	=	{ categoryBits=4, maskBits=19}
	C.sensorCol	=	{ categoryBits=8, maskBits=17}
	C.wallCol	=	{ categoryBits=16, maskBits=15}
return C
--[[

						1	2	4	8	16	32	64	128	|	SUM
==============================================================
Player	||category||	X								|	1
		||collides||			X	X	X				|	28
==============================================================
shotgun	||category||		X							|	2
		||collides||			X		X				|	20
==============================================================
Enemy	||category||			X						|	4
		||collides||	X	X			X				|	19
=============================================================
Sens	||category||				X					|	8
		||collides|| 	X				X				|	17
============================================================

--]]