package hex.di.provider;

/**
 * ...
 * @author Francis Bourre
 */
class SingletonProvider implements IDependencyProvider
{
    var _type   : Class<Dynamic>;
    var _value  : Dynamic;

    public function new( type : Class<Dynamic> )
    {
        this._type = type;
    }

    public function getResult( injector : SpeedInjector ) : Dynamic
    {
        if ( this._value == null )
        {
            this._value = injector.instantiateUnmapped( this._type );
        }

        return this._value;
    }
}
