package hex.di.provider;

import hex.di.error.InjectorException;

/**
 * ...
 * @author Francis Bourre
 */
class SingletonProvider implements IDependencyProvider
{
    var _isDestroyed    : Bool;

    var _type           : Class<Dynamic>;
    var _value          : Dynamic;
    var _injector       : Injector;

    public function new( type : Class<Dynamic>, injector : Injector )
    {
        this._isDestroyed   = false;
        this._type          = type;
        this._injector      = injector;
    }

    public function getResult( injector : Injector ) : Dynamic
    {
        if ( this._isDestroyed )
        {
            throw new InjectorException( "Forbidden usage of unmapped singleton provider for type '" + Type.getClassName( this._value ) + "'" );
        }
        else if ( this._value == null )
        {
            this._value = this._injector.instantiateUnmapped( this._type );
        }

        return this._value;
    }
	
	public function destroy() : Void
	{
        this._isDestroyed = true;

        if ( this._value != null )
        {
            this._injector.destroyInstance( this._value );
        }

        this._injector  = null;
        this._value     = null;
	}
}
