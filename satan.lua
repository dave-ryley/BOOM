local S = {}
	
	local C = require "enemies.satanVisuals"
	
	local function spawn(path)
		local s = C.spawn()
		s.currentPath = 1
		s.speed = 0.77
		s.path = {}
		s.bounds:scale(1.5,1.5)
		s.bounds.anchorY = 0.75
		s.animate(180, "Walk")
		s.bounds.super = s

		for i = 1, #path do
			if(i>1)then 
				distance = math.sqrt(math.pow((path[i].x-path[i-1].x),2)+math.pow((path[i].y-path[i-1].y),2))
				time = distance/s.speed
			end
			s.path[i] = {path[i].x, path[i].y, time}

		end

		local function destinationReached( obj )
			print( "Transition 1 completed on object: " .. tostring( obj ) )
			--print(s.path[currentPath].x.." : ".. s.path[currentPath].y)
			if(s.currentPath < #s.path) then 
				s.currentPath = s.currentPath + 1
				transition.to(s.bounds,{time = s.path[s.currentPath][3], x=s.path[s.currentPath][1], y=s.path[s.currentPath][2], onComplete = s.destinationReached})
				print("Hi")
			end
		end

		s.destinationReached = destinationReached

		local function start( )
			print("satan started")
			transition.to( s.bounds, {time = 3000, x=s.path[s.currentPath][1], y=s.path[s.currentPath][2], onComplete = s.destinationReached} )
		end

		s.start = start

		return s

	end

	S.spawn = spawn

return S