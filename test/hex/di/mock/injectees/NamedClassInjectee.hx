package hex.di.mock.injectees;

import hex.di.mock.types.MockConstants;

/**
 * ...
 * @author Francis Bourre
 */
class NamedClassInjectee implements IInjectorContainer
{
	public inline static var NAME : String = 'Name';
		
	@Inject( 'Name' )
	public var property : Clazz;
	
	public function new() 
	{
		
	}
}

class NamedClassInjecteeConst implements IInjectorContainer
{
	public inline static var NAME : String = 'Name';
		
	@Inject( NAME )
	public var property : Clazz;
	
	public function new() 
	{
		
	}
}

class NamedClassInjecteeConstOutside implements IInjectorContainer
{
	@Inject( MockConstants.NAME )
	public var property : Clazz;
	
	public function new() 
	{
		
	}
}

class NamedClassInjecteeConstOutsideFQCN implements IInjectorContainer
{
	@Inject( hex.di.mock.types.MockConstants.NAME )
	public var property : Clazz;
	
	public function new() 
	{
		
	}
}