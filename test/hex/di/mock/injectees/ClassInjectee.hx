package hex.di.mock.injectees;

import hex.di.mock.types.Clazz;

/**
 * ...
 * @author Francis Bourre
 */
class ClassInjectee implements IInjectorContainer
{
	@Inject
	public var property : Clazz;
		
	public var someProperty : Bool;
		
	public function new() 
	{
		someProperty = false;
	}
	
	@PostConstruct( 1 )
	public function doSomeStuff() : Void
	{
		this.someProperty = true;
	}
}