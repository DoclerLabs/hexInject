package hex.di.mock.injectable;

/**
 * ...
 * @author Francis Bourre
 */
class NamedClassInjecteeWithClassName implements IInjectable
{
	@Inject( 'Clazz' )
	public var property : Clazz;
	
	public function new() 
	{
		
	}
}