package hex.di;

import hex.di.mock.injectees.ClassInjectee;
import hex.di.mock.injectees.ComplexClassInjectee;
import hex.di.mock.injectees.MultipleSingletonsOfSameClassInjectee;
import hex.di.mock.injectees.NamedClassInjectee;
import hex.di.mock.injectees.NamedInterfaceInjectee;
import hex.di.mock.injectees.RecursiveInterfaceInjectee;
import hex.di.mock.injectees.SetterInjectee;
import hex.di.mock.injectees.StringInjectee;
import hex.di.mock.injectees.TwoNamedInterfaceFieldsInjectee;
import hex.di.mock.types.Clazz2;
import hex.di.mock.types.ComplexClazz;
import hex.di.mock.types.Interface;
import hex.di.mock.types.Clazz;
import hex.di.mock.injectees.InterfaceInjectee;
import hex.di.mock.types.Interface2;
import hex.unittest.assertion.Assert;

/**
 * ...
 * @author Francis Bourre
 */
class SpeedInjectorTest
{
    var injector 				: SpeedInjector;
    var receivedInjectorEvents 	: Array<Dynamic>;

    @Before
    public function runBeforeEachTest() : Void
    {
        this.injector 				= new SpeedInjector();
        this.receivedInjectorEvents = [];
    }

    @After
    public function teardown() : Void
    {
        SpeedInjector.purgeCache();
        this.injector 				= null;
        this.receivedInjectorEvents = null;
    }

   @Test( "Test 'unmap' remvoves existing mapping" )
    public function testUnmapRemovesExistingMapping() : Void
    {
        var injectee = new InterfaceInjectee();
        var value = new Clazz();
        this.injector.map( Interface ).toValue( value );
        Assert.isTrue( this.injector.satisfies( Interface ), "injector should satisifies mapped interface" );
        injector.unmap( Interface );
        Assert.isFalse( this.injector.satisfies( Interface ), "injector shouldn't satisfie mapped interface anymore" );
    }

    @Test( "Test 'mapToValue' with class parameter" )
    public function testMapToValueWithClassParameter() : Void
    {
        var injectee = new ClassInjectee();
        var injectee2 = new ClassInjectee();
        var value = new Clazz();
        this.injector.map( Clazz ).toValue( value );
        this.injector.injectInto( injectee );
        Assert.equals( value, injectee.property, "mapped value should have been injected" );
        this.injector.injectInto( injectee2 );
        Assert.equals( injectee.property, injectee2.property, "injected values should be the same" );
    }
	
	@Test( "Test 'mapToValue' with interface parameter" )
	public function testMapToValueWithInterfaceParameter() : Void
	{
		var injectee = new InterfaceInjectee();
		var value = new Clazz();
		this.injector.map( Interface ).toValue( value );
		this.injector.injectInto( injectee );
		Assert.equals( value, injectee.property, "value should have been injected" );
	}
	
	@Test( "Test 'mapToValue' with named class parameter" )
	public function testMapToValueWithNamedClassParameter() : Void
	{
		var injectee = new NamedClassInjectee();
		var value = new Clazz();
		this.injector.map( Clazz, NamedClassInjectee.NAME ).toValue( value );
		this.injector.injectInto( injectee );
		Assert.equals( value, injectee.property, "named value should have been injected" );
	}
	
	@Test( "Test 'mapToValue' with named interface parameter" )
	public function testMapToValueWithNamedInterfaceParameter() : Void
	{
		var injectee = new NamedInterfaceInjectee();
		var value = new Clazz();
		this.injector.map( Interface, NamedInterfaceInjectee.NAME ).toValue( value );
		this.injector.injectInto( injectee );
		Assert.equals( value, injectee.property, "named value should have been injected" );
	}
	
	@Test( "Test 'mapToValue' with empty String value" )
	public function testMapToValueWithEmptyStringValue() : Void
	{
		var injectee = new StringInjectee();
		var value : String = '';
		this.injector.map( String ).toValue( value );
		this.injector.injectInto( injectee );
		Assert.equals( value, injectee.property, "value should have been injected" );
	}
	
	@Test( "Test mapped value is not injected into recursively" )
	public function testMappedValueIsNotInjectedIntoRecursively() : Void
	{
		var injectee = new RecursiveInterfaceInjectee();
		var value = new InterfaceInjectee();
		this.injector.map( InterfaceInjectee ).toValue( value );
		this.injector.injectInto( injectee );
		Assert.isNull( value.property, "value shouldn't have been injected into" );
	}
	
	@Test( "Test map multiple interfacs to one singleton class" )
	public function testMapMultipleInterfacesToOneSingletonClass() : Void
	{
		var injectee = new MultipleSingletonsOfSameClassInjectee();
		this.injector.map( Interface ).toSingleton( Clazz );
		this.injector.map( Interface2 ).toSingleton( Clazz );
		this.injector.injectInto( injectee );
		Assert.isNotNull( injectee.property1, "singleton Value for 'property1' should have been injected" );
		Assert.isNotNull( injectee.property2, "singleton Value for 'property2' should have been injected" );
		Assert.notEquals( injectee.property1, injectee.property2, "singleton Values 'property1' and 'property2' should not be identical" );
	}
	
	@Test( "Test map class to type creates a new instance" )
	public function testMapClassToTypeCreatesNewInstance() : Void
	{
		var injectee 	= new ClassInjectee();
		var injectee2 	= new ClassInjectee();
		this.injector.map( Clazz ).toType( Clazz );
		this.injector.injectInto( injectee );
		Assert.isNotNull( injectee.property, "Instance of Class should have been injected" );
		this.injector.injectInto( injectee2 );
		Assert.notEquals( injectee.property, injectee2.property, "Injected values should be different" );
	}
	
	@Test( "Test map class to type produce new instances injected into" )
	public function testMapClassToTypeProduceNewInstancesInjectedInto() : Void
	{
		var injectee = new ComplexClassInjectee();
		var value = new Clazz();
		this.injector.map( Clazz ).toValue( value );
		this.injector.map( ComplexClazz ).toType( ComplexClazz );
		this.injector.injectInto( injectee );
		Assert.isNotNull( injectee.property, "Complex Value should have been injected" );
		Assert.equals( value, injectee.property.value, "Nested value should have been injected" );
	}
	
	//
	@Test( "Test map interface to type" )
	public function testMapInterfaceToType() : Void
	{
		var injectee = new InterfaceInjectee();
		this.injector.map( Interface ).toType( Clazz );
		this.injector.injectInto( injectee );
		Assert.isNotNull( injectee.property, "instance of Class should have been injected" );
	}
	
	@Test( "Test map class to type by name" )
	public function testMapClassToTypeByName() : Void
	{
		var injectee = new NamedClassInjectee();
		this.injector.map( Clazz, NamedClassInjectee.NAME ).toType( Clazz );
		this.injector.injectInto( injectee );
		Assert.isNotNull( injectee.property, "Instance of named Class should have been injected" );
	}
	
	@Test( "Test map interface to type by name" )
	public function testMapInterfaceToTypeByName() : Void
	{
		var injectee = new NamedInterfaceInjectee();
		this.injector.map( Interface, NamedInterfaceInjectee.NAME ).toType( Clazz );
		this.injector.injectInto( injectee );
		Assert.isNotNull( injectee.property, "instance of named Class should have been injected" );
	}
	
	@Test( "Test map class to singleton provide unique instance" )
	public function mapClassToSingletonProvideUniqueInstance() : Void
	{
		var injectee 	= new ClassInjectee();
		var injectee2 	= new ClassInjectee();
		this.injector.map( Clazz ).toSingleton( Clazz );
		this.injector.injectInto( injectee );
		Assert.isNotNull( injectee.property, "instance of Class should have been injected" );
		this.injector.injectInto( injectee2 );
		Assert.equals( injectee.property, injectee2.property, "injected values should be the same" );
	}
	
	@Test( "Test map interface to singleton provide unique instance" )
	public function testMapInterfaceToSingletonProvideUniqueInstance() : Void
	{
		var injectee	= new InterfaceInjectee();
		var injectee2	= new InterfaceInjectee();
		this.injector.map( Interface ).toSingleton( Clazz );
		this.injector.injectInto( injectee );
		Assert.isNotNull( injectee.property, "instance of Class should have been injected" );
		this.injector.injectInto( injectee2 );
		Assert.equals( injectee.property, injectee2.property, "injected values should be equal" );
	}
	
	@Test( "Test map same interface with different names to different singletons provide different instances" )
	public function testMapSameInterfaceWithDifferentNamesToDifferentSingletonsProvideDifferentInstances() : Void
	{
		var injectee = new TwoNamedInterfaceFieldsInjectee();
		this.injector.map( Interface, 'Name1' ).toSingleton( Clazz );
		this.injector.map( Interface, 'Name2' ).toSingleton( Clazz2 );
		this.injector.injectInto( injectee );
		Assert.isInstanceOf( injectee.property1, Clazz, 'Property "property1" should be of type "Clazz"' );
		Assert.isInstanceOf( injectee.property2, Clazz2, 'Property "property2" should be of type "Clazz2"');
		Assert.notEquals( injectee.property1, injectee.property2, 'Properties "property1" and "property2" should have received different singletons' );
	}
	
	/*@Test( "Test setter injection fulfills dependency" )
	public function testSetterInjectionFulfillsDependency() : Void
	{
		var injectee 	= new SetterInjectee();
		var injectee2 	= new SetterInjectee();
		this.injector.map( Clazz ).toType( Clazz );
		this.injector.injectInto( injectee );
		Assert.isNotNull( injectee.property, "Instance of Class should have been injected" );
		this.injector.injectInto( injectee2 );
		Assert.notEquals( injectee.property, injectee2.property, "Injected values should be different" );
	}*/
}
