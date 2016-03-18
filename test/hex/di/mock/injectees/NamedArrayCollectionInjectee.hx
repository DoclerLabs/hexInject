package hex.di.mock.injectees;

import hex.di.ISpeedInjectorContainer;

/**
 * ...
 * @author Francis Bourre
 */
class NamedArrayCollectionInjectee implements ISpeedInjectorContainer
{
	@Inject( "namedCollection" )
	public var ac : Array<Dynamic>;
	
	public function new() 
	{
		
	}
}