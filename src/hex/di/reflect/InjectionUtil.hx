package hex.di.reflect;

import hex.di.Injector;
import hex.di.error.MissingMappingException;
import hex.log.Stringifier;

/**
 * ...
 * @author Francis Bourre
 */
class InjectionUtil
{
	function new() 
	{
		
	}
	
	inline public static function applyClassInjection( target : Dynamic, injector : Injector, classDescription : ClassDescription ) : Dynamic
	{
		for ( property in classDescription.properties )
		{
			InjectionUtil.applyPropertyInjection( property.propertyName, property.propertyType, property.injectionName, property.isOptional, target, injector );
		}
		
		for ( method in classDescription.methods )
		{
			InjectionUtil.applyMethodInjection( target, injector, method.args, method.methodName );
		}
		
		for ( postConstruct in classDescription.postConstruct )
		{
			InjectionUtil.applyMethodInjection( target, injector, postConstruct.args, postConstruct.methodName );
		}

		return target;
	}
	
	inline public static function applyConstructorInjection( type : Class<Dynamic>, injector : Injector, arguments : Array<ArgumentInjectionVO> ) : Dynamic
	{
		return Type.createInstance( type, InjectionUtil.gatherArgs( type, injector, arguments, 'new' ) );
	}
	
	inline public static function applyPropertyInjection( 	propertyName: String, 
															propertyType: Class<Dynamic>, 
															injectionName: String = '', 
															isOptional: Bool = false,
															target : Dynamic, 
															injector : Injector ) : Dynamic
	{
		var provider = injector.getProvider( propertyType, injectionName );

		if ( provider != null )
		{
			Reflect.setProperty( target, propertyName, provider.getResult( injector ) );
		}
		else if ( !isOptional )
		{
			throw new MissingMappingException( "'" + Stringifier.stringify( injector ) + 
												"' is missing a mapping to inject into property named '" + 
												propertyName + "' with type '" + Type.getClassName( propertyType ) + 
												"' inside instance of '" + Stringifier.stringify( target ) + 
												"'. Target dependency: '" + Type.getClassName( propertyType ) 
												+ "|" + injectionName + "'" );
		}

		return target;
	}
	
	inline public static function applyMethodInjection( target : Dynamic, injector : Injector, arguments : Array<ArgumentInjectionVO>, methodName : String ) : Dynamic
	{
		Reflect.callMethod( target, Reflect.field( target, methodName ), InjectionUtil.gatherArgs( target, injector, arguments, methodName ) );
        return target;
	}
	
	inline static function gatherArgs( target : Dynamic, injector : Injector, arguments : Array<ArgumentInjectionVO>, methodName : String ) : Array<Dynamic>
	{
		var args = [];
        for ( arg in arguments )
        {
			var provider = injector.getProvider( arg.type, arg.injectionName );

			if ( provider != null )
			{
				args.push( provider.getResult( injector ) );
			}
			else if ( !arg.isOptional )
			{
				if ( methodName == 'new' )
				{
					InjectionUtil._throwMissingMappingConstructorException( target, arg.type, arg.injectionName, injector );
				}
				else 
				{
					InjectionUtil._throwMissingMappingException( target, arg.type, arg.injectionName, injector, methodName );
				}
			}
		}
			
		return args;
	}
	
	inline static function _throwMissingMappingException( target : Dynamic, type : Class<Dynamic>, injectionName : String, injector : Injector, methodName : String ) : Void
    {
        throw new MissingMappingException( "'" + Stringifier.stringify( injector ) +
			"' is missing a mapping to inject argument into method named '" +
				methodName + "' with type '" + Type.getClassName( type ) +
					"' inside instance of '" + Stringifier.stringify( target ) +
						"'. Target dependency: '" + Type.getClassName( type ) +
							"|" + injectionName + "'" );
    }
	
	inline static function _throwMissingMappingConstructorException( target : Dynamic, type : Class<Dynamic>, injectionName : String, injector : Injector ) : Void
    {
        throw new MissingMappingException( "'" + Stringifier.stringify( injector ) +
			"' is missing a mapping to inject argument" +
				" with type '" + Type.getClassName( type ) +
					"' into constructor of class '" + Stringifier.stringify( target ) +
						"'. Target dependency: '" + Type.getClassName( type ) +
							"|" + injectionName + "'" );
    }
}