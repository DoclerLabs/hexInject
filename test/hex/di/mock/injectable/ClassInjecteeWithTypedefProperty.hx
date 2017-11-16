package hex.di.mock.injectable;

import hex.di.mock.types.MockTypedef;

/**
 * ...
 * @author Francis Bourre
 */
class ClassInjecteeWithTypedefProperty implements IInjectable
{
	@Inject
	public var property : MockTypedef;
		
	public function new() 
	{
		
	}
}