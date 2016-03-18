package hex.di.mapping;

import hex.di.provider.ClassProvider;
import hex.di.provider.SingletonProvider;
import hex.di.provider.ValueProvider;
import hex.di.provider.IDependencyProvider;
import hex.error.NullPointerException;

/**
 * ...
 * @author Francis Bourre
 */
class InjectionMapping
{
    var _injector		        : SpeedInjector;
    var _type					: Class<Dynamic>;
    var _name					: String;
    var _mappingID				: String;

    public var provider	( default, null ) : IDependencyProvider;

    public function new( injector : SpeedInjector, type : Class<Dynamic>, name : String, mappingID : String )
    {
        this._injector			= injector;
        this._type 				= type;
        this._name 				= name;
        this._mappingID 		= mappingID;
    }

    public function getResult() : Dynamic
    {
        if ( this.provider != null )
        {
            return this.provider.getResult( this._injector );
        }

        throw new NullPointerException( "can't retrieve result, mapping with id '" + this._mappingID + "' has no provider" );
    }

    public function asSingleton() : InjectionMapping
    {
        return this.toSingleton( this._type );
    }

    public function toSingleton( type : Class<Dynamic> ) : InjectionMapping
    {
        return this._toProvider( new SingletonProvider( type, this._injector ) );
    }

    public function toType( type : Class<Dynamic> ) : InjectionMapping
    {
        return this._toProvider( new ClassProvider( type ) );
    }

    public function toValue( value : Dynamic ) : InjectionMapping
    {
        return this._toProvider( new ValueProvider( value, this._injector ) );
    }

    function _toProvider( provider : IDependencyProvider ) : InjectionMapping
    {
        if ( this.provider != null )
        {
            trace(  'Warning: Injector already has a mapping for ' + this._mappingID + '.\n ' +
                    'If you have overridden this mapping intentionally you can use ' +
                    '"injector.unmap()" prior to your replacement mapping in order to ' +
                    'avoid seeing this message.' );
        }

        this.provider = provider;
        return this;
    }
}
