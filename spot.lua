local C = {}

	local function spawn(id)
		
		local temp = {}
			temp.move = require "movementFunctions"
			--temp.collisionFilter = { categoryBits = 4, maskBits = 3}
			--temp.sensorCollFilter = { categoryBits = 8, maskBits = 1}
			--setup variables
			temp.hasTarget = false
			temp.physics = require ("physics")
			temp.health = 2
			temp.targetX = 0
			temp.targetY = 0
			temp.moveAngle = 0
			temp.speed = 10
			temp.isDead = false
			temp.parent = display.newGroup()
			

			--enemyID
			temp.myName = "spot" .. tostring(id)
			--setting up collision bounds
			temp.bounds = display.newImageRect( "Graphics/Temp/TestFace.png", 100, 100 )
			temp.bounds.id = id
			temp.bounds.myName = "spot"
			temp.physics.addBody( 	temp.bounds, 
									"dynamic", 	
								{	density=3.0, 
									friction=1.0, 
									bounce=0.0,
									isFixedRotation=true
								} )
			--spot detection area
			temp.bounds.filter = temp.collisionFilter
			temp.sensorRadius = 500
			temp.sensorArea = display.newCircle( temp.bounds.x, temp.bounds.y, temp.sensorRadius )
			temp.sensorArea.myName = "spotSensor"
			temp.physics.addBody( 	temp.sensorArea, 
									"dynamic", 
									{isSensor = true, 
									radius=temp.sensorRadius
									--,filter=temp.sensorCollFilter
								} )
			--temp.sensorArea.filter = temp.sensorCollFilter
			temp.bounds.isFixedRotation = true
			temp.bounds.linearDamping = 7
			--face smash
			
			
			temp.parent:insert(temp.bounds)
			temp.parent:insert(temp.sensorArea)
			temp.sensorArea.alpha = 0.0

			function updatePlayerLocation(x, y)
				temp.targetX = x
				temp.targetY = y
			end
			temp.updatePlayerLocation = updatePlayerLocation

			function splatter()
				
				print("making face: " .. temp.myName)
				local xPos = temp.bounds.x
				local yPos = temp.bounds.y 
				local face1 = display.newImageRect( "Graphics/Temp/TestFaceShattered/facePiece1.png",
				                      66, 49)
				local face2 = display.newImageRect( "Graphics/Temp/TestFaceShattered/facePiece2.png",
				              54, 60)
				local face3 = display.newImageRect( "Graphics/Temp/TestFaceShattered/facePiece3.png",
				              59, 51)
				local face4 = display.newImageRect( "Graphics/Temp/TestFaceShattered/facePiece4.png",
				              50, 66)
				face1.x = xPos
				face1.y = yPos
				--face1:translate( xPos, yPos )
				face2.x = xPos
				face2.y = yPos

				face3.x = xPos
				face3.y= yPos

				face4.x = xPos
				face4.y = yPos
				
				physics.addBody(  face1,
				          "dynamic",
				        {   density = 0.5,
				          friction = 0.5,
				          bounce = 0.9})
				physics.addBody(  face2,
				          "dynamic",
				        {   density = 0.5,
				          friction = 0.5,
				          bounce = 0.9})
				physics.addBody(  face3,
				          "dynamic",
				        {   density = 0.5,
				          friction = 0.5,
				          bounce = 0.9})
				physics.addBody(  face4,
				          "dynamic",
				        {   density = 0.5,
				          friction = 0.5,
				          bounce = 0.9})

				face1.linearDamping = 3
				face2.linearDamping = 3
				face3.linearDamping = 3
				face4.linearDamping = 3

				face1.angularDamping = 3
				face2.angularDamping = 3
				face3.angularDamping = 3
				face4.angularDamping = 3

	         face1:applyLinearImpulse(  
	                 math.cos(player.thisAimAngle)*500, 
	                 math.sin(player.thisAimAngle)*500, 
	                 50, 
	                 50 )
	         face2:applyLinearImpulse(  
	                 math.cos(player.thisAimAngle)*500, 
	                 math.sin(player.thisAimAngle)*500, 
	                 50, 
	                 50 )
	         face3:applyLinearImpulse(  
	                 math.cos(player.thisAimAngle)*500, 
	                 math.sin(player.thisAimAngle)*500, 
	                 50, 
	                 50 )
	         face4:applyLinearImpulse(  
	                 math.cos(player.thisAimAngle)*500, 
	                 math.sin(player.thisAimAngle)*500, 
	                 50, 
	                 50 )
				local gore = display.newGroup( )
				gore:insert(face1)
				gore:insert(face2)
				gore:insert(face3)
				gore:insert(face4)

			return gore
		end
		local function die()
			temp.isDead = true
			temp.hasTarget = false

		end
		temp.die = die

		temp.splatter = splatter
		temp.update = function( event )
			if(temp.health <= 0) then
				temp.die()
			end
			temp.sensorArea.x = temp.bounds.x
			temp.sensorArea.y = temp.bounds.y
			if(temp.hasTarget == true and temp.bounds ~= nil) then
				temp.moveAngle = temp.move.calculateLineAngle(	
									temp.bounds.x,
									temp.bounds.y,
									temp.targetX,
									temp.targetY)
				if(temp.isDead == false) then
					local xMove = 
							math.cos(temp.moveAngle)
					local yMove =
								math.sin(temp.moveAngle)
					temp.bounds.x = temp.bounds.x + xMove * temp.speed
					temp.bounds.y = temp.bounds.y + yMove * temp.speed
				end
			end
				--print(xMove .. " : " ..yMove)
		end
		Runtime:addEventListener( "enterFrame", temp.update )

		temp.detectPlayer = function( event )

			if (temp.hasTarget == true and event.other.myName == "player") then
				print("updating target: "..event.other.x .. " : " .. event.other.y)
				temp.targetX = event.other.x
				temp.targetY = event.other.y
			end

			if (event.phase == "began") then

				--print( event.myName .. ": collision began with " .. event.other.myName )
				--print("Killed by: " .. event.object1.myName)
					--event.object2:applyLinearImpulse( 3000, 0, 50, 50 )
				if(event.other.myName == "player") then
					print("Target acquired!: " .. event.other.y)
					temp.hasTarget = true
					temp.targetX = event.other.x
					temp.targetY = event.other.y

				end
			elseif (event.phase == "ended") then
				print("Target lost!")
				temp.hasTarget = false
			end
		end
			
		temp.onCollision = function( event )
			print("from spot: " .. event.other.myName)
			if (event.phase == "began") then
				if (event.other.myName == "shotgun") then
						--print("reloaawding: "..event.object1.reloading)
					if(temp.health > 0) then
						temp.bounds:applyLinearImpulse( 	
										math.cos(math.mod(
											temp.moveAngle+math.pi, math.pi))*2000, 
										math.sin(math.mod(
											temp.moveAngle+math.pi, math.pi))*2000, 
										50, 
										50 
									)
						temp.health = temp.health - 1
						print("puppy health: " .. temp.health)
					else
						temp.die()
						print("Killed by: " .. event.other.myName)
					end
					--C[event.object2.id].parent:removeSelf( )

				end
			end
		end


		
		temp.sensorArea:addEventListener( "collision", temp.detectPlayer )
		temp.bounds:addEventListener( "collision", temp.onCollision )
		return temp
		
	end
	C.spawn = spawn	
return C