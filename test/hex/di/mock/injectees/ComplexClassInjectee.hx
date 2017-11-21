package hex.di.mock.injectees;

/**
 * ...
 * @author Francis Bourre
 */
class ComplexClassInjectee implements IInjectorContainer
{
	@Inject
	public var property : ComplexClazz;
	
	public function new() 
	{
		
	}
}