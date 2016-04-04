package hex.di.mock.injectees;

import hex.di.IInjectorContainer;
import hex.di.mock.types.Interface;

/**
 * ...
 * @author Francis Bourre
 */
class OptionalClassInjectee implements IInjectorContainer
{
	@Inject
	@Optional( true )
	public var property : Interface;

	public function new() 
	{
		
	}
}