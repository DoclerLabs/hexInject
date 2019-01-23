package hex.di.util;

import haxe.macro.Context;
import haxe.macro.Expr;
import hex.di.Dependency;
import hex.di.IDependencyInjector;
import hex.di.Injector;
import hex.error.PrivateConstructorException;
import hex.util.MacroUtil;

using haxe.macro.Tools;
using hex.error.Error;

/**
 * ...
 * @author Francis Bourre
 */
class InjectorUtil 
{
	/** @private */ function new() throw new PrivateConstructorException();
	
	macro public static function getDependencyInstance<T>( 	injector : ExprOf<IDependencyInjector>, 
															clazz : ExprOf<Dependency<T>>
														) : Expr
	{
		var classReference = InjectorUtil._getStringClassRepresentation( clazz );
		return macro { $injector.getInstanceWithClassName( $v{ classReference } ); };
	}
	
	macro public static function mapDependency<T>( 	injector : ExprOf<Injector>, 
													clazz : ExprOf<Dependency<T>>, 
													?id : ExprOf<String>
												) : Expr
	{	
		var classReference = InjectorUtil._getStringClassRepresentation( clazz );
		return macro { $injector.mapClassName( $v{ classReference }, $id ); };
	}
	
	macro public static function mapDependencyToValue<T>( 	injector : ExprOf<IDependencyInjector>, 
															clazz : ExprOf<Dependency<T>>, 
															value : ExprOf<T>,
															?id : ExprOf<String>
														) : Expr
	{	
		var classReference = InjectorUtil._getStringClassRepresentation( clazz );
		MacroUtil.assertValueMatching( classReference, value, clazz.pos );
		return macro { $injector.mapClassNameToValue( $v{ classReference }, $value, $id ); };
	}
	
	macro public static function mapDependencyToType<T>( 	injector : ExprOf<IDependencyInjector>, 
															clazz : ExprOf<Dependency<T>>, 
															type : ExprOf<Dependency<T>>,
															?id : ExprOf<String>
														) : Expr
	{
		var classReference 			= InjectorUtil._getStringClassRepresentation( clazz );
		var typeReference 			= InjectorUtil._getClassReference( type );
		MacroUtil.assertTypeMatching( classReference, InjectorUtil._getStringClassRepresentation( type ), clazz.pos );
		return macro { $injector.mapClassNameToType( $v{ classReference }, $typeReference, $id ); };
	}
	
	macro public static function mapDependencyToSingleton<T>( 	injector : ExprOf<IDependencyInjector>, 
																clazz : ExprOf<Dependency<T>>, 
																type : ExprOf<Dependency<T>>,
																?id : ExprOf<String>
															) : Expr
	{
		var classReference 			= InjectorUtil._getStringClassRepresentation( clazz );
		var typeReference 			= InjectorUtil._getClassReference( type );
		MacroUtil.assertTypeMatching( classReference, InjectorUtil._getStringClassRepresentation( type ), clazz.pos );
		return macro { $injector.mapClassNameToSingleton( $v{ classReference }, $typeReference, $id ); };
	}
	
	macro public static function unmapDependency<T>( 	injector : ExprOf<IDependencyInjector>, 
														clazz : ExprOf<Dependency<T>>, 
														?id : ExprOf<String>
													) : Expr
	{
		var classReference = InjectorUtil._getStringClassRepresentation( clazz );
		return macro { $injector.unmapClassName( $v{ classReference }, $id ); };
	}
	
	#if macro
	public static function _getStringClassRepresentation<T>( clazz : ExprOf<Dependency<T>> ) : String
	{
		switch( clazz.expr )
		{
			case ENew( t, params ):

				switch( t.params[ 0 ] )
				{
					case TPType( t ):
						
						return MacroUtil.getFQCNFromComplexType( t );
					
					case _:
				}
				
			case _:
		}
		
		Context.error( "Invalid dependency", clazz.pos );
		return null;
	}
	
	public static function _getClassReference<T>( clazz : ExprOf<Dependency<T>> ) : ExprOf<Class<T>>
	{
		switch( clazz.expr )
		{
			case ENew( t, params ):

				switch( t.params[ 0 ] )
				{
					case TPType( TPath( tp ) ):
						return macro $p { MacroUtil.getPack( MacroUtil.getClassFullQualifiedName( tp ) ) };
						
					case _:
				}
				
			case _:
		}
		
		Context.error( "Invalid dependency", clazz.pos );
		return macro null;
	}
	
	public static function _getComplexType<T>( clazz : ExprOf<Dependency<T>> ) : ComplexType
	{
		switch( clazz.expr )
		{
			case ENew( t, params ):

				switch( t.params[ 0 ] )
				{
					case TPType( t ):
						return t;
						
					case _:
				}
				
			case _:
		}
		
		return null;
	}
	#end
}