package hex.di.mock.injectees;

import hex.di.IInjectorContainer;
import hex.di.mock.types.Clazz;

/**
 * ...
 * @author Francis Bourre
 */
class NamedClassInjectee implements IInjectorContainer
{
	public inline static var NAME : String = 'Name';
		
	@Inject( 'Name' )
	public var property : Clazz;
	
	public function new() 
	{
		
	}
}