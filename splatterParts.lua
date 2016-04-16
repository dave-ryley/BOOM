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
			    --[[
				p:applyForce( 
						math.cos(angle)*50, 
						math.sin(angle)*50 
						)
				--p.isFixedRotation = true
				]]
				
				p.linearDamping = 5
				p.angularDamping = 5
				p.super = p
				p.bounds = p
				parts[i] = p
				parts.disp:insert(p)
			end
			local joints = {}

			local function createJoint(j1, j2, x1, y1, x2, y2)
				joints[#joints + 1] = physics.newJoint( "pivot",
														parts[j1],
														parts[j2],
														x + x1,
														y + y1,
														x + x2,
														y + y2)
				joints[#joints].isLimitEnable = true
				joints[#joints]:setRotationLimits( -5, 5 )
			end
			createJoint(1,2,60,134,60,134)
			createJoint(2,3,80,121,80,121)
			createJoint(3,4,88,155,88,155)
			createJoint(4,5,91,177,91,177)
			createJoint(5,6,83,192,83,192)
			createJoint(7,8,149,136,149,136)
			createJoint(8,9,134,120,134,120)
			createJoint(9,10,122,149,122,149)
			createJoint(10,11,129,174,129,174)
			createJoint(11,12,151,179,151,179)
			--createJoint(3,#files,92,153,92,153)
			--createJoint(9,#files,122,154,122,154)
			parts[#files]:applyForce( 
					math.cos(angle)*50, 
					math.sin(angle)*50 
					)
			--p.isFixedRotation = true
			--parts[14].linearDamping = 3
			--parts[14].angularDamping = 3

						joints[#joints].isLimitEnable = true
			joints[#joints]:setRotationLimits( -10, 10 )
			local s = sausage.spawn(8, x, y)
			s.link[math.ceil(#s.link/2)]:applyForce( 
					math.cos(angle)*20, 
					math.sin(angle)*20, 
					50, 
					50 )
			parts.disp:insert(s.display)

		return parts.disp
	end
	--C[1] = parts.display
	C.spawn = spawn
return C