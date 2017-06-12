package hex.di;

import hex.di.mapping.DependencyOwnerTest;
import hex.di.mapping.MappingConfigurationTest;
import hex.di.util.InjectionUtilTest;

/**
 * ...
 * @author Francis Bourre
 */
class DISuite
{
	@Suite( "DI suite" )
    public var list : Array<Class<Dynamic>> = [ InjectorTest, InjectionUtilTest, MappingConfigurationTest, DependencyOwnerTest ];
}