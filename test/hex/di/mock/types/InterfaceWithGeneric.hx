package hex.di.mock.types;

/**
 * @author Francis Bourre
 */
interface InterfaceWithGeneric<T> 
{
	function store( o : T ) : Void;
}