package hex.di;

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
		hex.di.util.InjectorUtilTest, 
		hex.di.mapping.MappingDefinitionTest, 
		hex.di.mapping.DependencyOwnerTest
	];
}