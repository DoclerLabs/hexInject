package hex.di.mapping;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Expr.Field;
import haxe.macro.ExprTools;
import haxe.macro.TypeTools;
import hex.annotation.AnnotationReplaceBuilder;
import hex.error.PrivateConstructorException;
import hex.util.TinkHelper;
using Lambda;

#if macro
using tink.MacroApi;
#end


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
	
	static inline var _afterMapping = 'AfterMapping';
	static inline var _mapMethodName = '__map';
	static inline var _injectIntoMethodName = '__injectInto';

	/** @private */
    function new()  throw new PrivateConstructorException();
	
	static var _dependencies : Map<String, Array<String>> = new Map();

	macro public static function check() : Array<Field>
	{
		var fields = Context.getBuildFields();
		
		//if it's an interface we don't want to check
		//and check if macro is already apply
		if ( Context.getLocalClass().get().isInterface || fields.filter( function(f) return f.name == DEPENDENCY ).length > 0 )
		{
			return fields;
		}
		//check if __map is already added on class or super class
		if ( TypeTools.findField(Context.getLocalClass().get(), _mapMethodName) == null )
		{
			fields.push(
			{
				name: _mapMethodName,
				pos: haxe.macro.Context.currentPos(),
				kind: FFun( 
				{
					args: [{name:'mappings', type: macro:Array<hex.di.mapping.MappingDefinition>}, {name:'target', type: macro:Class<Dynamic>}, {name:'injectInto', type: macro:Array<hex.di.mapping.MappingDefinition>, opt:true}],
					ret: macro:Array<hex.di.mapping.MappingDefinition>,
					expr: macro 
					{
						mappings = hex.di.mapping.MappingChecker.filter( target, mappings );
						
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
				name: _injectIntoMethodName,
				pos: haxe.macro.Context.currentPos(),
				kind: FFun( 
				{
					args: [{name:'injectInto', type: macro:Array<hex.di.mapping.MappingDefinition>}],
					ret: macro:Void,
					expr: macro 
					{
						for ( mapping in  injectInto )
						{
							this.getInjector().injectInto( mapping.toValue );
						}
					}
				}),
				access: [ APrivate ]
			});
		}

		
		var metas = Context.getLocalClass().get().meta.get();
		var parsedDeps = metas	
						.filter( function(m) return m.name == _annotation )
						.map( _parse );
						
		var runtimeDeps = parsedDeps.map( function(e) return macro ($v{e.type}:hex.di.ClassName) | ($v{e.name}:hex.di.MappingName) );
		var compiletimeDeps = parsedDeps.map( function(e) return (e.type:ClassName) | (e.name:MappingName) );
			
		Context.getLocalClass().get().meta.remove( _annotation );

		//append the expression as a field
		fields.push(
		{
			name:  MappingChecker.DEPENDENCY,
			access:  [ Access.APublic, Access.AStatic ],
			kind: FieldType.FVar( macro: Array<String>, macro $a{ runtimeDeps } ), 
			pos: Context.currentPos(),
		});
		
		var className =  Context.getLocalClass().get().pack.concat([Context.getLocalClass().get().name]).join('.');
		MappingChecker._dependencies.set( className, compiletimeDeps );

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
							var isDynamic = switch( arg.type )
							{
								case TPath( t ) if ( t.name == 'Dynamic' ) : true;
								case _ : false;
							}
							if ( !isDynamic )
							{
								var p = Context.currentPos();
								var localClass = Context.getLocalClass().toString().resolve();
								var isInstance = Context.unify( Context.resolveType( arg.type, p ), Context.resolveType( macro:MappingDefinition, p ) );
								var isArray = Context.unify( Context.resolveType( arg.type, p ), Context.resolveType( macro:Array<MappingDefinition>, p ) );
								

								if ( a.length == 0 )
								{
									//if ( isInstance ) a.push( macro  @:mergeBlock { var __injectInto__ = this.__map( [$i{arg.name}], Type.resolveClass( $v {Context.getLocalClass().toString()} ) ); } );
									//if ( isArray ) a.push( macro  @:mergeBlock { var __injectInto__ = this.__map( $i { arg.name }, Type.resolveClass( $v { Context.getLocalClass().toString() } ) ); } );
									if ( isInstance ) a.push( macro  @:mergeBlock { var __injectInto__ = this.__map( [$i{arg.name}], $localClass ); } );
									if ( isArray ) a.push( macro  @:mergeBlock { var __injectInto__ = this.__map( $i{arg.name}, $localClass ); } );
								}
								else
								{
									//if ( isInstance ) a.push( macro  @:mergeBlock { __injectInto__ = this.__map( [$i{arg.name}], Type.resolveClass( $v {Context.getLocalClass().toString()} ), __injectInto__ ); } );
									//if ( isArray ) a.push( macro  @:mergeBlock { __injectInto__ = this.__map( $i { arg.name }, Type.resolveClass( $v { Context.getLocalClass().toString() } ), __injectInto__ ); } );
									if ( isInstance ) a.push( macro  @:mergeBlock { __injectInto__ = this.__map( [$i{arg.name}], $localClass, __injectInto__ ); } );
									if ( isArray ) a.push( macro  @:mergeBlock { __injectInto__ = this.__map( $i{arg.name}, $localClass, __injectInto__ ); } );
								}
							}
						}

						if ( a.length > 0 )
						{
							a.push( macro  @:mergeBlock { this.__injectInto( __injectInto__ ); } );

							var hasAfterMappingMeta = false;
							function findAfterMappingMeta( e )
							{
								switch( e.expr )
								{
									case EMeta( s, exp ) if ( s.name == _afterMapping ):
										hasAfterMappingMeta = hasAfterMappingMeta || true;
										//Append
										a.push( exp );
										e.expr = (macro @:mergeBlock $b{a}).expr;
									case _:
										//trace( new haxe.macro.Printer().printExpr( e ) );
										ExprTools.iter( e, findAfterMappingMeta );
								}
							};
							ExprTools.iter( func.expr, findAfterMappingMeta );

							//Append at the end if @AfterMapping not found
							if( !hasAfterMappingMeta )
							{
								func.expr.expr = switch( func.expr.expr )
								{
									case EBlock( exprs ): EBlock( exprs.concat( a ) );
									case _: EBlock( a );
								}
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
				return { type: TinkHelper.fcqn( t ), name: varName != '_'? varName : '' };

			case [ _ => ( macro var $varName: $t ),  _ => macro $e ]:
				return { type: TinkHelper.fcqn( t ), name: $v{ ExprTools.getValue( AnnotationReplaceBuilder.processParam( e ) ) } };

			case _: Context.error( 'Invalid Dependency description', meta.pos );
		}
		return null;
	}
	
	public static function getDependency( className : String ) : Array<String>
	{
		return MappingChecker._dependencies.get( className );
	}
	
	public static function matchForClassName<T>( className : String, mappings : Array<MappingDefinition> ) : Bool
	{
		var dependencies = MappingChecker._dependencies.get( className );
		var filtered = mappings.filter( function(e) return dependencies.indexOf( e.fromType | e.withName ) != -1 );
		return filtered.length == mappings.length && dependencies.length == mappings.length;
	}
	
	public static function getMissingMapping<T>( className : String, mappings : Array<MappingDefinition> ) : Array<String>
	{
		var dependencies = MappingChecker._dependencies.get( className );
		var result = [];
		
		for ( dep in dependencies )
		{
			if ( !Lambda.exists( mappings, function(e) return e.fromType | e.withName == dep ) ) 
			{
				result.push( dep );
			}
		}
		
		return result;
	}
#end

	public static function filter<T>( classReference : Dynamic, mappings : Array<MappingDefinition> ) : Array<MappingDefinition>
	{
		var dependencies : Array<String> = classReference.__DEP__;
		return mappings.filter( function(e) return dependencies.indexOf( e.fromType | e.withName ) != -1 );
	}
	
	public static function match<T>( classReference : Dynamic, mappings : Array<MappingDefinition> ) : Bool
	{
		var dependencies : Array<String> = classReference.__DEP__;
		var filtered = mappings.filter( function(e) return dependencies.indexOf( e.fromType | e.withName ) != -1 );
		return filtered.length == mappings.length && dependencies.length == mappings.length;
	}
}
