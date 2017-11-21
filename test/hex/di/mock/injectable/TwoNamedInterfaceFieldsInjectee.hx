package hex.di.mock.injectable;

import hex.di.mock.types.Interface;

/**
 * ...
 * @author Francis Bourre
 */
class TwoNamedInterfaceFieldsInjectee implements IInjectable
{
	@Inject( "Name1" )
	public var property1 : Interface;
	
	@Inject( "Name2" )
	public var property2 : Interface;
	
	public function new() 
	{
		
	}
	
}