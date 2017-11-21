package hex.di.mock.injectable;

/**
 * ...
 * @author Francis Bourre
 */
class InterfaceInjecteeWithMethod implements IInjectable
{
	@Inject
	public var methodWithStringArgument : String->Void;
	
	@Inject
	public var methodWithMultipleArguments : String->Array<Int>->Bool;
	
	public function new() 
	{
		
	}
}