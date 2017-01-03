package hex.di.mock.injectees;

import hex.di.mock.types.MockTypedef;

/**
 * ...
 * @author Francis Bourre
 */
class ClassInjecteeWithTypedefProperty implements IInjectorContainer
{
	@Inject
	public var property : MockTypedef;
		
	public function new() 
	{
		
	}
}