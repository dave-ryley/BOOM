local C = {}

	local function spawn(id)
		
		local temp = {}
			--temp.collisionFilter = { categoryBits = 4, maskBits = 3}
			--temp.sensorCollFilter = { categoryBits = 8, maskBits = 1}
			--setup variables
			temp.physics = require ("physics")
			temp.health = 2
			--enemyID
			temp.myName = "hellPup" .. tostring(id)
			--setting up collision bounds
			temp.bounds = display.newImageRect( "Graphics/Temp/TestFace.png", 100, 100 )
			temp.bounds.id = id
			temp.bounds.myName = "hellPup"
			temp.physics.addBody( 	temp.bounds, 
									"dynamic", 	
								{	density=3.0, 
									friction=1.0, 
									bounce=0.0,
									--filter=temp.collisionFilter,
									{isSensor=true, 
									isFixedRotation=true}
								} )
			--hellPup detection area
			temp.bounds.filter = temp.collisionFilter
			temp.sensorRadius = 500
			temp.sensorArea = display.newCircle( temp.bounds.x, temp.bounds.y, temp.sensorRadius )
			temp.sensorArea.myName = "hellPupSensor"
			temp.physics.addBody( 	temp.sensorArea, 
									"dynamic", 
									{isSensor = true, 
									radius=temp.sensorRadius
									--,filter=temp.sensorCollFilter
								} )
			--temp.sensorArea.filter = temp.sensorCollFilter
			temp.bounds.isFixedRotation = true
			temp.bounds.linearDamping = 7
			
			temp.parent = display.newGroup()
			temp.parent:insert(temp.bounds)
			temp.parent:insert(temp.sensorArea)
			temp.sensorArea.alpha = 0.0
			temp.update = function( event )
				temp.sensorArea.x = temp.bounds.x
				temp.sensorArea.y = temp.bounds.y
			end
			Runtime:addEventListener( "enterFrame", temp.update )
			
			temp.detectPlayer = function( event )
				if (event.phase == "began") then

					--print( event.myName .. ": collision began with " .. event.other.myName )
					--print("Killed by: " .. event.object1.myName)
						--event.object2:applyLinearImpulse( 3000, 0, 50, 50 )
					if(event.other.myName == "player") then
						print("Target acquired!")
					end
				end
				return true
			end
			
			temp.onCollision = function( event )
				print(event.other.myName)
				if (event.phase == "began") then
					if (event.other.myName == "shotgun"
						and event.other.reloading == true) then
							--print("reloading: "..event.object1.reloading)
							if(temp.health > 0) then
								temp.bounds:applyLinearImpulse( 2000, 0, 50, 50 )
							else
								print("Killed by: " .. event.other.myName) 
								temp.parent:removeSelf()
							end
						--C[event.object2.id].parent:removeSelf( )

					end
				end
				return true
			end
	
		temp.sensorArea:addEventListener( "collision", temp.detectPlayer )
		temp.bounds:addEventListener( "collision", temp.onCollision )
		return temp
		
	end
	C.spawn = spawn
	--C[0] = spawn(0)
	--C[1] = spawn(1)
	--print(C[0].Name)

	
return C