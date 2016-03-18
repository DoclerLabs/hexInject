package hex.di.provider;

/**
 * ...
 * @author Francis Bourre
 */
class ValueProvider implements IDependencyProvider
{
    var _value      : Dynamic;
    var _injector   : SpeedInjector;

    public function new( value : Dynamic, injector : SpeedInjector )
    {
        this._value     = value;
        this._injector  = injector;
    }

    public function getResult( injector : SpeedInjector ) : Dynamic
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
