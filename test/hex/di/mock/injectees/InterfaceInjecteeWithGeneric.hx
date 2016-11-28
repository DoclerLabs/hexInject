package hex.di.mock.injectees;

import hex.di.mock.types.InterfaceWithGeneric;

/**
 * ...
 * @author Francis Bourre
 */
class InterfaceInjecteeWithGeneric implements IInjectorContainer
{
	@Inject
	public var stringProperty : InterfaceWithGeneric<String>;
	
	@Inject
	public var intProperty : InterfaceWithGeneric<Int>;
	
	@Inject
	public var objectProperty : InterfaceWithGeneric<{}>;
	
	public function new() 
	{
		
	}
}