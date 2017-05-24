package hex.di.mapping;

/**
 * @author Francis Bourre
 */
#if !macro
@:remove
@:autoBuild( hex.di.mapping.MappingChecker.check() )
#end
interface IDependencyOwner extends hex.di.IContextOwner
{
	
}