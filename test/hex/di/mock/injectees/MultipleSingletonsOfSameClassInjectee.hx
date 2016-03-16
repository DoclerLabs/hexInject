package hex.di.mock.injectees;

import hex.di.ISpeedInjectorContainer;
import hex.di.mock.types.Interface;
import hex.di.mock.types.Interface2;

/**
 * ...
 * @author Francis Bourre
 */
class MultipleSingletonsOfSameClassInjectee implements ISpeedInjectorContainer
{
	@Inject
	public var property1 : Interface;
	
	@Inject
	public var property2 : Interface2;
		
	public function new() 
	{
		
	}
}