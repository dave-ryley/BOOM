F = {}
--local physics = require "physics"
 
function spawn(angle, x, y)
	local col = require "collisionFilters"
	local t
	local f = {}
	local fireballSheetOptions =
	{
		width = 120,
		height = 160,
		numFrames = 8
	}
	local fireballSheet = graphics.newImageSheet(g.animationPath.."fireball.png", fireballSheetOptions )
	local fireballSeq =
	{
		{
			name = "default",
			start = 1,
			count = 8,
			time = 800,
			loopCount = 0,
			loopDirection = "forward"
		}
	}

	f.fireball = display.newSprite( fireballSheet, fireballSeq )
	f.fireball:play()
	f.fireball.enemyType = "fireball"
	f.fireball.x = math.cos(math.rad(angle - 90))*100 + x -- need to determine actual angle
	f.fireball.y = math.sin(math.rad(angle - 90))*100 + y -- need to determine actual angle
	f.fireball.myName = "p_fireball"
	--local fireballShape = { -80,-70, 80,-70, 80,120, -80,120 }
	local fireballShape = { -30,-30, 30,-30, 30,30, -30,30 }
	local fireballData = {   
					physicsData =   {
								shape=fireballShape,
								density=0.025, 
								friction=0.0, 
								bounce=0.0,
								isFixedRotation=true,
								filter=col.projCol
									}
								}
	f.fireball.rotation = angle
	f.fireball.isFixedRotation=true
--[[
	physics.addBody( fireball, "dynamic", fireballData.physicsData )
	xForce = math.cos(math.rad(angle - 90))*200
	yForce = math.sin(math.rad(angle - 90))*200
	]]
	physics.addBody( f.fireball, "dynamic", fireballData.physicsData )
	local xForce = math.cos(math.rad(angle - 90))*2
	local yForce = math.sin(math.rad(angle - 90))*2
	f.fireball:applyLinearImpulse( xForce, yForce, x, y )
	f.fireball.super = f.fireball
	
	local function die()
		if(f ~= nil) then
			--fireball:removeEventListener( "collision", fireball.onCollision )
			display.remove( f.fireball )
			timer.cancel( t )
			f = nil
		end
	end
	f.die = die


	local function pause()
		if(f ~= nil) then
			f.fireball:pause()
		end
	end
	f.pause = pause

	local function unpause()
		if(f ~= nil) then
			f.fireball:play()
		end
	end
	f.unpause = unpause

	f.fireball.onCollision = function (event)
		if (event.phase == "began" and event.other ~= nil) then
			local other = event.other.super
			if(other.myName == "player") then
				--print("Fireball killing player")
			end
			f.die()
		end
	end
	t = timer.performWithDelay( 10000, 
		function ()
			--print("fireball removing self")
			if(f ~= nil) then
				f.die()
			end
		end
	)

	f.fireball:addEventListener( "collision", f.fireball.onCollision )

	return f
	end
	F.spawn = spawn

return F