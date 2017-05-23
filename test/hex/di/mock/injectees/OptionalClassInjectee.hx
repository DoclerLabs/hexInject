package hex.di.mock.injectees;

import hex.di.IInjectorContainer;
import hex.di.mock.types.Interface;
import hex.di.mock.types.MockConstants;

/**
 * ...
 * @author Francis Bourre
 */
class OptionalClassInjectee implements IInjectorContainer
{
	@Inject
	@Optional( true )
	public var property : Interface;

	public function new() 
	{
		
	}
}

class OptionalClassInjecteeConst implements IInjectorContainer
{
	static var BOOL_TRUE = true;
	
	@Inject
	@Optional( BOOL_TRUE )
	public var property : Interface;

	public function new() 
	{
		
	}
}

class OptionalClassInjecteeConstOutside implements IInjectorContainer
{
	@Inject
	@Optional( MockConstants.BOOL_TRUE )
	public var property : Interface;

	public function new() 
	{
		
	}
}

class OptionalClassInjecteeConstOutsideFQCN implements IInjectorContainer
{
	@Inject
	@Optional( hex.di.mock.types.MockConstants.BOOL_TRUE )
	public var property : Interface;

	public function new() 
	{
		
	}
}