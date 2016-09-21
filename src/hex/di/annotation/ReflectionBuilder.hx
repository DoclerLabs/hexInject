package hex.di.annotation;

import haxe.ds.ArraySort;
import haxe.macro.Context;
import haxe.macro.Expr;
import hex.annotation.ClassAnnotationData;
import hex.di.reflect.ClassDescription;
import hex.error.PrivateConstructorException;

using hex.util.ArrayUtil;

/**
 * ...
 * @author Francis Bourre
 */
class ReflectionBuilder
{
	/** @private */
    function new()
    {
        throw new PrivateConstructorException( "This class can't be instantiated." );
    }
	
	static function _sortExpr( a : Expr, b : Expr ) : Int
	{
		return _getOrder( a ) - _getOrder( b );
	}
	
	static function _getOrder( e : Expr ) : Int
	{
		switch( e.expr )
		{
			case EObjectDecl( fields ):
				for ( f in fields )
				{
					if ( f.field == 'order' )
					{
						switch( f.expr.expr )
						{
							case EConst( CInt( s ) ):
									return Std.parseInt( s );
							case _:
						}
					}
				}
			case _:
		}
		
		return -1;
	}
	
	public static function getClassDescriptionExpression( data : ClassAnnotationData ) : ExprOf<ClassDescription>
    {
		//properties parsing
		var propValues: Array<Expr> = [];
		for ( property in data.properties )
		{
			var inject 				= ArrayUtil.find( property.annotationDatas, e => e.annotationName == "Inject" );
			var key					= inject != null ? inject.annotationKeys[ 0 ] : "";
			var optional 			= ArrayUtil.find( property.annotationDatas, e => e.annotationName == "Optional" );
			var isOpt : Null<Bool> 	= optional != null ? optional.annotationKeys[ 0 ] : false;
			
			var eProp = EObjectDecl([
				//propertyName
				{field: "propertyName", expr: macro $v { property.propertyName }}, 
				//propertyType
				{field: "propertyType", expr: macro $v { property.propertyType }},
				//injectionName
				{field: "injectionName", expr: macro $v { key == null?"":key }},
				//isOptional
				{field: "isOptional", expr: macro $v{isOpt==null?false:isOpt}}
			]);
			propValues.push( {expr: eProp, pos:Context.currentPos()} );
		}
		
		//methods parsing
		var postConstructValues: 	Array<Expr> = [];
		var preDestroyValues: 		Array<Expr> = [];
		var methodValues: 			Array<Expr> = [];
		
		for ( method in data.methods )
		{
			var argValues: Array<Expr> = [];
			var argData = method.argumentDatas;
			for ( j in 0...argData.length )
			{
				var inject 				= ArrayUtil.find( method.annotationDatas, e => e.annotationName == "Inject" );
				var key 				= inject != null ? inject.annotationKeys[ j ] : "";
				var optional 			= ArrayUtil.find( method.annotationDatas, e => e.annotationName == "Optional" );
				var isOpt : Null<Bool> 	= optional != null ? optional.annotationKeys[ j ] : false;
				
				var eArg = EObjectDecl([
					//type
					{field: "type", expr: macro $v { argData[ j ].argumentType }},
					//injectionName
					{field: "injectionName", expr: macro $v { key == null?"":key }},
					//isOptional
					{field: "isOptional", expr: macro $v{isOpt==null?false:isOpt}}
				]);
				
				argValues.push( { expr: eArg, pos:Context.currentPos() } );
			}

			//method building
			var postConstruct 		= ArrayUtil.find( method.annotationDatas, e => e.annotationName == "PostConstruct" );
			var preDestroy	 		= ArrayUtil.find( method.annotationDatas, e => e.annotationName == "PreDestroy" );
			var order : Null<Int> 	= 0;

			if ( postConstruct != null )
			{
				order = postConstruct.annotationKeys[ 0 ];
				var eMethod = EObjectDecl([
					//methodName
					{field: "methodName", expr: macro $v { method.methodName }},
					//args
					{field: "args", expr: { expr:EArrayDecl(argValues), pos: Context.currentPos() }},
					//order
					{field: "order", expr: macro $v{order==null?0:order}}
				]);
				
				postConstructValues.push( { expr: eMethod, pos: Context.currentPos() } );
			}
			else if ( preDestroy != null )
			{
				order = preDestroy.annotationKeys[ 0 ];
				var eMethod = EObjectDecl([
					//methodName
					{field: "methodName", expr: macro $v { method.methodName }},
					//args
					{field: "args", expr: { expr:EArrayDecl(argValues), pos: Context.currentPos() }},
					//order
					{field: "order", expr: macro $v{order==null?0:order}}
				]);
				
				preDestroyValues.push( {expr: eMethod, pos: Context.currentPos()} );
			}
			else
			{
				var eMethod = EObjectDecl([
					//methodName
					{field: "methodName", expr: macro $v { method.methodName }},
					//args
					{field: "args", expr: {expr:EArrayDecl(argValues), pos: Context.currentPos()}}
				]);
				
				methodValues.push( { expr: eMethod, pos: Context.currentPos() } );
			}
		}
		
		if ( postConstructValues.length > 0 ) ArraySort.sort( postConstructValues, ReflectionBuilder._sortExpr );
		if ( preDestroyValues.length > 0 ) ArraySort.sort( preDestroyValues, ReflectionBuilder._sortExpr );

		//constructor parsing
		var ctorArgValues: Array<Expr> = [];
		var ctorAnn = data.constructorAnnotationData;

		if ( ctorAnn != null )
		{
			for ( i in 0...ctorAnn.argumentDatas.length )
			{
				var inject 				= ArrayUtil.find( ctorAnn.annotationDatas, e => e.annotationName == "Inject" );
				var key 				= inject != null ? inject.annotationKeys[ i ] : "";
				var optional 			= ArrayUtil.find( ctorAnn.annotationDatas, e => e.annotationName == "Optional" );
				var isOpt : Null<Bool> 	= optional != null ? optional.annotationKeys[ i ] : false;
				
				var eCtorArg = EObjectDecl([
					//type
					{field: "type", expr: macro $v { ctorAnn.argumentDatas[ i ].argumentType }},
					//injectionName
					{field: "injectionName", expr: macro $v { key == null?"":key }},
					//isOptional
					{field: "isOptional", expr: macro $v{isOpt == null?false:isOpt}}
				]);
				
				ctorArgValues.push( { expr: eCtorArg, pos:Context.currentPos() } );
			}
		}

		var ctor = EObjectDecl([
				//args
				{field: "args", expr: {expr:EArrayDecl(ctorArgValues), pos: Context.currentPos()}}
			]);
		
			
		//final expression
		var classDescription = EObjectDecl([
				//constructorInjection
				{field: "constructorInjection", expr: { expr: ctor, pos: Context.currentPos() }},
				//properties
				{field: "properties", expr: { expr: EArrayDecl(propValues), pos: Context.currentPos() }},
				//methods
				{field: "methods", expr: { expr: EArrayDecl(methodValues), pos: Context.currentPos() }},
				//postConstruct
				{field: "postConstruct", expr: { expr: EArrayDecl(postConstructValues), pos: Context.currentPos() }},
				//preDestroy
				{field: "preDestroy", expr: {expr: EArrayDecl(preDestroyValues), pos: Context.currentPos()}}
			]);

		return { expr: classDescription, pos: Context.currentPos() };
	}
}