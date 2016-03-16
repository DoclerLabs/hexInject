package hex.di.mock.injectees;

import hex.di.ISpeedInjectorContainer;
import hex.di.mock.types.Clazz;

/**
 * ...
 * @author Francis Bourre
 */
class SetterInjectee implements ISpeedInjectorContainer
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