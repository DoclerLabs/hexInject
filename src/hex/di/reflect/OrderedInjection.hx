package hex.di.reflect;

/**
 * ...
 * @author Francis Bourre
 */
typedef OrderedInjection =
{
	//methodName
	public var m : String;
	
	//args
    public var a : Array<ArgumentInjectionVO>;
	
	//order
	public var o : Int;
}