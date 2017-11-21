package hex.di.mock.injectable;

import hex.di.IDependencyInjector;

/**
 * ...
 * @author Francis Bourre
 */
class InjectorInjectee implements IInjectable
{
	@Inject
	public var injector : IDependencyInjector;
	
	public function new() 
	{
		
	}
}