package hex.di.mock.injectable;

/**
 * ...
 * @author Francis Bourre
 */
class RecursiveInterfaceInjectee implements IInjectable
{
	@Inject
	public var interfaceInjectee : InterfaceInjectee;
	
	public function new() 
	{
		
	}
}