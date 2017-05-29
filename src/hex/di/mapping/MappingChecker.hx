package hex.di.mapping;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Expr.Field;
import haxe.macro.ExprTools;
import hex.annotation.AnnotationReplaceBuilder;
import hex.error.PrivateConstructorException;
import hex.util.MacroUtil;
using Lambda;

/**
 * ...
 * @author Francis Bourre
 */
class MappingChecker 
{
	//static property name that will handle the data
	public static inline var DEPENDENCY : String = "__DEP__";
	
#if macro
	static inline var _annotation = 'Dependency';
	
	/** @private */
    function new()  throw new PrivateConstructorException();

	macro public static function check() : Array<Field>
	{
		var fields = Context.getBuildFields();
		
		//if it's an interface we don't want to check
		if ( Context.getLocalClass().get().isInterface )
		{
			return fields;
		}
		
		if ( fields.filter( function(f) return f.name == 'map' ).length == 0 )
		{
			fields.push(
			{
				name: '__map',
				pos: haxe.macro.Context.currentPos(),
				kind: FFun( 
				{
					args: [{name:'mappings', type: macro:Array<MappingDefinition>}, {name:'injectInto', type: macro:Array<MappingDefinition>, opt:true}],
					ret: macro:Array<MappingDefinition>,
					expr: macro 
					{
						mappings = hex.di.mapping.MappingChecker.filter( Type.resolveClass( $v { Context.getLocalClass().toString() } ), mappings );
						
						if ( injectInto == null ) injectInto = [];
						for ( mapping in  mappings )
						{
							if ( mapping.toValue != null )
							{
								this.getInjector().mapClassNameToValue( mapping.fromType, mapping.toValue, mapping.withName );
							}
							else
							{
								if ( mapping.asSingleton )
								{
									this.getInjector().mapClassNameToSingleton( mapping.fromType, mapping.toClass, mapping.withName );
								}
								else
								{
									this.getInjector().mapClassNameToType( mapping.fromType, mapping.toClass, mapping.withName );
								}
							}
							
							if ( mapping.injectInto ) injectInto.push( mapping );
						}
						
						return injectInto;
					}
				}),
				access: [ APrivate ]
			});
			
			fields.push(
			{
				name: '__injectInto',
				pos: haxe.macro.Context.currentPos(),
				kind: FFun( 
				{
					args: [{name:'injectInto', type: macro:Array<MappingDefinition>}],
					ret: macro:Void,
					expr: macro 
					{
						for ( mapping in  injectInto )
						{
							this.getInjector().injectInto( mapping );
						}
					}
				}),
				access: [ APrivate ]
			});
		}

		
		var metas = Context.getLocalClass().get().meta.get();
		var m = metas	
						.filter( function(m) return m.name == _annotation )
						.map( _parse )
						.map( function(e) return e.type + '|' + e.name );
			
		Context.getLocalClass().get().meta.remove( _annotation );

		//append the expression as a field
		fields.push(
		{
			name:  MappingChecker.DEPENDENCY,
			access:  [ Access.APublic, Access.AStatic ],
			kind: FieldType.FVar( macro: Array<String>, macro $v{ m } ), 
			pos: Context.currentPos(),
		});

		for ( f in fields )
		{
			switch( f.kind )
			{ 
				case FFun( func ) :
				{
					if ( f.name == 'new' )
					{
						var a : Array<Expr> = [];
						for ( arg in func.args )
						{
							var p = Context.currentPos();
							var isInstance = Context.unify( Context.resolveType( arg.type, p ), Context.resolveType( macro:MappingDefinition, p ) );
							var isArray = Context.unify( Context.resolveType( arg.type, p ), Context.resolveType( macro:Array<MappingDefinition>, p ) );
							
							if ( a.length == 0 )
							{
								if ( isInstance ) a.push( macro  @:mergeBlock { var __injectInto__ = this.__map( [$i{arg.name}] ); } );
								if ( isArray ) a.push( macro  @:mergeBlock { var __injectInto__ = this.__map( $i{arg.name} ); } );
							}
							else
							{
								if ( isInstance ) a.push( macro  @:mergeBlock { __injectInto__ = this.__map( [$i{arg.name}], __injectInto__ ); } );
								if ( isArray ) a.push( macro  @:mergeBlock { __injectInto__ = this.__map( $i{arg.name}, __injectInto__ ); } );
							}
							
						}
						
						//Append
						if ( a.length > 0 )
						{
							a.push( macro  @:mergeBlock { this.__injectInto( __injectInto__ ); } );
							func.expr.expr = switch( func.expr.expr )
							{
								case EBlock( exprs ): EBlock( a.concat( exprs ) );
								case _: EBlock( a );
							}
						}
					}
				}
				
				case _:
			}
		}
		
		return fields;
	}
	
	static function _parse( meta : MetadataEntry )
	{
		switch( meta.params )
		{
			case [ _ => macro var $varName: $t ]:
				return { type: MacroUtil.getFQCNFromComplexType( t ), name: varName != '_'? varName : '' };

			case [ _ => ( macro var $varName: $t ),  _ => macro $e ]:
				return { type: MacroUtil.getFQCNFromComplexType( t ), name: $v{ ExprTools.getValue( AnnotationReplaceBuilder.processParam( e ) ) } };

			case _: Context.error( 'Invalid Dependency description', meta.pos );
		}
		return null;
	}
#end

	public static function filter<T>( classReference : Class<T>, mappings : Array<MappingDefinition> ) : Array<MappingDefinition>
	{
		var dependencies = Reflect.getProperty( classReference, DEPENDENCY );
		return mappings.filter( function(e) return dependencies.indexOf( e.fromType + '|' + (e.withName==null?"":e.withName) ) != -1 );
	}
	
	public static function match<T>( classReference : Class<T>, mappings : Array<MappingDefinition> ) : Bool
	{
		var dependencies : Array<String> = Reflect.getProperty( classReference, DEPENDENCY );
		var filtered = mappings.filter( function(e) return dependencies.indexOf( e.fromType + '|' + (e.withName==null?"":e.withName) ) != -1 );
		return filtered.length == mappings.length && dependencies.length == mappings.length;
	}
}