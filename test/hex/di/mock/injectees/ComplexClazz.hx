package hex.di.mock.injectees;

import hex.di.mock.types.ComplexInterface;

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