local g = require "globals"
local Q = {}

	local function spawn()
		local P = {}
		local col = require "collisionFilters"
		local g = require "globals"
		local v = require "playerVisuals"
		local s = require "shotgun"
		local m = require "movementFunctions"
		P.movementFunctions = m.spawn()
		P.visuals = v.spawn()
		P.myName = "player"
		P.shotgun = s.spawn()
		P.parent = display.newGroup()
		P.parent.x = 0--display.contentCenterX
		P.parent.y = 0--display.contentCenterY
		--P.parent.x = display.contentCenterX
		--P.parent.y = display.contentCenterY
		P.canShoot = true
		P.isMovingX = 0
		P.isMovingY = 0
		P.isRotatingX = 0
		P.isRotatingY = 0
		P.thisAimAngle = 0
		P.thisDirectionAngle = 0
		P.velocity = 0.5
		P.maxSpeed = g.speed
		P.isAlive = true
		P.health = g.health
		P.isSlowed = false
		-- Collision object setup
		P.bounds = display.newRect(0,0,70,70)
		P.bounds.alpha = 0.0
		P.bounds.myName = "player"
		P.id = 1

		physics.addBody( P.bounds, "dynamic", 
									{
										density=1.0, 
										friction=0.5, 
										bounce=0.0,
										filter=col.playerCol
									})

		P.bounds.isFixedRotation=true
		P.bounds.x = (1216-448)*5
		P.bounds.y = 0
        --P.bounds.x = display.contentCenterX
        --P.bounds.y = display.contentCenterY
        P.bounds.linearDamping = 5
        -- Camera lock object setup
        P.cameraLock = display.newRect(0,-200,50,50)
        P.cameraLock.alpha = 0.00
        P.cameraLock.x = P.parent.x
        P.cameraLock.y = P.parent.y
        P.bounds.super = P
        --print("making new player: " ..P.myName)
            --TORCH LIGHT--

        P.torchLight = display.newRect(P.bounds.x, P.bounds.y,51200,51200)
        display.setDefault( "textureWrapX", "clampToEdge" )
        display.setDefault( "textureWrapY", "clampToEdge" )
        P.torchLight.fill = {type = "image",filename ="Graphics/Animation/torchRad.png"}
        P.torchLight.fill.scaleX = 0.02
        P.torchLight.fill.scaleY = 0.02
        P.torchLight.alpha = 0.75
        P.parent:insert( P.visuals.lowerBody )
        P.parent:insert( P.visuals.upperBody )
        P.parent:insert( P.cameraLock)
        P.parent:insert( P.bounds)
        P.parent.x, P.torchLight.x = P.bounds.x, P.bounds.x
        P.parent.y, P.torchLight.y = P.bounds.y -50, P.bounds.y
        P.visuals.animate(90, 90, 0, 0)

		local function update ()
			P.shotgun.aimAngle = P.thisAimAngle
			if(P.isAlive == true ) then
				P.parent.x, P.torchLight.x = P.bounds.x, P.bounds.x
				P.parent.y, P.torchLight.y = P.bounds.y -50, P.bounds.y
				P.cameraLock.x = P.parent.x + P.isRotatingX*350
				P.cameraLock.y = P.parent.y + P.isRotatingY*350
				P.visuals.footsteps()
            end

            -- MOVE THE PLAYER
            if ( P.isMovingX ~= 0 or P.isMovingY ~= 0 ) then
                --P.bounds.linearDamping = 5
                local x, y = P.bounds:getLinearVelocity()
                x = x + P.isMovingX*P.velocity
                y = y + P.isMovingY*P.velocity
                --print("x = " .. x .. " y = " .. y)
                local hyp = math.sqrt(x*x + y*y) * 1.0
                if (hyp > P.maxSpeed) then
                    x = x/hyp * P.maxSpeed
                    y = y/hyp * P.maxSpeed
                    --print("x = " .. x .. " y = " .. y)
                end
                P.bounds:setLinearVelocity( x, y )
                --P.parent.x, P.parent.y = P.bounds.x, P.bounds.y
            end

            -- PLACE THE SHOTGUN
            if(P.shotgun.shooting == false) then
                P.visuals.animate(P.thisAimAngle, P.thisDirectionAngle, math.abs(P.isMovingX) + math.abs(P.isMovingY), P.velocity)
                P.shotgun.place(P.thisAimAngle, P.parent.x, P.parent.y)
            else
                P.shotgun.place( P.shotgun.bounds.rotation , P.parent.x, P.parent.y)
            end

		end

        P.update = update

		local function playerAxis( axis, value )
			-- Map event data to simple variables
			local abs = math.abs
			local floor = math.floor

			if ( "left_x" == axis ) then
			   if ( abs(value) > 0.15 ) then
				   P.isMovingX = value * P.velocity*P.maxSpeed
				   P.thisDirectionAngle = floor( P.movementFunctions.calculateAngle(P.isMovingX, P.isMovingY, P.thisDirectionAngle) )
			   else
				   P.isMovingX = 0
			   end
			elseif ( "left_y" == axis ) then
			   if ( abs(value) > 0.15 ) then
				   P.isMovingY = value * P.velocity*P.maxSpeed
				   P.thisDirectionAngle = floor( P.movementFunctions.calculateAngle(P.isMovingX, P.isMovingY, P.thisDirectionAngle) )
			   else
				   P.isMovingY = 0
			   end
			elseif ( "right_x" == axis ) then
				P.isRotatingX = value
				P.thisAimAngle = floor( P.movementFunctions.calculateAngle(P.isRotatingX, P.isRotatingY, P.thisAimAngle) )
			elseif ( "right_y" == axis ) then
				P.isRotatingY = value
				P.thisAimAngle = floor( P.movementFunctions.calculateAngle(P.isRotatingX, P.isRotatingY, P.thisAimAngle) )
			elseif ( "left_trigger" == axis or "right_trigger" == axis ) then
				if(P.canShoot) then
					P.shoot()
				end
			end
			return true
		end

		P.playerAxis = playerAxis

		local function pause()
			P.visuals.torch:pause()
			P.visuals.upperBodyRun_sprite:pause( )
			P.visuals.lowerBodyRun_sprite:pause( )
		end
		P.pause = pause

		local function unpause()
			P.visuals.torch:play()
			P.visuals.upperBodyRun_sprite:play( )
			P.visuals.lowerBodyRun_sprite:play( )
		end
		P.unpause = unpause

		local function blastDisppear( event )
			P.shotgun.bounds.isAwake = false
			P.shotgun.shooting = false
			if(P.shotgun ~= nil) then
				physics.removeBody( P.shotgun.bounds )
			end
			P.shotgun.blast.alpha = 0
			P.shotgun.bounds.isAwake = false    
		end

		local function shootDelay( event )
			P.canShoot = true;
		end

		local function shoot()
			P.shotgun.createBlastBounds()
			P.shotgun.bounds.isAwake = true
			P.canShoot = false
			P.bounds:applyLinearImpulse(    
						math.cos(math.rad(P.thisAimAngle + 90))*P.shotgun.force/2, 
						math.sin(math.rad(P.thisAimAngle + 90))*P.shotgun.force/2, 
						0, 0)
			audio.stop(3)
			audio.play(P.visuals.sounds.boomStick,{channel = 3})
			P.shotgun.blast_sprite:play()
			P.shotgun.blast.alpha = 1
			P.shotgun.blast_sprite.alpha = 1
			P.shotgun.shooting = true
			P.visuals.animateShotgunBlast(P.thisAimAngle )
			timer.performWithDelay(200, blastDisppear)
			return timer.performWithDelay(500, shootDelay)
		end

		P.shoot = shoot

		local function getAimAngle()
			return P.shotgun.bounds.aimAngle
		end
		P.getAimAngle = getAimAngle

		local function getX()
			return P.bounds.x
		end
		P.getX = getX

		local function getY()
			return P.bounds.y
		end
		P.getY = getY
		----- Started adding in functions


		local function die()
			physics.stop( )
			P.isAlive = false
			g.pause = true
			audio.stop( 2 )
			timer.performWithDelay( 10, 
				function ()
					display.remove( P.bounds )
					display.remove( P.shotgun.shotgunOMeter )
					display.remove( P.shotgun.blast )
					display.remove( P.shotgun.bounds)
					display.remove( P.torchLight)
					display.remove( P.parent )
				end
				)
		end
		P.die = die

		P.onCollision = function( event )
			if (event.phase == "began" and event.other ~= nil) then
				local other = event.other.super
				local s = string.sub(event.other.myName, 1, 2)
				if(s == "e_" or s == "p_" or other.enemyType == "satan") then
					--print("in player collided with: ".. other.myName)
					if(other.enemyType== "fireball") then
						--print("player health taking damage: "..P.health)
						P.health = P.health - 1
					elseif (other.enemyType == "spot") then
						P.health = 0
						other.hasTarget = false
						other.isDead = true
						--other.die(false)
					elseif( other.enemyType == "satan") then
						P.health = 0
					end
				end
				if(P.health == 0) then
					print("Killed by: "..other.enemyType)
					Runtime:dispatchEvent( {name="youDied",killer = other.enemyType} )
				end
			end
		end


		function virtualJoystickInput(ljsAngle, ljsX, ljsY, rjsAngle, rjsDistance, rjsX, rjsY)
			if rjsDistance > 2.45 and P.canShoot then
				P.shoot()
			end
			P.isMovingX = ljsX * P.velocity*P.maxSpeed
			P.isMovingY = ljsY * P.velocity*P.maxSpeed
			local rhyp = math.sqrt(rjsX*rjsX + rjsY*rjsY)
			if rhyp > 1 then
				P.isRotatingX = rjsX/rhyp
				P.isRotatingY = rjsY/rhyp
			else
				P.isRotatingX = rjsX
				P.isRotatingY = rjsY
			end
			P.thisDirectionAngle = (720-(ljsAngle-90)) % 360
			P.thisAimAngle = (720-(rjsAngle-90)) % 360
		end

		P.virtualJoystickInput = virtualJoystickInput

		P.bounds:addEventListener( "collision", P.onCollision )
		return P
	end
	Q.spawn = spawn
return Q
	