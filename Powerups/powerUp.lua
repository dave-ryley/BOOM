local S = {}

	local function spawn(x, y)
		local g = require "globals"
		local col = require "collisionFilters"
		local T = {}
			T.bounds = display.newImageRect( "Graphics/Items/shotgunPowerUp.png", 100, 100 )
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
				local fx = audio.loadSound( "Sounds/PowerUps/ShotgunPowerUp.ogg")
				local other = event.other.super
				audio.play(fx,{channel = audio.findFreeChannel()})
				audio.dispose( fx )
				other.shotgun.powerUp(1)
				g.shotgun = other.shotgun.power
				display.remove( T.bounds )
			end
			T.bounds:addEventListener( "collision", T.powerup )
			
		return T
	end
	S.spawn = spawn
return S