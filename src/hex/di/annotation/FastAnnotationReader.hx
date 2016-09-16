package hex.di.annotation;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Expr.Access;
import haxe.macro.Expr.Field;
import haxe.macro.Expr.FieldType;
import hex.di.reflect.ClassDescription;
import hex.error.PrivateConstructorException;

using hex.util.ArrayUtil;

/**
 * ...
 * @author Francis Bourre
 */
class FastAnnotationReader
{
	/** @private */
    function new()
    {
        throw new PrivateConstructorException( "This class can't be instantiated." );
    }
	
	macro public static function readMetadata( metadataExpr : Expr ) : Array<Field>
	{
		var localClass = Context.getLocalClass().get();
		if ( Context.getLocalClass().get().isInterface )
		{
			return Context.getBuildFields();
		}
		
		//parse annotations
		var fields : Array<Field> = hex.annotation.AnnotationReader.parseMetadata( metadataExpr, [ "Inject", "PostConstruct", "Optional", "PreDestroy" ], false );
		
		//get data result
		var data = hex.annotation.AnnotationReader._static_classes[ hex.annotation.AnnotationReader._static_classes.length - 1 ];

		// append the expression as a field
		var a = Lambda.find( fields, function ( f ) { return f.name == "__INJECTION_DATA"; } );
		if ( a == null )
		{
			fields.push(
			{
				name:  "__INJECTION_DATA",
				access:  [ Access.APublic, Access.AStatic ],
				kind: FieldType.FVar( macro: hex.di.reflect.ClassDescription, ReflectionBuilder.getClassDescriptionExpression( data ) ), 
				pos: Context.currentPos(),
			});
		}
		return fields;
	}
}