local composer = require( "composer" )

local scene = composer.newScene()

grid = display.newGroup()
-- "scene:create()"
function scene:create( event )
  local sceneGroup = self.view
  myText = display.newText(grid, "LEVEL EDITOR", display.contentCenterX, display.contentCenterY, "Curse of the Zombie.ttf", 80 )
  sceneGroup:insert(grid)
  map = {}
  mapSize = 0
  selectedImage = ""
  initPosX = 0
  initPosY = 0
  --modifiers
  impPlace =           false
  spotPlace =          false
  rosyPlace =          false
  ----traps
  staticFireTrapPlace =   false
  slowTrapPlace =      false
  flameThrowerTrapPlace = false
  ----checkpoints and finish line
  checkPoint =         false
  finishLine =         false
  ----enemies
  mapDone = false
  point1 = 0
  point2 = 0
  point3 = 0
  point4 = 0
  ----Constants
  top = 0
  bottom = display.contentHeight
  left = 0
  right = display.contentWidth
  squareSize = 128

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
   -- Initialize the scene here.
   -- Example: add display objects to "sceneGroup", add touch listeners, etc.
end
 
-- "scene:show()"
function scene:show( event )
 
   local sceneGroup = self.view
   local phase = event.phase
 
   if ( phase == "will" ) then
      -- Called when the scene is still off screen (but is about to come on screen).
   elseif ( phase == "did" ) then
      -- Called when the scene is now on screen.
      -- Insert code here to make the scene come alive.
      -- Example: start timers, begin animation, play audio, etc.
   end
end
 
-- "scene:hide()"
function scene:hide( event )
 
   local sceneGroup = self.view
   local phase = event.phase
 
   if ( phase == "will" ) then
      -- Called when the scene is on screen (but is about to go off screen).
      -- Insert code here to "pause" the scene.
      -- Example: stop timers, stop animation, stop audio, etc.
   elseif ( phase == "did" ) then
      -- Called immediately after scene goes off screen.
   end
end
 
-- "scene:destroy()"
function scene:destroy( event )
 
   local sceneGroup = self.view
 
   -- Called prior to the removal of scene's view ("sceneGroup").
   -- Insert code here to clean up the scene.
   -- Example: remove display objects, save state, etc.
end
 
---------------------------------------------------------------------------------
local function point(xValue,yValue,entitytype)
    map[mapSize] = {x = xValue, y = yValue, object = entitytype}
 end

local function mathToSquare(point1,point2)
  return( math.abs( math.abs((point1 - (squareSize/2))/squareSize)-math.abs((point2 - (squareSize/2))/squareSize) ) )
end

local function onKeyEvent( event )
    print( impPlace )
    if ( event.keyName == "q" and event.phase == "down") then
      impPlace = true
    end
    print (impPlace)
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

      checkPoint = false
      finishLine = false
    end
  return false
end

local function onMouseEvent( event )
  if(event.isPrimaryButtonDown and (not mapDone))then
    print (impPlace)
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
          local path = system.pathForFile( "level.BOOMMAP", system.ResourceDirectory )
          local file = io.open(path, "w")
          for i= 1,mapSize,1 do
            file:write(map[i].x..","..map[i].y..","..map[i].object.."\n")
            print(map[i].x,map[i].y,map[i].object)
            mapDone = true
          end
          io.close(file)
          file = nil
          print("Written")
        end   
        if(mathToSquare(point1, point3) >1 or mathToSquare(point2, point4) >1)then
          blocked = true
        else
          for i=1, mapSize,1 do
            if(map[i].object==10)then
              if(point3 == map[i].x and point4==map[i].y)then
                blocked = true
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
    print(initPosX,initPosY)
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
-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

Runtime:addEventListener( "mouse", onMouseEvent )
Runtime:addEventListener("key", onKeyEvent)
---------------------------------------------------------------------------------
 return scene