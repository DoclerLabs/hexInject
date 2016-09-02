package hex.di.annotation;

import hex.di.annotation.mock.IMockInjectorContainer;
import hex.di.annotation.mock.MockInjectorContainer;
import hex.domain.Domain;
import hex.log.ILogger;
import hex.unittest.assertion.Assert;

/**
 * ...
 * @author Francis Bourre
 */
class AnnotationDataProviderTest
{
	static var _annotationProvider : IAnnotationDataProvider;

    @BeforeClass
    public static function beforeClass() : Void
    {
        AnnotationDataProviderTest._annotationProvider = new AnnotationDataProvider( "__INJECTION_DATA" );
    }

    @AfterClass
    public static function afterClass() : Void
    {
        AnnotationDataProviderTest._annotationProvider = null;
    }

    @Test( "test get annotation data with class name" )
    public function testGetAnnotationDataWithClassName() : Void
    {
        Assert.isNotNull( AnnotationDataProviderTest._annotationProvider, "annotation data map shouldn't be null" );
        Assert.isNotNull( AnnotationDataProviderTest._annotationProvider.getClassAnnotationData( MockInjectorContainer ), "'MockInjectorContainer' class should be referenced" );

        var data : InjectorClassVO = AnnotationDataProviderTest._annotationProvider.getClassAnnotationData( MockInjectorContainer );
        Assert.equals( Type.getClassName( MockInjectorContainer ), data.name, "class name should be the same" );
    }
	
	@Test( "test get property annotation" )
    public function testGetPropertyAnnotation() : Void
    {
		var data : InjectorClassVO = AnnotationDataProviderTest._annotationProvider.getClassAnnotationData( MockInjectorContainer );
		
		var property0 = data.props[ 0 ];
		Assert.isFalse( property0.isOpt, "'isOpt' should equal false" );
		Assert.equals( "property0", property0.name, "name should be 'property0'" );
		Assert.equals( Type.getClassName( ILogger ), property0.type, "type should be 'ILogger'" );
		Assert.equals( "name0", property0.key, "key should be 'name0'" );
		
		var property1 = data.props[ 1 ];
		Assert.isFalse( property1.isOpt, "'isOpt' should equal false" );
		Assert.equals( "property1", property1.name, "name should be 'property1'" );
		Assert.equals( Type.getClassName( Domain ), property1.type, "type should be 'Domain'" );
		Assert.equals( "", property1.key, "key should be empty String" );
		
		var property2 = data.props[ 2 ];
		Assert.isTrue( property2.isOpt, "'isOpt' should equal true" );
		Assert.equals( "property2", property2.name, "name should be 'property2'" );
		Assert.equals( Type.getClassName( String ), property2.type, "type should be 'String'" );
		Assert.equals( "name2", property2.key, "key should be 'name2'" );
	}
	
	@Test( "test get constructor annotation" )
    public function testGetConstructorAnnotation() : Void
    {
		var data : InjectorClassVO = AnnotationDataProviderTest._annotationProvider.getClassAnnotationData( MockInjectorContainer );
		Assert.equals( "new", data.ctor.name, "constructor's name should be 'new'" );
		Assert.isFalse( data.ctor.isPost, "constructor can't be set to post constructor" );
		Assert.isFalse( data.ctor.isPre, "constructor can't be set to pre destroy" );
		Assert.equals( 0, data.ctor.order, "constructor order should always equal zero" );
		
		var arg0 = data.ctor.args[ 0 ];
		Assert.isFalse( arg0.isOpt, "'isOpt' should equal false" );
		Assert.equals( Type.getClassName( ILogger ), arg0.type, "type should be 'ILogger'" );
		Assert.equals( "name0", arg0.key, "key should be 'name0'" );
		
		var arg1 = data.ctor.args[ 1 ];
		Assert.isFalse( arg1.isOpt, "'isOpt' should equal false" );
		Assert.equals( Type.getClassName( Domain ), arg1.type, "type should be 'Domain'" );
		Assert.equals( "", arg1.key, "key should be empty String" );
		
		var arg2 = data.ctor.args[ 2 ];
		Assert.isTrue( arg2.isOpt, "'isOpt' should equal true" );
		Assert.equals( Type.getClassName( String ), arg2.type, "type should be 'String'" );
		Assert.equals( "name2", arg2.key, "key should be 'name2'" );
	}
	
	@Test( "test get method annotation" )
    public function testGetMethodAnnotation() : Void
    {
		var data : InjectorClassVO = AnnotationDataProviderTest._annotationProvider.getClassAnnotationData( MockInjectorContainer );
		
		//beforeInit
		var method0 = data.methods[ 0 ];
		Assert.equals( "beforeInit", method0.name, "method name should be the same" );
		Assert.isTrue( method0.isPost, "method should be a post constructor one" );
		Assert.isFalse( method0.isPre, "method should not be a pre destroy one" );
		Assert.equals( 2, method0.order, "method execution order should equal 2" );
		Assert.equals( 0, method0.args.length, "method args length should equal 0" );
		
		//preInit
		var method1 = data.methods[ 1 ];
		Assert.equals( "preInit", method1.name, "method name should be the same" );
		Assert.isTrue( method1.isPost, "method should be a post constructor" );
		Assert.isFalse( method1.isPre, "method should not be a pre destroy one" );
		Assert.equals( 0, method1.order, "method execution order should equal 0" );
		Assert.equals( 1, method1.args.length, "method args length should equal 1" );
		
		var arg0 = method1.args[ 0 ];
		Assert.isFalse( arg0.isOpt, "'isOpt' should equal false" );
		Assert.equals( Type.getClassName( Domain ), arg0.type, "type should be 'Domain'" );
		Assert.equals( "", arg0.key, "key should be empty String" );
		
		//init
		var method2 = data.methods[ 2 ];
		Assert.equals( "init", method2.name, "method name should be the same" );
		Assert.isTrue( method2.isPost, "method should be a post constructor" );
		Assert.isFalse( method2.isPre, "method should not be a pre destroy one" );
		Assert.equals( 1, method2.order, "method execution order should equal 1" );
		Assert.equals( 3, method2.args.length, "method args length should equal 3" );
		
		arg0 = method2.args[ 0 ];
		Assert.isFalse( arg0.isOpt, "'isOpt' should equal false" );
		Assert.equals( Type.getClassName( ILogger ), arg0.type, "type should be 'ILogger'" );
		Assert.equals( "name0", arg0.key, "key should be 'name0'" );
		
		var arg1 = method2.args[ 1 ];
		Assert.isFalse( arg1.isOpt, "'isOpt' should equal false" );
		Assert.equals( Type.getClassName( Domain ), arg1.type, "type should be 'Domain'" );
		Assert.equals( "", arg1.key, "key should be empty String" );
		
		var arg2 = method2.args[ 2 ];
		Assert.isTrue( arg2.isOpt, "'isOpt' should equal true" );
		Assert.equals( Type.getClassName( String ), arg2.type, "type should be 'String'" );
		Assert.equals( "name2", arg2.key, "key should be 'name2'" );
		
		//setLogger
		var method3 = data.methods[ 3 ];
		Assert.equals( "setLogger", method3.name, "method name should be the same" );
		Assert.isFalse( method3.isPre, "method should not be a pre destroy one" );
		Assert.isFalse( method3.isPost, "method should not be a post constructor" );
		Assert.equals( 0, method3.order, "method execution order should equal 0" );
		Assert.equals( 1, method3.args.length, "method args length should equal 1" );
		
		arg0 = method3.args[ 0 ];
		Assert.isFalse( arg0.isOpt, "'isOpt' should equal false" );
		Assert.equals( Type.getClassName( ILogger ), arg0.type, "type should be 'ILogger'" );
		Assert.equals( "", arg0.key, "key should be empty String" );
		
		//setDomain
		var method4 = data.methods[ 4 ];
		Assert.equals( "setDomain", method4.name, "method name should be the same" );
		Assert.isFalse( method4.isPost, "method should not be a post constructor" );
		Assert.isFalse( method4.isPre, "method should not be a pre destroy one" );
		Assert.equals( 0, method4.order, "method execution order should equal 0" );
		Assert.equals( 1, method4.args.length, "method args length should equal 1" );
		
		arg0 = method4.args[ 0 ];
		Assert.isFalse( arg0.isOpt, "'isOpt' should equal false" );
		Assert.equals( Type.getClassName( Domain ), arg0.type, "type should be 'domain'" );
		Assert.equals( "name", arg0.key, "key should equal 'name'" );
		
		//beforeDestroy
		var method5 = data.methods[ 5 ];
		Assert.equals( "beforeDestroy", method5.name, "method name should be the same" );
		Assert.isFalse( method5.isPost, "method should not be a post constructor one" );
		Assert.isTrue( method5.isPre, "method should be a pre destroy one" );
		Assert.equals( 2, method5.order, "method execution order should equal 2" );
		Assert.equals( 0, method5.args.length, "method args length should equal 0" );
		
		//preDestroy
		var method6 = data.methods[ 6 ];
		Assert.equals( "preDestroy", method6.name, "method name should be the same" );
		Assert.isFalse( method5.isPost, "method should not be a post constructor one" );
		Assert.isTrue( method5.isPre, "method should be a pre destroy one" );
		Assert.equals( 1, method6.order, "method execution order should equal 1" );
		Assert.equals( 1, method6.args.length, "method args length should equal 1" );
		
		arg0 = method6.args[ 0 ];
		Assert.isFalse( arg0.isOpt, "'isOpt' should equal false" );
		Assert.equals( Type.getClassName( Domain ), arg0.type, "type should be 'Domain'" );
		Assert.equals( "", arg0.key, "key should be empty String" );
		
		//destroy
		var method7 = data.methods[ 7 ];
		Assert.equals( "destroy", method7.name, "method name should be the same" );
		Assert.isFalse( method5.isPost, "method should not be a post constructor one" );
		Assert.isTrue( method5.isPre, "method should be a pre destroy one" );
		Assert.equals( 0, method7.order, "method execution order should equal 0" );
		Assert.equals( 3, method7.args.length, "method args length should equal 3" );
		
		arg0 = method7.args[ 0 ];
		Assert.isFalse( arg0.isOpt, "'isOpt' should equal false" );
		Assert.equals( Type.getClassName( ILogger ), arg0.type, "type should be 'ILogger'" );
		Assert.equals( "name0", arg0.key, "key should be 'name0'" );
		
		arg1 = method7.args[ 1 ];
		Assert.isFalse( arg1.isOpt, "'isOpt' should equal false" );
		Assert.equals( Type.getClassName( Domain ), arg1.type, "type should be 'Domain'" );
		Assert.equals( "", arg1.key, "key should be empty String" );
		
		arg2 = method7.args[ 2 ];
		Assert.isTrue( arg2.isOpt, "'isOpt' should equal true" );
		Assert.equals( Type.getClassName( String ), arg2.type, "type should be 'String'" );
		Assert.equals( "name2", arg2.key, "key should be 'name2'" );
		
		//testDestroy
		var method8 = data.methods[ 8 ];
		Assert.equals( "testDestroy", method8.name, "method name should be the same" );
		Assert.isFalse( method8.isPost, "method should not be a post constructor one" );
		Assert.isTrue( method8.isPre, "method should be a pre destroy one" );
		Assert.equals( 0, method8.order, "method execution order should equal 0" );
		Assert.equals( 0, method8.args.length, "method args length should equal 0" );
		
		//testConstruct
		var method9 = data.methods[ 9 ];
		Assert.equals( "testConstruct", method9.name, "method name should be the same" );
		Assert.isTrue( method9.isPost, "method should be a post constructor one" );
		Assert.isFalse( method9.isPre, "method should not be a pre destroy one" );
		Assert.equals( 0, method9.order, "method execution order should equal 0" );
		Assert.equals( 0, method9.args.length, "method args length should equal 0" );
	}
}