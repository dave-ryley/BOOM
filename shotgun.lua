local C = {}
	--C.col = require "collisionFilters"
	local vertices = { -20,0, -100,-300, 100,-300, 20,0, }
	C.bounds = display.newPolygon( 0, 0, vertices )


	C.bounds.alpha = 0.0
	C.power = 1
	C.force = 500
	C.bounds.reloading = false
	C.bounds.myName = "shotgun"
	C.bounds.anchorX = 0.3
	C.bounds.anchorY = 1
	
	local blastShape = { 	80 	-C.bounds.width/2,	320	-C.bounds.height/2,
							120 -C.bounds.width/2,	0	-C.bounds.height/2,
							0 	-C.bounds.width/2,	0 	-C.bounds.height/2,
							40 	-C.bounds.width/2,	320	-C.bounds.height/2}

	physics.addBody( C.bounds, "dynamic", 	{ 	density=0.0, 
												friction=0.0, 
												bounce=0.0,
												--filter=C.col.shotgunCol,
												shape=blastShape, 
												isSensor=true
										})
	C.bounds.isAwake = false

	--C.bounds.filter=C.col.shotgunCol
	-- Setting up the blast Animation
    C.blast = display.newGroup()
    C.blast:insert(C.bounds)
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
        elseif aimAngle < 68 then
        	C.blast.rotation = 45
        	C.blast.x = x + 62
			C.blast.y = y - 27
        elseif aimAngle < 113 then
        	C.blast.rotation = 90
        	C.blast.x = x + 65
			C.blast.y = y + 10
        elseif aimAngle < 158 then
        	C.blast.rotation = 135
        	C.blast.x = x + 50
			C.blast.y = y + 50
        elseif aimAngle < 203 then
        	C.blast.rotation = 180
        	C.blast.x = x - 20
			C.blast.y = y + 70
        elseif aimAngle < 248 then
        	C.blast.rotation = 225
        	C.blast.x = x - 70
			C.blast.y = y + 40
        elseif aimAngle < 293 then
        	C.blast.rotation = 270
        	C.blast.x = x - 70
			C.blast.y = y
        else
        	C.blast.rotation = 315
        	C.blast.x = x - 35
			C.blast.y = y - 50
        end
    end
    C.onCollision = function( event ) 
		print("shotgun collision with: " ..event.other.myName)
		if (event.phase == "began") then
		
		end
	end
	C.bounds:addEventListener( "collision", C.onCollision )
    C.place = place
return C