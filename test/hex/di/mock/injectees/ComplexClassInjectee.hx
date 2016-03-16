package hex.di.mock.injectees;

import hex.di.ISpeedInjectorContainer;
import hex.di.mock.types.ComplexClazz;

/**
 * ...
 * @author Francis Bourre
 */
class ComplexClassInjectee implements ISpeedInjectorContainer
{
	@Inject
	public var property : ComplexClazz;
	
	public function new() 
	{
		
	}
}