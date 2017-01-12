package hex.di.mock.injectees;

import hex.di.mock.types.MockEnum;
import hex.structures.Point;

/**
 * ...
 * @author Francis Bourre
 */
class ClassInjecteeWithEnumProperty implements IInjectorContainer
{
	@Inject
	public var property : MockEnum;
		
	public function new() 
	{
		
	}
}