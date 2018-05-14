package hex.di;

import hex.di.error.MissingMappingException;
import hex.di.mock.injectees.ClassInjectee;
import hex.di.mock.injectees.ClassInjecteeWithAbstractProperty;
import hex.di.mock.injectees.ClassInjecteeWithBoolProperty;
import hex.di.mock.injectees.ClassInjecteeWithEnumProperty;
import hex.di.mock.injectees.ClassInjecteeWithTypedefProperty;
import hex.di.mock.injectees.Clazz;
import hex.di.mock.injectees.ComplexClassInjectee;
import hex.di.mock.injectees.ComplexClazz;
import hex.di.mock.injectees.FunctionParameterConstructorInjectee;
import hex.di.mock.injectees.InjectorInjectee;
import hex.di.mock.injectees.InterfaceInjectee;
import hex.di.mock.injectees.InterfaceInjecteeWithGeneric;
import hex.di.mock.injectees.InterfaceInjecteeWithIsLoggable;
import hex.di.mock.injectees.InterfaceInjecteeWithMethod;
import hex.di.mock.injectees.MixedParametersConstructorInjectee;
import hex.di.mock.injectees.MixedParametersMethodInjectee;
import hex.di.mock.injectees.MockLogger;
import hex.di.mock.injectees.MultipleSingletonsOfSameClassInjectee;
import hex.di.mock.injectees.NamedArrayCollectionInjectee;
import hex.di.mock.injectees.NamedClassInjectee;
import hex.di.mock.injectees.NamedClassInjecteeWithClassName;
import hex.di.mock.injectees.NamedInterfaceInjectee;
import hex.di.mock.injectees.OneNamedParameterConstructorInjectee;
import hex.di.mock.injectees.OneNamedParameterMethodInjectee;
import hex.di.mock.injectees.OneParameterConstructorInjectee;
import hex.di.mock.injectees.OneParameterMethodInjectee;
import hex.di.mock.injectees.OptionalClassInjectee;
import hex.di.mock.injectees.OptionalOneRequiredParameterMethodInjectee;
import hex.di.mock.injectees.OrderedPostConstructInjectee;
import hex.di.mock.injectees.PostConstructWithArgInjectee;
import hex.di.mock.injectees.RecursiveInterfaceInjectee;
import hex.di.mock.injectees.SetterInjectee;
import hex.di.mock.injectees.StringInjectee;
import hex.di.mock.injectees.TwoNamedInterfaceFieldsInjectee;
import hex.di.mock.injectees.TwoNamedParametersConstructorInjectee;
import hex.di.mock.injectees.TwoNamedParametersMethodInjectee;
import hex.di.mock.injectees.TwoParametersConstructorInjectee;
import hex.di.mock.injectees.TwoParametersConstructorInjecteeWithConstructorInjectedDependencies;
import hex.di.mock.injectees.TwoParametersConstructorInjecteeWithGeneric;
import hex.di.mock.injectees.TwoParametersMethodInjectee;
import hex.di.mock.injectees.TwoParametersMethodInjecteeWithGeneric;
import hex.di.mock.injectees.XMLInjectee;
import hex.di.mock.provider.MockDependencyProvider;
import hex.di.mock.types.Clazz2;
import hex.di.mock.types.ClazzWithGeneric;
import hex.di.mock.types.Interface;
import hex.di.mock.types.Interface2;
import hex.di.mock.types.MockEnum;
import hex.di.mock.types.MockTypedefImplementation;
import hex.error.NullPointerException;
import hex.log.ILogger;
import hex.structures.Point;
import hex.unittest.assertion.Assert;


/**
 * ...
 * @author Francis Bourre
 */
class InjectorTest implements IInjectorListener
{
    var injector 						: Injector;
    var injectorPreConstructArguments 	: Array<Dynamic>;
    var injectorPostConstructArguments 	: Array<Dynamic>;

    @Before
    public function runBeforeEachTest() : Void
    {
        this.injector = new Injector();
		this.injectorPreConstructArguments = [];
		this.injectorPostConstructArguments = [];
    }

    @Test( "Test 'unmap' remvoves existing mapping" )
    public function testUnmapRemovesExistingMapping() : Void
    {
        var value = new Clazz();
        this.injector.map( Interface ).toValue( value );
        Assert.isTrue( this.injector.satisfies( Interface ), "Injector should satisifies mapped interface" );
        injector.unmap( Interface );
        Assert.isFalse( this.injector.satisfies( Interface ), "Injector shouldn't satisfie mapped interface anymore" );
    }

	@Test( "Test conflict with IsLoggable and IInjectorContainer in interface" )
	public function testInterfaceInjecteeWithIsLoggable() : Void
	{
		var injectee = new InterfaceInjecteeWithIsLoggable();
		var value = new Clazz();
		this.injector.map( Interface ).toValue( value );
		var logger = new MockLogger();
		this.injector.map( ILogger ).toValue( logger );
		this.injector.injectInto( injectee );
		Assert.equals( value, injectee.property, "Mapped value should have been injected" );
		Assert.equals( logger, injectee.logger, "Mapped logger should have been injected" );
	}
	
	@Test( "Test conflict between IsLoggable and IInjectorContainer interface with inheritance" )
	public function testExtendedInjecteeWithIsLoggable() : Void
	{
		var injectee = new ExtendedInjecteeWithIsLoggable();
		var value = new Clazz();
		this.injector.map( Interface ).toValue( value );
		var logger = new MockLogger();
		this.injector.map( ILogger ).toValue( logger );
		this.injector.injectInto( injectee );
		Assert.equals( value, injectee.property, "Mapped value should have been injected" );
		Assert.equals( logger, injectee.logger, "Mapped logger should have been injected" );
	}
	
	@Test( "Test conflict between IsLoggable (implemented twice) and IInjectorContainer interface with inheritance" )
	public function testExtendsAndImplementsIsLoggableTwice() : Void
	{
		var injectee = new ExtendsAndImplementsIsLoggable();
		var value = new Clazz();
		this.injector.map( Interface ).toValue( value );
		var logger = new MockLogger();
		this.injector.map( ILogger ).toValue( logger );
		this.injector.injectInto( injectee );
		Assert.equals( value, injectee.property, "Mapped value should have been injected" );
		Assert.equals( logger, injectee.logger, "Mapped logger should have been injected" );
	}

    @Test( "Test 'mapToValue' with class parameter" )
    public function testMapToValueWithClassParameter() : Void
    {
        var injectee = new ClassInjectee();
        var injectee2 = new ClassInjectee();
        var value = new Clazz();
        this.injector.map( Clazz ).toValue( value );
        this.injector.injectInto( injectee );
        Assert.equals( value, injectee.property, "Mapped value should have been injected" );
        this.injector.injectInto( injectee2 );
        Assert.equals( injectee.property, injectee2.property, "Injected values should be the same" );
    }
	
	@Test( "Test 'mapToValue' with interface parameter" )
	public function testMapToValueWithInterfaceParameter() : Void
	{
		var injectee = new InterfaceInjectee();
		var value = new Clazz();
		this.injector.map( Interface ).toValue( value );
		this.injector.injectInto( injectee );
		Assert.equals( value, injectee.property, "Value should have been injected" );
	}
	
	@Test( "Test 'mapToValue' with interface fully qualified name parameter" )
	public function testMapToValueWithInterfaceFullyQualifiedNameParameter() : Void
	{
		var injectee = new InterfaceInjectee();
		var value = new Clazz();
		this.injector.mapClassName( "hex.di.mock.types.Interface" ).toValue( value );
		this.injector.injectInto( injectee );
		Assert.equals( value, injectee.property, "Value should have been injected" );
	}
	
	@Test( "Test 'mapToValue' with interface fully qualified name parameter and generic" )
	public function testMapToValueWithInterfaceFullyQualifiedNameParameterAndGeneric() : Void
	{
		var injectee = new InterfaceInjecteeWithGeneric();
		var s = new ClazzWithGeneric<String>();
		var i = new ClazzWithGeneric<Int>();
		var o = new ClazzWithGeneric<{}>();
		this.injector.mapClassName( "hex.di.mock.types.InterfaceWithGeneric<String>" ).toValue( s );
		this.injector.mapClassName( "hex.di.mock.types.InterfaceWithGeneric<Int>" ).toValue( i );
		this.injector.mapClassName( "hex.di.mock.types.InterfaceWithGeneric<{}>" ).toValue( o );
		this.injector.injectInto( injectee );
		Assert.equals( s, injectee.stringProperty, "Value should have been injected" );
		Assert.equals( i, injectee.intProperty, "Value should have been injected" );
	}
	
	@Test( "Test 'mapToValue' with interface fully qualified name parameter and method" )
	public function testMapToValueWithInterfaceFullyQualifiedNameParameterAndMethod() : Void
	{
		var injectee = new InterfaceInjecteeWithMethod();
		var f : String->Void = function ( s: String ) {};
		var f2 : String->Array<Int>->Bool = function ( s: String, a : Array<Int> ) : Bool { return true; };
		this.injector.mapClassName( "String->Void" ).toValue( f );
		this.injector.mapClassName( "String->Array<Int>->Bool" ).toValue( f2 );
		this.injector.injectInto( injectee );
		Assert.equals( f, injectee.methodWithStringArgument, "Value should have been injected" );
		Assert.equals( f2, injectee.methodWithMultipleArguments, "Value should have been injected" );
	}
	
	@Test( "Test 'mapClassNameToValue' with boolean value" )
	public function testMapToValueWithBoolean() : Void
	{
		var injectee = new ClassInjecteeWithBoolProperty();
		var b = true;
		this.injector.mapClassNameToValue( "Bool", b );
		this.injector.injectInto( injectee );
		Assert.isTrue( injectee.property, "Value should have been injected" );
	}
	
	@Test( "Test 'mapClassNameToValue' with abstract value" )
	public function testMapToValueWithAbstract() : Void
	{
		var injectee = new ClassInjecteeWithAbstractProperty();
		var p = new Point( 3, 4 );
		this.injector.mapClassNameToValue( "hex.structures.Point", p );
		this.injector.injectInto( injectee );
		Assert.equals( p, injectee.property, "Value should have been injected" );
	}
	
	@Test( "Test 'mapClassNameToValue' with enum value" )
	public function testMapToValueWithEnum() : Void
	{
		var injectee = new ClassInjecteeWithEnumProperty();
		var item = MockEnum.MockItemWithBool( true );
		this.injector.mapClassNameToValue( "hex.di.mock.types.MockEnum", item );
		this.injector.injectInto( injectee );
		Assert.equals( item, injectee.property, "Value should have been injected" );
	}
	
	@Test( "Test 'mapClassNameToValue' with typedef value" )
	public function testMapToValueWithTypedef() : Void
	{
		var injectee = new ClassInjecteeWithTypedefProperty();
		var item = new MockTypedefImplementation();
		this.injector.mapClassNameToValue( "hex.di.mock.types.MockTypedef", item );
		this.injector.injectInto( injectee );
		Assert.equals( item, injectee.property, "Value should have been injected" );
	}
	
	public static var testMapToValueWithNameDataProvider:Array<Dynamic> = [
		new NamedClassInjectee(),
		new NamedClassInjecteeConst(),
		new NamedClassInjecteeConstOutside(),
		new NamedClassInjecteeConstOutsideFQCN()
	];
	
	@Test( "Test 'mapToValue' with named class parameter" )
	@DataProvider("testMapToValueWithNameDataProvider")
	public function testMapToValueWithNamedClassParameter(injectee:Dynamic) : Void
	{
		var value = new Clazz();
		this.injector.map( Clazz, NamedClassInjectee.NAME ).toValue( value );
		this.injector.injectInto( injectee );
		Assert.equals( value, injectee.property, "Named value should have been injected" );
	}
	
	@Test( "Test 'mapToValue' with named interface parameter" )
	public function testMapToValueWithNamedInterfaceParameter() : Void
	{
		var injectee = new NamedInterfaceInjectee();
		var value = new Clazz();
		this.injector.map( Interface, NamedInterfaceInjectee.NAME ).toValue( value );
		this.injector.injectInto( injectee );
		Assert.equals( value, injectee.property, "Named value should have been injected" );
	}
	
	@Test( "Test 'mapToValue' with empty String value" )
	public function testMapToValueWithEmptyStringValue() : Void
	{
		var injectee = new StringInjectee();
		var value : String = '';
		this.injector.map( String ).toValue( value );
		this.injector.injectInto( injectee );
		Assert.equals( value, injectee.property, "Value should have been injected" );
	}
	
	@Test( "Test mapped value is not injected into recursively" )
	public function testMappedValueIsNotInjectedIntoRecursively() : Void
	{
		var injectee = new RecursiveInterfaceInjectee();
		var value = new InterfaceInjectee();
		this.injector.map( InterfaceInjectee ).toValue( value );
		this.injector.injectInto( injectee );
		Assert.isNull( value.property, "Value shouldn't have been injected into" );
	}
	
	@Test( "Test map multiple interfacs to one singleton class" )
	public function testMapMultipleInterfacesToOneSingletonClass() : Void
	{
		var injectee = new MultipleSingletonsOfSameClassInjectee();
		this.injector.map( Interface ).toSingleton( Clazz );
		this.injector.map( Interface2 ).toSingleton( Clazz );
		this.injector.injectInto( injectee );
		Assert.isNotNull( injectee.property1, "Singleton Value for 'property1' should have been injected" );
		Assert.isNotNull( injectee.property2, "Singleton Value for 'property2' should have been injected" );
		Assert.notEquals( injectee.property1, injectee.property2, "Singleton Values 'property1' and 'property2' should not be identical" );
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
	
	@Test( "Test map interface to type" )
	public function testMapInterfaceToType() : Void
	{
		var injectee = new InterfaceInjectee();
		this.injector.map( Interface ).toType( Clazz );
		this.injector.injectInto( injectee );
		Assert.isNotNull( injectee.property, "Instance of Class should have been injected" );
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
		Assert.isNotNull( injectee.property, "Instance of named Class should have been injected" );
	}
	
	@Test( "Test map class to singleton provide unique instance" )
	public function mapClassToSingletonProvideUniqueInstance() : Void
	{
		var injectee 	= new ClassInjectee();
		var injectee2 	= new ClassInjectee();
		this.injector.map( Clazz ).toSingleton( Clazz );
		this.injector.injectInto( injectee );
		Assert.isNotNull( injectee.property, "Instance of Class should have been injected" );
		this.injector.injectInto( injectee2 );
		Assert.equals( injectee.property, injectee2.property, "Injected values should be the same" );
	}
	
	@Test( "Test map interface to singleton provide unique instance" )
	public function testMapInterfaceToSingletonProvideUniqueInstance() : Void
	{
		var injectee	= new InterfaceInjectee();
		var injectee2	= new InterfaceInjectee();
		this.injector.map( Interface ).toSingleton( Clazz );
		this.injector.injectInto( injectee );
		Assert.isNotNull( injectee.property, "Instance of Class should have been injected" );
		this.injector.injectInto( injectee2 );
		Assert.equals( injectee.property, injectee2.property, "Injected values should be equal" );
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
	
	@Ignore( "Test setter injection fulfills dependency" )
	public function testSetterInjectionFulfillsDependency() : Void
	{
		var injectee 	= new SetterInjectee();
		var injectee2 	= new SetterInjectee();
		this.injector.map( Clazz ).toType( Clazz );
		this.injector.injectInto( injectee );
		Assert.isNotNull( injectee.property, "Instance of Class should have been injected" );
		this.injector.injectInto( injectee2 );
		Assert.notEquals( injectee.property, injectee2.property, "Injected values should be different" );
	}
	
	@Test( "Test one parameter method injection" )
	public function testOneParameterMethodInjection() : Void
	{
		var injectee 	= new OneParameterMethodInjectee();
		var injectee2 	= new OneParameterMethodInjectee();
		this.injector.map( Clazz ).toType( Clazz );
		this.injector.injectInto( injectee );
		Assert.isNotNull( injectee.getDependency(),"Instance of Class should have been injected" );
		this.injector.injectInto( injectee2 );
		Assert.notEquals( injectee.getDependency(), injectee2.getDependency(),"Injected values should be different" );
	}
	
	@Test( "Test one named parameter method injection" )
	public function testOneNamedParameterMethodInjection() : Void
	{
		var injectee = new OneNamedParameterMethodInjectee();
		var injectee2 = new OneNamedParameterMethodInjectee();
		this.injector.map( Clazz, 'namedDep' ).toType( Clazz );
		this.injector.injectInto( injectee );
		Assert.isNotNull( injectee.getDependency(), "Instance of Class should have been injected for named Clazz parameter" );
		this.injector.injectInto( injectee2 );
		Assert.notEquals( injectee.getDependency(), injectee2.getDependency(), "Injected values should be different" );
	}
	
	@Test( "Test two parameters method injection" )
	public function testTwoParametersMethodInjection() : Void
	{
		var injectee = new TwoParametersMethodInjectee();
		var injectee2 = new TwoParametersMethodInjectee();
		this.injector.map( Clazz ).toType( Clazz );
		this.injector.map( Interface ).toType( Clazz );
		this.injector.injectInto( injectee );
		Assert.isNotNull( injectee.getDependency(), "Instance of Class should have been injected for unnamed Clazz parameter" );
		Assert.isNotNull( injectee.getDependency2(), "Instance of Class should have been injected for unnamed Interface parameter" );
		this.injector.injectInto( injectee2 );
		Assert.notEquals( injectee.getDependency(), injectee2.getDependency(), "Injected values should be different" );
		Assert.notEquals( injectee.getDependency2(), injectee2.getDependency2(), "Injected values for Interface should be different" );
	}
	
	@Test( "Test two parameters method injection with generic" )
	public function testTwoParametersMethodInjectionWithGeneric() : Void
	{
		var injectee = new TwoParametersMethodInjecteeWithGeneric();
		var injectee2 = new TwoParametersMethodInjecteeWithGeneric();
		this.injector.mapClassName( "hex.di.mock.types.ClazzWithGeneric<String>" ).toType( ClazzWithGeneric );
		this.injector.mapClassName( "hex.di.mock.types.InterfaceWithGeneric<Int>" ).toType( ClazzWithGeneric );
		this.injector.injectInto( injectee );
		Assert.isNotNull( injectee.getDependency(), "Instance of ClazzWithGeneric should have been injected for 1st parameter" );
		Assert.isNotNull( injectee.getDependency2(), "Instance of ClazzWithGeneric should have been injected for 2nd parameter" );
		this.injector.injectInto( injectee2 );
		Assert.notEquals( injectee.getDependency(), injectee2.getDependency(), "Injected values should be different" );
		Assert.notEquals( injectee.getDependency2(), injectee2.getDependency2(), "Injected values for Interface should be different" );
	}
	
	@Test( "Test two named parameters method injection" )
	public function testTwoNamedParametersMethodInjection() : Void
	{
		var injectee = new TwoNamedParametersMethodInjectee();
		var injectee2 = new TwoNamedParametersMethodInjectee();
		this.injector.map( Clazz, 'namedDep' ).toType( Clazz );
		this.injector.map( Interface, 'namedDep2' ).toType( Clazz );
		this.injector.injectInto( injectee );
		Assert.isNotNull( injectee.getDependency(), "Instance of Class should have been injected for named Clazz parameter" );
		Assert.isNotNull( injectee.getDependency2(), "Instance of Class should have been injected for named Interface parameter" );
		this.injector.injectInto( injectee2 );
		Assert.notEquals( injectee.getDependency(), injectee2.getDependency(), "Injected values should be different" );
		Assert.notEquals( injectee.getDependency2(), injectee2.getDependency2(), "Injected values for Interface should be different" );
	}
	
	@Test( "Test named and unnamed parameters method injection" )
	public function testNamedAndUnnamedParametersMethodInjection() : Void
	{
		var injectee = new MixedParametersMethodInjectee();
		var injectee2 = new MixedParametersMethodInjectee();
		this.injector.map( Clazz, 'namedDep' ).toType( Clazz );
		this.injector.map( Clazz ).toType( Clazz );
		this.injector.map( Interface, 'namedDep2' ).toType( Clazz );
		this.injector.injectInto( injectee );
		Assert.isNotNull( injectee.getDependency(), "Instance of Class should have been injected for named Clazz parameter" );
		Assert.isNotNull( injectee.getDependency2(), "Instance of Class should have been injected for unnamed Clazz parameter" );
		Assert.isNotNull( injectee.getDependency3(), "Instance of Class should have been injected for Interface" );
		this.injector.injectInto( injectee2 );
		Assert.notEquals( injectee.getDependency(), injectee2.getDependency(), "Injected values for named Clazz should be different" );
		Assert.notEquals( injectee.getDependency2(), injectee2.getDependency2(), "Injected values for unnamed Clazz should be different" );
		Assert.notEquals( injectee.getDependency3(), injectee2.getDependency3(), "Injected values for named Interface should be different" );
	}
	
	#if debug
	@Test( "Test get mapping result without provider throws an exception" )
	public function testGetMappingResultWithoutProviderThrowsAnException() : Void
	{
		this.injector.map( Clazz );
		Assert.methodCallThrows( NullPointerException, this.injector, this.injector.instantiateUnmapped, [ null ], "" );
	}
	#end
	
	@Test( "Test one parameter constructor injection" )
	public function testOneParameterConstructorInjection() : Void
	{
		this.injector.map( Clazz ).toType( Clazz );
		var injectee = this.injector.instantiateUnmapped( OneParameterConstructorInjectee );
		Assert.isNotNull( injectee.getDependency(), "Instance of Class should have been injected for Clazz parameter" );
	}
	
	@Test( "Test two parameters constructor injection" )
	public function testTwoParametersConstructorInjection() : Void
	{
		this.injector.map( Clazz ).toType( Clazz );
		this.injector.map( String ).toValue( 'stringDependency' );
		var injectee = injector.instantiateUnmapped( TwoParametersConstructorInjectee );
		Assert.isNotNull( injectee.getDependency(), "Instance of Class should have been injected for named Clazz parameter" );
		Assert.equals( 'stringDependency', injectee.getDependency2(), "The String 'stringDependency' should have been injected for String parameter" );
	}
	
	@Test( "Test two parameters constructor injection with generic" )
	public function testTwoParametersConstructorInjectionWithGeneric() : Void
	{
		this.injector.mapClassName( "hex.di.mock.types.ClazzWithGeneric<String>" ).toType( ClazzWithGeneric );
		var value = new ClazzWithGeneric<Int>();
		this.injector.mapClassName( "hex.di.mock.types.InterfaceWithGeneric<Int>" ).toValue( value );
		var injectee = injector.instantiateUnmapped( TwoParametersConstructorInjecteeWithGeneric );
		Assert.isNotNull( injectee.getDependency(), "Instance of 'ClazzWithGeneric' should have been injected for 1st parameter" );
		Assert.equals( value, injectee.getDependency2(), "'value' should have been injected for 2nd parameter" );
	}
	
	@Test( "Test one named parameter constructor injection" )
	public function testOneNamedParameterConstructorInjection() : Void
	{
		this.injector.map( Clazz, 'namedDependency' ).toType( Clazz );
		var injectee = this.injector.instantiateUnmapped( OneNamedParameterConstructorInjectee );
		Assert.isNotNull( injectee.getDependency(), "Instance of Class should have been injected for named Clazz parameter" );
	}
	
	@Test( "Test two named parameters constructor injection" )
	public function testTwoNamedParametersConstructorInjection() : Void
	{
		this.injector.map( Clazz, 'namedDependency' ).toType( Clazz );
		this.injector.map( String, 'namedDependency2' ).toValue( 'stringDependency' );
		var injectee = injector.instantiateUnmapped( TwoNamedParametersConstructorInjectee );
		Assert.isNotNull( injectee.getDependency(), "Instance of Class should have been injected for named Clazz parameter" );
		Assert.equals( injectee.getDependency2(), 'stringDependency', "The String 'stringDependency' should have been injected for named String parameter" );
	}
	
	public static var namedAndUnnamedParametersConstructorDataProvider:Array<Class<Dynamic>> = [
		MixedParametersConstructorInjectee,
		MixedParametersConstructorInjecteeConst,
		MixedParametersConstructorInjecteeConstOutside,
		MixedParametersConstructorInjecteeConstOutsideFQCN
	];
	
	@Test( "Test named and unnamed parameters constructor injection" )
	@DataProvider("namedAndUnnamedParametersConstructorDataProvider")
	public function testNamedAndUnnamedParametersConstructorInjection(clss:Class<Dynamic>) : Void
	{
		this.injector.map( Clazz, 'namedDep' ).toType( Clazz );
		this.injector.map( Clazz ).toType( Clazz );
		this.injector.map( Interface, 'namedDep2' ).toType( Clazz );
		var injectee = this.injector.instantiateUnmapped( clss );
		Assert.isNotNull( injectee.getDependency(), "Instance of Class should have been injected for named Clazz parameter" );
		Assert.isNotNull( injectee.getDependency2(), "Instance of Class should have been injected for unnamed Clazz parameter" );
		Assert.isNotNull( injectee.getDependency3(), "Instance of Class should have been injected for Interface" );
	}
	
	@Test( "Test named Array injection" )
	public function testNamedArrayInjection() : Void
	{
		var ac = new Array<Dynamic>();
		this.injector.mapClassName( "Array<Dynamic>", "namedCollection" ).toValue( ac );
		var injectee = injector.instantiateUnmapped( NamedArrayCollectionInjectee );
		Assert.isNotNull( injectee.ac, "Instance 'ac' should have been injected for named ArrayCollection parameter" );
		Assert.equals( ac, injectee.ac, "Instance field 'ac' should be identical to local variable 'ac'" );
	}
	
	@Test( "Test inject Xml value" )
	public function testInjectXmlValue() : Void
	{
		var injectee = new XMLInjectee();
		var value : Xml = Xml.parse( "<test/>" );
		this.injector.map( Xml ).toValue( value );
		this.injector.injectInto( injectee );
		Assert.equals( value, injectee.property, 'injected value should be indentical to mapped value' );
	}
	
	@Test( "Test missing interface mapping throws an exception" )
	public function testMissingInterfaceMappingThrowsAnException() : Void
	{
		Assert.methodCallThrows( MissingMappingException, this.injector, this.injector.injectInto, [ new InterfaceInjectee() ], "'injectInto' should throw MissingMappingException" );
	}

	@Test( "Test missing class mapping throws an exception" )
	public function testMissingClassMappingThrowsAnException() : Void
	{
		var injectee = new ClassInjectee();
		Assert.methodCallThrows( MissingMappingException, this.injector, this.injector.injectInto, [ injectee ], "'injectInto' should throw InjectorMissingMappingError" );
	}
	
	@Test( "Test missing named class mapping throws an exception" )
	public function testMissingNamedClassMappingThrowsAnException() : Void
	{
		var injectee = new NamedClassInjectee();
		Assert.methodCallThrows( MissingMappingException, this.injector, this.injector.injectInto, [injectee], "'injectInto' should throw InjectorMissingMappingError" );
	}
	
	public static var postConstructDataProvider:Array<Dynamic> = [
		new ClassInjectee(),
		new ClassInjecteeWithConst(),
		new ClassInjecteeWithConstOutside(),
		new ClassInjecteeWithConstOutsideFQCN()
	];
	
	@Test( "Test postConstruct method is called" )
	@DataProvider("postConstructDataProvider")
	public function testPostConstructMethodIsCalled(injectee:Dynamic) : Void
	{
		var value = new Clazz();
		injector.map( Clazz ).toValue( value );
		injector.injectInto( injectee );
		Assert.isTrue( injectee.someProperty, "'postConstruct' tagged method should be called after class instantiation" );
	}
	
	@Test( "Test postConstruct method with arg is called" )
	public function testPostConstructMethodWithArgIsCalled() : Void
	{
		this.injector.map( Clazz ).toType( Clazz );
		var injectee : PostConstructWithArgInjectee = this.injector.instantiateUnmapped( PostConstructWithArgInjectee );
		Assert.isInstanceOf( injectee.property, Clazz, "'postConstruct' tagged method should be called with args after class instantiation" );
	}
	
	@Test( "Test postConstruct method with arg are called in the right order" )
	public function testPostConstructMethodAreCalledInTheRightOrder() : Void
	{
		var injectee = new OrderedPostConstructInjectee();
		injector.injectInto( injectee );
		Assert.deepEquals( [1,2,3,4], injectee.loadOrder, "'postConstruct' tagged method should be called with args after class instantiation in the right order" );
	}
	
	@Test( "Test 'satisfies' returns false for unmapped and unnamed interface" )
	public function testSatisfiesReturnsFalseForUnmappedAndUnnamedInterface() : Void
	{
		Assert.isFalse( this.injector.satisfies( Interface ), "'satisfies' should returns false with unmapped type" );
	}
	
	@Test( "Test 'satisfies' returns false for unmapped and unnamed class" )
	public function testSatisfiesReturnsFalseForUnmappedAndUnnamedClass() : Void
	{
		Assert.isFalse( this.injector.satisfies( Clazz ), "'satisfies' should returns false with unmapped type" );
	}
	
	@Test( "Test 'satisfies' returns false for unmapped and named class" )
	public function testSatisfiesReturnsFalseForUnmappedAndNamedClass() : Void
	{
		Assert.isFalse( this.injector.satisfies( Clazz, 'namedClass' ), "'satisfies' should returns false with unmapped type" );
	}
	
	@Test( "Test 'satisfies' returns true for mapped and unnamed class" )
	public function testSatisfiesReturnsTrueForMappedAndUnnamedClass() : Void
	{
		this.injector.map( Clazz ).toType( Clazz );
		Assert.isTrue( this.injector.satisfies( Clazz ), "'satisfies' should returns true with mapped type" );
	}
	
	@Test( "Test 'satisfies' returns true for mapped and named class" )
	public function testSatisfiesReturnsTrueForMappedAndNamedClass() : Void
	{
		this.injector.map( Clazz, 'namedClass' ).toType( Clazz );
		Assert.isTrue( this.injector.satisfies( Clazz, 'namedClass' ), "'satisfies' should returns true with mapped named type"  );
	}
	
	@Test( "Test 'getInstance' throws an error for unmapped class" )
	public function testGetInstanceThrowsAnErrorForUnmappedClass() : Void
	{
		Assert.methodCallThrows( MissingMappingException, this.injector, this.injector.getInstance, [ Clazz ], "'getInstance' should throw InjectorMissingMappingError" );
	}
	
	@Test( "Test 'instantiateUnmapped' works with unmapped class" )
	public function testInstantiateUnmappedWorksWithUnmappedClass() : Void
	{
		Assert.isInstanceOf( this.injector.instantiateUnmapped( Clazz ), Clazz, "'instantiateUnmapped' should work with unmapped types" );
	}
	
	@Test( "Test 'getInstance' throws an error for unmapped and named class" )
	public function testGetInstanceThrowsAnErrorForUnmappedAndNamedClass() : Void
	{
		Assert.methodCallThrows( MissingMappingException, this.injector, this.injector.getInstance, [ Clazz, 'namedClass' ], "'getInstance' should throw InjectorMissingMappingError" );
	}
	
	@Test( "Test 'getInstance' returns mapped value for mapped and unnamed class" )
	public function testGetInstanceReturnsMappedValueForMappedAndUnnamedClass() : Void
	{
		var clazz = new Clazz();
		this.injector.map( Clazz ).toValue( clazz );
		Assert.equals( this.injector.getInstance( Clazz ), clazz, "'getInstance' should return mapped value" );
	}
	
	@Test( "Test 'getInstance' returns mapped value for mapped and named class" )
	public function testGetInstanceReturnsMappedValueForMappedAndNamedClass() : Void
	{
		var clazz = new Clazz();
		this.injector.map( Clazz, 'namedClass' ).toValue( clazz );
		Assert.equals( this.injector.getInstance( Clazz, 'namedClass' ), clazz, "'getInstance' should return mapped named value" );
	}
	
	@Test( "Test map to singleton twice targets the same instance" )
	public function testMapToSingletonTwiceTargetsTheSameInstance() : Void
	{
		this.injector.map( Clazz ).toSingleton( Clazz );
		var injectee1 : ClassInjectee = injector.instantiateUnmapped( ClassInjectee );
		this.injector.map( Clazz ).toSingleton( Clazz );
		var injectee2 : ClassInjectee = injector.instantiateUnmapped( ClassInjectee );
		Assert.notEquals( injectee1.property, injectee2.property, 'injectee1.property is not the same instance as injectee2.property' );
	}
	
	@Test( "Test unmap singleton removes the singleton instance" )
	public function testUnmapSingletonRemovesTheSingletonInstance() : Void
	{
		this.injector.map( Clazz ).toSingleton( Clazz );
		var injectee1 : ClassInjectee = injector.instantiateUnmapped( ClassInjectee );
		this.injector.unmap( Clazz );
		this.injector.map( Clazz ).toSingleton( Clazz );
		var injectee2 : ClassInjectee = injector.instantiateUnmapped( ClassInjectee );
		Assert.notEquals( injectee1.property, injectee2.property, 'injectee1.property is not the same instance as injectee2.property' );
	}
	
	@Test
	public function testGetInstanceOnUmappedInterfaceThrowsException() : Void
	{
		Assert.methodCallThrows( MissingMappingException, this.injector, this.injector.getInstance, [ Interface ], "'getInstance' should throw MissingMappingException" );
	}
	
	public static var instantiateClassWithOptionalPropertyDataProvider:Array<Class<Dynamic>> = [
		OptionalClassInjectee,
		OptionalClassInjecteeConst,
		OptionalClassInjecteeConstOutside,
		OptionalClassInjecteeConstOutsideFQCN
	];
	
	@Test( "Test instantiate class with optional property" )
	@DataProvider("instantiateClassWithOptionalPropertyDataProvider")
	public function testInstantiateClassWithOptionalProperty(clss:Class<Dynamic>) : Void
	{
		var injectee = this.injector.instantiateUnmapped( clss );
		Assert.isNull( injectee.property, "Injectee mustn't contain Clazz instance" );
	}
	
	@Test( "Test instantiate class with optional method argument" )
	public function testInstantiateClassWithOptionalMethodArgument() : Void
	{
		var injectee = this.injector.instantiateUnmapped( OptionalOneRequiredParameterMethodInjectee );
		Assert.isNull( injectee.getDependency(), "Injectee mustn't contain Interface instance" );
	}
	
	@Test( "Test 'injectInto' triggers `onPreConstruct` and `onPostConstruct` callbacks" )
	public function testInjectIntoTriggersPreAndPostConstruct() : Void
	{
		this.injector.addListener( this );
		
		var injectee = new ClassInjectee();
		this.injector.map( Clazz ).toValue( new Clazz() );
		this.injector.injectInto( injectee );
		
		Assert.deepEquals( [ this.injector, injectee, ClassInjectee ], this.injectorPreConstructArguments  );
		Assert.deepEquals( [ this.injector, injectee, ClassInjectee ], this.injectorPostConstructArguments  );
	}
	
	public function onPreConstruct( target : IDependencyInjector, instance : Dynamic, instanceType : Class<Dynamic> ): Void
	{
		this.injectorPreConstructArguments =  [ target, instance, instanceType ];
	}
	
	public function onPostConstruct( target : IDependencyInjector, instance : Dynamic, instanceType : Class<Dynamic> ) : Void
	{
		this.injectorPostConstructArguments =  [ target, instance, instanceType ];
	}
	
	@Test( "Test unmap singleton provider invokes PreDestroy methods on singleton" )
	public function testUnmapSingletonProviderInvokesPredestroyMethodsOnSingleton() : Void
	{
		this.injector.map( Clazz ).toSingleton( Clazz );
		var singleton = this.injector.getInstance( Clazz );
		Assert.isFalse( singleton.preDestroyCalled, "singleton.preDestroyCalled should be false" );
		this.injector.unmap( Clazz );
		Assert.isTrue( singleton.preDestroyCalled, "singleton.preDestroyCalled should be true" );
	}
	
	@Test( "Test 'destroyIntance' invoke PreDestroy methods on instance" )
	public function testDestroyInstanceInvokesPredestroyMethodsOnInstance() : Void
	{
		var target = new Clazz();
		Assert.isFalse( target.preDestroyCalled, "target.preDestroyCalled should be false" );
		this.injector.destroyInstance( target );
		Assert.isFalse( target.preDestroyCalled, "target.preDestroyCalled should be false" );
		this.injector.map( Clazz ).toType( Clazz );
		target = this.injector.getOrCreateNewInstance( Clazz );
		this.injector.destroyInstance( target );
		Assert.isTrue( target.preDestroyCalled, "target.preDestroyCalled should be true" );
	}
	
	@Test( "Test 'teardown' destroy all singletons" )
	public function testTeardownDestroyAllSingletons() : Void
	{
		this.injector.map( Clazz ).toSingleton( Clazz );
		this.injector.map( Interface ).toSingleton( Clazz );
		var singleton1 = injector.getInstance( Clazz );
		var singleton2 = injector.getInstance( Interface );

		Assert.isFalse( singleton1.preDestroyCalled, "singleton1.preDestroyCalled should be false" );
		Assert.isFalse( singleton2.preDestroyCalled, "singleton2.preDestroyCalled should be false" );

		this.injector.teardown();

		Assert.isTrue( singleton1.preDestroyCalled, "singleton1.preDestroyCalled should be true" );
		Assert.isTrue( singleton2.preDestroyCalled, "singleton2.preDestroyCalled should be true" );
	}

	@Test( "Test 'teardown' destroys all instances injected into" )
	public function testTeardownDestroysAllInstancesInjectedInto() : Void
	{
		var target1 = new Clazz();
		this.injector.injectInto( target1 );
		this.injector.map( Clazz ).toType( Clazz );
		var target2 : Clazz = this.injector.getInstance( Clazz );
		
		Assert.notEquals( target1, target2, "" );

		Assert.isFalse( target1.preDestroyCalled, "target1.preDestroyCalled should be false" );
		Assert.isFalse( target2.preDestroyCalled, "target2.preDestroyCalled should be false" );

		this.injector.teardown();

		Assert.isTrue( target1.preDestroyCalled, "target1.preDestroyCalled should be true" );
		Assert.isTrue( target2.preDestroyCalled, "target2.preDestroyCalled should be true" );
	}


	static public var baseTypes : Array<Dynamic> = [
		#if (!neko && !hl)
		Bool,
		#end
		Dynamic, Array, Class, Int, Float, String
	];
	@DataProvider("baseTypes")
	@Test( "Test satisfies returns false for unmapped common base types" )
	public function testSatisfiesReturnsFalseForUnmappedCommonBaseTypes(o) : Void
	{
		Assert.isFalse( this.injector.satisfies( o ), "injector.satisfies should return false" );
	}

	
	@Test( "Test map injector to value" )
	public function testMapInjectorToValue() : Void
	{
		this.injector.mapToValue( IDependencyInjector, this.injector );
		var injectee = this.injector.instantiateUnmapped( InjectorInjectee );
		Assert.equals( this.injector, injectee.injector, "injector should be injected" );
	}

	@Test( "Test 'instantiateUnmapped' returns new instance when mapped instance exists" )
	public function testInstantiateUnmappedReturnsNewInstanceWhenMappedInstanceExists() : Void
	{
		var mappedValue = new Clazz();
		this.injector.map( Clazz ).toValue( mappedValue );
		var instance = this.injector.instantiateUnmapped( Clazz );
		Assert.notEquals( instance, mappedValue, "" );
	}
	
	@Test( "Test hasMapping returns true for parent mapping" )
	public function testHasMappingReturnsTrueForParentMapping() : Void
	{
		this.injector.map( Clazz ).toValue( new Clazz() );
		var childInjector = this.injector.createChildInjector();
		Assert.isTrue( childInjector.hasMapping( Clazz ), "" );
	}
	
	@Test( "Test 'hasMapping' returns false when mapping doesn't exist" )
	public function testHasMappingReturnsFalseWhenMappingDoesntExist() : Void
	{
		Assert.isFalse( this.injector.hasMapping( Clazz ),"" );
	}
	
	@Test( "Test 'hasDirectMapping' returns false for parent mapping" )
	public function testHasDirectMappingReturnsFalseForParentMapping() : Void
	{
		this.injector.map( Clazz ).toValue( new Clazz() );
		var childInjector = this.injector.createChildInjector();
		Assert.isFalse( childInjector.hasDirectMapping(Clazz), "" );
		
	}

	@Test( "Test 'hasMapping' returns true for type local mapping" )
	public function hasMappingReturnsTrueForTypeLocalMapping() : Void
	{
		this.injector.map( Clazz ).toType( Clazz );
		Assert.isTrue( this.injector.hasMapping( Clazz ), "" );
	}
	
	@Test( "Test 'hasMapping' returns true for value local mapping" )
	public function hasMappingReturnsTrueForValueLocalMapping() : Void
	{
		this.injector.map( Clazz ).toValue( new Clazz() );
		Assert.isTrue( this.injector.hasMapping( Clazz ), "" );
	}
	
	@Test( "Test 'hasDirectMapping' returns true for local mapping" )
	public function hasDirectMappingReturnsTrueForLocalMapping() : Void
	{
		this.injector.map( Clazz ).toValue( new Clazz() );
		Assert.isTrue( this.injector.hasDirectMapping( Clazz ), "" );
	}
	
	@Test( "Test 'getOrCreateNewInstance' provides mapped value" )
	public function testGetOrCreateNewInstanceProvidesMappedValue() : Void
	{
		this.injector.map( Clazz ).toSingleton( Clazz );
		var instance1 = this.injector.getOrCreateNewInstance( Clazz );
		var instance2 = this.injector.getOrCreateNewInstance( Clazz );
		Assert.equals( instance1, instance2, "" );
	}
	
	@Test( "Test 'getOrCreateNewInstance' instantiates when no mapping was found" )
	public function testGetOrCreateNewInstanceInstantiatesWhenNoMappingWasFound() : Void
	{
		var instance1 = this.injector.getOrCreateNewInstance( Clazz );
		Assert.isInstanceOf( instance1, Clazz, "" );
	}
	
	@Test( "Test 'getOrCreateNewInstance' instantiates each time when no mapping was found" )
	public function testGetOrCreateNewInstanceInstantiatesEachTimeWhenNoMappingWasFound() : Void
	{
		var instance1 = this.injector.getOrCreateNewInstance( Clazz );
		var instance2 = this.injector.getOrCreateNewInstance( Clazz );
		Assert.notEquals( instance1, instance2, "" );
	}
	
	@Test( "Test two params constructor injection with constructor injected dependencies" )
	public function testFunctionParameterInjectionWithConstructorInjectedDependencies() : Void
	{
		var f = function ( s : String ) return s;
		injector.mapClassName( 'String->String' ).toValue( f );
		injector.map( FunctionParameterConstructorInjectee ).toType( FunctionParameterConstructorInjectee );

		var injectee = this.injector.instantiateUnmapped( FunctionParameterConstructorInjectee );
		Assert.equals( 'test', injectee.getDependency()( 'test' ), "function should have been injected and return the value" );
		Assert.equals( f, injectee.getDependency(), "function should have been injected and be the same" );
	}

	@Test( "Test two params constructor injection with constructor injected dependencies" )
	public function testTwoParamConstructorInjectionWithConstructorInjectedDependencies() : Void
	{
		injector.map( Clazz ).toType( Clazz );
		injector.map( OneParameterConstructorInjectee ).toType( OneParameterConstructorInjectee );
		injector.map( TwoParametersConstructorInjectee ).toType( TwoParametersConstructorInjectee );
		injector.map( String ).toValue( 'stringDependency' );

		var injectee = this.injector.instantiateUnmapped( TwoParametersConstructorInjecteeWithConstructorInjectedDependencies );
		Assert.isNotNull( injectee.getDependency1(), "Instance of Class should have been injected for OneParameterConstructorInjectee parameter" );
		Assert.isNotNull( injectee.getDependency2(), "Instance of Class should have been injected for TwoParametersConstructorInjectee parameter" );
	}
	
	@Test( "Test named class injectee with class name" )
	public function testNamedClassInjecteeWithClassName() : Void
	{
		var clazzInstance = new Clazz();
		injector.map( Clazz, 'Clazz' ).toValue( clazzInstance );
		
		injector.map( NamedClassInjecteeWithClassName, 'NamedClassInjecteeWithClassName' ).toType( NamedClassInjecteeWithClassName );
		var instance = injector.getInstance( NamedClassInjecteeWithClassName, 'NamedClassInjecteeWithClassName' );

		Assert.isInstanceOf( instance, NamedClassInjecteeWithClassName, "instance should be an instance of 'NamedClassInjecteeWithClassName'" );
		Assert.equals( clazzInstance, instance.property, "Named value should have been injected" );
	}
	
	@Test( "Test dependency provider" )
	public function testDependencyProvider() : Void
	{
		var instance = new Clazz();
		var provider = new MockDependencyProvider<Clazz>(instance);
		injector.map( Clazz ).toProvider(provider);
		
		var returnVal = injector.getInstance(Clazz);
		
		Assert.equals(instance, returnVal, "Returned value must come from dependency provider");
		Assert.equals(injector, provider.injector, "Injector provided to the dependency provider must be the correct one");
		Assert.isNull(provider.target, "Target is unknown so it's supposed to be null");
	}
	
	@Test( "Test injection from dependency provider" )
	public function testInjectionFromDependencyProvider() : Void
	{
		var instance = new Clazz();
		var provider = new MockDependencyProvider<Clazz>(instance);
		injector.map( Clazz, 'Clazz' ).toProvider(provider);
		
		var newInst = injector.instantiateUnmapped(NamedClassInjecteeWithClassName);
		
		Assert.equals(instance, newInst.property, "Returned value must come from dependency provider");
		Assert.equals(injector, provider.injector, "Injector provided to the dependency provider must be the correct one");
		Assert.equals(NamedClassInjecteeWithClassName, provider.target, "Target should be proper class");
		Assert.equals("hex.di.mock.injectees.NamedClassInjecteeWithClassName", provider.className, "Target should be proper class");
	}
	
	@Test( "Test dependency provider with class name" )
	public function testDependencyProviderWithClassName() : Void
	{
		var instance = new Clazz();
		var provider = new MockDependencyProvider<Clazz>(instance);
		injector.map( Clazz ).toProvider(provider);
		
		var returnVal = injector.getInstanceWithClassName("hex.di.mock.injectees.Clazz");
		
		Assert.equals(instance, returnVal, "Returned value must come from dependency provider");
		Assert.equals(injector, provider.injector, "Injector provided to the dependency provider must be the correct one");
		Assert.isNull(provider.target, "Target is unknown so it's supposed to be null");
	}
	
	@Test( "Test getInstance target type is passed to dependency provider" )
	public function testGetInstanceTargetTypeIsPassedToDependencyProvider() : Void
	{
		var instance = new Clazz();
		var provider = new MockDependencyProvider<Clazz>(instance);
		injector.map( Clazz ).toProvider(provider);
		
		var returnVal = injector.getInstance(Clazz, null, NamedClassInjecteeWithClassName);
		
		Assert.equals(instance, returnVal, "Returned value must come from dependency provider");
		Assert.equals(injector, provider.injector, "Injector provided to the dependency provider must be the correct one");
		Assert.equals("hex.di.mock.injectees.NamedClassInjecteeWithClassName", provider.className, "Target should be proper class");
	}
	
	@Test( "Test getInstanceWithClassName target type is passed to dependency provider" )
	public function testGetInstanceWithClassNameTargetTypeIsPassedToDependencyProvider() : Void
	{
		var instance = new Clazz();
		var provider = new MockDependencyProvider<Clazz>(instance);
		injector.map( Clazz ).toProvider(provider);
		
		var returnVal = injector.getInstanceWithClassName("hex.di.mock.injectees.Clazz", null, NamedClassInjecteeWithClassName);
		
		Assert.equals(instance, returnVal, "Returned value must come from dependency provider");
		Assert.equals(injector, provider.injector, "Injector provided to the dependency provider must be the correct one");
		Assert.equals("hex.di.mock.injectees.NamedClassInjecteeWithClassName", provider.className, "Target should be proper class");
	}
	
	@Test( "Test get singleton instance With class name" )
	public function testGetSingletonInstanceWithClassName() : Void
	{
		injector.mapClassName( "hex.di.mock.types.Interface", "name" ).toSingleton( Clazz );
		Assert.equals( injector.getInstanceWithClassName( "hex.di.mock.types.Interface", "name" ), injector.getInstanceWithClassName( "hex.di.mock.types.Interface", "name" ) );
	}
	
	@Test( "Test get non singleton instance With class name" )
	public function testGetNonSingletonInstanceWithClassName() : Void
	{
		injector.mapClassName( "hex.di.mock.types.Interface", "name" ).toType( Clazz );
		Assert.notEquals( injector.getInstanceWithClassName( "hex.di.mock.types.Interface", "name" ), injector.getInstanceWithClassName( "hex.di.mock.types.Interface", "name" ) );
	}
}