package hex.di.annotation;

import haxe.Json;
import haxe.macro.Context;
import haxe.macro.Expr.Field;
import hex.di.annotation.InjectorArgumentVO;
import hex.di.annotation.InjectorClassVO;
import hex.di.annotation.InjectorMethodVO;
import hex.di.annotation.InjectorPropertyVO;
import hex.annotation.ClassAnnotationData;

/**
 * ...
 * @author Francis Bourre
 */
class AnnotationReader
{
	function new() 
	{
		
	}
	
	macro public static function readMetadata( metadataName : String ) : Array<Field>
	{
		var localClass = Context.getLocalClass().get();
		
		//parse annotations
		var fields : Array<Field> = hex.annotation.AnnotationReader.parseMetadata( metadataName, [ "Inject", "PostConstruct", "Optional" ] );
		
		//get data result
		var data = hex.annotation.AnnotationReader._static_classes[ hex.annotation.AnnotationReader._static_classes.length - 1 ];
		
		//create Json
		var json = Json.stringify( AnnotationReader._adaptToSpeedInject( data ) );
		
		//add Json as metadata
		localClass.meta.add( metadataName, [ Context.parse( "'" + json + "'", localClass.pos ) ], localClass.pos );
		
		return fields;
	}
	
	private static function _adaptToSpeedInject( data : ClassAnnotationData ) : InjectorClassVO
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
				var key = inject.length > 0 ? inject[ 0 ].annotationKeys[ i ] : null;
				
				var optional = annotations.filter( function ( v ) { return v.annotationName == "Optional"; } );
				var isOpt = optional.length > 0 ? optional[ 0 ].annotationKeys[ i ] : null;
				
				ctorArgs.push( { type: ctorAnn.argumentDatas[ i ].argumentType, key:key, isOpt:isOpt!=null?true:false } );
			}
		}
		var ctor : InjectorMethodVO = { name: "new", args: ctorArgs, isPost: false, order: 0 };

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
			
			props.push( { name: propAnn[ i ].propertyName, type: propAnn[ i ].propertyType, key:key, isOpt: isOpt } );
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
				var key = inject.length > 0 ? inject[ 0 ].annotationKeys[ j ] : null;
				
				var optional = annotations.filter( function ( v ) { return v.annotationName == "Optional"; } );
				var isOpt = optional.length > 0 ? optional[ 0 ].annotationKeys[ j ] : null;
				
				args.push( { type: argData[ j ].argumentType, key: key, isOpt: isOpt!=null?true:false } );
			}
			
			//method building
			var postConstruct = methAnn[ i ].annotationDatas.filter( function ( v ) { return v.annotationName == "PostConstruct"; } );
			var order = postConstruct.length > 0 ? postConstruct[ 0 ].annotationKeys[ i ] : null;
			methods.push( { name: methAnn[ i ].methodName, args: args, isPost: order!=null?true:false, order: order } );
		}
	
		//final building
		//trace( { name:data.name, ctor:ctor, props:props, methods:methods } );
		return { name:data.name, ctor:ctor, props:props, methods:methods };
	}
}