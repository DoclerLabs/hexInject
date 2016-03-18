package hex.di.mock.injectees;

import hex.di.ISpeedInjectorContainer;
import hex.di.mock.types.Interface;

/**
 * ...
 * @author Francis Bourre
 */
class OptionalClassInjectee implements ISpeedInjectorContainer
{
	@Inject
	@Optional( true )
	public var property : Interface;

	public function new() 
	{
		
	}
}