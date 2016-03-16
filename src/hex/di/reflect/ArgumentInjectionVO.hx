package hex.di.reflect;

class ArgumentInjectionVO
{
    public var type             : Class<Dynamic>;
    public var injectionName    : String;
    public var isOptional       : Bool = false;

    public function new( type : Class<Dynamic>, injectionName : String, isOptional : Bool = false )
    {
        this.type           = type;
        this.injectionName  = injectionName;
        this.isOptional     = isOptional;
    }
}
