package hex.di.reflect;

import hex.error.NullPointerException;
import hex.unittest.assertion.Assert;

/**
 * ...
 * @author Francis Bourre
 */
class FastClassDescriptionProviderTest
{
	@Test( "Test getClassDescription" )
	public function testGetClassDescription() : Void
	{
		var provider 	= new FastClassDescriptionProvider();
		var description = provider.getClassDescription( MockClass );
		Assert.equals( MockClass.__INJECTION_DATA, description, "description should be the same" );
	}
	
	@Test( "Test getClassDescription with null parameter" )
	public function testGetClassDescriptionWithNullParameter() : Void
	{
		var provider = new FastClassDescriptionProvider();
		Assert.methodCallThrows( NullPointerException, provider, provider.getClassDescription, [null], "'getClassDescription' should throw 'NullPointerException' when called with null argument" );
	}
	
}

private class MockClass
{
	static public var __INJECTION_DATA : ClassDescription = { constructorInjection: { methodName: "", args: [] }, properties: [], methods: [], postConstruct: [], preDestroy: [] };
}