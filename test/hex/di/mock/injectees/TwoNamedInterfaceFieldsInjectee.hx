package hex.di.mock.injectees;

import hex.di.IInjectorContainer;
import hex.di.mock.types.Interface;

/**
 * ...
 * @author Francis Bourre
 */
class TwoNamedInterfaceFieldsInjectee implements IInjectorContainer
{
	@Inject( "Name1" )
	public var property1 : Interface;
	
	@Inject( "Name2" )
	public var property2 : Interface;
	
	public function new() 
	{
		
	}
	
}