local C = {}
	local function spawn(angle, x, y)
		local parts = {}
				local sausage = require "sausage"
				parts.display = display.newGroup( )
				for i =1,4 do
					local p = display.newImage(
						"Graphics/Temp/TestFaceShattered/facePiece"..i..".png")
					p.x = x
					p.y = y
					p.myName = "gore"
					physics.addBody( p,
				          	"dynamic",
				        {	density = 0.5,
				        	friction = 0.5,
				        	bounce = 0.9
				        })
					p:applyLinearImpulse( 
						math.cos(angle)*50, 
						math.sin(angle)*50, 
						50, 
						50 )
					p.linearDamping = 2
					p.angularDamping = 2
					parts.display:insert(p)
				end
				parts.display:insert(sausage.spawn(3).display)
		return parts.display
	end
	--C[1] = parts.display
	C.spawn = spawn
return C