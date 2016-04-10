local C = {}

	C.shooting = false
	--C.collisionFilter = {categoryBits = 2, maskBits = 4}
	local vertices = { -20,0, -100,-300, 100,-300, 20,0, }
	C.bounds = display.newPolygon( 0, 0, vertices )
	C.bounds.alpha = 0.0
	C.max = 20
	C.min = 5
	C.power = 10 --Default
	C.force = 10 --
	-- Blast animation and bounds Scale = 1/10 power
	C.bounds.myName = "shotgun"
	--[[local blastShape = { 	0 	-C.bounds.width/2 ,0 -C.bounds.height/2, 
							320	-C.bounds.width/2 , 40 -C.bounds.height/2, 
							320	-C.bounds.width/2 , 80 -C.bounds.height/2, 
							0	-C.bounds.width/2 , 120 -C.bounds.height/2}
]]
	C.bounds.isSensor = true
	C.bounds.isAwake = false
	physics.addBody( C.bounds, "dynamic", { 	
												density=0.0, 
												friction=0.0, 
												bounce=0.0, 
												shape=vertices, 
												isSensor=true 
										} )
	C.bounds.isFixedRotation = false
	C.bounds.anchorY = 1.0
	-- Setting up the blast Animation
    
    C.blast = display.newGroup()
    --C.blast:insert(C.bounds)

    local blastSheetOptions =
    {
        width = 144,
        height = 322,
        numFrames = 5
    }
    C.blast_sheet = graphics.newImageSheet( "Graphics/Animation/shotBlast.png", blastSheetOptions )
    blast_sequences =
    {
        {
            name = "default",
            start = 1,
            count = 5,
            time = 250,
            loopCount = 1,
            loopDirection = "forward"
        }
    }

    C.blast_sprite = display.newSprite( C.blast, C.blast_sheet, blast_sequences )

    C.blast_sprite.anchorY = 1.0
    C.blast.alpha = 0.0
    C.blast_sprite:play()

	function place(aimAngle, x, y)
        if aimAngle > 337 or aimAngle < 23 then
            C.blast.rotation = 0
            C.blast.x = x + 30
			C.blast.y = y - 50
			C.bounds.rotation = 0
            C.bounds.x = x + 30
			C.bounds.y = y - 50
        elseif aimAngle < 68 then
        	C.blast.rotation = 45
        	C.blast.x = x + 62
			C.blast.y = y - 27
			C.bounds.rotation = 45
        	C.bounds.x = x + 62
			C.bounds.y = y - 27
        elseif aimAngle < 113 then
        	C.blast.rotation = 90
        	C.blast.x = x + 65
			C.blast.y = y + 10
			C.bounds.rotation = 90
        	C.bounds.x = x + 65
			C.bounds.y = y + 10
        elseif aimAngle < 158 then
        	C.blast.rotation = 135
        	C.blast.x = x + 50
			C.blast.y = y + 50
			C.bounds.rotation = 135
        	C.bounds.x = x + 50
			C.bounds.y = y + 50
        elseif aimAngle < 203 then
        	C.blast.rotation = 180
        	C.blast.x = x - 20
			C.blast.y = y + 70
			C.bounds.rotation = 180
        	C.bounds.x = x - 20
			C.bounds.y = y + 70
        elseif aimAngle < 248 then
        	C.blast.rotation = 225
        	C.blast.x = x - 70
			C.blast.y = y + 40
			C.bounds.rotation = 225
        	C.bounds.x = x - 70
			C.bounds.y = y + 40
        elseif aimAngle < 293 then
        	C.blast.rotation = 270
        	C.blast.x = x - 70
			C.blast.y = y
			C.bounds.rotation = 270
        	C.bounds.x = x - 70
			C.bounds.y = y
        else
        	C.blast.rotation = 315
        	C.blast.x = x - 35
			C.blast.y = y - 50
			C.bounds.rotation = 315
        	C.bounds.x = x - 35
			C.bounds.y = y - 50
        end
    end

    C.place = place

    function powerUp( value )
    	if value > 0 then
    		if value + C.power > C.max then
    			C.power = C.max
    		else
    			C.power = C.power + value
    		end
    	else
    		if value + C.power < C.min then
    			C.power = C.min
    		else
    			C.power = C.power + value
    		end
    	end
    	C.force = C.power*50-200
    	C.bounds.xScale = C.power/10
    	C.bounds.yScale = C.power/10
    	C.blast.xScale = C.power/10
    	C.blast.yScale = C.power/10
    end

    C.powerUp = powerUp

return C