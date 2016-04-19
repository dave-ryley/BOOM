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
				health 		= 	1
		}

	local function spawn(startX, startY)
		local i = constructor.spawn("spot", startX, startY, spotData)
		i.xMove = 0
		i.yMove = 0
		i.baseSpeed = 8
		i.speedMod = 1
		i.animationParam = ""
		i.currentAngle = 0
		i.diveRange = 500
		i.moving = false
		i.evil = false
		i.dogHappy = audio.loadSound( "Sounds/Enemies/DogBarkHappy.ogg")
		i.dogAngry = audio.loadSound( "Sounds/Enemies/DogBarkAngry.ogg")

		i.AI = function()
			if(i.isDead == false and i.hasTarget == true) then
				--if(i.health <= 0) then
				--	i.die()
				--end
				if(i.hit == true) then
					i.animate(i.targetAngle, "Run", "Hit")
				elseif(i.hasTarget == true) then
					local move = require "movementFunctions"
					local x1 = i.targetX
					local y1 = i.targetY
					local x2 = i.bounds.x
					local y2 = i.bounds.y
					local distance = i.move.calculateDistance(x1,
															y1,
															x2, 
															y2)
					if(distance <= i.diveRange and i.evil == false) then
						audio.play(i.dogAngry,{channel = audio.findFreeChannel()})
						
						i.speedMod = 2.5
						i.evil = true
						i.animationParam = "Evil"
						--print("spot is evil now!")
					elseif (i.evil == true and distance > i.diveRange) then
						i.evil = false
						i.animationParam = ""
						i.speedMod = 1
					end
						i.animate(i.targetAngle, "Run", i.animationParam)
					if (i.moving == false) then
						i.moving = true
						i.currentAngle = i.targetAngle
						print("target angle: "..i.currentAngle)
						i.xMove = 
							math.cos(math.rad(i.currentAngle - 90))
						i.yMove =
							math.sin(math.rad(i.currentAngle - 90))

						print("xMove: " .. i.xMove .. " : yMove: " .. i.yMove)
						--timer.performWithDelay( 200,
						--	function()
								--print("spot angle: "..i.targetAngle.." : frame: ".. i.bounds.sequence)
						--		i.moving = false
						--	end
						--)
					end
				end
				print(i.bounds.x .. " : " .. i.bounds.y)
				i.bounds:setLinearVelocity( i.xMove*i.baseSpeed*i.speedMod*100, i.yMove*i.baseSpeed*i.speedMod*100 )
				--i.bounds.x = i.bounds.x + i.xMove*i.baseSpeed*i.speedMod
				--i.bounds.y = i.bounds.y + i.yMove*i.baseSpeed*i.speedMod
			end
		end
		Runtime:addEventListener( "enterFrame", i.AI )
		return i
	end
	S.spawn = spawn	
return S