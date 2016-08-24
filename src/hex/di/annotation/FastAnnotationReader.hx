package hex.di.annotation;

import haxe.ds.ArraySort;
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Expr.Access;
import haxe.macro.Expr.Field;
import haxe.macro.Expr.FieldType;
import hex.annotation.ClassAnnotationData;
import hex.di.reflect.ClassDescription;
import hex.error.PrivateConstructorException;
import hex.util.MacroUtil;

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
		fields.push(
		{
			name:  "__INJECTION_DATA",
			access:  [ Access.APublic, Access.AStatic ],
			kind: FieldType.FVar( macro: hex.di.reflect.ClassDescription, FastAnnotationReader._getClassDescriptionExpression( data ) ), 
			pos: Context.currentPos(),
		});
		
		return fields;
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
	
	static function _getClassDescriptionExpression( data : ClassAnnotationData ) : ExprOf<ClassDescription>
    {
		//properties parsing
		var propValues: Array<Expr> = [];
		for ( property in data.properties )
		{
			var inject 		= ArrayUtil.find( property.annotationDatas, e => e.annotationName == "Inject" );
			var key 		= inject != null ? inject.annotationKeys[ 0 ] : "";
			var optional 	= ArrayUtil.find( property.annotationDatas, e => e.annotationName == "Optional" );
			var isOpt 		= optional != null ? optional.annotationKeys[ 0 ] : false;
			
			var eProp = EObjectDecl([
				{field: "propertyName", expr: macro $v{property.propertyName}}, 
				{field: "propertyType", expr: macro $p{ MacroUtil.getPack(property.propertyType) }},
				{field: "injectionName", expr: macro $v{key==null?"":key}},
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
				var inject 		= ArrayUtil.find( method.annotationDatas, e => e.annotationName == "Inject" );
				var key 		= inject != null ? inject.annotationKeys[ j ] : "";
				var optional 	= ArrayUtil.find( method.annotationDatas, e => e.annotationName == "Optional" );
				var isOpt 		= optional != null ? optional.annotationKeys[ j ] : false;
				
				var eArg = EObjectDecl([
					{field: "type", expr: macro $p{MacroUtil.getPack( argData[ j ].argumentType )}},
					{field: "injectionName", expr: macro $v{key==null?"":key}},
					{field: "isOptional", expr: macro $v{isOpt==null?false:isOpt}}
				]);
				
				argValues.push( { expr: eArg, pos:Context.currentPos() } );
			}

			//method building
			var postConstruct 	= ArrayUtil.find( method.annotationDatas, e => e.annotationName == "PostConstruct" );
			var preDestroy 		= ArrayUtil.find( method.annotationDatas, e => e.annotationName == "PreDestroy" );
			var order 			= 0;

			if ( postConstruct != null )
			{
				order = postConstruct.annotationKeys[ 0 ];
				var eMethod = EObjectDecl([
					{field: "methodName", expr: macro $v{method.methodName}},
					{field: "args", expr: {expr:EArrayDecl(argValues), pos: Context.currentPos()}},
					{field: "order", expr: macro $v{order==null?0:order}}
				]);
				
				postConstructValues.push( { expr: eMethod, pos: Context.currentPos() } );
			}
			else if ( preDestroy != null )
			{
				order = preDestroy.annotationKeys[ 0 ];
				var eMethod = EObjectDecl([
					{field: "methodName", expr: macro $v{method.methodName}},
					{field: "args", expr: {expr:EArrayDecl(argValues), pos: Context.currentPos()}},
					{field: "order", expr: macro $v{order==null?0:order}}
				]);
				
				preDestroyValues.push( {expr: eMethod, pos: Context.currentPos()} );
			}
			else
			{
				var eMethod = EObjectDecl([
					{field: "methodName", expr: macro $v{method.methodName}},
					{field: "args", expr: {expr:EArrayDecl(argValues), pos: Context.currentPos()}}
				]);
				
				methodValues.push( { expr: eMethod, pos: Context.currentPos() } );
			}
		}
		
		if ( postConstructValues.length > 0 ) ArraySort.sort( postConstructValues, FastAnnotationReader._sortExpr );
		if ( preDestroyValues.length > 0 ) ArraySort.sort( preDestroyValues, FastAnnotationReader._sortExpr );

		//constructor parsing
		var ctorArgValues: Array<Expr> = [];
		var ctorAnn = data.constructorAnnotationData;

		if ( ctorAnn != null )
		{
			for ( i in 0...ctorAnn.argumentDatas.length )
			{
				var inject 		= ArrayUtil.find( ctorAnn.annotationDatas, e => e.annotationName == "Inject" );
				var key 		= inject != null ? inject.annotationKeys[ i ] : "";
				var optional 	= ArrayUtil.find( ctorAnn.annotationDatas, e => e.annotationName == "Optional" );
				var isOpt 		= optional != null ? optional.annotationKeys[ i ] : false;
				
				var eCtorArg = EObjectDecl([
					{field: "type", expr: macro $p{ MacroUtil.getPack( ctorAnn.argumentDatas[ i ].argumentType ) }},
					{field: "injectionName", expr: macro $v{key == null?"":key}},
					{field: "isOptional", expr: macro $v{isOpt == null?false:isOpt}}
				]);
				
				ctorArgValues.push( { expr: eCtorArg, pos:Context.currentPos() } );
			}
		}

		var ctor = EObjectDecl([
				{field: "methodName", expr: macro $v{'new'}},
				{field: "args", expr: {expr:EArrayDecl(ctorArgValues), pos: Context.currentPos()}}
			]);
		
			
		//final expression
		var classDescription = EObjectDecl([
				{field: "constructorInjection", expr: {expr: ctor, pos: Context.currentPos()}},
				{field: "properties", expr: {expr: EArrayDecl(propValues), pos: Context.currentPos()}},
				{field: "methods", expr: {expr: EArrayDecl(methodValues), pos: Context.currentPos()}},
				{field: "postConstruct", expr: {expr: EArrayDecl(postConstructValues), pos: Context.currentPos()}},
				{field: "preDestroy", expr: {expr: EArrayDecl(preDestroyValues), pos: Context.currentPos()}}
			]);

		return { expr: classDescription, pos: Context.currentPos() };
	}
}