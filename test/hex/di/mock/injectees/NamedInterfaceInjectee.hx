package hex.di.mock.injectees;

import hex.di.IInjectorContainer;
import hex.di.mock.types.Interface;

/**
 * ...
 * @author Francis Bourre
 */
class NamedInterfaceInjectee implements IInjectorContainer
{
	public inline static var NAME : String = 'Name';
		
	@Inject( 'Name' )
	public var property : Interface;

	public function new() 
	{
		
	}
}