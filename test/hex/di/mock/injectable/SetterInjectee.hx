package hex.di.mock.injectable;

/**
 * ...
 * @author Francis Bourre
 */
class SetterInjectee implements IInjectable
{
	@Inject
	@:isVar 
	public var property( get, set ) : Clazz;
	
	function get_property() : Clazz
	{
		return this.property;
	}
	
	function set_property( value : Clazz ) : Clazz
	{
		this.property = value;
		return value;
	}

	public function new() 
	{
		
	}
}