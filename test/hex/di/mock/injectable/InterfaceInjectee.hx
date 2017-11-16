package hex.di.mock.injectable;

import hex.di.mock.types.Interface;

/**
 * ...
 * @author Francis Bourre
 */
class InterfaceInjectee implements IInjectable
{
	@Inject
	public var property : Interface;
	
	public function new() 
	{
		
	}
}