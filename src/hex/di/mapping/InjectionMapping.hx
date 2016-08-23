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
    var _injector		        : Injector;
    var _type					: Class<Dynamic>;
    var _name					: String;
    var _mappingID				: String;

    public var provider	( default, null ) : IDependencyProvider;

    public function new( injector : Injector, type : Class<Dynamic>, name : String, mappingID : String )
    {
        this._injector			= injector;
        this._type 				= type;
        this._name 				= name;
        this._mappingID 		= mappingID;
    }

    public function getResult() : Dynamic
    {
		#if debug
        if ( this.provider == null )
        {
			throw new NullPointerException( "can't retrieve result, mapping with id '" + this._mappingID + "' has no provider" );
        }
		#end
		
        return this.provider.getResult( this._injector );
    }

    inline public function asSingleton() : InjectionMapping
    {
        return this.toSingleton( this._type );
    }

    inline public function toSingleton( type : Class<Dynamic> ) : InjectionMapping
    {
        return this._toProvider( new SingletonProvider( type, this._injector ) );
    }

    inline public function toType( type : Class<Dynamic> ) : InjectionMapping
    {
        return this._toProvider( new ClassProvider( type ) );
    }

    inline public function toValue( value : Dynamic ) : InjectionMapping
    {
        return this._toProvider( new ValueProvider( value, this._injector ) );
    }

    inline function _toProvider( provider : IDependencyProvider ) : InjectionMapping
    {
		#if debug
        if ( this.provider != null )
        {
            trace(  'Warning: Injector already has a mapping for ' + this._mappingID + '.\n ' +
                    'If you have overridden this mapping intentionally you can use ' +
                    '"injector.unmap()" prior to your replacement mapping in order to ' +
                    'avoid seeing this message.' );
        }
		#end
		
        this.provider = provider;
        return this;
    }
}
