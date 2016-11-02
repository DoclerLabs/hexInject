package hex.di.annotation;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Expr.Field;
import hex.di.reflect.ClassDescription;
import hex.error.PrivateConstructorException;

/**
 * ...
 * @author Francis Bourre
 */
class FastAnnotationReader
{
	private static var _map : Map<String, ExprOf<ClassDescription>> = new Map();
	
	/** @private */
    function new()
    {
        throw new PrivateConstructorException( "This class can't be instantiated." );
    }
	
	macro public static function readMetadata( metadataExpr : Expr ) : Array<Field>
	{
		//if it's an interface we don't want to build reflection data
		if ( Context.getLocalClass().get().isInterface )
		{
			return Context.getBuildFields();
		}
		
		var fields 			= Context.getBuildFields();
		var localClass 		= Context.getLocalClass().get();
		var className 		= localClass.pack.join( "." ) + "." + localClass.name;
		var hasBeenBuilt 	= FastAnnotationReader._map.exists( className );
		
		if ( !hasBeenBuilt )
		{
			return reflect( metadataExpr, fields );
		}
		else
		{
			Context.warning( "Class description already exists for '" + className + "' class. You should not implement 'IInjectorContainer' twice", localClass.pos );
		}
		
		return reflect( metadataExpr, fields );
	}
	
	public static function reflect( metadataExpr : Expr, fields : Array<Field>  ) : Array<Field>
	{
		var localClass 		= Context.getLocalClass().get();
		var className 		= localClass.pack.join( "." ) + "." + localClass.name;
		var hasBeenBuilt 	= FastAnnotationReader._map.exists( className );
		
		//parse annotations
		fields = hex.annotation.AnnotationReader.parseMetadata( metadataExpr, fields, [ "Inject", "PostConstruct", "Optional", "PreDestroy" ], false );
	
		//get/set data result
		var data = hex.annotation.AnnotationReader._static_classes[ hex.annotation.AnnotationReader._static_classes.length - 1 ];
		//merge with existing data
		
		//get reflection data
		var reflectionData = ReflectionBuilder.getClassDescriptionExpression( data );
		FastAnnotationReader._map.set( className, reflectionData );
		
		var f = fields.filter( function ( f ) { return f.name == "__INJECTION_DATA"; } );
		if ( f.length != 0 )
		{
			//remove existing reflection data
			fields.remove( f[ 0 ] );
		}
		
		// append the expression as a field
		fields.push(
		{
			name:  "__INJECTION_DATA",
			access:  [ Access.APublic, Access.AStatic ],
			kind: FieldType.FVar( macro: hex.di.reflect.ClassDescription, reflectionData ),
			meta: [ { name: ":noDoc", params: null, pos: Context.currentPos() } ],
			pos: Context.currentPos()
		});

		return fields;
	}
}
