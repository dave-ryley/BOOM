return
{
    _namespace = "SFX.CHARACTER",

    BASE = 
    {
        volume = 1,
    },

    SATAN_INTRO = 
    {
        _includes = "BASE",
        asset = 
        {
            "Resources/Sounds/Satan/ImComingHaHa",
            "Resources/Sounds/Satan/Laugh",
            "Resources/Sounds/Satan/RunMortal",
            "Resources/Sounds/Satan/YouCannotEscape",
            "Resources/Sounds/Satan/YourSoulIsMine",
        },
    },

    CHARACTER_FOOTSTEPS_RUNNING = 
    {
        _includes = "BASE",
        asset = 
        {
            "Resources/Sounds/Player/Step1.ogg",
            "Resources/Sounds/Player/Step2.ogg",
        },
    },

    DOG_BARK = 
    {
        _includes = "BASE",
        asset = 
        {
            "Resources/Sounds/Enemies/DogBarkAngry.ogg",
            "Resources/Sounds/Enemies/DogBarkHappy.ogg",
        },
    },

    IMP_LAUGH = 
    {
        _includes = "BASE",
        asset = "Resources/Sounds/Enemies/ImpLaugh.ogg",
    },

    IMP_FIRE = 
    {
        _includes = "BASE",
        asset = "Resources/Sounds/Enemies/ImpFire.ogg",
    },

    SPLATTER = 
    {
        _includes = "BASE",
        asset = "Resources/Sounds/Enemies/Splat.ogg",
    },
}