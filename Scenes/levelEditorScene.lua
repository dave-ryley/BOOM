local composer = require( "composer" )
local g = require "globals"
local scene = composer.newScene()
composer.recycleOnSceneChange = true
--composer.isDebug = true

grid = display.newGroup()

local function mapPoint(object,rotation,xValue,yValue)
    writeMap[mapSize] = {obj = object, rot= rotation, x = xValue, y = yValue}
end

local function getVertices(type,rotation)
    if(type <= 1)then
      vertices = {0,0,0,128,128,128,128,0}
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
      if(rotation == 1)then
            vertices = {10,0,0,0,0,10,118,128,128,128,128,118}
        elseif(rotation == 2)then
            vertices = {128,10,128,0,118,0,0,118,0,128,10,128}
        elseif(rotation == 3)then
            vertices = {10,0,0,0,0,10,118,128,128,128,128,118}
        else
            vertices = {128,10,128,0,118,0,0,118,0,128,10,128}
        end
    elseif(type == 4)then
    if(rotation == 1)then
            vertices = {0,0,128,0,128,20,0,20}
        elseif(rotation == 2)then
            vertices = {49,0,69,0,69,128,49,128}
        elseif(rotation == 3)then
            vertices = {0,0,128,0,128,20,0,20}
        else
            vertices = {49,0,69,0,69,128,49,128}
      end
    end
    return vertices
end

function scene:create( event )
  local sceneGroup = self.view
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

  --objno,rotation,x,y

  objectFileName = {"lavaTile","lavaTile","wall_diagonal","wall_flat","winTile"}
  enemyFileName = {"Imp","HellPup","Minator"}
  trapFileName = {"Slow","Fire", "FlameThrower"}
  miscFileName = {}

  objectColours = {{0,0,1},{0,1,0},{0,1,1},{1,0,0}}
  selectedObject = 1
  rotation = 1

  --initial wall in corner
  selectedShape = display.newPolygon( overlay, display.contentWidth/16,display.contentHeight-100, getVertices(selectedObject,rotation) )
  selectedShape.fill = { type="image", filename="Graphics/Background/"..objectFileName[selectedObject].."1.png" }

  mapDone = false

  top = 0
  bottom = display.contentHeight
  left = 0
  right = display.contentWidth
  squareSize = 128

  --Draw Grid
  for i = 1, (right)/squareSize, 1 do
      gridLines = display.newLine(overlay,i*(left+squareSize), top, i* (left+squareSize), bottom )
      gridLines:setStrokeColor( 1, 1, 1, 0.3 )
      gridLines.strokeWidth = 2
  end
  for i = 1, (bottom)/squareSize, 1 do
      gridLines = display.newLine(overlay,left, i*squareSize, right, i*squareSize )
      gridLines:setStrokeColor( 1, 1, 1, 0.3)
      gridLines.strokeWidth = 2
  end

  mapSize = mapSize +1
  map[mapSize] = display.newPolygon( grid, 448, 448, getVertices(0,1))
  map[mapSize]:setFillColor( 1,0,0)
  mapPoint(0,rotation,448,448)

  mapSize = mapSize +1
  map[mapSize] = display.newPolygon( grid, 1216, 448, getVertices(0,1))
  map[mapSize]:setFillColor(0,1,0)
  mapPoint(0,rotation,1216,448)

  function removeAllListeners(obj)
    obj._functionListeners = nil
    obj._tableListeners = nil
  end

  local press = audio.loadSound( "Sounds/GUI/ButtonPress.ogg")
  function buttonPress( self, event )
      if event.phase == "began" then
        audio.play(press, {channel = 31})
        if self.id == 1 then
          removeAllListeners(Runtime)
          composer.gotoScene( g.scenePath.."menu" )
        end
        return true
      end
  end

  button = display.newRect(overlay,125,37.5,250,75)
  button:setFillColor( 1, 1, 0 )
  button.id = 1
  button.touch = buttonPress
  button:addEventListener( "touch", button )
    
  buttonText = display.newText(overlay,"MAIN MENU", 125,37.5, "Curse of the Zombie", 30 )
  buttonText:setFillColor(1,0,0)
  sceneGroup:insert(grid)
  sceneGroup:insert(overlay)
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

local function onMouseEvent( event )
    if(event.isPrimaryButtonDown)then
        localX = event.x-grid.x
        localY = event.y-grid.y
        squareX = math.floor((localX/squareSize))*128+64
        squareY = math.floor((localY/squareSize))*128+64
        --print(squareX,squareY)
        if(selectedObject<11)then
          if (mapSize > 0) then
              for i = 1,table.getn(writeMap),1 do
                  if(math.floor((writeMap[i].x/squareSize))*128+64 == squareX and math.floor((writeMap[i].y/squareSize))*128+64 == squareY
                      and writeMap[i].obj == selectedObject)then 
                      if(selectedObject < 3 or writeMap[i].rot == rotation)then
                        blocked = true 
                        i=table.getn(writeMap)
                      end
                  end
              end
          end
          if(not blocked)then
              mapSize = mapSize +1
              if(selectedObject == 4)then
                if(rotation == 1)then
                  squareY = squareY-64
                elseif(rotation == 2)then
                  squareX = squareX+64
                elseif(rotation == 3)then
                  squareY = squareY+64
                elseif(rotation == 4)then
                  squareX = squareX-64
                end
              end
              map[mapSize] = display.newPolygon( grid, squareX, squareY, getVertices(selectedObject,rotation))
              map[mapSize].fill = { type="image", filename="Graphics/Background/"..objectFileName[selectedObject]..tonumber(rotation)..".png" }
              mapPoint(selectedObject,rotation,squareX,squareY)
          end
          blocked = false
        elseif(selectedObject == 666)then
            mapSize = mapSize +1
            map[mapSize] = display.newRect( grid, squareX, squareY, 12,12)
            map[mapSize]:setFillColor(1,0,0)
            mapPoint(selectedObject,rotation,squareX,squareY)
            print("Path placed")
        elseif(selectedObject == 100)then
            mapSize = mapSize +1
            map[mapSize] = display.newRect( grid, squareX, squareY, 128,128)
            map[mapSize]:setFillColor(0,1,0)
            mapPoint(selectedObject,rotation,squareX,squareY)
            print("win placed")
        else
          mapSize = mapSize +1
          map[mapSize] = display.newRect( grid, localX, localY, 10,10)
          map[mapSize]:setFillColor(1,0,1)
          mapPoint(selectedObject,rotation,localX,localY)
        end
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
    if ( event.keyName == "z" and event.phase == "down") then
        if(mapSize >2)then 
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
        if(selectedObject > table.getn(objectFileName)-1)then selectedObject = 1 end
        if(selectedObject > 1)then selectedObject = selectedObject -1 
        else selectedObject = table.getn(objectFileName)-1
        end
    end
    
    if ( event.keyName == "s" and event.phase == "down") then
        if(selectedObject < table.getn(objectFileName)-1)then selectedObject = selectedObject +1 
        else selectedObject = 1
        end
    end
    if(event.keyName == "e" and event.phase == "down")then
      selectedObject = selectedObject+1
      if(selectedObject < 11)then
        selectedObject = 11
      elseif(selectedObject>table.getn(enemyFileName)+10)then
        selectedObject = 11
      end
    end

    if(event.keyName == "q" and event.phase == "down")then
      selectedObject = selectedObject+1
      if(selectedObject < 41)then
        selectedObject = 41
      elseif(selectedObject>table.getn(enemyFileName)+40)then
        selectedObject = 41
      end
    end

    if(event.keyName == "y" and event.phase == "down")then
      selectedObject = 100
    end

    if(event.keyName == "t" and event.phase == "down")then
      selectedObject = selectedObject+1
      if(selectedObject < 666)then
        selectedObject = 666
      elseif(selectedObject >= 666)then
        selectedObject = 1
      end
    end

    if(event.phase == "down")then
      if(selectedShape)then selectedShape:removeSelf()end
      if(selectedObject < 11)then
        --print(selectedObject,rotation)
        selectedShape = display.newPolygon( overlay, display.contentWidth/16,display.contentHeight-100, getVertices(selectedObject,rotation) )
        selectedShape.fill = { type="image", filename="Graphics/Background/"..objectFileName[selectedObject]..tostring(rotation)..".png" }
      elseif(selectedObject < 21)then
        selectedShape = display.newPolygon( overlay, display.contentWidth/16,display.contentHeight-100, getVertices(1,1) )
        selectedShape.fill = { type="image", filename="Graphics/Art/"..enemyFileName[selectedObject-10]..".png" }
      elseif(selectedObject < 51)then
        selectedShape = display.newPolygon( overlay, display.contentWidth/16,display.contentHeight-100, getVertices(1,1) )
        selectedShape:setFillColor( 1,0,1)
      elseif(selectedObject == 666)then
        selectedShape = display.newPolygon( overlay, display.contentWidth/16,display.contentHeight-100, getVertices(1,1) )
        selectedShape:setFillColor( 1,0,0)
      elseif(selectedObject == 100)then
        selectedShape = display.newPolygon( overlay, display.contentWidth/16,display.contentHeight-100, getVertices(1,1) )
        selectedShape:setFillColor( 0,1,0)
      end
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