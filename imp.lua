local T = {}
	local constructor = require "enemy"
	local impShape = { -80,-70, 80,-70, 80,120, -80,120 }
	local impData = {	
				physicsData = 	{
							shape=impShape,
							density=3.0, 
							friction=1.0, 
							bounce=0.0,
							isFixedRotation=true
								},
							sensorRadius = 	500,
							health = 3
								}

local fireball = require "enemies.fireball"
	local function spawn(id, startX, startY)
		local i = constructor.spawn("imp", id, startX, startY, impData)
		i.bounds.update = function( event )
			print("imp update"..i.myName)
			--if i.bounds.hasTarget == true then
				timer.performWithDelay(200, 
					function()
						print("spawning fireball")
						fireball.spawn(i.bounds.targetAngle, i.getX(), i.getY() )
					end
					)
			--end
		end
		i.bounds:addEventListener( "enterFrame", i.bounds.update )
		return i
	end
	T.spawn = spawn
return T
