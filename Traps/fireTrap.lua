local S = {}

	local function spawn(id)

		local T = {}
			T.bounds = display.newImageRect( "Graphics/Traps/death.png", 300, 300 )
			T.bounds.myName = "trap_fire"
			physics.addBody( T.bounds, "kinematic", {
														isSensor=true
													})
		return T
	end
	S.spawn = spawn
return S