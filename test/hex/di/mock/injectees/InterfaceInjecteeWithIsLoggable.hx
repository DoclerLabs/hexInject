package hex.di.mock.injectees;

import hex.di.mock.types.Interface;
import hex.log.IsLoggable;

class InterfaceInjecteeWithIsLoggable implements IInjectorContainerAndIsLoggable
{
	@Inject
	public var property : Interface;
	
	public function new() 
	{
		
	}
}

interface IInjectorContainerAndIsLoggable extends IsLoggable extends IInjectorContainer
{}