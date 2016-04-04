package hex.di.mock.injectees;

import hex.di.IInjectorContainer;

/**
 * ...
 * @author Francis Bourre
 */
class StringInjectee implements IInjectorContainer
{
	@Inject
	public var property : String;
		
	public function new() 
	{
		
	}
}