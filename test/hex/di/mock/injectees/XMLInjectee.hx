package hex.di.mock.injectees;

import hex.di.IInjectorContainer;

/**
 * ...
 * @author Francis Bourre
 */
class XMLInjectee implements IInjectorContainer
{
	@Inject
	public var property : Xml;
	
	public function new() 
	{
		
	}
}