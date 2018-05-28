package hex.di.mapping;

import hex.di.IDependencyInjector;
import hex.di.provider.ClassProvider;
import hex.di.provider.IDependencyProvider;
import hex.di.provider.SingletonProvider;
import hex.di.provider.ValueProvider;
import hex.error.NullPointerException;
import hex.log.HexLog.getLogger;

/**
 * ...
 * @author Francis Bourre
 */
class InjectionMapping<T>
{
    var _injector		        : IDependencyInjector;
    var _mappingID				: String;

    public var provider	( default, null ) : IDependencyProvider<T>;

    public function new( injector : IDependencyInjector, mappingID : String )
    {
        this._injector			= injector;
        this._mappingID 		= mappingID;
    }
	
    @:keep
    public function getResult( target : Class<Dynamic> ) : Dynamic
    {
        if ( this.provider == null )
        {
			throw new NullPointerException( "can't retrieve result, mapping with id '" 
				+ this._mappingID + "' has no provider" );
        }

        return this.provider.getResult( this._injector, target );
    }

    inline public function toSingleton( type : Class<T> ) : InjectionMapping<T>
    {
        return this.toProvider( new SingletonProvider( type, this._injector ) );
    }

    inline public function toType( type : Class<T> ) : InjectionMapping<T>
    {
        return this.toProvider( new ClassProvider( type ) );
    }

    inline public function toValue( value : T ) : InjectionMapping<T>
    {
        return this.toProvider( new ValueProvider( value, this._injector ) );
    }

    inline public function toProvider( provider : IDependencyProvider<T> ) : InjectionMapping<T>
    {
		#if debug
        if ( this.provider != null )
        {
            getLogger().warn( 'Injector already has a mapping for ' + this._mappingID + '.\n ' +
							  'If you have overridden this mapping intentionally you can use ' +
							  '"injector.unmap()" prior to your replacement mapping in order to ' +
							  'avoid seeing this message.' );
        }
		#end
		
        this.provider = provider;
        return this;
    }
}
