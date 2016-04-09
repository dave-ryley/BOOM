local C = {}

C.bounds = display.newRect(0,0,200,200)
physics.addBody( C.bounds, "static", {friction=0.5, bounce=0.3})
C.bounds.myName = "testBlock"

return C