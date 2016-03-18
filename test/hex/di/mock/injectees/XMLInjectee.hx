package hex.di.mock.injectees;

import hex.di.ISpeedInjectorContainer;

/**
 * ...
 * @author Francis Bourre
 */
class XMLInjectee implements ISpeedInjectorContainer
{
	@Inject
	public var property : Xml;
	
	public function new() 
	{
		
	}
}