local S = {}

	local function spawn(id)

		local T = {}
			T.bounds = display.newImageRect( "Graphics/Temp/slowTrap.png", 300, 300 )
			T.bounds.myName = "trap_slow"
			
			physics.addBody( T.bounds, "dynamic", {
														isSensor=true
													})
		return T
	end
	S.spawn = spawn
return S