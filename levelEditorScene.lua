local composer = require( "composer" )

local scene = composer.newScene()

grid = display.newGroup()
-- "scene:create()"
function scene:create( event )
  local sceneGroup = self.view
  grid = display.newGroup()
  overlay = display.newGroup( )

  myText = display.newText(overlay, "LEVEL EDITOR", display.contentCenterX, 40, "Curse of the Zombie.ttf", 80 )
  menu = display.newRect( overlay, display.contentWidth/16, display.contentHeight/2, display.contentWidth/8, display.contentHeight )

  writeMap = {}

  map = {}
  mapSize = 0
  selectedImage = ""
  initPosX = 0
  initPosY = 0

  blocked = false

  amountOfObjects = 8
  for i = 1, amountOfObjects, 1 do
      for j = 1, 2,1 do
          option = display.newRect(overlay,j*88-10,i*100,80,80)
          option:setFillColor( 0,0,1,1 )
          text = display.newText(overlay, "A", j*88-10, i*100, "Curse of the Zombie.ttf", 40 )
      end
  end


  --objno,rotation,x,y

  objectFileName = {"wall","corner"}
  objectColours = {{0,0,1},{0,1,0},{0,1,1},{1,0,0}}
  selectedObject = 1
  rotation = 1

  mapDone = false

  top = 0
  bottom = display.contentHeight
  left = 0
  right = display.contentWidth
  squareSize = 128

  --Draw Grid
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

local function writeBoomMap()
      local path = system.pathForFile( "level.BOOMMAP", system.ResourceDirectory )
      local file = io.open(path, "w")
      for i= 1,mapSize,1 do
          file:write(writeMap[i].obj..","..writeMap[i].rot..","..writeMap[i].x..","..writeMap[i].y.."\n")
      end
      io.close(file)
      file = nil
      print("Written")
  end

local function mapPoint(object,rotation,xValue,yValue)
    writeMap[mapSize] = {obj = object, rot= rotation, x = xValue, y = yValue}
 end

local function getVertices(type,rotation)
    if(type == 1)then
        vertices = {0,0,0,128,128,128,128,0}
        if(rotation == 1)then
            
        elseif(rotation == 2)then
            
        elseif(rotation == 3)then
            
        else
            
        end
    elseif(type == 2)then
        if(rotation == 1)then
            vertices = {64,64,0,128,128,128,128,0}
        elseif(rotation == 2)then
            vertices = {0,0,0,128,128,128,64,64}
        elseif(rotation == 3)then
            vertices = {0,0,0,128,64,64,128,0}
        else
            vertices = {0,0,64,64,128,128,128,0}
        end
    elseif(type == 3)then

    end
    return vertices
end

local function onMouseEvent( event )
    if(event.isPrimaryButtonDown)then
        localX = event.x-grid.x
        localY = event.y-grid.y
        squareX = math.floor((localX/squareSize))*128+64
        squareY = math.floor((localY/squareSize))*128+64
        print(squareX,squareY)
        if (mapSize > 1) then
            for i = 1,table.getn(writeMap),1 do
                if(math.floor((writeMap[i].x/squareSize))*128+64 == squareX and math.floor((writeMap[i].y/squareSize))*128+64 == squareY)then 
                    blocked = true 
                    i=table.getn(writeMap)
                end
            end
        end
        if(not blocked)then
            mapSize = mapSize +1
            map[mapSize] = display.newPolygon( grid, squareX, squareY, getVertices(selectedObject,rotation))
            map[mapSize]:setFillColor( objectColours[selectedObject][1],objectColours[selectedObject][2],objectColours[selectedObject][3]  )
            --map[mapSize].fill = { type="image", filename=""..objectFileName[selectedObject]..tostring(rotation)..".png" }
            mapPoint(selectedObject,rotation,squareX,squareY)
            print("Block placed")
        end
        blocked = false
    end
    
    if(event.isSecondaryButtonDown)then
    --print(initPosX,initPosY)
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
    print( event.keyName )
    if ( event.keyName == "z" and event.phase == "down") then
        if(mapSize >0)then 
        map[mapSize]:removeSelf()
        writeMap[mapSize] = nil
        mapSize = mapSize-1
        end 
    end
    
    if ( event.keyName == "a" and event.phase == "down") then
        if(rotation > 1)then rotation = rotation -1 
        else rotation = 4
        end
    end
    
    if ( event.keyName == "d" and event.phase == "down") then
        if(rotation < 4)then rotation = rotation +1 
        else rotation = 1
        end
    end
    
    if ( event.keyName == "w" and event.phase == "down") then
        if(selectedObject > 1)then selectedObject = selectedObject -1 
        else selectedObject = table.getn(objectFileName)
        end
    end
    
    if ( event.keyName == "s" and event.phase == "down") then
        if(selectedObject < table.getn(objectFileName))then selectedObject = selectedObject +1 
        else selectedObject = 1
        end
    end
    
    if(event.phase == "down")then
        if(selectedShape)then selectedShape:removeSelf()end
        selectedShape = display.newPolygon( overlay, display.contentWidth/16,display.contentHeight-100, getVertices(selectedObject,rotation) )
        selectedShape:setFillColor( objectColours[selectedObject][1],objectColours[selectedObject][2],objectColours[selectedObject][3] )
        --selectedShape.fill = { type="image", filename=""..objectFileName[selectedObject]..tostring(rotation)..".png" }
    end

    if(event.keyName == "/" and event.phase == "down")then
        writeBoomMap()
    end

  return false
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