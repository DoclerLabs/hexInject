package hex.di.mock.injectees;

import hex.di.ISpeedInjectorContainer;
import hex.di.mock.types.Clazz;

/**
 * ...
 * @author Francis Bourre
 */
class NamedClassInjectee implements ISpeedInjectorContainer
{
	public inline static var NAME : String = 'Name';
		
	@Inject( 'Name' )
	public var property : Clazz;
	
	public function new() 
	{
		
	}
}