package hex.di.util;

import haxe.macro.Expr;
import hex.di.IDependencyInjector;

/**
 * ...
 * @author Francis Bourre
 */
class InjectionUtil 
{

	function new() 
	{
		
	}
	
	macro public static function map( injector : ExprOf<IDependencyInjector>, clazz : Expr ) : Expr
	{
		trace( clazz );
		return macro true;
	}
}