package hex.di.reflect;

/**
 * ...
 * @author Francis Bourre
 */
class ClassDescription implements IInjectable
{
	public var constructorInjection ( default, null ) 	: ConstructorInjection;
	var _injectable 									: Array<IInjectable>;
	
	public function new( injectable : Array<IInjectable>, ?constructorInjection : ConstructorInjection )
	{
		this._injectable 			= injectable;
		this.constructorInjection 	= constructorInjection;
	}
	
	public function applyInjection( target : Dynamic, injector : SpeedInjector ) : Dynamic
	{
		for ( injectable in this._injectable )
		{
			injectable.applyInjection( target, injector );
		}
		
		return target;
	}
}