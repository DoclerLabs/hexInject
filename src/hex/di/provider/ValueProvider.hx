package hex.di.provider;

/**
 * ...
 * @author Francis Bourre
 */
class ValueProvider implements IDependencyProvider
{
    var _value : Dynamic;

    public function new( value : Dynamic )
    {
        this._value = value;
    }

    public function getResult( injector : SpeedInjector ) : Dynamic
    {
        return this._value;
    }
}
