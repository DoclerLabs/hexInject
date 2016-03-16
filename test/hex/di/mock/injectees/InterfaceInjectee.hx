package hex.di.mock.injectees;

import hex.di.mock.types.Interface;

/**
 * ...
 * @author Francis Bourre
 */
class InterfaceInjectee implements ISpeedInjectorContainer
{
	@Inject
	public var property : Interface;
	
	public function new() 
	{
		
	}
}