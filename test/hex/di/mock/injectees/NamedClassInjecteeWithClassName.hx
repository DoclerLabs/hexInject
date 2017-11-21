package hex.di.mock.injectees;

/**
 * ...
 * @author Francis Bourre
 */
class NamedClassInjecteeWithClassName implements IInjectorContainer
{
	@Inject( 'Clazz' )
	public var property : Clazz;
	
	public function new() 
	{
		
	}
}