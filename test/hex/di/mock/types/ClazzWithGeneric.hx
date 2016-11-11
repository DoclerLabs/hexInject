package hex.di.mock.types;

/**
 * ...
 * @author Francis Bourre
 */
class ClazzWithGeneric<T> implements InterfaceWithGeneric<T> implements IInjectorContainer
{
	var _o : T;
	
	public function new() 
	{
		
	}

	public function store( o : T ) : Void
	{
		this._o = o;
	}
}