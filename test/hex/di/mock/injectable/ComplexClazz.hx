package hex.di.mock.injectable;

import hex.di.mock.types.ComplexInterface;

/**
 * ...
 * @author Francis Bourre
 */
class ComplexClazz implements ComplexInterface implements IInjectable
{
	@Inject
	public var value : Clazz;

	public function new() 
	{
		
	}
}