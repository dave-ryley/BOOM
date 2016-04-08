local C = {}

	C.collisionBody = display.newImage( "Graphics/Temp/TestBlast.png", 
										display.contentCenterX/2,
										display.contentCenterY/2)
	--C.collisionBody.alpha = 1.0
	C.anchorX = 0
	C.anchorY = 0.5
	C.collisionBody.alpha = 0
	C.collisionBody.isAwake = false;
	--C.name = "shotgun"
	C.collisionBody.myName = "shotgun"
	local blastShape = { 	0 	-C.collisionBody.width/2 ,0 -C.collisionBody.height/2, 
							320	-C.collisionBody.width/2 , 40 -C.collisionBody.height/2, 
							320	-C.collisionBody.width/2 , 80 -C.collisionBody.height/2, 
							0	-C.collisionBody.width/2 , 120 -C.collisionBody.height/2}
	physics.addBody( C.collisionBody, "static", { density=0.0, friction=0.0, bounce=0.0, shape=blastShape, isSensor=true } )

	local function onCollision( self, event )
		if ( event.phase == "began" ) then

			print( self.myName .. ": collision began with " .. event.other.myName )

		elseif ( event.phase == "ended" ) then

			print( self.myName .. ": collision ended with " .. event.other.myName )

		end
	end

	C.collisionBody.collision = onCollision
	C.collisionBody:addEventListener( "collision" )

return C