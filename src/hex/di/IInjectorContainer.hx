package hex.di;

/**
 * @author Francis Bourre
 */
#if !macro
@:remove
//@:autoBuild( hex.di.annotation.AnnotationReader.readMetadata( hex.di.IInjectorContainer ) )
@:autoBuild( hex.di.annotation.FastAnnotationReader.readMetadata( hex.di.IInjectorContainer ) )
#end
interface IInjectorContainer
{
	
}