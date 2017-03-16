package hex.di.provider;

/**
 * ...
 * @author Francis Bourre
 */
class ClassProvider<T> implements IDependencyProvider<T>
{
    var _type : Class<T>;

    public function new( type : Class<T> )
    {
        this._type = type;
    }

    inline public function getResult( injector : IDependencyInjector ) : T
    {
        return injector.instantiateUnmapped( this._type );
    }
	
	public function destroy() : Void
	{
		//do nothing
	}
}
