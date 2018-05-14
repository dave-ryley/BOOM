return
{
    _namespace = "CHARACTER",

    BASE = 
    {
        damage = 1,
        health = 3,
        speed = 10,
    },

    IMP =
    {
        _includes = "BASE",
    },

    SUPER_IMP =
    {
        _includes = "IMP",
    },

    SPOT =
    {
        _includes = "BASE",
    },

}