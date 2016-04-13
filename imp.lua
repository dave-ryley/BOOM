local T = {}
local colFilters = require "collisionFilters"

	local constructor = require "enemy"
	local impShape = { -60,-90, 60,-90, 60,90, -60,90 }
	local impData = {
			physicsData = 	{	
								shape=impShape,
								density=1.0, 
								friction=1.0, 
								bounce=0.0,
								filter=colFilters.enemyCol
							},
			sensorData	=	{
								isSensor=true,
								radius=500,
								filter=colFilters.sensorCol,
							},
			sensorRadius=	800,
			health 		= 	1
	}

	local function spawn(startX, startY)
		local i = constructor.spawn("imp", startX, startY, impData)
		local fireball = require "enemies.fireball"
		i.AI = function()
			--print(i.hasTarget)
			if(i.hasTarget == true or i.shooting > 0) then
				--print("frame "..i.bounds.frame.." : shooting "..i.shooting)

				if i.shooting == 0 then
					i.shooting = 1
					local impFire = audio.loadSound( "Sounds/Enemies/ImpFire.ogg" )
					audio.play(impFire,{ channel = 10, loops = 0, fadein = 0})
					i.animate(i.targetAngle, "Shoot")
				elseif i.bounds.frame == 5 and i.shooting == 1 then
					i.shooting = 2
					local f = fireball.spawn(i.targetAngle, i.getX(), i.getY() )
					i.parent:insert(f)
				elseif i.bounds.frame == 7 and i.shooting == 2 and string.sub( i.bounds.sequence, -5 ) == "Shoot" then
					i.animate(i.targetAngle, "Stand")
					timer.performWithDelay(1000, 
						function() 
							i.shooting = 0
						end 
					)
				end
			else
				i.animate(i.targetAngle, "Stand")
			end
--[[
			if(i.hasTarget == true) then
				--print("frame "..i.bounds.frame.." : shooting "..i.shooting)

				if i.shooting == 0 then
					i.shooting = 1
					local impFire = audio.loadSound( "Sounds/Enemies/ImpFire.ogg" )
					audio.play(impFire,{ channel = 10, loops = 0, fadein = 0})
					i.animate(i.targetAngle, "Shoot")
				elseif string.sub(i.bounds.sequence, -5) == "Shoot" and i.bounds.frame == 5 then
					local f = fireball.spawn(i.targetAngle, i.getX(), i.getY() )
					i.parent:insert(f)
				elseif string.sub(i.bounds.sequence, -5) == "Shoot" and i.bounds.frame == 7 then
					i.animate(i.targetAngle, "Stand")
					timer.performWithDelay(1000, 
						function() 
							i.shooting = 0
						end 
					)
				end
			else
				i.animate(i.targetAngle, "Stand")
			end]]
			--print("shooting: " .. i.shooting)
		end
		Runtime:addEventListener( "enterFrame", i.AI )
		return i
	end
	T.spawn = spawn
return T
