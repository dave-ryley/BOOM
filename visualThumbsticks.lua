local T = {}

T.rightThumbstick = display.newGroup()

T.rightThumbstickHead = display.newCircle( 0, 0, 14 )
T.rightThumbstickHead:setFillColor( 1 )
T.rightThumbstickHead.alpha = 0.5

T.rightThumbstickBase = display.newCircle( 0, 0, 20 )
T.rightThumbstickBase:setFillColor( 1 )
T.rightThumbstickBase.alpha = 0.5

T.rightThumbstick:insert( T.rightThumbstickBase )
T.rightThumbstick:insert( T.rightThumbstickHead )

T.leftThumbstick = display.newGroup()

T.leftThumbstickHead = display.newCircle( 0, 0, 14 )
T.leftThumbstickHead:setFillColor( 1 )
T.leftThumbstickHead.alpha = 0.5

T.leftThumbstickBase = display.newCircle( 0, 0, 20 )
T.leftThumbstickBase:setFillColor( 1 )
T.leftThumbstickBase.alpha = 0.5

T.leftThumbstick:insert( T.leftThumbstickBase )
T.leftThumbstick:insert( T.leftThumbstickHead )


T.rightThumbstick.x = display.contentWidth/2 + 50
T.rightThumbstick.y = display.contentHeight - 200
T.leftThumbstick.x = display.contentWidth/2 - 50
T.leftThumbstick.y = display.contentHeight - 200