package hex.di;

import hex.di.reflect.FastClassDescriptionProviderTest;
import hex.di.util.InjectionUtilTest;

/**
 * ...
 * @author Francis Bourre
 */
class DISuite
{
	@Suite( "DI suite" )
    public var list : Array<Class<Dynamic>> = [ FastClassDescriptionProviderTest, InjectorTest, InjectionUtilTest ];
}