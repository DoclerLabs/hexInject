package hex.di.mock.injectable;

/**
 * ...
 * @author Francis Bourre
 */
class ComplexClassInjectee implements IInjectable
{
	@Inject
	public var property : ComplexClazz;
	
	public function new() 
	{
		
	}
}