package hex.di.provider;

/**
 * ...
 * @author Francis Bourre
 */
class ValueProvider implements IDependencyProvider
{
    var _value      : Dynamic;
    var _injector   : Injector;

    public function new( value : Dynamic, injector : Injector )
    {
        this._value     = value;
        this._injector  = injector;
    }

    public function getResult( injector : Injector ) : Dynamic
    {
        return this._value;
    }
	
	public function destroy() : Void
	{
        this._injector.destroyInstance( this._value );

        this._injector  = null;
        this._value     = null;
	}
}
