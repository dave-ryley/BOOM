local C = {}

	local function spawn(id)
		
		local temp = {}
			--temp.col = require "collisionFilters"
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
									--filter=temp.col.enemyCol,
									isFixedRotation=true
								} )
			--hellPup detection area
			--temp.bounds.filter = temp.col.enemyCol
			temp.sensorRadius = 500
			temp.sensorArea = display.newCircle( temp.bounds.x, temp.bounds.y, temp.sensorRadius )
			temp.sensorArea.myName = "hellPupSensor"
			temp.physics.addBody( 	temp.sensorArea, 
									"dynamic", 
								{	isSensor = true, 
									radius=temp.sensorRadius
									--filter=temp.col.sensorCol
								} )
			--temp.sensorArea.filter = temp.col.sensorCol
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
			

			temp.onCollision = function( event ) 
				print("hellpup collision with: ")
				if (event.phase == "began") then

					print( "hellpupsensor" .. ": collision began with " )
					if(event.other.myName == "player") then
						print("Target acquired!")
					end
				end
			end
			temp.bounds:addEventListener( "collision", temp.onCollision )
		return temp
		
	end
	C.spawn = spawn
	--C[0] = spawn(0)
	--C[1] = spawn(1)
	--print(C[0].Name)

	
return C