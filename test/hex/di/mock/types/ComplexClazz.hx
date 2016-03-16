package hex.di.mock.types;

import hex.di.ISpeedInjectorContainer;

/**
 * ...
 * @author Francis Bourre
 */
class ComplexClazz implements ComplexInterface implements ISpeedInjectorContainer
{
	@Inject
	public var value : Clazz;

	public function new() 
	{
		
	}
}