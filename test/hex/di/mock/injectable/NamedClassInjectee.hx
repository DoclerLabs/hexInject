package hex.di.mock.injectable;

import hex.di.mock.types.MockConstants;

/**
 * ...
 * @author Francis Bourre
 */
class NamedClassInjectee implements IInjectable
{
	public inline static var NAME : String = 'Name';
		
	@Inject( 'Name' )
	public var property : Clazz;
	
	public function new() 
	{
		
	}
}

class NamedClassInjecteeConst implements IInjectable
{
	public inline static var NAME : String = 'Name';
		
	@Inject( NAME )
	public var property : Clazz;
	
	public function new() 
	{
		
	}
}

class NamedClassInjecteeConstOutside implements IInjectable
{
	@Inject( MockConstants.NAME )
	public var property : Clazz;
	
	public function new() 
	{
		
	}
}

class NamedClassInjecteeConstOutsideFQCN implements IInjectable
{
	@Inject( hex.di.mock.types.MockConstants.NAME )
	public var property : Clazz;
	
	public function new() 
	{
		
	}
}