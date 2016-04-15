local C = {}
local colFilters = require "collisionFilters"
	local function spawn( angle, x, y)
		local parts = {}
				local sausage = require "sausage"
				parts.disp = display.newGroup( )
				parts.disp.myName = "goreDisplay"
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
				        	bounce = 0.7,
				        	filter=colFilters.enemyCol
				        })
				    --p.isFixedRotation=true
					p:applyLinearImpulse( 
							math.cos(angle)*50, 
							math.sin(angle)*50 
							)
					p.isFixedRotation = true
					p.linearDamping = 3
					p.angularDamping = 3
					p.super = p
					p.bounds = p
					parts.disp:insert(p)
				end
				local s = sausage.spawn(4, x, y)
				s.link[math.ceil(#s.link/2)]:applyLinearImpulse( 
						math.cos(angle)*40, 
						math.sin(angle)*40, 
						50, 
						50 )
				parts.disp:insert(s.display)
		return parts.disp
	end
	--C[1] = parts.display
	C.spawn = spawn
return C