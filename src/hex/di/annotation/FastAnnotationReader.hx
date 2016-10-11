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
	private static var _map : Map<String, ExprOf<ClassDescription>>;
	
	/** @private */
    function new()
    {
        throw new PrivateConstructorException( "This class can't be instantiated." );
    }
	
	macro public static function readMetadata( metadataExpr : Expr ) : Array<Field>
	{
		if ( FastAnnotationReader._map == null )
		{
			FastAnnotationReader._map = new Map();
		}
		
		var localClass = Context.getLocalClass().get();
		var className = localClass.pack.join( "." ) + "." + localClass.name;
		
		//if it's an interface we don't want to build reflection data
		if ( localClass.isInterface )
		{
			return Context.getBuildFields();
		}
		
		//parse annotations
		var fields : Array<Field> = hex.annotation.AnnotationReader.parseMetadata( metadataExpr, [ "Inject", "PostConstruct", "Optional", "PreDestroy" ], false );
		
		//get/set data result
		var data = hex.annotation.AnnotationReader._static_classes[ hex.annotation.AnnotationReader._static_classes.length - 1 ];

		if ( !FastAnnotationReader._map.exists( className ) )
		{
			//get reflection data
			var reflectionData = ReflectionBuilder.getClassDescriptionExpression( data );
			FastAnnotationReader._map.set( className, reflectionData );
			
			// append the expression as a field
			fields.push(
			{
				name:  "__INJECTION_DATA",
				access:  [ Access.APublic, Access.AStatic ],
				kind: FieldType.FVar( macro: hex.di.reflect.ClassDescription, reflectionData ),
				meta: [ { name: ":noDoc", params: null, pos: Context.currentPos() } ],
				pos: Context.currentPos()
			});
		}
		else
		{
			
			Context.warning( "Class description already exists for '" + className + "' class. You should not implement 'IInjectorContainer' twice", localClass.pos );
		}
		
		return fields;
	}
}
