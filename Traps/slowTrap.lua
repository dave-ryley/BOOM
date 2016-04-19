local S = {}


	local function spawn(x, y)

		local T = {}
			T = {}

			local col = require "collisionFilters"
			--T.joint = nil
			--print(col.sensorCol.categoryBits)
			T.bounds = display.newImageRect( "Graphics/Traps/slow.png", 370, 370 )
			T.bounds.myName = "trap_slow"
			T.bounds.x = x
			T.bounds.y = y
			T.slow = 0.5
			T.previousSpeed = 0
			physics.addBody( T.bounds, "static", 	{
														isSensor=true,
														filter=col.sensorCol,

													})

			T.trap = function(event)
				local other = event.other.super
				if (event.phase == "began") then
					print(event.phase.." caught in slow trap")
					T.previousSpeed = other.maxSpeed
					other.maxSpeed = T.previousSpeed * T.slow
				elseif (event.phase=="ended") then
					print(event.phase.." left slow trap")
					other.maxSpeed = T.previousSpeed
				end
				return true
			end
			T.bounds:addEventListener( "collision", T.trap )
		return T 

	end
	S.spawn = spawn
return S