package hex.di.mock.injectees;

import hex.di.IDependencyInjector;

/**
 * ...
 * @author Francis Bourre
 */
class InjectorInjectee implements IInjectorContainer
{
	@Inject
	public var injector : IDependencyInjector;
	
	public function new() 
	{
		
	}
}