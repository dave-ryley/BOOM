local S = {}

	local function spawn(x, y)
		local g = require "globals"
		local col = require "collisionFilters"
		local T = {}
			T.bounds = display.newImageRect( "Graphics/items/shotgunPowerUp.png", 100, 100 )
			T.bounds.myName = "powerup"
			T.bounds.x = x
			T.bounds.y = y
			T.bounds.super = T
			T.myName = "powerup"
			print("making powerup: " .. x .. " : " .. y)
			physics.addBody( T.bounds, "kinematic", {
														isSensor=true,
														filter=col.sensorCol
													})
			T.powerup = function(event)
				local other = event.other.super
				other.shotgun.powerUp(1)
				display.remove( T.bounds )
			end
			T.bounds:addEventListener( "collision", T.powerup )
			
		return T
	end
	S.spawn = spawn
return S