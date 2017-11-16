package hex.di.mock.injectable;

import hex.di.mock.types.InterfaceWithGeneric;

/**
 * ...
 * @author Francis Bourre
 */
class InterfaceInjecteeWithGeneric implements IInjectable
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