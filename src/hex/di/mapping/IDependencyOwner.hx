package hex.di.mapping;

/**
 * @author Francis Bourre
 */
#if !macro
@:autoBuild( hex.di.mapping.MappingChecker.check() )
#end
interface IDependencyOwner extends hex.di.IContextOwner
{
	
}