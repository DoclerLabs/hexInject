package hex.di.mock.injectees;

/**
 * ...
 * @author Francis Bourre
 */
class InterfaceInjecteeWithMethod implements IInjectorContainer
{
	@Inject
	public var methodWithStringArgument : String->Void;
	
	@Inject
	public var methodWithMultipleArguments : String->Array<Int>->Bool;
	
	public function new() 
	{
		
	}
}