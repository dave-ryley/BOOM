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
--[[
		function print_r ( t )  
			local print_r_cache={}
			local function sub_print_r(t,indent)
				if (print_r_cache[tostring(t)]) then
					print(indent.."*"..tostring(t))
				else
					print_r_cache[tostring(t)]=true
					if (type(t)=="table") then
						for pos,val in pairs(t) do
							if (type(val)=="table") then
								print(indent.."["..pos.."] => "..tostring(t).." {")
								sub_print_r(val,indent..string.rep(" ",string.len(pos)+8))
								print(indent..string.rep(" ",string.len(pos)+6).."}")
							elseif (type(val)=="string") then
								print(indent.."["..pos..'] => "'..val..'"')
							else
								print(indent.."["..pos.."] => "..tostring(val))
							end
						end
					else
						print(indent..tostring(t))
					end
				end
			end
			if (type(t)=="table") then
				print(tostring(t).." {")
				sub_print_r(t,"  ")
				print("}")
			else
				sub_print_r(t,"  ")
			end
			print()
		end
		print_r(s.path)
		]]
		local function start( )
			print("satan started")
			transition.to( s.bounds, s.path[s.currentPath] )
		end
		s.start = start
		--[[
		s.path = {	{time=4000, 	x = 2000, 	y = 0, 		onComplete=s.destinationReached},
					{time=4000,		x = 0, 		y = 0, 		onComplete=s.destinationReached},
					{time=4000,		x = 2000, 	y = 0, 		onComplete=s.destinationReached},
					{time=4000,		x = 0, 		y = 0, 		onComplete=s.destinationReached},
					{time=4000,		x = 2000, 	y = 0, 		onComplete=s.destinationReached}
				}
	]]
		return s
	end
	S.spawn = spawn
return S