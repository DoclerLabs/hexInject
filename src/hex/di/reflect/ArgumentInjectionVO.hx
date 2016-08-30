package hex.di.reflect;

typedef ArgumentInjectionVO =
{
    var type             : Class<Dynamic>;
    var injectionName    : String;
    var isOptional       : Bool;
}
