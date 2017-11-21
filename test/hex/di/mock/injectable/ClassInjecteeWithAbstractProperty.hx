package hex.di.mock.injectable;

import hex.structures.Point;

/**
 * ...
 * @author Francis Bourre
 */
class ClassInjecteeWithAbstractProperty implements IInjectable
{
	@Inject
	public var property : Point;
		
	public function new() 
	{
		
	}
}