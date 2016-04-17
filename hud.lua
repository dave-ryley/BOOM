local HUD = {}
	
	local g = require "globals"
	HUD.hudGroup = display.newGroup()
	HUD.distance = 0

	HUD.satanIndicatorGroup = display.newGroup()
	HUD.pointer = display.newPolygon( HUD.satanIndicatorGroup, g.ccx, g.ccy, {0,0, 35,50,90,0,35,-50} )
	HUD.satanIndicator = display.newCircle( HUD.satanIndicatorGroup, g.ccx, g.ccy, 60 )
	HUD.distanceText = display.newText( HUD.satanIndicatorGroup, tostring(HUD.distance).."m", g.ccx, g.ccy+60, native.systemFont,60)

	HUD.hudGroup:insert(HUD.satanIndicatorGroup)
	HUD.satanIndicator:setFillColor(1,0,0)
	HUD.pointer:setFillColor(1,0,0)
	HUD.distanceText:setFillColor( 1,1,0 )
	HUD.pointer.anchorX=-1

	local function updateSatanPointer(satanX,satanY,playerX,playerY,cameraLockX,cameraLockY)
		HUD.distance = math.sqrt(math.pow((satanX-playerX),2)+math.pow((satanY-playerY),2))
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
	end
	HUD.updateSatanPointer = updateSatanPointer



return HUD