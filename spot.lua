local S = {}
local colFilters = require "collisionFilters"

	local constructor = require "enemy"
	local spotShape = { -60,-90, 60,-90, 60,90, -60,90 }
	local radius = 1200
	local spotData = {
				physicsData = 	{	
									shape=spotShape,
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
				health 		= 	2
		}

	local function spawn(startX, startY)
		local i = constructor.spawn("imp", startX, startY, spotData)
		i.xMove = 0
		i.yMove = 0
		i.speed = 8
		i.currentAngle = 0
		i.moving = false
		i.evil = false
		i.AI = function()
			
			if(i.health <= 0) then
				i.die()
			end

			if(i.hasTarget == true) then
				local move = require "movementFunctions"
				local distance = move.calculateDistance(i.targetX, 
														i.targetY, 
														i.bounds.x, 
														i.bounds.y)
				if(distance < 650 and i.evil == false) then
					i.speed = i.speed * 2
					i.evil = true
				end

				if (i.moving == false) then
					i.moving = true
					i.currentAngle = i.targetAngle
					print("target angle: "..i.currentAngle)
					i.xMove = 
						math.cos(math.rad(i.currentAngle - 90))
					i.yMove =
						math.sin(math.rad(i.currentAngle - 90))

					print("xMove: " .. i.xMove .. " : yMove: " .. i.yMove)
					timer.performWithDelay( 200, 
						function()
							i.moving = false
						end
					)
				end
			i.bounds.x = i.bounds.x + i.xMove*i.speed
			i.bounds.y = i.bounds.y + i.yMove*i.speed
			end
		end
		Runtime:addEventListener( "enterFrame", i.AI )
		return i
	end
	S.spawn = spawn	
return S