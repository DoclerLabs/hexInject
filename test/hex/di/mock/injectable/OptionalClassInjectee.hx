package hex.di.mock.injectable;

import hex.di.mock.types.Interface;
import hex.di.mock.types.MockConstants;

/**
 * ...
 * @author Francis Bourre
 */
class OptionalClassInjectee implements IInjectable
{
	@Inject
	@Optional( true )
	public var property : Interface;

	public function new() 
	{
		
	}
}

class OptionalClassInjecteeConst implements IInjectable
{
	static var BOOL_TRUE = true;
	
	@Inject
	@Optional( BOOL_TRUE )
	public var property : Interface;

	public function new() 
	{
		
	}
}

class OptionalClassInjecteeConstOutside implements IInjectable
{
	@Inject
	@Optional( MockConstants.BOOL_TRUE )
	public var property : Interface;

	public function new() 
	{
		
	}
}

class OptionalClassInjecteeConstOutsideFQCN implements IInjectable
{
	@Inject
	@Optional( hex.di.mock.types.MockConstants.BOOL_TRUE )
	public var property : Interface;

	public function new() 
	{
		
	}
}