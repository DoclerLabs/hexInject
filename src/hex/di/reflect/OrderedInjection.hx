package hex.di.reflect;

/**
 * ...
 * @author Francis Bourre
 */
typedef OrderedInjection =
{
	public var methodName : String;
    public var args : Array<ArgumentInjectionVO>;
	public var order : Int;
}