package hex.di.mock.injectable;

import hex.di.mock.types.Interface;
import hex.log.IsLoggable;

class InterfaceInjecteeWithIsLoggable implements IInjectableAndIsLoggable
{
	@Inject
	public var property : Interface;
	
	public function new() 
	{
		
	}
}

interface IInjectableAndIsLoggable extends IsLoggable extends IInjectable
{}