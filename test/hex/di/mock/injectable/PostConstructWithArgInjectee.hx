package hex.di.mock.injectable;

/**
 * ...
 * @author Francis Bourre
 */
class PostConstructWithArgInjectee implements IInjectable
{
	public var property : Clazz;
	
	public function new() 
	{
		
	}

	@PostConstruct
	public function doSomeStuff( arg : Clazz ) : Void
	{
		this.property = arg;
	}
}