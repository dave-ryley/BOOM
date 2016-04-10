local C = {}
	C.playerCol =	{ categoryBits=1, maskBits=12 }
	C.shotgunCol= 	{ categoryBits=2, maskBits=4}
	C.enemyCol 	=	{ categoryBits=4, maskBits=3}
	C.sensorCol	=	{ categoryBits=8, maskBits=1}

return C
--[[

						1	2	4	8	16	32	64	128	|	SUM
==============================================================
Player	||category||	X								|	1
		||collides||			X	X					|	12
==============================================================
shotgun	||category||		X							|	2
		||collides||			X						|	4
==============================================================
Pup		||category||			X						|	4
		||collides||	X	X							|	3
=============================================================
Sens	||category||				X					|	8
		||collides|| 	X								|	1
============================================================

--]]