package hex.di.mock.injectees;

import hex.di.IInjectorContainer;
import hex.di.mock.types.ComplexClazz;

/**
 * ...
 * @author Francis Bourre
 */
class ComplexClassInjectee implements IInjectorContainer
{
	@Inject
	public var property : ComplexClazz;
	
	public function new() 
	{
		
	}
}