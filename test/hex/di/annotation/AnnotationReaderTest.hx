package hex.di.annotation;

import hex.di.annotation.mock.MockSpeedInjectorContainer;
import hex.unittest.assertion.Assert;

/**
 * ...
 * @author Francis Bourre
 */
class AnnotationReaderTest
{
	static var _annotationProvider : IAnnotationDataProvider;

    @BeforeClass
    public static function beforeClass() : Void
    {
        AnnotationReaderTest._annotationProvider = new AnnotationDataProvider( ISpeedInjectorContainer );
    }

    @AfterClass
    public static function afterClass() : Void
    {
        AnnotationReaderTest._annotationProvider = null;
    }

    @Test( "test get annotation data with class name" )
    public function testGetAnnotationDataWithClassName() : Void
    {
        Assert.isNotNull( AnnotationReaderTest._annotationProvider, "annotation data map shouldn't be null" );
        Assert.isNotNull( AnnotationReaderTest._annotationProvider.getClassAnnotationData( MockSpeedInjectorContainer ), "'MockSpeedInjectorContainer' class should be referenced" );

        var data : InjectorClassVO = AnnotationReaderTest._annotationProvider.getClassAnnotationData( MockSpeedInjectorContainer );
        Assert.equals( Type.getClassName( MockSpeedInjectorContainer ), data.name, "class name should be the same" );
    }
	
	@Test( "test get property annotation" )
    public function testGetPropertyAnnotation() : Void
    {
		var data : InjectorClassVO = AnnotationReaderTest._annotationProvider.getClassAnnotationData( MockSpeedInjectorContainer );
		trace( data.props );
	}
	
}