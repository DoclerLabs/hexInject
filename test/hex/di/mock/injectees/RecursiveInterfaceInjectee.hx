package hex.di.mock.injectees;

import hex.di.ISpeedInjectorContainer;

/**
 * ...
 * @author Francis Bourre
 */
class RecursiveInterfaceInjectee implements ISpeedInjectorContainer
{
	@Inject
	public var interfaceInjectee : InterfaceInjectee;
	
	public function new() 
	{
		
	}
}