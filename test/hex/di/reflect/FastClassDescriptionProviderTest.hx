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
		var description = provider.getClassDescription( MockClassInjectee );
		Assert.isNotNull( description, "description should not be null" );
	}
	
	@Test( "Test getClassDescription with null parameter" )
	public function testGetClassDescriptionWithNullParameter() : Void
	{
		var provider = new FastClassDescriptionProvider();
		Assert.methodCallThrows( NullPointerException, provider, provider.getClassDescription, [null], "'getClassDescription' should throw 'NullPointerException' when called with null argument" );
	}
}