local S = {}

local colFilters = require "collisionFilters"

local function spawn(links, x, y)
	local group = {}
	group.display = display.newGroup( )
	group.myJoints = {}
	group.link = {}
	group.myName = "sausage"

	for i = 1, links do
		local scale = 1.3
		local p = display.newImage(GLOBAL_gorePath.."IntestinePart.png")
		p.width = p.width * scale
		p.height = p.height * scale
		p.x = x + p.width * i
		p.y = y
		p.super = p
		p.bounds = p
		physics.addBody(
			p,
			"dynamic",
			{
				density=1,
				friction=0.,
				bounce=0.5,
				filter=colFilters.goreCol
			}
		)
		p.linearDamping = 3
		p.angularDamping = 3
		p.myName = "sausage"
		group.link[i] = p
		group.display:insert(group.link[i] )
		if i > 1 then
			local prevLink = group.link[i-1] -- each link is joined with the one above it
			group.myJoints[#group.myJoints + 1] = physics.newJoint(
				"pivot",
				prevLink,
				p,
				prevLink.x + 8 * scale,
				prevLink.y,
				p.x + 8 * scale,
				p.y

			)
			group.myJoints[#group.myJoints].isLimitEnable = true
			group.myJoints[#group.myJoints]:setRotationLimits( -40, 40 )
		end
	end

	return group
end
S.spawn = spawn

return S
