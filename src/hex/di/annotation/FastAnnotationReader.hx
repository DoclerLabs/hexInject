package hex.di.annotation;

import haxe.ds.ArraySort;
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Expr.Access;
import haxe.macro.Expr.Field;
import haxe.macro.Expr.FieldType;
import hex.annotation.ClassAnnotationData;
import hex.di.annotation.InjectorArgumentVO;
import hex.di.annotation.InjectorClassVO;
import hex.di.annotation.InjectorMethodVO;
import hex.di.annotation.InjectorPropertyVO;
import hex.di.reflect.ArgumentInjectionVO;
import hex.di.reflect.ClassDescription;
import hex.di.reflect.ConstructorInjection;
import hex.di.reflect.MethodInjection;
import hex.di.reflect.OrderedInjection;
import hex.di.reflect.PropertyInjection;
import hex.error.PrivateConstructorException;

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
		
		//create expected value object
		var vo = FastAnnotationReader._adaptToInject( data );
		var classDescription = FastAnnotationReader._getClassDescription( vo );

		// append the expression as a field
		fields.push(
		{
			name:  "__INJECTION_DATA",
			access:  [ Access.APublic, Access.AStatic ],
			kind: FieldType.FVar(macro:hex.di.reflect.ClassDescription, macro $v{ classDescription } ), 
			//kind: FieldType.FVar(macro:hex.di.annotation.InjectorClassVO, macro $v{ vo } ), 
			pos: Context.currentPos(),
		});
		
		return fields;
	}
	
	static function _getClassDescription( classAnnotationData : InjectorClassVO )  : ClassDescription
    {
		/*var injections 		: Array<IInjectable> 		= [];
		var postConstruct 	: Array<OrderedInjection> 	= [];
		var preDestroy 		: Array<OrderedInjection> 	= [];
		
		for ( prop in classAnnotationData.props )
		{
			injections.push( new PropertyInjection( prop.name, prop.type, prop.key, prop.isOpt ) );
		}

		for ( method in classAnnotationData.methods )
		{
			var arguments : Array<ArgumentInjectionVO> = [];
			for ( arg in method.args )
			{
				arguments.push( new ArgumentInjectionVO( Type.resolveClass( arg.type ), arg.key, arg.isOpt ) );
			}
			
			if ( method.isPost )
			{
				postConstruct.push( new OrderedInjection( method.name, arguments, method.order ) );
			}
			else if ( method.isPre )
			{
				preDestroy.push( new OrderedInjection( method.name, arguments, method.order ) );
			}
			else
			{
				injections.push( new MethodInjection( method.name, arguments ) );
			}
		}

		var ctor = classAnnotationData.ctor;
		var ctorArguments : Array<ArgumentInjectionVO> = [];
		for ( arg in ctor.args )
		{
			ctorArguments.push( new ArgumentInjectionVO( Type.resolveClass( arg.type ), arg.key, arg.isOpt ) );
		}
		var constructorInjection = new ConstructorInjection( ctorArguments );

		var classDescription : ClassDescription = new ClassDescription( constructorInjection, injections, postConstruct, preDestroy );
		return classDescription;*/
		
		var properties 	= [ 
			for ( prop in classAnnotationData.props ) 
					{ propertyName: prop.name, propertyType: Type.resolveClass( prop.type ), injectionName: prop.key, isOptional: prop.isOpt } 
			];
		
		var methods 		: Array<MethodInjection> 	= [];
		var postConstruct 	: Array<OrderedInjection> 	= [];
		var preDestroy 		: Array<OrderedInjection> 	= [];
		
		for ( method in classAnnotationData.methods )
		{
			var arguments = [ for ( arg in method.args ) { type: Type.resolveClass( arg.type ), injectionName: arg.key, isOptional: arg.isOpt } ];
			
			if ( method.isPost )
			{
				postConstruct.push( { methodName: method.name, args: arguments, order: method.order } );
			}
			else if ( method.isPre )
			{
				preDestroy.push( { methodName: method.name, args: arguments, order: method.order } );
			}
			else
			{
				methods.push( { methodName: method.name, args: arguments } );
			}
		}
		
		if ( postConstruct.length > 0 )
		{
			ArraySort.sort( postConstruct, FastAnnotationReader._sort );
		}
		
		if ( preDestroy.length > 0 )
		{
			ArraySort.sort( preDestroy, FastAnnotationReader._sort );
		}

		var ctor = classAnnotationData.ctor;
		var ctorArguments = [ for ( arg in ctor.args ) { type: Type.resolveClass( arg.type ), injectionName: arg.key, isOptional: arg.isOpt } ];
		var constructorInjection = { methodName: 'new', args: ctorArguments };
		return { constructorInjection: constructorInjection, properties: properties, methods: methods, postConstruct: postConstruct, preDestroy: preDestroy };
    }
	
	inline static function _sort( a : OrderedInjection, b : OrderedInjection ) : Int
	{
		return  a.order - b.order;
	}
	
	private static function _adaptToInject( data : ClassAnnotationData ) : InjectorClassVO
	{
		var length : Int;

		//constructor parsing
		var ctorArgs : Array<InjectorArgumentVO> = [];
		
		var ctorAnn = data.constructorAnnotationData;
		if ( ctorAnn != null )
		{
			length = ctorAnn.argumentDatas.length;
			for ( i in 0...length )
			{
				var annotations = ctorAnn.annotationDatas;
				
				var inject = annotations.filter( function ( v ) { return v.annotationName == "Inject"; } );
				var key = inject.length > 0 ? inject[ 0 ].annotationKeys[ i ] : "";

				var optional = annotations.filter( function ( v ) { return v.annotationName == "Optional"; } );
				var isOpt = optional.length > 0 ? optional[ 0 ].annotationKeys[ i ] : false;
				
				ctorArgs.push( { type: ctorAnn.argumentDatas[ i ].argumentType, key: key==null?"":key, isOpt: isOpt==null?false:isOpt } );
			}
		}
		var ctor : InjectorMethodVO = { name: "new", args: ctorArgs, isPre: false, isPost: false, order: 0 };

		//properties parsing
		var props : Array<InjectorPropertyVO> = [];
		
		var propAnn = data.properties;
		length = propAnn.length;
		for ( i in 0...length )
		{
			var annotations = propAnn[ i ].annotationDatas;
			
			var inject = annotations.filter( function ( v ) { return v.annotationName == "Inject"; } );
			var key = inject.length > 0 ? inject[ 0 ].annotationKeys[ 0 ] : "";

			var optional = annotations.filter( function ( v ) { return v.annotationName == "Optional"; } );
			var isOpt = optional.length > 0 ? optional[ 0 ].annotationKeys[ 0 ] : false;
			
			props.push( { name: propAnn[ i ].propertyName, type: propAnn[ i ].propertyType, key: key==null?"":key, isOpt: isOpt==null?false:isOpt } );
		}

		//methods parsing
		var methods : Array<InjectorMethodVO> = [];
		
		var methAnn = data.methods;
		length = methAnn.length;
		for ( i in 0...length )
		{
			// arguments parsing
			var args : Array<InjectorArgumentVO> = [];
			
			var argData = methAnn[ i ].argumentDatas;
			var argLength = argData.length;
			for ( j in 0...argLength )
			{
				var annotations = methAnn[ i ].annotationDatas;
				
				var inject = annotations.filter( function ( v ) { return v.annotationName == "Inject"; } );
				var key = inject.length > 0 ? inject[ 0 ].annotationKeys[ j ] : "";
				
				var optional = annotations.filter( function ( v ) { return v.annotationName == "Optional"; } );
				var isOpt = optional.length > 0 ? optional[ 0 ].annotationKeys[ j ] : false;
				
				args.push( { type: argData[ j ].argumentType, key: key==null?"":key, isOpt: isOpt==null?false:isOpt } );
			}
			
			//method building
			var postConstruct = methAnn[ i ].annotationDatas.filter( function ( v ) { return v.annotationName == "PostConstruct"; } );
			var preDestroy = methAnn[ i ].annotationDatas.filter( function ( v ) { return v.annotationName == "PreDestroy"; } );
			var order = 0;
			if ( postConstruct.length > 0 ) order = postConstruct[ 0 ].annotationKeys[ 0 ];
			if ( preDestroy.length > 0 ) order = preDestroy[ 0 ].annotationKeys[ 0 ];
			methods.push( { name: methAnn[ i ].methodName, args: args, isPre: preDestroy.length>0, isPost: postConstruct.length>0, order: order==null?0:order } );
		}
	
		//final building
		//trace( data.name, { name:data.name, ctor:ctor, props:props, methods:methods } );
		return { name:data.name, ctor:ctor, props:props, methods:methods };
	}
}