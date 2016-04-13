local S = {}
local colFilters = require "collisionFilters"
	local function spawn(links, x, y)
		local group = {}
			--local t = display.newImage("Graphics/Temp/sausage.png", 60, 20)
			group.display = display.newGroup( )
			group.myJoints = {}
			group.link = {}
			group.myName = "sausage"
			for i=1,links do
				local l = display.newImage("Graphics/Temp/sausage.png")
				l.width = l.width/10
				l.height = l.height/10
				l.x = x + l.width * i
				l.y = y
				l.super = l
				l.bounds = l
				physics.addBody( 	l, 
									"dynamic",
								{	density=1, 
									friction=0., 
									bounce=0.5,
									filter=colFilters.enemyCol
								})
				l.linearDamping = 3
				l.angularDamping = 3
				l.myName = "sausage"
				group.link[i] = l
				group.display:insert(group.link[i] )
				if (i > 1) then
					local prevLink = group.link[i-1] -- each link is joined with the one above it
					group.myJoints[#group.myJoints + 1] = physics.newJoint( "pivot", 
											prevLink, 
											l,
											prevLink.x + 25,
											prevLink.y,
											l.x + 25,
											l.y
											)
					--print
					--group.myJoints[#group.myJoints].isLimitEnable = true
					--group.myJoints[#group.myJoints]:setRotationLimits( -20, 20 )
				end
			end
		return group
	end
	S.spawn = spawn
return S