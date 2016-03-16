package hex.di.mock.injectees;

import hex.di.ISpeedInjectorContainer;
import hex.di.mock.types.Interface;

/**
 * ...
 * @author Francis Bourre
 */
class TwoNamedInterfaceFieldsInjectee implements ISpeedInjectorContainer
{
	@Inject( "Name1" )
	public var property1 : Interface;
	
	@Inject( "Name2" )
	public var property2 : Interface;
	
	public function new() 
	{
		
	}
	
}