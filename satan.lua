local S = {}
	
	
	local function spawn(path)
		local s = {}
		local c = require "enemies.satanVisuals"
		local col = require "collisionFilters"
		local m = require "movementFunctions"
		s = c.spawn()
		s.move = m.spawn()
		s.currentPath = 1
		s.speed = 0.77
		s.path = {}
		s.enemyType = "satan"
		s.visuals.anchorY = 0.75
		s.visuals:scale(1.5,1.5)
		s.bounds = display.newRect( 0, 0, 730, 630 )
		s.bounds.alpha = 0.0
		s.animate(180, "Walk")
		s.bounds.super = s
		s.distance = 0
		s.time = 0
		s.parent = display.newGroup( )
		s.parent:insert(s.visuals)
		s.parent:insert(s.bounds)
		physics.addBody(s.bounds,	{	density=2.0, 
										friction=1.0, 
										bounce=0.0,
										filter=col.satanCol} )
		s.bounds.isFixedRotation = true
		s.myName = "satan"
		s.bounds.myName = "satan"
		for i = 1, #path do
			if(i>1)then 
				distance = math.sqrt(math.pow((path[i].x-path[i-1].x),2)
									+math.pow((path[i].y-path[i-1].y),2))
				time = distance/s.speed
			end
			s.path[i] = {path[i].x, path[i].y, time}

		end

		local function destinationReached( obj )
			--print( "Transition 1 completed on object: " .. tostring( obj ) )
			--print(s.path[currentPath].x.." : ".. s.path[currentPath].y)
			if(s.currentPath < #s.path) then 
				s.currentPath = s.currentPath + 1
				local xDestination = s.path[s.currentPath][1]
				local yDestination = s.path[s.currentPath][2]
				local angle = s.move.calculateLineAngle(	s.bounds.x,
															s.bounds.y,
															xDestination,
															yDestination)
				transition.to(s.bounds,{time = 	s.path[s.currentPath][3], 
												x=xDestination, 
												y=yDestination, 
												onComplete = s.destinationReached})
				transition.to(s.visuals,{time = s.path[s.currentPath][3], 
												x=xDestination, 
												y=yDestination
												})
												--onComplete = s.destinationReached})
				s.animate(angle, "Walk")
				--print("satan angle: " .. angle)
			end
		end

		s.destinationReached = destinationReached


		local function pause()
			transition.pause( s.bounds )
			transition.pause( s.visuals )
			s.visuals:pause()
		end
		s.pause = pause

		local function unpause()
			transition.resume( s.bounds )
			transition.resume( s.visuals )
			s.visuals:play()
		end
		s.unpause = unpause

		local function start( )
			--print("satan started")
			local xDestination = s.path[s.currentPath][1]
			local yDestination = s.path[s.currentPath][2]
			local angle = s.move.calculateLineAngle(	s.bounds.x,
														s.bounds.y,
														xDestination,
														yDestination)
			transition.to( 	s.bounds, 
							{time = 3000, 
							x=xDestination, 
							y=yDestination, 
							onComplete = s.destinationReached} )
			transition.to(s.visuals,
							{time = 3000, 
							x=xDestination, 
							y=yDestination
							})
			s.animate(angle, "Walk")
		end

		s.start = start
		return s

	end

	S.spawn = spawn

return S