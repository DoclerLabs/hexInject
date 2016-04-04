package hex.di.mock.injectees;

import hex.di.IInjectorContainer;

/**
 * ...
 * @author Francis Bourre
 */
class RecursiveInterfaceInjectee implements IInjectorContainer
{
	@Inject
	public var interfaceInjectee : InterfaceInjectee;
	
	public function new() 
	{
		
	}
}