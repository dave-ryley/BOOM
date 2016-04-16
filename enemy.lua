local C = {}
--[[
	enemyType:	String defining the type of enemy to create
	id:			Incrementally increasing number to distinguish between
				multiple instances of the same enemy
	startX:		Starting X position in the game world
	startY:		Starting Y position in the game world
	data:		Table containing initialization data for specified enemy
]]
	local path = "enemies."
	--initializing id
	C.id = 1
	C.splatSound = audio.loadSound( "Sounds/Enemies/Splat.ogg" )
	local function spawn(enemyType, startX, startY, data)
		local enemy = require(  path .. enemyType .. "Visuals")
		C.id = C.id + 1
		--require for the gory splatter effects
		local splatterParts = require "splatterParts"
		--path to graphical assets for enemies
------------------------------------------------------------
------------VARIABLE INITIALIZATION------------------------------------------------
-----------------------------------------------------------------------------------
		--create enemy table
		local e = require(  path .. enemyType .. "Visuals").spawn()
		--display group for physics components
		e.parent = display.newGroup()
		--parent:insert(e.animate)
		--main physics component
		--allows referencing of parent table for the bounds events
		--has the enemy spotted the player
		e.hasTarget = false
		--used for entity identification
		e.id = C.id
		e.myName = "e_"..enemyType .. tostring(C.id)
		e.bounds.myName=e.myName.."_bounds"

		--magic!
		e.bounds.super = e
		e.super = e
		--last detected player x co-ordinate
		e.targetX = nil
		--last detected player y co-ordinate
		e.targetY = nil
		--angle towards player
		e.targetAngle = 0
		--is this enemy dead
		e.isDead = false
		--enemies health
		e.health = data.health
		--initialize physics body with data passed in
		e.shooting = 0
		--check if enemy has been hit
		e.hit = false

		physics.addBody( 	e.bounds, 	
							"dynamic", 	
							data.physicsData
						)
		e.bounds.x = startX
		e.bounds.y = startY
		--initialize enemies sensor radius
		e.sensorRadius = data.sensorRadius
		e.sensorArea = display.newCircle( 
								e.bounds.x, 
								e.bounds.y, 
								e.sensorRadius
								)
		--used to identify the sensor
		e.sensorArea.myName = "s_"..e.myName
		--initialize sensor
		physics.addBody( 	e.sensorArea, 
							data.sensorData
							)
		--stops sprites from rotating
		e.bounds.isFixedRotation = true
		e.sensorArea.isFixedRotation = true

		--rate of slow when flying freely
		e.bounds.linearDamping = 7
		e.sensorArea.linearDamping = 7


		--sensor should be invisible
		e.sensorArea.alpha = 0.0

		--insert to display group
		e.parent:insert( e.bounds, true )
		e.parent:insert( e.sensorArea, true )

		--create splatter parts
		local function splat( angle, x, y)
			timer.performWithDelay( 125,
				function()
					local c = audio.findFreeChannel()
					audio.play(C.splatSound,{ 
							channel = c,
							loops = 0, 
							fadein = 0,
							})
				end
			 )
			return splatterParts.spawn(angle, x, y)
		end
		e.splat = splat


		--return x position
	    local function getX()
	        return e.bounds.x
	    end
	    e.getX = getX

	    --return y position
	    local function getY()
	        return e.bounds.y
	    end
	    e.getY = getY

	    function updatePlayerLocation(x, y)
			local move = require "movementFunctions"
			e.targetX = x
			e.targetY = y
			e.targetAngle = move.calculateLineAngle(
									e.bounds.x,
									e.bounds.y,
									e.targetX,
									e.targetY)
			--print("target angle: "..e.targetAngle)
		end
		e.updatePlayerLocation = updatePlayerLocation

	    --triggers if player enters sensorArea
		e.detectPlayer = function( event )
			if (event.phase == "began" and event.other ~= nil) then
				local other = event.other.super
				e.updatePlayerLocation(other.getX(), other.getY())
				print(e.sensorArea.myName.." colliding with: "..other.myName)
				--print(e.myName.." updating target: "..other.getX() .. " : " .. other.getY())
				e.hasTarget = true
			end
			if (event.phase == "ended") then
				--print("Target lost!")
				e.hasTarget = false
				--e.shooting = 0
			end
		end
		e.sensorArea:addEventListener( "collision", e.detectPlayer )

		--on collision event
		e.onCollision = function( event )
			if(event.other ~= nil) then
				local other = event.other.super
				--print("from "..e.myName .. " colliding with " .. other.myName)

			end
		end
		e.bounds:addEventListener( "collision", e.onCollision )

		--onFrameEnter event
		e.update = function( event )
			e.sensorArea.x = e.bounds.x
			e.sensorArea.y = e.bounds.y
			if(e.hasTarget) then
				--e.updatePlayerLocation(other.getX(), other.getY())
				Runtime:dispatchEvent({	name="getPlayerLocation", 
										updatePlayerLocation=e.updatePlayerLocation})
				--print("x: "..x..", y: "..y.. " :dispatch")
				--e.updatePlayerLocation(x, y)
			end
		end
		Runtime:addEventListener( "enterFrame", e.update )

		--kill enemy and safely remove him
		local function die()
			--passing data to game.lua so gore can be added to camera and
			--player aimAngle can be accessed
			Runtime:removeEventListener( "enterFrame", e.update )
			Runtime:removeEventListener( "enterFrame", e.AI )
			e.bounds:removeEventListener( "collision", e.onCollision )
			e.sensorArea:removeEventListener( "collision", e.detectPlayer )
			Runtime:dispatchEvent( { name="makeGore", bounds=e.bounds, splat=e.splat })

			--need to remove eventListeners before remove dispaly objects
			--slight delay to let any running functions to finish
			timer.performWithDelay( 20,
				function ()
					--removing visual aspects
					display.remove( e.parent )
					--deleting enemy from memory
					e = nil
				end
			)
		end
		e.die = die

		local function takeHit()
			e.health = e.health - 1
			e.hit = true
			if(e.health <= 0) then
				e.die()
			else
				timer.performWithDelay( 500, 
					function ()
						e.hit = false
					end
				)
			end
		end
		e.takeHit = takeHit


		e.bounds.super = e
		e.sensorArea.super = e
		return e
	end

	C.spawn = spawn
return C