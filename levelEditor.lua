grid = display.newGroup()

map = {}
local mapSize = 0


--modifiers
----enemies
impPlace = 				false
spotPlace = 			false
rosyPlace = 			false
----traps
staticFireTrapPlace = 	false
slowTrapPlace = 		false
flameThrowerTrapPlace = false
----checkpoints and finish line
checkPoint = 			false
finishLine =			false

mapDone = false

point1 = 0
point2 = 0

point3 = 0
point4 = 0

local top = 0
local bottom = display.contentHeight
local left = 0
local right = display.contentWidth

local squareSize = 128

initPosX = 0
initPosY = 0

for i = 1, (right)/squareSize, 1 do
	gridLines = display.newLine(i*(left+squareSize), top, i* (left+squareSize), bottom )
	gridLines:setStrokeColor( 1, 1, 1, 0.3 )
	gridLines.strokeWidth = 2
end

for i = 1, (bottom)/squareSize, 1 do
	gridLines = display.newLine(left, i*squareSize, right, i*squareSize )
	gridLines:setStrokeColor( 1, 1, 1, 0.3)
	gridLines.strokeWidth = 2
end

local function point(xValue,yValue,entitytype)
	--adds a point to the map
	map[mapSize] = {x = xValue, y = yValue, object = entitytype}
end

local function mathToSquare(point1,point2)
	return( math.abs( math.abs((point1 - (squareSize/2))/squareSize)-math.abs((point2 - (squareSize/2))/squareSize) ) )
end

local function writeMap()

end


local function onMouseEvent( event )
    if(event.isPrimaryButtonDown and (not mapDone))then
    	blocked = false
    	localX = event.x-grid.x
    	localY = event.y-grid.y
	 	if(impPlace==false and spotPlace==false and rosyPlace==false and staticFireTrapPlace==false and slowTrapPlace==false and flameThrowerTrapPlace==false and finishLine==false and checkPoint==false)then
	    	squareX = localX/squareSize
	    	squareY = localY/squareSize
	    	if(point1 == 0)then
	    		point1 = math.floor(squareX)*128+64
	    		point2 = math.floor(squareY)*128+64
	    		
	    		local startPaint = {1,0,0}
	    		local pointerPaint = {0,1,0}

	    		start = display.newRect( grid, point1, point2, 10, 10 )
	    		pointer = display.newRect( grid, point1, point2, 10, 10 )

	    		start.fill = startPaint
	    		pointer.fill = pointerPaint

	    		mapSize = mapSize + 1
	    		point(point1, point2,10)
	    		blocked = false
	    	else
	    		point3 = math.floor(squareX)*128+64
	    		point4 = math.floor(squareY)*128+64
	    		
	    		if(point3 == map[1].x and point4 == map[1].y and mapSize > 1)then 
					print("done")
					for i= 1,mapSize,1 do
						print(map[i].x..":"..map[i].y..":"..map[i].object)
						mapDone = true
					end
				end
	    		
	    		if(mathToSquare(point1, point3) >1 or mathToSquare(point2, point4) >1)then
	    			blocked = true
	    		else
		    		for i=1, mapSize,1 do
		    			if(map[i].object==10)then
			    			if(point3 == map[i].x and point4==map[i].y)then
			    				blocked = true
			    				print("no")
			    			end
			    		end
		    		end
	    		end
	    		if(not blocked)then
		    		mapLines = display.newLine(grid,point1,point2, point3, point4 )
		    		mapLines:setStrokeColor( 1, 0.5, 0.5, 1 )
					mapLines.strokeWidth = 5
					transition.moveTo( pointer, { x=point3, y=point4, time=0 } )
					point1 = point3
					point2 = point4
					mapSize = mapSize + 1
					point(point1, point2,10)
					point3 = 0
					point4 = 0
				end
	    	end
	    elseif(impPlace==true)then 
	    	mapSize = mapSize+1
	    	point(localX,localY,1)
	    	print(localX,localY)
	    	local impPaint = {0,0,1}
	    	imp = display.newRect( grid, map[mapSize].x, map[mapSize].y, 10, 10 )
	    	imp.fill = impPaint
	    elseif(spotPlace==true)then
	    	mapSize = mapSize+1
	    	point(localX,localY,2)
	    	print(localX,localY)
	    	local spotPaint = {0,1,0}
	    	spot = display.newRect( grid, map[mapSize].x, map[mapSize].y, 10, 10 )
	    	spot.fill = spotPaint
	    elseif(rosyPlace==true)then
	    	mapSize = mapSize+1
	    	point(localX,localY,3)
	    	print(localX,localY)
	    	local rosyPaint = {0,1,1}
	    	rosy = display.newRect( grid, map[mapSize].x, map[mapSize].y, 10, 10 )
	    	rosy.fill = rosyPaint
	    elseif(staticFireTrapPlace==true)then 
			mapSize = mapSize+1
	    	point(localX,localY,4)
	    	print(localX,localY)
	    	local firePaint = {1,0,0}
	    	fire = display.newRect( grid, map[mapSize].x, map[mapSize].y, 10, 10 )
	    	fire.fill = firePaint
	    elseif(slowTrapPlace==true)then 
	    	mapSize = mapSize+1
	    	point(localX,localY,5)
	    	print(localX,localY)
	    	local slowPaint = {1,1,1}
	    	slow = display.newRect( grid, map[mapSize].x, map[mapSize].y, 10, 10 )
	   		slow.fill = slowPaint
	    elseif(flameThrowerTrapPlace==true)then 
	    	mapSize = mapSize+1
	    	point(localX,localY,6)
	    	print(localX,localY)
	    	local flamePaint = {0.5,0.5,0.5}
	    	flame = display.newRect( grid, map[mapSize].x, map[mapSize].y, 10, 10 )
	    	flame.fill = flamePaint
	    elseif(checkPoint==true)then 
	    	mapSize = mapSize+1
	    	point(localX,localY,7)
	    	print(localX,localY)
	    	local cPPaint = {0.5,1,0.5}
	    	checkPoint = display.newRect( grid, map[mapSize].x, map[mapSize].y, 10, 10 )
	    	checkPoint.fill = cPPaint
	    elseif(finishLine==true)then 
	    	mapSize = mapSize+1
	    	point(localX,localY,8)
	    	print(localX,localY)
	    	local fLPaint = {1,0.5,1}
	    	finishLine = display.newRect( grid, map[mapSize].x, map[mapSize].y, 10, 10 )
	    	finishLine.fill = fLPaint
	    end
    end

    if(event.isSecondaryButtonDown)then
    	if(initPosX == 0 and initPosY == 0)then
    		initPosX = event.x
    		initPosY = event.y
    	else
    		grid:translate( event.x-initPosX , event.y-initPosY)
    		initPosX = 0
    		initPosY = 0
    	end
    else
    	initPosX = 0
    	initPosY = 0
	end
end

local function onKeyEvent( event )
    -- Print which key was pressed down/up
    local message = impPlace
    print( message )
    if ( event.keyName == "q" and event.phase == "down") then
    	impPlace = true
    end
    if ( event.keyName == "w" and event.phase == "down") then
    	spotPlace = true
    end
    if ( event.keyName == "e" and event.phase == "down") then
    	rosyPlace = true
    end
    if ( event.keyName == "r" and event.phase == "down") then
    	staticFireTrapPlace = true
    end
    if ( event.keyName == "t" and event.phase == "down") then
    	slowTrapPlace = true
    end
    if ( event.keyName == "y" and event.phase == "down") then
    	flameThrowerTrapPlace = true
    end
    if ( event.keyName == "u" and event.phase == "down") then
    	checkPoint = true
    end
    if ( event.keyName == "i" and event.phase == "down") then
    	finishLine = true
    end
    if(event.phase == "up")then
    	impPlace = false
    	spotPlace = false
    	rosyPlace = false

    	staticFireTrapPlace = false
    	slowTrapPlace = false
    	flameThrowerTrapPlace = false
    end
    return false
end

Runtime:addEventListener( "mouse", onMouseEvent )
Runtime:addEventListener("key",onKeyEvent)

--print("mapsize: " ..mapSize)
--print(map[mapSize].x)
--print(map[mapSize].y)