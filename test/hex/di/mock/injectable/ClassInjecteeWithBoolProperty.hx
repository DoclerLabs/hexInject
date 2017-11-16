package hex.di.mock.injectable;

/**
 * ...
 * @author Francis Bourre
 */
class ClassInjecteeWithBoolProperty implements IInjectable
{
	@Inject
	public var property : Bool;
		
	public function new() 
	{
		
	}
}