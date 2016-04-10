local S = {}

	local function spawn(id)

		local T = {}
			T.bounds = display.newImageRect( "Graphics/Temp/win.png", 300, 300 )
			T.bounds.myName = "trap_win"
			physics.addBody( T.bounds, "kinematic", {
														isSensor=true
													})
			
		return T
	end
	S.spawn = spawn
return S