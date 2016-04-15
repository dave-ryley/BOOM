local S = {}

	local function spawn(path)
		local s = {}
		s.x = 1000
		s.y = 0
		s.currentPath = 1
		s.bounds = display.newRect( 0, 0, 200, 200 )
		s.bounds.super = s

		local function destinationReached( obj )
		    print( "Transition 1 completed on object: " .. tostring( obj ) )
		    if(s.currentPath < #s.path) then 
		    	s.currentPath = s.currentPath + 1
		    	transition.to( s.bounds, s.path[s.currentPath] )
		    end
		end
		s.destinationReached = destinationReached
		s.path = {	{time=4000, 	x = 2000, 	y = 0, 		onComplete=s.destinationReached},
					{time=4000,		x = 0, 		y = 0, 		onComplete=s.destinationReached},
					{time=4000,		x = 2000, 	y = 0, 		onComplete=s.destinationReached},
					{time=4000,		x = 0, 		y = 0, 		onComplete=s.destinationReached},
					{time=4000,		x = 2000, 	y = 0, 		onComplete=s.destinationReached}
				}

		return s
	end
	S.spawn = spawn
return S