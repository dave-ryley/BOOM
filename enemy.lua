local C = {}

	local function spawn(enemyType, id, startX, startY, data)
		local splatterParts = require "splatterParts"
		local path = "enemies."
		local e = require(  path .. enemyType .. "Visuals")
			--e.collisionFilter = { categoryBits = 4, maskBits = 3}
			--e.sensorCollFilter = { categoryBits = 8, maskBits = 1}
			--setup variables
			e.parent = display.newGroup()
			e.bounds.hasTarget = false
			e.bounds.physics = require ("physics")
			e.bounds.targetX = 0
			e.bounds.targetY = 0
			e.bounds.targetAngle = math.random(359)
			e.animate(e.bounds.targetAngle, "Shoot")
			e.bounds.isDead = false
			e.bounds.health = data.health
			e.shooting = 0

			e.bounds.myName = "e_"..enemyType .. tostring(id)
			e.bounds.id = e.bounds.myName..id
			physics.addBody( 	e.bounds, 
								"dynamic", 	
								data.physicsData
							)
			e.bounds.isFixedRotation = true
			e.bounds.linearDamping = 7
			e.sensorArea = display.newCircle( e.bounds.x, e.bounds.y, data.sensorRadius )
			e.sensorRadius = data.sensorRadius
			e.sensorArea.myName = enemyType.."Sensor"
			physics.addBody( 	e.sensorArea, 
									"dynamic", 
									{
									isSensor = true, 
									radius=e.sensorRadius
								} )
			e.sensorArea.alpha = 0.0
			
			function die()
				e.bounds.isDead = true
				e.bounds.hasTarget = false
			end
			e.bounds.die = die

			function splat(angle, x, y)
				return splatterParts.spawn(angle, x, y)
			end
			e.splat = splat

			    local function getX()
			        return e.bounds.x
			    end
			    e.getX = getX

			    local function getY()
			        return e.bounds.y
			    end
			    e.getY = getY
			e.bounds.detectPlayer = function( event )

				if (event.phase == "began") then
					if (e.bounds.hasTarget == true and event.other.myName == "player") then
						print("updating target: "..event.other.x .. " : " .. event.other.y)
						e.bounds.targetX = event.other.x
						e.bounds.targetY = event.other.y
					end
				elseif (event.phase == "ended") then
					print("Target lost!")
					e.bounds.hasTarget = false
				end
			end
			e.sensorArea:addEventListener( "collision", e.bounds.detectPlayer )

			e.bounds.onCollision = function( event )
				print("from "..e.bounds.myName .. " colliding with " .. event.other.myName)
			end
			e.bounds:addEventListener( "collision", e.bounds.onCollision )
			local fireball = require "enemies.fireball"
			e.update = function()
				e.sensorArea.x = e.bounds.x
				e.sensorArea.y = e.bounds.y

				if e.shooting == 0 then
					e.shooting = 1
					local impFire = audio.loadSound( "Sounds/Enemies/ImpFire.ogg" )
					audio.play(impFire,{ channel = 10, loops = 0, fadein = 0})
					e.animate(e.bounds.targetAngle, "Shoot")
				elseif e.bounds.frame == 5 and e.shooting == 1 then
					e.shooting = 2
					local f = fireball.spawn(e.bounds.targetAngle, e.getX(), e.getY() )
					e.parent:insert(f)
				end
				if e.bounds.frame == 7 and e.shooting == 2 and string.sub( e.bounds.sequence, -5 ) == "Shoot" then
					e.animate(e.bounds.targetAngle, "Stand")
					timer.performWithDelay(2000, function() e.shooting = 0 end )
				end

			end
			Runtime:addEventListener( "enterFrame", e.update )
			e.parent:insert(e.bounds, true)
			e.parent:insert(e.sensorArea, true)
		return e
	end
	C.spawn = spawn
return C