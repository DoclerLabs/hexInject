package hex.di.annotation;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Expr.Field;
import haxe.macro.Type.ModuleType;
import hex.di.reflect.ClassDescription;
import hex.error.PrivateConstructorException;

/**
 * ...
 * @author Francis Bourre
 */
class FastAnnotationReader
{
	private static var _isInitialized 	: Bool = false;
	private static var _map 			: Map<String, ExprOf<ClassDescription>>;
	
	/** @private */
    function new()
    {
        throw new PrivateConstructorException( "This class can't be instantiated." );
    }
	
	private static function _onAfterTyping( a : Array<ModuleType> ) : Void
	{
		if ( FastAnnotationReader._map != null )
		{

			var map : Array<Expr> = [];
			var i = FastAnnotationReader._map.keys();
			while ( i.hasNext() )
			{
				var key = i.next();
				var value = FastAnnotationReader._map.get( key );
				map.push( macro $v{key} => $value );
			}
			FastAnnotationReader._map = null;
			
			var m = macro $a { map };
			var c = macro 
			class InjectionData 
			{
				private static var data : Map<String, hex.di.reflect.ClassDescription> = $m;
				
				function new() {}
				public function test() 
				{
					trace( "test was called");
				}
			}
			
			Context.defineType( c );
		}
	}
	
	macro public static function readMetadata( metadataExpr : Expr ) : Array<Field>
	{
		if ( !FastAnnotationReader._isInitialized )
		{
			FastAnnotationReader._isInitialized = true;
			FastAnnotationReader._map = new Map();
			Context.onAfterTyping( FastAnnotationReader._onAfterTyping );
		}
		
		var localClass = Context.getLocalClass().get();
		var className = localClass.pack.join( "." ) + "." + localClass.name;
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
			FastAnnotationReader._map.set( className, ReflectionBuilder.getClassDescriptionExpression( data ) );
		}
		else
		{
			
			Context.warning( "Class description already exists for '" + className + "' class. You should not implement 'IInjectorContainer' twice", localClass.pos );
		}
		
		return fields;
	}
}