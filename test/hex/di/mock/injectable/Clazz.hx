package hex.di.mock.injectable;

import hex.di.mock.types.Interface;
import hex.di.mock.types.Interface2;

/**
 * ...
 * @author Francis Bourre
 */
class Clazz implements Interface implements Interface2 implements IInjectable
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