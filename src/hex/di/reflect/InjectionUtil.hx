package hex.di.reflect;

import hex.di.Injector;
import hex.di.error.MissingMappingException;
import hex.util.Stringifier;

/**
 * ...
 * @author Francis Bourre
 */
class InjectionUtil
{
	function new() 
	{
		
	}
	
	inline public static function applyClassInjection<T>( target : T, injector : Injector, classDescription : ClassDescription, targetType : Class<Dynamic> ) : T
	{
		for ( property in classDescription.p )
		{
			InjectionUtil.applyPropertyInjection( target, injector, targetType, property.p, property.t, property.n, property.o );
		}
		
		for ( method in classDescription.m )
		{
			InjectionUtil.applyMethodInjection( target, injector, targetType, method.a, method.m );
		}
		
		for ( postConstruct in classDescription.pc )
		{
			InjectionUtil.applyMethodInjection( target, injector, targetType, postConstruct.a, postConstruct.m );
		}

		return target;
	}
	
	inline public static function applyConstructorInjection<T>( type : Class<T>, injector : Injector, arguments : Array<ArgumentInjection>, targetType : Class<Dynamic> ) : T
	{
		var args = InjectionUtil.gatherArgs( type, injector, arguments, 'new', targetType );
		return Type.createInstance( type, args );
	}
	
	inline public static function applyPropertyInjection( 	target : Dynamic, 
															injector : Injector,
															targetType : Class<Dynamic>,
															propertyName: String, 
															propertyType: String, 
															injectionName: String = '', 
															isOptional: Bool = false ) : Dynamic
	{
		var provider = injector.getProvider( propertyType, injectionName );

		if ( provider != null )
		{
			Reflect.setProperty( target, propertyName, provider.getResult( injector, targetType ) );
		}
		else if ( !isOptional )
		{
			throw new MissingMappingException( "'" + Stringifier.stringify( injector ) + 
												"' is missing a mapping to inject into property named '" + 
												propertyName + "' with type '" + propertyType + 
												"' inside instance of '" + Stringifier.stringify( target ) + 
												"'. Target dependency: '" + propertyType 
												+ "|" + injectionName + "'" );
		}

		return target;
	}
	
	inline public static function applyMethodInjection( target : Dynamic, injector : Injector, targetType : Class<Dynamic>, arguments : Array<ArgumentInjection>, methodName : String ) : Dynamic
	{
		Reflect.callMethod( target, Reflect.field( target, methodName ), InjectionUtil.gatherArgs( target, injector, arguments, methodName, targetType ) );
        return target;
	}
	
	inline static function gatherArgs( target : Dynamic, injector : Injector, arguments : Array<ArgumentInjection>, methodName : String, targetType : Class<Dynamic> ) : Array<Dynamic>
	{
		var args = [];
        for ( arg in arguments )
        {
			var provider = injector.getProvider( arg.t, arg.n );

			if ( provider != null )
			{
				args.push( provider.getResult( injector, targetType ) );
			}
			else if ( !arg.o )
			{
				if ( methodName == 'new' )
				{
					InjectionUtil._throwMissingMappingConstructorException( target, arg.t, arg.n, injector );
				}
				else 
				{
					InjectionUtil._throwMissingMappingException( target, arg.t, arg.n, injector, methodName );
				}
			}
		}
		
		return args;
	}
	
	inline static function _throwMissingMappingException( target : Dynamic, type : String, injectionName : String, injector : Injector, methodName : String ) : Void
    {
        throw new MissingMappingException( "'" + Stringifier.stringify( injector ) +
			"' is missing a mapping to inject argument into method named '" +
				methodName + "' with type '" + type +
					"' inside instance of '" + Stringifier.stringify( target ) +
						"'. Target dependency: '" + type +
							"|" + injectionName + "'" );
    }
	
	inline static function _throwMissingMappingConstructorException( target : Dynamic, type : String, injectionName : String, injector : Injector ) : Void
    {
        throw new MissingMappingException( "'" + Stringifier.stringify( injector ) +
			"' is missing a mapping to inject argument" +
				" with type '" + type +
					"' into constructor of class '" + Stringifier.stringify( target ) +
						"'. Target dependency: '" + type +
							"|" + injectionName + "'" );
    }
}