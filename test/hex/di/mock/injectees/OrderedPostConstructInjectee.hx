package hex.di.mock.injectees;

import hex.di.IInjectorContainer;

/**
 * ...
 * @author Francis Bourre
 */
class OrderedPostConstructInjectee implements IInjectorContainer
{
	public var loadOrder : Array<Int> = [];
	
	public function new() 
	{
		
	}

	@PostConstruct( 2 )
	public function methodTwo() : Void
	{
		this.loadOrder.push( 2 );
	}
	
	@PostConstruct( 8 )
	public function methodFour() : Void
	{
		this.loadOrder.push( 4 );
	}
	
	@PostConstruct( 5 )
	public function methodThree() : Void
	{
		this.loadOrder.push( 3 );
	}
	
	@PostConstruct( 1 )
	public function methodOne() : Void
	{
		this.loadOrder.push( 1 );
	}
}