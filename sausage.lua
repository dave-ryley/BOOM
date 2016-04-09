local S = {}

	S.sausage1 = display.newRect( 0, 0, 200, 100 )
	S.sausage2 = display.newRect( 200, 0, 200, 100 )
	S.sausage3 = display.newRect( 400, 0, 200, 100 )
	S.pivot1 = display.newCircle( -50, 0, 10 )
	S.pivot2 = display.newCircle( 50, 0, 10 )
	S.paint1 = {1, 0, 0}
	S.paint2 = {0, 1, 0}
	S.paint3 = {0, 0, 1}
	S.sausage1.dg = display.newGroup()
	S.sausage1.dg:insert(S.pivot1)
	S.sausage1.dg:insert(S.pivot2)
	S.sausage1.fill = S.paint1
	S.sausage2.fill = S.paint2
	S.sausage3.fill = S.paint3
	--[[]]
	physics.addBody( S.sausage1, "dynamic", {friction=0.5, bounce=1})
	physics.addBody( S.sausage2, "dynamic", {friction=0.5, bounce=1} )
	physics.addBody( S.sausage3, "dynamic", {friction=0.5, bounce=1} )
	S.sausage1.linearDamping = 2
	S.sausage2.linearDamping = 2
	S.sausage3.linearDamping = 2
	S.parent = display.newGroup( )
	S.parent:insert( S.sausage1 )
	S.parent:insert( S.sausage2 )
	S.parent:insert( S.sausage3 )
	--S.parent:inser
	S.joint1 = physics.newJoint( "pivot", 
									S.sausage1, S.sausage2, 	--objects to be linked
									S.sausage1.x + 80,			--anchorA.x 
									S.sausage1.y, 				--anchorB.y 
									S.sausage1.x - 80,			--anchorA.x 
									S.sausage2.y )				--anchorB.y 
	S.joint1.isLimitEnable = true
	S.joint1:setRotationLimits( -5, 5 )
	S.joint2 = physics.newJoint( "pivot", 
									S.sausage2, S.sausage3, 	--objects to be linked
									S.sausage2.x + 80,			--anchorA.x 
									S.sausage2.y, 				--anchorB.y 
									S.sausage3.x - 80,	 		--anchorA.x 
									S.sausage3.y )				--anchorB.y 
	S.joint2.isLimitEnable = true
	S.joint2:setRotationLimits( -5, 5 )
	--S.joint3 = physics.newJoint( "pivot", S.sausage1, S.sausage3, 50, 0, -50, 0)
	--S.joint3.isLimitEnable = true
	--S.joint3:setRotationLimits( -20, 20 )

	--S.joint1.maxLength = 80
	--S.joint2.maxLength = 80
	--]]--S.joint2.maxLength = 100

return S