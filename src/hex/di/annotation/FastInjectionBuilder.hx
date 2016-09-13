package hex.di.annotation;

import haxe.ds.ArraySort;
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Expr.Access;
import haxe.macro.Expr.Field;
import haxe.macro.Expr.FieldType;
import hex.annotation.ClassAnnotationData;
import hex.di.IDependencyInjector;
import hex.di.reflect.InjectionProcessor;
import hex.error.PrivateConstructorException;
import hex.util.MacroUtil;

using hex.util.ArrayUtil;

/**
 * ...
 * @author Francis Bourre
 */
class FastInjectionBuilder
{
	/** @private */
    function new()
    {
        throw new PrivateConstructorException( "This class can't be instantiated." );
    }
	
	static function _getMissingMappingPropertyException( propertyType : String, className : String, propertyName : String, injectionName : String = '' ) : String
    {
		return "Injector is missing a mapping to inject into property named '" + 
			propertyName + "' with type '" + propertyType + 
				"' inside instance of '" + className + 
					"'. Target dependency: '" + propertyType +
						"|" + injectionName + "'";
	}
	
	static function _getMissingMappingMethodException( type : String, className : String, methodName : String, injectionName : String = '' ) : String
    {
        return "Injector is missing a mapping to inject argument into method named '" +
			methodName + "' with type '" + type +
				"' inside instance of '" + className +
					"'. Target dependency: '" + type +
						"|" + injectionName + "'";
    }
	
	static function _getMissingMappingConstructorException( type : String, className : String, injectionName : String = '' ) : String
    {
		return "Injector is missing a mapping to inject argument" +
			" with type '" + type +
				"' into constructor of class '" + className +
					"'. Target dependency: '" + type +
						"|" + injectionName + "'";
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
		fields.push(
		{
			name:  "__INJECTION",
			access:  [ Access.APublic, Access.AStatic ],
			kind: FieldType.FVar( macro: hex.di.reflect.InjectionProcessor, FastInjectionBuilder._generateInjectionProcessorExpr( data ) ), 
			pos: Context.currentPos(),
		});
		
		return fields;
	}
	
	static function _generateInjectionProcessorExpr( data : ClassAnnotationData ) : ExprOf<InjectionProcessor>
    {
		var applyClassInjection : ExprOf<Dynamic->IDependencyInjector->Dynamic> = null;
		var applyConstructorInjection : ExprOf<Class<Dynamic>->IDependencyInjector->Dynamic> = null;
		var applyPreDestroyInjection : ExprOf<Dynamic->IDependencyInjector->Dynamic> = null;
		
		var className 	= data.name;
		var instance 	= macro $i { "instance" };
		var type 		= macro $i { "type" };
		
		var expressions = [ macro {} ];
		var consExpression = [ macro {} ];

		//constructor parsing
		var ctorArgProvider 	= [];
		var ctorAnn = data.constructorAnnotationData;

		if ( ctorAnn != null )
		{
			for ( i in 0...ctorAnn.argumentDatas.length )
			{
				var inject 				= ArrayUtil.find( ctorAnn.annotationDatas, e => e.annotationName == "Inject" );
				var key 				= inject != null ? inject.annotationKeys[ i ] : "";
				var optional			= ArrayUtil.find( ctorAnn.annotationDatas, e => e.annotationName == "Optional" );
				var isOpt : Null<Bool> 	= optional != null ? optional.annotationKeys[ i ] : false;
				
				var argType 		= MacroUtil.getPack( ctorAnn.argumentDatas[ i ].argumentType );
				var injectionName 	= key == null ? "" : key;
				var isOptional 		= isOpt == null ? false : isOpt;
				
				//build provider
				var providerID 		= 'p' + consExpression.length;
				var provider 		= macro $i { providerID };
				consExpression.push( macro @:mergeBlock { var $providerID = injector.getProvider( $p{argType}, $v{injectionName} ); } );
				
				if ( isOptional )
				{
					ctorArgProvider.push( macro{ $provider != null ? $provider.getResult( injector ) : null;} );
					
				}
				else
				{
					#if debug
					var errorMessage = _getMissingMappingConstructorException( ctorAnn.argumentDatas[ i ].argumentType, className, injectionName );
					consExpression.push( macro @:mergeBlock { if ( $provider == null ) throw new hex.di.error.MissingMappingException( $v{errorMessage} ); } );
					#end
					ctorArgProvider.push( macro{ $provider.getResult( injector );} );
				}
			}

			var tp = MacroUtil.getTypePath( className );
			consExpression.push( macro @:mergeBlock { return new $tp( $a{ctorArgProvider} ); } );
			applyConstructorInjection = macro function f( type : Class<Dynamic>, injector : hex.di.IDependencyInjector ) : Dynamic { $b{ consExpression }; };
		}

		//properties parsing
		var propValues: Array<Expr> = [];
		for ( property in data.properties )
		{
			var inject 				= ArrayUtil.find( property.annotationDatas, e => e.annotationName == "Inject" );
			var key 				= inject != null ? inject.annotationKeys[ 0 ] : "";
			var optional 			= ArrayUtil.find( property.annotationDatas, e => e.annotationName == "Optional" );
			var isOpt : Null<Bool> 	= optional != null ? optional.annotationKeys[ 0 ] : false;
			
			var propertyName 	= property.propertyName;
			var propertyType 	= MacroUtil.getPack( property.propertyType );
			var injectionName 	= key == null ? "" : key;
			var isOptional 		= isOpt == null ? false : isOpt;
			
			//build provider
			var providerID 		= 'p' + expressions.length;
			var provider 		= macro $i { providerID };
			expressions.push( macro @:mergeBlock { var $providerID = injector.getProvider( $p { propertyType }, $v { injectionName } ); } );
			
			if ( isOptional )
			{
				expressions.push( macro @:mergeBlock { if ( $provider != null ) { $instance.$propertyName = $provider.getResult( injector ); }; } );
			}
			else
			{
				#if debug
				var errorMessage = _getMissingMappingPropertyException( property.propertyType, className, propertyName, injectionName );
				expressions.push( macro @:mergeBlock { if ( $provider == null ) throw new hex.di.error.MissingMappingException( $v{errorMessage} ); } );
				#end
				expressions.push( macro @:mergeBlock { $instance.$propertyName = $provider.getResult( injector ); } );
			}
		}
		
		//methods parsing
		var postConstructExprs: 	Array<Expr> = [];
		var preDestroyExprs: 		Array<Expr> = [];
		var methodExprs: 			Array<Expr> = [];
		
		for ( method in data.methods )
		{
			var argProviders 	= [];
			var methodName 		= method.methodName;

			var argData = method.argumentDatas;
			for ( j in 0...argData.length )
			{
				var inject 					= ArrayUtil.find( method.annotationDatas, e => e.annotationName == "Inject" );
				var key 					= inject != null ? inject.annotationKeys[ j ] : "";
				var optional 				= ArrayUtil.find( method.annotationDatas, e => e.annotationName == "Optional" );
				var isOpt  : Null<Bool>		= optional != null ? optional.annotationKeys[ j ] : false;
				
				var argType 				= MacroUtil.getPack( argData[ j ].argumentType );
				var injectionName 			= key == null ? "" : key;
				var isOptional				= isOpt == null ? false : isOpt;
				
				//build provider
				var providerID 		= 'p' + expressions.length;
				var provider 		= macro $i { providerID };
				expressions.push( macro @:mergeBlock { var $providerID = injector.getProvider( $p{argType}, $v{injectionName} ); } );
				
				if ( isOptional )
				{
					argProviders.push( macro{ $provider != null ? $provider.getResult( injector ) : null;} );
				}
				else
				{
					#if debug
					var errorMessage = _getMissingMappingMethodException( argData[ j ].argumentType, className, methodName, injectionName );
					expressions.push( macro @:mergeBlock { if ( $provider == null ) throw new hex.di.error.MissingMappingException( $v{errorMessage} ); } );
					#end
					
					argProviders.push( macro{ $provider.getResult( injector );} );
				}
			}

			//method building
			var postConstruct 		= ArrayUtil.find( method.annotationDatas, e => e.annotationName == "PostConstruct" );
			var preDestroy 			= ArrayUtil.find( method.annotationDatas, e => e.annotationName == "PreDestroy" );
			var order : Null<Int>	= 0;

			if ( postConstruct != null )
			{
				order = postConstruct.annotationKeys[ 0 ];
				postConstructExprs.push( macro @:mergeBlock @:order($v{order==null?0:order}) { $instance.$methodName( $a{argProviders} ); } );
			}
			else if ( preDestroy != null )
			{
				order = preDestroy.annotationKeys[ 0 ];
				preDestroyExprs.push( macro @:mergeBlock @:order($v{order==null?0:order}) { $instance.$methodName( $a{argProviders} ); } );
			}
			else
			{
				methodExprs.push( macro @:mergeBlock { $instance.$methodName( $a{argProviders} ); } );
			}
		}
		
		if ( methodExprs.length > 0 ) 
		{
			expressions = expressions.concat( methodExprs );
		}
		
		if ( postConstructExprs.length > 0 ) 
		{
			ArraySort.sort( postConstructExprs, FastInjectionBuilder._sortExpressions );
			expressions = expressions.concat( postConstructExprs );
		}
		
		if ( preDestroyExprs.length > 0 ) 
		{
			ArraySort.sort( preDestroyExprs, FastInjectionBuilder._sortExpressions );
			preDestroyExprs.push( macro @:mergeBlock { return $instance; } );
			applyPreDestroyInjection = macro function f( instance : Dynamic, injector : hex.di.IDependencyInjector ) : Dynamic { $b{ preDestroyExprs }; };
		}

		expressions.push( macro @:mergeBlock { return $instance; } );
		applyClassInjection = macro function f( instance : Dynamic, injector : hex.di.IDependencyInjector ) : Dynamic { $b { expressions }; };
		

		var injectionProcessor = null;
		var fields = [ { field: "applyClassInjection", expr: applyClassInjection } ];
		if ( applyConstructorInjection != null )
		{
			fields.push( { field: "applyConstructorInjection", expr: applyConstructorInjection } );
		}
		
		if ( applyPreDestroyInjection != null )
		{
			fields.push( { field: "applyPreDestroyInjection", expr: applyPreDestroyInjection } );
		}
		
		return { expr: EObjectDecl( fields ), pos: Context.currentPos() };
	}
	
	static function _sortExpressions( a : Expr, b : Expr ) : Int
	{
		return _getExpOrder( a ) - _getExpOrder( b );
	}
	
	static function _getExpOrder( e : Expr ) : Int
	{
		switch( e.expr )
		{
			case EMeta( _, _.expr => EMeta( s, _ ) ):
				switch( s.params )
				{
					case [ _.expr => EConst( CInt( i ) )]:
						return Std.parseInt( i );
					case _:
				}		
			case _:
		}
		return -1;
	}
}