local shootSpeed = 150
local lowerBody_sequences =
{
    {
        name = "UpRun",
        start = 1,
        count = 8,
        time = 800,
        loopCount = 0,
        loopDirection = "forward"
    },
    {
        name = "UpRightRun",
        start = 20,
        count = 8,
        time = 800,
        loopCount = 0,
        loopDirection = "forward"
    },
    {
        name = "RightRun",
        start = 39,
        count = 8,
        time = 800,
        loopCount = 0,
        loopDirection = "forward"
    },
    {
        name = "DownRightRun",
        start = 58,
        count = 8,
        time = 800,
        loopCount = 0,
        loopDirection = "forward"
    },
    {
        name = "DownRun",
        start = 77,
        count = 8,
        time = 800,
        loopCount = 0,
        loopDirection = "forward"
    },
    {
        name = "UpLeftRun",
        start = 96,
        count = 8,
        time = 800,
        loopCount = 0,
        loopDirection = "forward"
    },
    {
        name = "LeftRun",
        start = 115,
        count = 8,
        time = 800,
        loopCount = 0,
        loopDirection = "forward"
    },
    {
        name = "DownLeftRun",
        start = 134,
        count = 8,
        time = 800,
        loopCount = 0,
        loopDirection = "forward"
    },
    {
        name = "DownBackRun",
        frames = { 8,7,6,5,4,3,2,1 },
        time = 800,
        loopCount = 0,
        loopDirection = "forward"
    },
    {
        name = "DownLeftBackRun",
        frames = { 27,26,25,24,23,22,21,20 },
        time = 800,
        loopCount = 0,
        loopDirection = "forward"
    },
    {
        name = "LeftBackRun",
        frames = { 46,45,44,43,42,41,40,39 },
        time = 800,
        loopCount = 0,
        loopDirection = "forward"
    },
    {
        name = "UpLeftBackRun",
        frames = { 65,64,63,62,61,60,59,58 },
        time = 800,
        loopCount = 0,
        loopDirection = "forward"
    },
    {
        name = "UpBackRun",
        frames = { 84,83,82,81,80,79,78,77 },
        time = 800,
        loopCount = 0,
        loopDirection = "forward"
    },
    {
        name = "DownRightBackRun",
        frames = { 103,102,101,100,99,98,97,96 },
        time = 800,
        loopCount = 0,
        loopDirection = "forward"
    },
    {
        name = "RightBackRun",
        frames = { 122,121,120,119,118,117,116,115 },
        time = 800,
        loopCount = 0,
        loopDirection = "forward"
    },
    {
        name = "UpRightBackRun",
        frames = { 141,140,139,138,137,136,135,134 },
        time = 800,
        loopCount = 0,
        loopDirection = "forward"
    },
    {
        name = "UpStand",
        start = 12,
        count = 8,
        time = 1600,
        loopCount = 0,
        loopDirection = "forward"
    },
    {
        name = "UpRightStand",
        start = 31,
        count = 8,
        time = 1600,
        loopCount = 0,
        loopDirection = "forward"
    },
    {
        name = "RightStand",
        start = 50,
        count = 8,
        time = 1600,
        loopCount = 0,
        loopDirection = "forward"
    },
    {
        name = "DownRightStand",
        start = 69,
        count = 8,
        time = 1600,
        loopCount = 0,
        loopDirection = "forward"
    },
    {
        name = "DownStand",
        start = 88,
        count = 8,
        time = 1600,
        loopCount = 0,
        loopDirection = "forward"
    },
    {
        name = "UpLeftStand",
        start = 107,
        count = 8,
        time = 1600,
        loopCount = 0,
        loopDirection = "forward"
    },
    {
        name = "LeftStand",
        start = 126,
        count = 8,
        time = 1600,
        loopCount = 0,
        loopDirection = "forward"
    },
    {
        name = "DownLeftStand",
        start = 145,
        count = 8,
        time = 1600,
        loopCount = 0,
        loopDirection = "forward"
    },
    {
        name = "UpShoot",
        start = 9,
        count = 3,
        time = shootSpeed,
        loopCount = 1,
        loopDirection = "bounce"
    },
    {
        name = "UpRightShoot",
        start = 28,
        count = 8,
        time = shootSpeed,
        loopCount = 1,
        loopDirection = "bounce"
    },
    {
        name = "RightShoot",
        start = 47,
        count = 3,
        time = shootSpeed,
        loopCount = 1,
        loopDirection = "bounce"
    },
    {
        name = "DownRightShoot",
        start = 66,
        count = 3,
        time = shootSpeed,
        loopCount = 1,
        loopDirection = "bounce"
    },
    {
        name = "DownShoot",
        start = 85,
        count = 3,
        time = shootSpeed,
        loopCount = 1,
        loopDirection = "bounce"
    },
    {
        name = "UpLeftShoot",
        start = 104,
        count = 3,
        time = shootSpeed,
        loopCount = 1,
        loopDirection = "bounce"
    },
    {
        name = "LeftShoot",
        start = 123,
        count = 3,
        time = shootSpeed,
        loopCount = 1,
        loopDirection = "bounce"
    },
    {
        name = "DownLeftShoot",
        start = 142,
        count = 3,
        time = shootSpeed,
        loopCount = 1,
        loopDirection = "bounce"
    }
}
return lowerBody_sequences
