package hex.di;

import hex.di.reflect.FastClassDescriptionProviderTest;

/**
 * ...
 * @author Francis Bourre
 */
class DISuite
{
	@Suite( "DI suite" )
    public var list : Array<Class<Dynamic>> = [ FastClassDescriptionProviderTest, /*FastInjectorTest,*/ InjectorTest ];
}