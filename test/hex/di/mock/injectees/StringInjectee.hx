package hex.di.mock.injectees;

import hex.di.ISpeedInjectorContainer;

/**
 * ...
 * @author Francis Bourre
 */
class StringInjectee implements ISpeedInjectorContainer
{
	@Inject
	public var property : String;
		
	public function new() 
	{
		
	}
}