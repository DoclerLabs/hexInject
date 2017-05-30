package hex.di.mock.injectees;

import hex.di.mock.types.Clazz;
import hex.di.mock.types.MockConstants;

/**
 * ...
 * @author Francis Bourre
 */
class ClassInjectee implements IInjectorContainer
{
	@Inject
	public var property : Clazz;
		
	public var someProperty : Bool;
		
	public function new() 
	{
		someProperty = false;
	}
	
	@PostConstruct( 1 )
	public function doSomeStuff() : Void
	{
		this.someProperty = true;
	}
}

class ClassInjecteeWithConst implements IInjectorContainer
{
	static inline var NUMBER_ONE = 1;
	
	@Inject
	public var property : Clazz;
		
	public var someProperty : Bool;
		
	public function new() 
	{
		someProperty = false;
	}
	
	@PostConstruct( NUMBER_ONE )
	public function doSomeStuff() : Void
	{
		this.someProperty = true;
	}
}

class ClassInjecteeWithConstOutside implements IInjectorContainer
{
	@Inject
	public var property : Clazz;
		
	public var someProperty : Bool;
		
	public function new() 
	{
		someProperty = false;
	}
	
	@PostConstruct( MockConstants.NUMBER_ONE )
	public function doSomeStuff() : Void
	{
		this.someProperty = true;
	}
}

class ClassInjecteeWithConstOutsideFQCN implements IInjectorContainer
{
	@Inject
	public var property : Clazz;
		
	public var someProperty : Bool;
		
	public function new() 
	{
		someProperty = false;
	}
	
	@PostConstruct( hex.di.mock.types.MockConstants.NUMBER_ONE )
	public function doSomeStuff() : Void
	{
		this.someProperty = true;
	}
}
