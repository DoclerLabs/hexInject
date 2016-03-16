package hex.di.mock.injectees;

import hex.di.ISpeedInjectorContainer;
import hex.di.mock.types.Interface;

/**
 * ...
 * @author Francis Bourre
 */
class NamedInterfaceInjectee implements ISpeedInjectorContainer
{
	public inline static var NAME : String = 'Name';
		
	@Inject( 'Name' )
	public var property : Interface;

	public function new() 
	{
		
	}
}