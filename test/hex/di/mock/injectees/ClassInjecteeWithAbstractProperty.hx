package hex.di.mock.injectees;

import hex.structures.Point;

/**
 * ...
 * @author Francis Bourre
 */
class ClassInjecteeWithAbstractProperty implements IInjectorContainer
{
	@Inject
	public var property : Point;
		
	public function new() 
	{
		
	}
}