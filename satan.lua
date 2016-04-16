local S = {}

	local function spawn(path)
		local s = {}
		s.currentPath = 1
		s.path = {}
		s.bounds = display.newRect( 0, 0, 200, 200 )
		s.bounds.super = s


		local function destinationReached( obj )
			print( "Transition 1 completed on object: " .. tostring( obj ) )
			--print(s.path[currentPath].x.." : ".. s.path[currentPath].y)
			if(s.currentPath < #s.path) then 
				s.currentPath = s.currentPath + 1
				transition.to( s.bounds, s.path[s.currentPath] )
			end
		end
		s.destinationReached = destinationReached

		for i = 1, #path do
			s.path[i] = {time=3000, x=path[i].x, y=path[i].y, onComplete=s.destinationReached}
		end

		local function start( )
			print("satan started")
			transition.to( s.bounds, s.path[s.currentPath] )
		end
		s.start = start

		return s
	end
	S.spawn = spawn
return S