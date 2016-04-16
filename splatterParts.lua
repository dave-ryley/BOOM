local C = {}
local colFilters = require "collisionFilters"
local partsList = require "splatter"
local g = require "globals"
	local function spawn( angle, x, y)
		local files = partsList.imp
		local parts = {}
			local b = display.newImage( g.gorePath.."BloodSplatter.png")
			b.x = x
			b.y = y
			b.anchorY = 0.75
			b:scale(	1.2, 	1.2)
			local sausage = require "sausage"
			parts.disp = display.newGroup( )
			parts.disp.myName = "goreDisplay"
			b.rotation = angle
			parts.disp:insert(b)
			for i =1, #files do
				local p = display.newImage( files[i].path)
				p:scale(	1.5,	1.5)
				p.x = x + files[i].x
				p.y = y + files[i].y
				p.myName = "gore"
				physics.addBody( p,
			          	"dynamic",
			        {	density = 0.5,
			        	friction = 0.5,
			        	bounce = 0.7,
			        	filter=colFilters.enemyCol
			        })
			    --p.isFixedRotation=true
				p:applyForce( 
						math.cos(angle)*50, 
						math.sin(angle)*50 
						)
				--p.isFixedRotation = true
				p.linearDamping = 3
				p.angularDamping = 3
				p.super = p
				p.bounds = p
				parts.disp:insert(p)
			end
			local s = sausage.spawn(8, x, y)
			s.link[math.ceil(#s.link/2)]:applyForce( 
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