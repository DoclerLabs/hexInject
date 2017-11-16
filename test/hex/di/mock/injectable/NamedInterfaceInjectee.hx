package hex.di.mock.injectable;

import hex.di.mock.types.Interface;

/**
 * ...
 * @author Francis Bourre
 */
class NamedInterfaceInjectee implements IInjectable
{
	public inline static var NAME : String = 'Name';
		
	@Inject( 'Name' )
	public var property : Interface;

	public function new() 
	{
		
	}
}