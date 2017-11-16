package hex.di.mock.injectable;

import hex.di.mock.types.MockEnum;
import hex.structures.Point;

/**
 * ...
 * @author Francis Bourre
 */
class ClassInjecteeWithEnumProperty implements IInjectable
{
	@Inject
	public var property : MockEnum;
		
	public function new() 
	{
		
	}
}