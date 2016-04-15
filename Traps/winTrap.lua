local S = {}

	local function spawn(id)

		local col = require "collisionFilters"
		local T = {}
			T.bounds = display.newImageRect( "Graphics/Temp/win.png", 300, 300 )
			T.bounds.myName = "trap_win"
			physics.addBody( T.bounds, "kinematic", {
														isSensor=true,
														filter=col.sensorCol
													})
			T.win = function(event)
				Runtime:dispatchEvent( { name="youWin"})
			end
			T.bounds:addEventListener( "collision", T.win )
			
		return T
	end
	S.spawn = spawn
return S