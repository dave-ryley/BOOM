local S = {}


	local function spawn(x, y)

		local T = {}
			T = {}
						local col = require "collision_filters"
			T.bounds = display.newImageRect( GLOBAL_graphicsPath.."Traps/Death.png", 300, 300 )
			T.bounds.x = x
			T.bounds.y = y
			T.enemyType = "fireball"
			T.bounds.myName = "fireTrap"
			T.myName = "fireTrap"
			physics.addBody(
				T.bounds,
				"static",
				{
					isSensor=true,
					filter=col.sensorCol,
				}
			)
			T.bounds.super = T
		return T

	end
	S.spawn = spawn
return S
