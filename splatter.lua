--[[local C = {}
	local function splat(parts)
		print("in plat")
		local p = require "splatterParts"
		--if(parts == "imp") then
		local P = {}
			P.spawn = 
		--end
	end
	C.splat = splat
return C
						
				print("making face: " .. temp.myName)
				local xPos = temp.bounds.x
				local yPos = temp.bounds.y 
				local face1 = display.newImageRect( "Graphics/Temp/TestFaceShattered/facePiece1.png",
				                      66, 49)
				local face2 = display.newImageRect( "Graphics/Temp/TestFaceShattered/facePiece2.png",
				              54, 60)
				local face3 = display.newImageRect( "Graphics/Temp/TestFaceShattered/facePiece3.png",
				              59, 51)
				local face4 = display.newImageRect( "Graphics/Temp/TestFaceShattered/facePiece4.png",
				              50, 66)
				face1.x = xPos
				face1.y = yPos
				--face1:translate( xPos, yPos )
				face2.x = xPos
				face2.y = yPos

				face3.x = xPos
				face3.y= yPos

				face4.x = xPos
				face4.y = yPos
				
				physics.addBody(  face1,
				          "dynamic",
				        {   density = 0.5,
				          friction = 0.5,
				          bounce = 0.9})
				physics.addBody(  face2,
				          "dynamic",
				        {   density = 0.5,
				          friction = 0.5,
				          bounce = 0.9})
				physics.addBody(  face3,
				          "dynamic",
				        {   density = 0.5,
				          friction = 0.5,
				          bounce = 0.9})
				physics.addBody(  face4,
				          "dynamic",
				        {   density = 0.5,
				          friction = 0.5,
				          bounce = 0.9})

				face1.linearDamping = 3
				face2.linearDamping = 3
				face3.linearDamping = 3
				face4.linearDamping = 3

				face1.angularDamping = 3
				face2.angularDamping = 3
				face3.angularDamping = 3
				face4.angularDamping = 3

	         face1:applyLinearImpulse(  
	                 math.cos(player.thisAimAngle)*500, 
	                 math.sin(player.thisAimAngle)*500, 
	                 50, 
	                 50 )
	         face2:applyLinearImpulse(  
	                 math.cos(player.thisAimAngle)*500, 
	                 math.sin(player.thisAimAngle)*500, 
	                 50, 
	                 50 )
	         face3:applyLinearImpulse(  
	                 math.cos(player.thisAimAngle)*500, 
	                 math.sin(player.thisAimAngle)*500, 
	                 50, 
	                 50 )
	         face4:applyLinearImpulse(  
	                 math.cos(player.thisAimAngle)*500, 
	                 math.sin(player.thisAimAngle)*500, 
	                 50, 
	                 50 )
				local gore = display.newGroup( )
				gore:insert(face1)
				gore:insert(face2)
				gore:insert(face3)
				gore:insert(face4)

			return gore
		end
		]]