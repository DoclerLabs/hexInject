package hex.di.annotation.mock;

/**
 * @author Francis Bourre
 */
#if !macro
@:remove
@:autoBuild( hex.di.annotation.AnnotationReader.readMetadata( hex.di.IMockInjectorContainer ) )
#end
interface IMockInjectorContainer
{
	
}