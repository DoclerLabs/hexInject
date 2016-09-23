package hex.di.mock.injectees;

import hex.di.IInjectorContainer;
import hex.di.mock.types.Clazz;

/**
 * ...
 * @author Francis Bourre
 */
class NamedClassInjecteeWithClassName implements IInjectorContainer
{
	@Inject( 'Clazz' )
	public var property : Clazz;
	
	public function new() 
	{
		
	}
}