package hex.di.reflect;

/**
 * ...
 * @author Francis Bourre
 */
class OrderedInjection extends MethodInjection
{
	public var order( default, null ) : Int;
	
	public function new( methodName : String, args : Array<ArgumentInjectionVO>, order : Int = 0 ) 
	{
		super( methodName, args );
		this.order = order;
	}
}