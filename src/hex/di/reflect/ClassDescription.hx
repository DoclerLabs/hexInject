package hex.di.reflect;

import haxe.ds.ArraySort;

/**
 * ...
 * @author Francis Bourre
 */
class ClassDescription implements IInjectable
{
	public var constructorInjection ( default, null ) 	: ConstructorInjection;
	
	public var injections ( default, null ) 			: Array<IInjectable>;
	public var postConstruct ( default, null ) 			: Array<OrderedInjection>;
	public var preDestroy ( default, null ) 			: Array<OrderedInjection>;
	
	
	public function new( 	constructorInjection 	: ConstructorInjection, 
							injections 				: Array<IInjectable>, 
							postConstruct 			: Array<OrderedInjection>, 
							preDestroy 				: Array<OrderedInjection> )
	{
		this.constructorInjection 	= constructorInjection;
		this.injections 			= injections;
		this.postConstruct 			= postConstruct;
		this.preDestroy 			= preDestroy;
		
		if ( this.postConstruct.length > 0 )
		{
			ArraySort.sort( this.postConstruct, this._sort );
		}
		
		
		if ( this.preDestroy.length > 0 )
		{
			ArraySort.sort( this.preDestroy, this._sort );
		}
	}
	
	function _sort( a : OrderedInjection, b : OrderedInjection ) : Int
	{
		return  a.order - b.order;
	}
	
	public function applyInjection( target : Dynamic, injector : Injector ) : Dynamic
	{
		for ( injection in this.injections )
		{
			injection.applyInjection( target, injector );
		}
		
		for ( injection in this.postConstruct )
		{
			injection.applyInjection( target, injector );
		}
		

		return target;
	}
}