package hex.di.mock.injectees;

import hex.di.ISpeedInjectorContainer;
import hex.di.mock.types.Clazz;

/**
 * ...
 * @author Francis Bourre
 */
class PostConstructWithArgInjectee implements ISpeedInjectorContainer
{
	public var property : Clazz;
	
	public function new() 
	{
		
	}

	@PostConstruct
	public function doSomeStuff( arg : Clazz ) : Void
	{
		this.property = arg;
	}
}