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
import hex.di.reflect.ClassDescription;
import hex.error.PrivateConstructorException;
import hex.util.MacroUtil;

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
		var e = FastAnnotationReader._getClassDescriptionExpr( vo );

		// append the expression as a field
		fields.push(
		{
			name:  "__INJECTION_DATA",
			access:  [ Access.APublic, Access.AStatic ],
			kind: FieldType.FVar(macro:hex.di.reflect.ClassDescription, e ), 
			pos: Context.currentPos(),
		});
		
		return fields;
	}
	
	static function _getClassDescriptionExpr( classAnnotationData : InjectorClassVO )  : ExprOf<ClassDescription>
    {
		var propValues: Array<Expr> = [];
		for ( prop in classAnnotationData.props ) 
		{
			Context.getType( prop.type );
			var eProp = EObjectDecl([
				{field: "propertyName", expr: macro $v{prop.name}}, 
				{field: "propertyType", expr: macro $p{ MacroUtil.getPack(prop.type) }},
				{field: "injectionName", expr: macro $v{prop.key}},
				{field: "isOptional", expr: macro $v{prop.isOpt}}
			]);
			propValues.push( {expr: eProp, pos:Context.currentPos()} );
		}
		
		var postConstructValues: Array<Expr> = [];
		var preDestroyValues: Array<Expr> = [];
		var methodValues: Array<Expr> = [];
		
		for ( method in classAnnotationData.methods )
		{
			var argValues: Array<Expr> = [];
			for ( arg in method.args ) 
			{
				Context.getType( arg.type );
				var eArg = EObjectDecl([
					{field: "type", expr: macro $p{ MacroUtil.getPack( arg.type ) }},
					{field: "injectionName", expr: macro $v{arg.key}},
					{field: "isOptional", expr: macro $v{arg.isOpt}}
				]);
				argValues.push( {expr: eArg, pos:Context.currentPos()} );
			}

			if ( method.isPost )
			{
				var eMethod = EObjectDecl([
					{field: "methodName", expr: macro $v{method.name}},
					{field: "args", expr: {expr:EArrayDecl(argValues), pos: Context.currentPos()}},
					{field: "order", expr: macro $v{method.order}}
				]);
				postConstructValues.push( { expr: eMethod, pos: Context.currentPos() } );
			}
			else if ( method.isPre )
			{
				var eMethod = EObjectDecl([
					{field: "methodName", expr: macro $v{method.name}},
					{field: "args", expr: {expr:EArrayDecl(argValues), pos: Context.currentPos()}},
					{field: "order", expr: macro $v{method.order}}
				]);
				preDestroyValues.push( {expr: eMethod, pos: Context.currentPos()} );
			}
			else
			{
				var eMethod = EObjectDecl([
					{field: "methodName", expr: macro $v{method.name}},
					{field: "args", expr: {expr:EArrayDecl(argValues), pos: Context.currentPos()}}
				]);
				
				methodValues.push( {expr: eMethod, pos: Context.currentPos()} );
			}
		}

		if ( postConstructValues.length > 0 )
		{
			ArraySort.sort( postConstructValues, FastAnnotationReader._sortExpr );
		}
		
		if ( preDestroyValues.length > 0 )
		{
			ArraySort.sort( preDestroyValues, FastAnnotationReader._sortExpr );
		}
		
		
		var ctor = classAnnotationData.ctor;
		var newMethodName = 'new';
		
		var ctorArgValues: Array<Expr> = [];
		for ( arg in ctor.args )
		{
			Context.getType( arg.type );
			var eCtorArg = EObjectDecl([
				{field: "type", expr: macro $p{ MacroUtil.getPack( arg.type ) }},
				{field: "injectionName", expr: macro $v{arg.key}},
				{field: "isOptional", expr: macro $v{arg.isOpt}}
			]);
			ctorArgValues.push( {expr: eCtorArg, pos:Context.currentPos()} );
		}
		
		var ctor = EObjectDecl([
				{field: "methodName", expr: macro $v{'new'}},
				{field: "args", expr: {expr:EArrayDecl(ctorArgValues), pos: Context.currentPos()}}
			]);
			
			
		var classDescription = EObjectDecl([
				{field: "constructorInjection", expr: {expr: ctor, pos: Context.currentPos()}},
				{field: "properties", expr: {expr: EArrayDecl(propValues), pos: Context.currentPos()}},
				{field: "methods", expr: {expr: EArrayDecl(methodValues), pos: Context.currentPos()}},
				{field: "postConstruct", expr: {expr: EArrayDecl(postConstructValues), pos: Context.currentPos()}},
				{field: "preDestroy", expr: {expr: EArrayDecl(preDestroyValues), pos: Context.currentPos()}}
			]);

		return {expr: classDescription, pos: Context.currentPos()};
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
					switch( f.field )
					{
						case 'order':
							switch( f.expr.expr )
							{
								case EConst( c ):
									switch ( c )
									{
										case CInt( s ):
											return  Std.parseInt( s );
										case _:
									}
								case _:
							}
					}
				}
				return -1;
			case _:
				return -1;
		}
		
		return -1;
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
		return { name:data.name, ctor:ctor, props:props, methods:methods };
	}
}