package hex.di.mock.injectees;

import hex.di.IInjectorContainer;

/**
 * ...
 * @author Francis Bourre
 */
class NamedArrayCollectionInjectee implements IInjectorContainer
{
	@Inject( "namedCollection" )
	public var ac : Array<Dynamic>;
	
	public function new() 
	{
		
	}
}