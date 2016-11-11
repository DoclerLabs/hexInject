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
    public var a : Array<ArgumentInjection>;
	
	//order
	public var o : Int;
}