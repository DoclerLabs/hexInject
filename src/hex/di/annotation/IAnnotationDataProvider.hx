package hex.di.annotation;

import hex.di.annotation.InjectorClassVO;
/**
 * @author Francis Bourre
 */

interface IAnnotationDataProvider 
{
	function getClassAnnotationData( type : Class<Dynamic> ) : InjectorClassVO;
}