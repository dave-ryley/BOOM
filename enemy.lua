local C = {}

	local path = "enemies."
	--initializing id
	C.id = 1
	C.splatSound = audio.loadSound( GLOBAL_soundsPath.."Enemies/Splat.ogg" )

	--[[
		enemyType:	String defining the type of enemy to create
		id:			Incrementally increasing number to distinguish between
					multiple instances of the same enemy
		startX:		Starting X position in the game world
		startY:		Starting Y position in the game world
		data:		Table containing initialization data for specified enemy
	]]
	local function spawn(enemyType, startX, startY, data)
		local m = require "movement_functions"
		C.id = C.id + 1
		local splatterParts = require "splatter_parts"
------------------------------------------------------------
------------VARIABLE INITIALIZATION------------------------------------------------
-----------------------------------------------------------------------------------
		local e = require(  path .. string.lower(enemyType) .. "_visuals").spawn()
		e.move = m.spawn()
		e.parent = display.newGroup()
		e.timers = {}
		e.hasTarget = false
		e.id = C.id
		e.enemyType = enemyType
		e.myName = "e_"..enemyType .. tostring(C.id)
		e.bounds.myName=e.myName.."_bounds"

		--magic!
		e.bounds.super = e
		e.super = e
		e.targetX = nil			--last detected player x co-ordinate
		e.targetY = nil 		--last detected player y co-ordinate
		e.targetAngle = 0		--angle towards player
		e.isDead = false
		e.health = data.health
		e.shooting = 0
		e.hit = false			--check if enemy has been hit

		physics.addBody(
			e.bounds,
			"dynamic",
			data.physicsData
		)
		e.bounds.x = startX
		e.bounds.y = startY
		e.sensorRadius = data.sensorRadius
		e.sensorArea = display.newCircle(
			e.bounds.x,
			e.bounds.y,
			e.sensorRadius
		)
		e.sensorArea.myName = "s_"..e.myName
		physics.addBody(
			e.sensorArea,
			data.sensorData
		)
		e.bounds.isFixedRotation = true
		e.bounds.linearDamping = 7

		e.sensorArea.isFixedRotation = true
		e.sensorArea.linearDamping = 7
		e.sensorArea.alpha = 0.0

		e.parent:insert( e.bounds, true )
		e.parent:insert( e.sensorArea, true )

	    local function getX()
	        return e.bounds.x
	    end
	    e.getX = getX

	    local function getY()
	        return e.bounds.y
	    end
	    e.getY = getY

	    function updatePlayerLocation(x, y)
			e.targetX = x
			e.targetY = y
			e.targetAngle = e.move.calculateLineAngle(
				e.bounds.x,
				e.bounds.y,
				e.targetX,
				e.targetY
			)
		end
		e.updatePlayerLocation = updatePlayerLocation

	    --triggers if player enters sensorArea
		e.detectPlayer = function( event )
			if event.phase == "began" and event.other then
				local other = event.other.super
				e.updatePlayerLocation(other.getX(), other.getY())
				e.hasTarget = true
			end
			if event.phase == "ended" then
				e.hasTarget = false
			end
		end
		e.sensorArea:addEventListener( "collision", e.detectPlayer )

		--on collision event
		e.onCollision = function( event )
			if event.other then
				local other = event.other.super
				if other.myName == "Satan" then
					local angle = e.move.calculateLineAngle(
						other.bounds.x,
						other.bounds.y,
						e.bounds.x,
						e.bounds.y
					)
					e.die(true, angle)
				end
			end
		end
		e.bounds:addEventListener( "collision", e.onCollision )

		--onFrameEnter event
		e.update = function( event )
			if GLOBAL_pause == false and e and e.isDead == false then
				e.sensorArea.x = e.bounds.x
				e.sensorArea.y = e.bounds.y
				if e.hasTarget then
					Runtime:dispatchEvent({	name="getPlayerLocation",
											updatePlayerLocation=e.updatePlayerLocation})
				end
			end
		end
		Runtime:addEventListener( "enterFrame", e.update )

		local function pause()
			if e then
				Runtime:removeEventListener( "enterFrame", e.update )
				Runtime:removeEventListener( "enterFrame", e.AI )
				e.bounds:pause()
			end
		end
		e.pause = pause

		local function unpause()
			if e then
				Runtime:addEventListener( "enterFrame", e.update )
				Runtime:addEventListener( "enterFrame", e.AI )
				e.bounds:play()
			end
		end
		e.unpause = unpause

		local function cleanup()
			if e then
				display.remove( e.bounds )
				display.remove( e.sensorArea )
			end
			e = nil
		end
		e.cleanup = cleanup


		local function splat( angle )
			local x = e.bounds.x
			local y = e.bounds.y
			local gore = splatterParts.spawn(angle, x, y)
			Runtime:dispatchEvent({name="makeGore", gore=gore, x = x, y = y})
			e.cleanup()
			timer.performWithDelay(
				125,
				function()
					local c = audio.findFreeChannel()
					audio.play(
						C.splatSound,
						{
							channel = c,
							loops = 0,
							fadein = 0,
						}
					)
				end
			 )
		end
		e.splat = splat
		--kill enemy and safely remove him
		local function die(gore, angle)
			if e then
				e.pause()
				if gore == true then
				--need to remove eventListeners before remove display objects
				--slight delay to let any running functions to finish
					timer.performWithDelay( 20,
						function()
							if e and e.splat then
								e.splat(angle)
							end
						end
						)
				else
					--timer.performWithDelay( 20, e.cleanup )
				end
			end

		end
		e.die = die

		local function takeHit(angle)
			e.health = e.health - 1
			e.hit = true
			if e.health <= 0 then
				e.isDead = true
				GLOBAL_kills = GLOBAL_kills + 1
				e.die(true, angle)
			end
		end
		e.takeHit = takeHit
		e.bounds.super = e
		e.sensorArea.super = e
		return e
	end

	C.spawn = spawn
return C
