package hex.di.mock.injectees;

import hex.di.mock.types.Interface;

/**
 * ...
 * @author Francis Bourre
 */
class InterfaceInjectee implements IInjectorContainer
{
	@Inject
	public var property : Interface;
	
	public function new() 
	{
		
	}
}