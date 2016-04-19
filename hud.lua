local HUD = {}
	local hudInitialized = false
	local g = require "globals"
	local shotgun = require "shotgun"
	local function initializeHUD()
		hudInitialized = true
		HUD.hudGroup = display.newGroup()
		HUD.distance = 0
		HUD.satanIndicatorGroup = display.newGroup()
		HUD.pointer = display.newPolygon( HUD.satanIndicatorGroup, g.ccx, g.ccy, {0,0, 35,50,90,0,35,-50} )
		--HUD.satanIndicator = display.newCircle( HUD.satanIndicatorGroup, g.ccx, g.ccy, 60 )
		local sheetOptions =
		{
			width = 165,
			height = 165,
			numFrames = 12
		}
		HUD.sheet_satanIndicator = graphics.newImageSheet("Graphics/UI/SatanIndicator.png", sheetOptions)
		local sequences_satanIndicator = 
		{
		    {
		        name = "play",
        		start = 1,
        		count = 12,
       		 	time = 1200,
       			loopCount = 0,
        		loopDirection = "forward"
		    }
		}
		HUD.satanIndicator = display.newSprite( HUD.satanIndicatorGroup, HUD.sheet_satanIndicator,sequences_satanIndicator)
		HUD.satanIndicator.x = g.ccx
		HUD.satanIndicator.y = g.ccy
		HUD.satanIndicator:scale(0.75,0.75)
		HUD.satanIndicator:setSequence("play")
		HUD.satanIndicator:play()
		HUD.distanceText = display.newText( HUD.satanIndicatorGroup, tostring(HUD.distance).."m", g.ccx, g.ccy+60, native.systemFont,60)
		HUD.hudGroup:insert(HUD.satanIndicatorGroup)
		HUD.satanIndicator.alpha = 0
		HUD.pointer:setFillColor(1,0,0,0)
		HUD.distanceText:setFillColor( 1,1,0,0)
		HUD.pointer.anchorX=-1

		HUD.shotgunOMeter = display.newImage( HUD.hudGroup, "Graphics/UI/Shotgun.png",400,110,isFullResolution )
		HUD.blocks = {}

	end
	HUD.initializeHUD = initializeHUD

	local function updateSatanPointer(satanX,satanY,playerX,playerY,cameraLockX,cameraLockY)
		HUD.distance = math.sqrt(math.pow((satanX-playerX),2)+math.pow((satanY-playerY),2))
		if(HUD.distance/100 >10)then
			HUD.satanIndicator.alpha = 1
			HUD.pointer:setFillColor(1,0,0,1)
			HUD.distanceText:setFillColor( 1,1,0,1)
			HUD.distanceText.text = tostring(math.floor(HUD.distance/100)).."m"
			local xDiff = satanX-playerX
			local yDiff = satanY-playerY
			local rotation = math.atan2(yDiff,xDiff)*(180/math.pi)
			HUD.pointer.rotation = rotation	
			if(xDiff < (g.ccx*-1)+100)then
				xDiff = (g.ccx*-1)+100
			elseif(xDiff > g.ccx-100)then
				xDiff = g.ccx-100
			end
			if(yDiff < (g.ccy*-1)+100)then
				yDiff = (g.ccy*-1)+100
			elseif(yDiff > g.ccy-100)then
				yDiff = g.ccy-100
			end
			HUD.satanIndicatorGroup.x = xDiff
			HUD.satanIndicatorGroup.y = yDiff
		else 
			HUD.satanIndicator.alpha = 0
			HUD.pointer:setFillColor(1,0,0,0)
			HUD.distanceText:setFillColor( 1,1,0,0)
		end
	end
	HUD.updateSatanPointer = updateSatanPointer

	local function updateShotgunOMeter(power)
		for j = 1,table.getn(HUD.blocks),1 do
				HUD.blocks[j]:removeSelf( )
		end
		for i=1,power-9,1 do
			HUD.blocks[i]=display.newRect( HUD.hudGroup,(i*42)+340, 95, 40,40 )
			HUD.blocks[i]:setFillColor((i/2.5),2/i,0,0.8)
			HUD.blocks[i]:toBack()
		end
	end
	HUD.updateShotgunOMeter = updateShotgunOMeter
	
	local function killHUD()
		if (hudInitialized == true)then
			HUD.hudGroup:removeSelf()
			HUD.hudGroup = nil
		end
	end
	HUD.killHUD = killHUD

return HUD