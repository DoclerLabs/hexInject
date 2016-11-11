package hex.di.mock.injectees;

/**
 * ...
 * @author Francis Bourre
 */
class ClassInjecteeWithBoolProperty implements IInjectorContainer
{
	@Inject
	public var property : Bool;
		
	public function new() 
	{
		
	}
	
	@PostConstruct( 1 )
	public function doSomeStuff() : Void
	{

	}
}