package hex.di.mock.types;

/**
 * ...
 * @author Francis Bourre
 */
class Clazz implements Interface implements Interface2 implements IInjectorContainer
{
	public var preDestroyCalled : Bool = false;

	public function new() 
	{
		
	}
	
	@PreDestroy
	public function preDestroy() : Void
	{
		this.preDestroyCalled = true;
	}
}