local T = {}
local colFilters = require "collisionFilters"

	local constructor = require "enemy"
	local impShape = { -60,-90, 60,-90, 60,90, -60,90 }
	local impData = {
			physicsData = 	{	
								shape=impShape,
								density=3.0, 
								friction=1.0, 
								bounce=0.0,
								filter=colFilters.enemyCol
							},
			sensorData	=	{
								isSensor=true,
								radius=800,
								filter=colFilters.sensorCol,
							},
			sensorRadius=	800,
			health 		= 	1
	}

	local function spawn(id, startX, startY)
		local i = constructor.spawn("imp", id, startX, startY, impData)
		local fireball = require "enemies.fireball"
		i.update = function()
			i.sensorArea.x = i.bounds.x
			i.sensorArea.y = i.bounds.y
			if(i.hasTarget == true) then
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
				end
				if i.bounds.frame == 7 and i.shooting == 2 and string.sub( i.bounds.sequence, -5 ) == "Shoot" then
					i.animate(i.targetAngle, "Stand")
					timer.performWithDelay(2000, function() i.shooting = 0 end )
				end
			else
				i.animate(i.targetAngle, "Stand")
			end
			--print("update: " .. i.myName)
		end
		Runtime:addEventListener( "enterFrame", i.update )
		return i
	end
	T.spawn = spawn
return T
