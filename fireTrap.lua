local S = {}
	--S.col = require "collisionFilters"
	S.bounds = display.newImageRect( "Graphics/Temp/fireTrap.png", 300, 300 )
	S.bounds.myName = "trap_fire"
	physics.addBody( S.bounds, "dynamic", {
												isSensor=true
											})
return S