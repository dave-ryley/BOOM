local I = {}
local colFilters = require "collisionFilters"
local g = require "globals"
	local constructor = require "enemy"
	local impShape = { -60,-90, 60,-90, 60,90, -60,90 }
	local radius = 1000
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
								radius=radius,
								filter=colFilters.sensorCol,
							},
			sensorRadius=	radius,
			health 		= 	1
	}

	local function spawn(startX, startY)
		local i = constructor.spawn("imp", startX, startY, impData)
		local fireball = require "enemies.fireball"
		local firstSight = true
		i.AI = function()
			if(i ~= nil) then
				if(g.pause == false and i.isDead == false) then
					if(i.hasTarget == true or i.shooting > 0) then
						--print("frame "..i.bounds.frame.." : shooting "..i.shooting)
						if i.shooting == 0 then
							i.shooting = 1
							if(firstSight == true)then
								firstSight = false
								local laughfx = audio.loadSound("Sounds/Enemies/ImpLaugh.ogg")
								audio.play(laughfx,{channel = audio.findFreeChannel()})
								audio.dispose( laughfx )
							end
							local impFire = audio.loadSound( "Sounds/Enemies/ImpFire.ogg" )
							audio.play(impFire,{ channel = audio.findFreeChannel(), loops = 0, fadein = 0})
							i.animate(i.targetAngle, "Shoot")
						elseif i.bounds.frame == 5 and i.shooting == 1 then
							i.shooting = 2
							local f = fireball.spawn(i.targetAngle, i.getX(), i.getY() )
							Runtime:dispatchEvent( {name="fireball", f=f} )
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
				end
			end
		end
		Runtime:addEventListener( "enterFrame", i.AI )
		return i
	end
	I.spawn = spawn
return I
