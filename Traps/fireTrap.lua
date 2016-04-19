local S = {}


	local function spawn(x, y)

		local T = {}
			T = {}

			local col = require "collisionFilters"
			--T.joint = nil
			--print(col.sensorCol.categoryBits)
			T.bounds = display.newImageRect( "Graphics/Traps/death.png", 300, 300 )
			T.bounds.x = x
			T.bounds.y = y
			T.enemyType = "fireball"
			T.bounds.myName = "fireTrap"
			T.myName = "fireTrap"
			physics.addBody( T.bounds, "static", 	{
														isSensor=true,
														filter=col.sensorCol,

													})
			T.bounds.super = T
		return T 

	end
	S.spawn = spawn
return S