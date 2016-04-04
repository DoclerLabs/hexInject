package hex.di;

/**
 * ...
 * @author Francis Bourre
 */
class DISuite
{
	@Suite( "DI suite" )
    public var list : Array<Class<Dynamic>> = [ InjectorTest ];
}