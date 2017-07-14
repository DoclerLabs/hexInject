package hex.di.util;

import hex.di.mapping.MappingDefinition;

/**
 * ...
 * @author Francis Bourre
 */
class MappingDefinitionUtil 
{
	/** @private */ function new() throw new hex.error.PrivateConstructorException();

	public static function addDefinition( target : GetInjector, mappings : Array<MappingDefinition>, useMetadata : Bool = true ) : Void
	{
		if ( useMetadata ) 
		{
			var cls = Type.getClass( target );
			mappings = hex.di.mapping.MappingChecker.filter( cls, mappings );
		}
						

		for ( mapping in  mappings )
		{
			if ( mapping.toValue != null )
			{
				target.getInjector().mapClassNameToValue( mapping.fromType, mapping.toValue, mapping.withName );
			}
			else
			{
				if ( mapping.asSingleton )
				{
					target.getInjector().mapClassNameToSingleton( mapping.fromType, mapping.toClass, mapping.withName );
				}
				else
				{
					target.getInjector().mapClassNameToType( mapping.fromType, mapping.toClass, mapping.withName );
				}
			}
			
			if ( mapping.injectInto ) 
			{
				target.getInjector().injectInto( mapping.toValue );
			}
		}
	}
}

typedef GetInjector =
{
	function getInjector() : IDependencyInjector;
}