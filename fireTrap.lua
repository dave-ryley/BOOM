local S = {}

	S.bounds = display.newImageRect( "Graphics/Temp/fireTrap.png", 300, 300 )
	S.bounds.myName = "trap_fire"
	physics.addBody( S.bounds, "kinematic", {isSensor=true})
return S