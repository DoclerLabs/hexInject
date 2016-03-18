package hex.di.reflect;

import hex.di.IInjectable;
import hex.di.SpeedInjector;
import hex.di.error.MissingMappingException;
import hex.log.Stringifier;

/**
 * ...
 * @author Francis Bourre
 */
class PropertyInjection implements IInjectable
{
	public var propertyName( default, null )		: String;
	public var propertyType( default, null )		: Class<Dynamic>;
	public var injectionName( default, null )		: String;
	public var isOptional( default, null )			: Bool;

	public function new( propertyName : String, propertyType : String, injectionName : String= "", isOptional : Bool = false )
	{
		this.propertyName 	= propertyName;
		this.propertyType 	= Type.resolveClass( propertyType );
		this.injectionName 	= injectionName;
		this.isOptional		= isOptional;
	}
	
	public function applyInjection( target : Dynamic, injector : SpeedInjector ) : Dynamic
	{
		var provider = injector.getProvider( this.propertyType, this.injectionName );

		if ( provider != null )
		{
			Reflect.setProperty( target, this.propertyName, provider.getResult( injector ) );
		}
		else if ( !this.isOptional )
		{
			throw new MissingMappingException( "'" + Stringifier.stringify( injector ) + 
												"' is missing a mapping to inject into property named '" + 
												this.propertyName + "' with type '" + Type.getClassName( this.propertyType ) + 
												"' inside instance of '" + Stringifier.stringify( target ) + 
												"'. Target dependency: '" + Type.getClassName( this.propertyType ) 
												+ "|" + this.injectionName + "'" );
		}

		return target;
	}
}