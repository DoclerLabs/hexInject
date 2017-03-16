package hex.di.provider;

import hex.di.error.InjectorException;

/**
 * ...
 * @author Francis Bourre
 */
class SingletonProvider<T> implements IDependencyProvider<T>
{
    var _isDestroyed    : Bool;

    var _type           : Class<T>;
    var _value          : T;
    var _injector       : IDependencyInjector;

    public function new( type : Class<T>, injector : IDependencyInjector )
    {
        this._isDestroyed   = false;
        this._type          = type;
        this._injector      = injector;
    }

    public function getResult( injector : IDependencyInjector ) : T
    {
		#if debug
        if ( this._isDestroyed )
        {
            throw new InjectorException( "Forbidden usage of unmapped singleton provider for type '" 
				+ Type.getClassName( this._type ) + "'" );
        }
        else 
		#end
		if ( this._value == null )
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
