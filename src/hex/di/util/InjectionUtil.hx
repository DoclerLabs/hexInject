package hex.di.util;

import haxe.macro.Context;
import haxe.macro.Expr;
import hex.di.Dependency;
import hex.di.IDependencyInjector;
import hex.di.mapping.MappingDefinition;
import hex.error.PrivateConstructorException;
import hex.util.MacroUtil;

using haxe.macro.Tools;

/**
 * ...
 * @author Francis Bourre
 */
class InjectionUtil 
{
	/** @private */
    function new()
    {
        throw new PrivateConstructorException();
    }
	
	public static function addDefinition( target : GetInjector, mappings : Array<MappingDefinition>, useMetadata : Bool = true ) : Void
	{
		if ( useMetadata ) 
		{
			var cls = Type.getClass( target );
			mappings = hex.di.mapping.MappingChecker.filter( cls, mappings );
			/*var className = Type.getClassName( cls );
			if ( !hex.di.mapping.MappingChecker.matchForClassName( className, mappings ) )
			{
				var missingMappings = hex.di.mapping.MappingChecker.getMissingMapping( className, mappings );
				throw new IllegalArgumentException(  "Missing mappings:" + missingMappings );
			}*/
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
	
	macro public static function getDependencyInstance<T>( 	injector : ExprOf<IDependencyInjector>, 
															clazz : ExprOf<Dependency<T>>
														) : Expr
	{
		var classReference = InjectionUtil._getStringClassRepresentation( clazz );
		return macro { $injector.getInstanceWithClassName( $v{ classReference } ); };
	}
	
	macro public static function mapDependencyToValue<T>( 	injector : ExprOf<IDependencyInjector>, 
															clazz : ExprOf<Dependency<T>>, 
															value : ExprOf<T>,
															?id : ExprOf<String>
														) : Expr
	{	
		var classReference = InjectionUtil._getStringClassRepresentation( clazz );
		MacroUtil.assertValueMatching( classReference, value, clazz.pos );
		return macro { $injector.mapClassNameToValue( $v{ classReference }, $value, $id ); };
	}
	
	macro public static function mapDependencyToType<T>( 	injector : ExprOf<IDependencyInjector>, 
															clazz : ExprOf<Dependency<T>>, 
															type : ExprOf<Dependency<T>>,
															?id : ExprOf<String>
														) : Expr
	{
		var classReference 			= InjectionUtil._getStringClassRepresentation( clazz );
		var typeReference 			= InjectionUtil._getClassReference( type );
		MacroUtil.assertTypeMatching( classReference, InjectionUtil._getStringClassRepresentation( type ), clazz.pos );
		return macro { $injector.mapClassNameToType( $v{ classReference }, $typeReference, $id ); };
	}
	
	macro public static function mapDependencyToSingleton<T>( 	injector : ExprOf<IDependencyInjector>, 
																clazz : ExprOf<Dependency<T>>, 
																type : ExprOf<Dependency<T>>,
																?id : ExprOf<String>
															) : Expr
	{
		var classReference 			= InjectionUtil._getStringClassRepresentation( clazz );
		var typeReference 			= InjectionUtil._getClassReference( type );
		MacroUtil.assertTypeMatching( classReference, InjectionUtil._getStringClassRepresentation( type ), clazz.pos );
		return macro { $injector.mapClassNameToSingleton( $v{ classReference }, $typeReference, $id ); };
	}
	
	#if macro
	public static function _getStringClassRepresentation<T>( clazz : ExprOf<Dependency<T>> ) : String
	{
		switch( clazz.expr )
		{
			case ENew( t, params ):

				switch( t.params[ 0 ] )
				{
					case TPType( t ):
						
						return MacroUtil.getFQCNFromComplexType( t );
					
					case _:
				}
				
			case _:
		}
		
		Context.error( "Invalid dependency", clazz.pos );
		return "";
	}
	
	public static function _getClassReference<T>( clazz : ExprOf<Dependency<T>> ) : ExprOf<Class<T>>
	{
		switch( clazz.expr )
		{
			case ENew( t, params ):

				switch( t.params[ 0 ] )
				{
					case TPType( TPath( tp ) ):
						return macro $p { MacroUtil.getPack( MacroUtil.getClassFullQualifiedName( tp ) ) };
						
					case _:
				}
				
			case _:
		}
		
		Context.error( "Invalid dependency", clazz.pos );
		return macro null;
	}
	
	public static function _getComplexType<T>( clazz : ExprOf<Dependency<T>> ) : ComplexType
	{
		switch( clazz.expr )
		{
			case ENew( t, params ):

				switch( t.params[ 0 ] )
				{
					case TPType( t ):
						return t;
						
					case _:
				}
				
			case _:
		}
		
		return null;
	}
	#end
}

typedef GetInjector =
{
	function getInjector() : IDependencyInjector;
}