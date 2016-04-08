local C = {}

C.collisionBody = display.newRect(0,0,200,200)
physics.addBody( C.collisionBody, "static", {friction=0.5, bounce=0.3})
C.collisionBody.myName = "testBlock"

return C