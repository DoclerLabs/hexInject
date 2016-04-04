package hex.di.mock.types;

import hex.di.IInjectorContainer;

/**
 * ...
 * @author Francis Bourre
 */
class ComplexClazz implements ComplexInterface implements IInjectorContainer
{
	@Inject
	public var value : Clazz;

	public function new() 
	{
		
	}
}