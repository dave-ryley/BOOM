local C = {}

	C.bounds = display.newImage( "Graphics/Temp/TestFace.png")
	--C.bounds.alpha = 1.0
	C.anchorX = 0
	C.anchorY = 0.5
	C.bounds.alpha = 0
	C.bounds.isAwake = false;
	--C.name = "shotgun"
	C.bounds.myName = "shotgun"
	local blastShape = { 	0 	-C.bounds.width/2 ,0 -C.bounds.height/2, 
							320	-C.bounds.width/2 , 40 -C.bounds.height/2, 
							320	-C.bounds.width/2 , 80 -C.bounds.height/2, 
							0	-C.bounds.width/2 , 120 -C.bounds.height/2}
	physics.addBody( C.bounds, "dynamic", { 	density=0.0, 
													friction=0.0, 
													bounce=0.0, 
													shape=blastShape, 
													isSensor=true 
												} )
return C