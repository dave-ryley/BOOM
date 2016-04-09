local C = {}
	--C.collisionFilter = {categoryBits = 2, maskBits = 4}
	C.bounds = display.newImage( "Graphics/Temp/TestBlast.png")
	--C.bounds.alpha = 1.0
	C.bounds.anchorX = 0
	C.bounds.anchorY = 0.5
	C.bounds.alpha = 0
	
	C.bounds.reloading = false
	C.myName = "shotgunObject"
	C.bounds.myName = "shotgun"
	local blastShape = { 	0 	-C.bounds.width/2 ,0 -C.bounds.height/2, 
							320	-C.bounds.width/2 , 40 -C.bounds.height/2, 
							320	-C.bounds.width/2 , 80 -C.bounds.height/2, 
							0	-C.bounds.width/2 , 120 -C.bounds.height/2}
	physics.addBody( C.bounds, "dynamic", 	{ 	density=0.0, 
												friction=0.0, 
												bounce=0.0, 
												shape=blastShape, 
												isSensor=true
												--,filter=C.collisionFilter
											} )
	--C.bounds.filter = C.collisionFilter
	C.bounds.isSensor = true
	C.bounds.isAwake = false;
return C