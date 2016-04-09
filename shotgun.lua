local C = {}
	--C.collisionFilter = {categoryBits = 2, maskBits = 4}
	C.bounds = display.newImage( "Graphics/Temp/TestBlast.png")

	C.bounds.anchorX = 0.5
	C.bounds.anchorY = 0
	C.bounds.alpha = 0
	
	C.bounds.reloading = false
	C.myName = "shotgunObject"
	C.bounds.myName = "shotgun"
	local blastShape = { 	0 	-C.bounds.width/2 ,0 -C.bounds.height/2, 
							320	-C.bounds.width/2 , 40 -C.bounds.height/2, 
							320	-C.bounds.width/2 , 80 -C.bounds.height/2, 
							0	-C.bounds.width/2 , 120 -C.bounds.height/2}

	C.bounds.isSensor = true
	C.bounds.isAwake = false;
	physics.addBody( C.bounds, "dynamic", { 	density=0.0, 
													friction=0.0, 
													bounce=0.0, 
													shape=blastShape, 
													isSensor=true 
												} )

	function place(aimAngle)
		C.bounds.x = 0
		C.bounds.y = 0
        if aimAngle > 337 or aimAngle < 23 then
            C.bounds.rotation = 0
        elseif aimAngle < 68 then
        	C.bounds.rotation = 45
        elseif aimAngle < 113 then
        	C.bounds.rotation = 90
        elseif aimAngle < 158 then
        	C.bounds.rotation = 135
        elseif aimAngle < 203 then
        	C.bounds.rotation = 180
        elseif aimAngle < 248 then
        	C.bounds.rotation = 225
        elseif aimAngle < 293 then
        	C.bounds.rotation = 270
        else
        	C.bounds.rotation = 315
        end
    end

    C.place = place
return C