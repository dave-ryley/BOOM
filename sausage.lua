local S = {}

	local function spawn(links)
		local group = {}
			--local t = display.newImage("Graphics/Temp/sausage.png", 60, 20)
			group.display = display.newGroup( )
			group.myJoints = {}
			group.link = {}
			group.myName = "sausage"
			for i=1,links do
				group.link[i] = display.newImage("Graphics/Temp/sausage.png")
				group.link[i].width = group.link[i].width/10
				group.link[i].height = group.link[i].height/10
				group.link[i].x = group.link[i].width * i
				group.display:insert(group.link[i])
				physics.addBody( group.link[i], "dynamic", {density=0.5, friction=0.3, bounce=1})
				group.link[i].linearDamping = 2
				group.link[i].angularDamping = 2
				group.link[i].myName = "sausage"
				if (i > 1) then
					group.prevLink = group.link[i-1] -- each link is joined with the one above it
					group.myJoints[#group.myJoints + 1] = physics.newJoint( "pivot", 
											group.prevLink, 
											group.link[i],
											group.prevLink.x + 25,
											group.prevLink.y,
											group.link[i].x + 25,
											group.link[i].y
											)
					--print
					--group.myJoints[#group.myJoints].isLimitEnable = true
					--group.myJoints[#group.myJoints]:setRotationLimits( -5, 5 )
				end
			end
		return group
	end
	S.spawn = spawn
return S