package hex.di.mock.injectable;

/**
 * ...
 * @author Francis Bourre
 */
class NamedArrayCollectionInjectee implements IInjectable
{
	@Inject( "namedCollection" )
	public var ac : Array<Dynamic>;
	
	public function new() 
	{
		
	}
}