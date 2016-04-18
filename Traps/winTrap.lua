local S = {}

	local function spawn(x, y)
		local g = require "globals"
		local col = require "collisionFilters"
		local T = {}
			T.bounds = display.newRect( x,y, 128*5, 128*5 )
			T.bounds.myName = "trap_win"
			T.bounds.alpha = 0.0
			T.bounds.super = T
			T.myName = "trap_win"
			physics.addBody( T.bounds, "kinematic", {
														isSensor=true,
														filter=col.sensorCol
													})
			T.win = function(event)
				if(g.gameState == "playing") then
					--print("in win tile")
					Runtime:dispatchEvent( { name="youWin"})
				end
			end
			T.bounds:addEventListener( "collision", T.win )
			
		return T
	end
	S.spawn = spawn
return S