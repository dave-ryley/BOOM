local shootSpeed = 150
local lowerBody_sequences = 
{
    {
        name = "upRun",
        start = 1,
        count = 8,
        time = 800,
        loopCount = 0,
        loopDirection = "forward"
    },
    {
        name = "upRightRun",
        start = 20,
        count = 8,
        time = 800,
        loopCount = 0,
        loopDirection = "forward"
    },
    {
        name = "rightRun",
        start = 39,
        count = 8,
        time = 800,
        loopCount = 0,
        loopDirection = "forward"
    },
    {
        name = "downRightRun",
        start = 58,
        count = 8,
        time = 800,
        loopCount = 0,
        loopDirection = "forward"
    },
    {
        name = "downRun",
        start = 77,
        count = 8,
        time = 800,
        loopCount = 0,
        loopDirection = "forward"
    },
    {
        name = "upLeftRun",
        start = 96,
        count = 8,
        time = 800,
        loopCount = 0,
        loopDirection = "forward"
    },
    {
        name = "leftRun",
        start = 115,
        count = 8,
        time = 800,
        loopCount = 0,
        loopDirection = "forward"
    },
    {
        name = "downLeftRun",
        start = 134,
        count = 8,
        time = 800,
        loopCount = 0,
        loopDirection = "forward"
    },
    {
        name = "downBackRun",
        frames = { 8,7,6,5,4,3,2,1 },
        time = 800,
        loopCount = 0,
        loopDirection = "forward"
    },
    {
        name = "downLeftBackRun",
        frames = { 27,26,25,24,23,22,21,20 },
        time = 800,
        loopCount = 0,
        loopDirection = "forward"
    },
    {
        name = "leftBackRun",
        frames = { 46,45,44,43,42,41,40,39 },
        time = 800,
        loopCount = 0,
        loopDirection = "forward"
    },
    {
        name = "upLeftBackRun",
        frames = { 65,64,63,62,61,60,59,58 },
        time = 800,
        loopCount = 0,
        loopDirection = "forward"
    },
    {
        name = "upBackRun",
        frames = { 84,83,82,81,80,79,78,77 },
        time = 800,
        loopCount = 0,
        loopDirection = "forward"
    },
    {
        name = "downRightBackRun",
        frames = { 103,102,101,100,99,98,97,96 },
        time = 800,
        loopCount = 0,
        loopDirection = "forward"
    },
    {
        name = "rightBackRun",
        frames = { 122,121,120,119,118,117,116,115 },
        time = 800,
        loopCount = 0,
        loopDirection = "forward"
    },
    {
        name = "upRightBackRun",
        frames = { 141,140,139,138,137,136,135,134 },
        time = 800,
        loopCount = 0,
        loopDirection = "forward"
    },
    {
        name = "upStand",
        start = 12,
        count = 8,
        time = 1600,
        loopCount = 0,
        loopDirection = "forward"
    },
    {
        name = "upRightStand",
        start = 31,
        count = 8,
        time = 1600,
        loopCount = 0,
        loopDirection = "forward"
    },
    {
        name = "rightStand",
        start = 50,
        count = 8,
        time = 1600,
        loopCount = 0,
        loopDirection = "forward"
    },
    {
        name = "downRightStand",
        start = 69,
        count = 8,
        time = 1600,
        loopCount = 0,
        loopDirection = "forward"
    },
    {
        name = "downStand",
        start = 88,
        count = 8,
        time = 1600,
        loopCount = 0,
        loopDirection = "forward"
    },
    {
        name = "upLeftStand",
        start = 107,
        count = 8,
        time = 1600,
        loopCount = 0,
        loopDirection = "forward"
    },
    {
        name = "leftStand",
        start = 126,
        count = 8,
        time = 1600,
        loopCount = 0,
        loopDirection = "forward"
    },
    {
        name = "downLeftStand",
        start = 145,
        count = 8,
        time = 1600,
        loopCount = 0,
        loopDirection = "forward"
    },
    {
        name = "upShoot",
        start = 9,
        count = 3,
        time = shootSpeed,
        loopCount = 1,
        loopDirection = "bounce"
    },
    {
        name = "upRightShoot",
        start = 28,
        count = 8,
        time = shootSpeed,
        loopCount = 1,
        loopDirection = "bounce"
    },
    {
        name = "rightShoot",
        start = 47,
        count = 3,
        time = shootSpeed,
        loopCount = 1,
        loopDirection = "bounce"
    },
    {
        name = "downRightShoot",
        start = 66,
        count = 3,
        time = shootSpeed,
        loopCount = 1,
        loopDirection = "bounce"
    },
    {
        name = "downShoot",
        start = 85,
        count = 3,
        time = shootSpeed,
        loopCount = 1,
        loopDirection = "bounce"
    },
    {
        name = "upLeftShoot",
        start = 104,
        count = 3,
        time = shootSpeed,
        loopCount = 1,
        loopDirection = "bounce"
    },
    {
        name = "leftShoot",
        start = 123,
        count = 3,
        time = shootSpeed,
        loopCount = 1,
        loopDirection = "bounce"
    },
    {
        name = "downLeftShoot",
        start = 142,
        count = 3,
        time = shootSpeed,
        loopCount = 1,
        loopDirection = "bounce"
    }
}
return lowerBody_sequences