local HUD = {}
	
	local g = require "globals"
	local hudGroup = display.newGroup()

	local satanIndicatorGroup = display.newGroup()
	satanIndicatorGroup.x = g.ccx
	satanIndicatorGroup.y = g.ccy
	hudGroup:insert(satanIndicatorGroup)
	local satanIndicator = display.newCircle( satanIndicatorGroup, g.ccx/2, 0, 60 )
	satanIndicator:setFillColor(1,1,0)

	local function updateSatanPointer(satanX,satanY,playerX,playerY)
		local distance = math.sqrt(math.pow((satanX-playerX),2)+math.pow((satanY-playerY),2))
		xDiff = satanX-playerX
		yDiff = satanY-playerY
		rotation = math.atan2(yDiff,xDiff)*(180/math.pi)
		print(rotation)
		satanIndicatorGroup.rotation = rotation
	end
	
	HUD.updateSatanPointer = updateSatanPointer

return HUD