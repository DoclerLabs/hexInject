package hex.di.mock.injectees;

import hex.di.IDependencyInjector;

/**
 * ...
 * @author Francis Bourre
 */
class InjectorInjectee implements ISpeedInjectorContainer
{
	@Inject
	public var injector : IDependencyInjector;
	
	public function new() 
	{
		
	}
}