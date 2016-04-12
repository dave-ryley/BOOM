local C = {}

--[[
	enemyType:	String defining the type of enemy to create
	id:			Incrementally increasing number to distinguish between
				multiple instances of the same enemy
	startX:		Starting X position in the game world
	startY:		Starting Y position in the game world
	data:		Table containing initialization data for specified enemy
]]
	local function spawn(enemyType, id, startX, startY, data)
		--require for the gory splatter effects
		local splatterParts = require "splatterParts"
		--path to graphical assets for enemies
		local path = "enemies."
------------------------------------------------------------
------------VARIABLE INITIALIZATION------------------------------------------------
-----------------------------------------------------------------------------------
		--create enemy table
		local e = require(  path .. enemyType .. "Visuals")
		--display group for physics components
		e.parent = display.newGroup()
		--main physics component
		--allows referencing of parent table for the bounds events
		--has the enemy spotted the player
		e.hasTarget = false
		--used for entity identification
		e.myName = "e_"..enemyType .. tostring(id)
		e.bounds.myName=e.myName.."_bounds"

		--magic!
		e.bounds.super = e
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
		physics.addBody( 	e.bounds, 	
							"dynamic", 	
							data.physicsData
						)
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
		local function splat(angle, x, y)
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
				print(e.sensorArea.myName.." colliding with: "..other.myName)
				print(e.myName.." updating target: "..other.getX() .. " : " .. other.getY())
				e.hasTarget = true
				e.updatePlayerLocation(other.getX(), other.getY())
			elseif (event.phase == "ended") then
				print("Target lost!")
				e.hasTarget = false
			end
		end
		e.sensorArea:addEventListener( "collision", e.detectPlayer )

		e.onCollision = function( event )
			if(event.other ~= nil) then
				local other = event.other.super
				print("from "..e.myName .. " colliding with " .. other.myName)

			end
		end
		e.bounds:addEventListener( "collision", e.onCollision )




		local function die()
			e.isDead = true
			e.hasTarget = false
		end
		e.die = die
		e.bounds.super = e
		e.sensorArea.super = e
		return e
	end

	C.spawn = spawn
return C