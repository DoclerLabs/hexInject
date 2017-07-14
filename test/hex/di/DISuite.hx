package hex.di;

import hex.di.mapping.DependencyOwnerTest;
import hex.di.mapping.MappingConfigurationTest;
import hex.di.mapping.MappingDefinitionTest;
import hex.di.util.InjectorUtilTest;

/**
 * ...
 * @author Francis Bourre
 */
class DISuite
{
	@Suite( "DI suite" )
    public var list : Array<Class<Dynamic>> = 
	[ 
		InjectorTest, 
		InjectorUtilTest, 
		MappingConfigurationTest, 
		MappingDefinitionTest, 
		DependencyOwnerTest 
	];
}