local C = {}
	local function spawn(enemyType, id, startX, startY, data)
		local splatterParts = require "splatterParts"
		local path = "enemies."
		local e = require(  path .. enemyType .. "Visuals")
			--e.collisionFilter = { categoryBits = 4, maskBits = 3}
			--e.sensorCollFilter = { categoryBits = 8, maskBits = 1}
			--setup variables
			e.animate(math.random(359), "Stand")
			e.parent = display.newGroup()
			e.bounds.hasTarget = false
			e.bounds.physics = require ("physics")
			e.bounds.targetX = 0
			e.bounds.targetY = 0
			e.bounds.moveAngle = 0
			e.bounds.isDead = false
			e.bounds.health = data.health

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

			e.update = function()
				e.sensorArea.x = e.bounds.x
				e.sensorArea.y = e.bounds.y
			end
			Runtime:addEventListener( "enterFrame", e.update )
			e.parent:insert(e.bounds, true)
			e.parent:insert(e.sensorArea, true)
		return e
	end
	C.spawn = spawn
return C