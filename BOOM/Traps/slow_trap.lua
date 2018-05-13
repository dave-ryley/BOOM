local S = {}
	local function spawn(x, y)
		local T = {}
		local col = require "collision_filters"
		T.bounds = display.newImageRect( GLOBAL_graphicsPath.."Traps/Slow.png", 370, 370 )
		T.bounds.myName = "trap_slow"
		T.bounds.x = x
		T.bounds.y = y
		T.slow = 0.5
		physics.addBody(
			T.bounds,
			"static",
			{
				isSensor=true,
				filter=col.sensorCol,
			}
		)
		T.trap = function(event)
			local other = event.other.super
			if event.phase == "began" then
				other.slowModifier = T.slow
			elseif event.phase == "ended" then
				other.slowModifier = 1.0
			end
			return true
		end
		T.bounds:addEventListener( "collision", T.trap )
		return T

	end
	S.spawn = spawn
return S
