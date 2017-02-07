package hex.di.mapping;

import hex.di.mapping.MappingConfiguration;
import hex.event.Dispatcher;
import hex.event.MessageType;
import hex.service.stateful.IStatefulService;
import hex.service.stateful.StatefulService;
import hex.service.stateless.IStatelessService;
import hex.service.stateless.MockStatelessService;
import hex.unittest.assertion.Assert;

/**
 * ...
 * @author Francis Bourre
 */
class MappingConfigurationTest
{
	var _mappingConfiguration : MappingConfiguration;

    @Before
    public function setUp() : Void
    {
        this._mappingConfiguration = new MappingConfiguration();
    }

    @After
    public function tearDown() : Void
    {
        this._mappingConfiguration = null;
    }
	
	@Test( "Test configure with stateless type unnnamed" )
    public function testConfigureWithStatelessServiceUnnamed() : Void
    {
		this._mappingConfiguration.addMapping( IStatelessService, MockStatelessService );
		var injector = new MockInjectorForMapToTypeTest();
		this._mappingConfiguration.configure( injector, null, null );
		
		Assert.equals( IStatelessService, injector.clazz, "injector should map the class" );
		Assert.equals( injector.type, MockStatelessService, "injector should map the service instance" );
		Assert.equals( "", injector.name, "injector should map the service name" );
	}
	
	@Test( "Test configure with stateless service named" )
    public function testConfigureWithStatelessServiceNamed() : Void
    {
		this._mappingConfiguration.addMapping( IStatelessService, MockStatelessService, "myServiceName" );
		var injector = new MockInjectorForMapToTypeTest();
		this._mappingConfiguration.configure( injector, null, null );
		
		Assert.equals( IStatelessService, injector.clazz, "injector should map the service class" );
		Assert.equals( injector.type, MockStatelessService, "injector should map the service type" );
		Assert.equals( "myServiceName", injector.name, "injector should map the service name" );
	}
	
	@Test( "Test configure with stateless service unnamed" )
    public function testConfigureWithSingletonUnnamed() : Void
    {
		this._mappingConfiguration.addMapping( IStatelessService, MockStatelessService, null, true );
		var injector = new MockInjectorForMapAsSingletonTest();
		this._mappingConfiguration.configure( injector, null, null );
		
		Assert.equals( IStatelessService, injector.clazz, "injector should map the service class" );
		Assert.equals( injector.type, MockStatelessService, "injector should map the service type" );
		Assert.equals( "", injector.name, "injector should map the service name" );
	}
	
	@Test( "Test configure with injectInto set to true" )
    public function testConfigureWithInjectIntoSetToTrue() : Void
    {
		var statefulService = new MockStatefulService();
		this._mappingConfiguration.addMapping( IStatefulService, statefulService, false, true );
		var injector = new MockInjectorForInjectInto();
		this._mappingConfiguration.configure( injector, null, null );
		
		Assert.equals( statefulService, injector.target, "injector should map the service type" );
	}
	
	@Test( "Test configure with injectInto set to false" )
    public function testConfigureWithInjectIntoSetToFalse() : Void
    {
		var statefulService = new MockStatefulService();
		this._mappingConfiguration.addMapping( IStatefulService, statefulService, false, false );
		var injector = new MockInjectorForInjectInto();
		this._mappingConfiguration.configure( injector, null, null );
		
		Assert.isNull( injector.target, "injector should map the service type" );
	}
	
	@Test( "Test configure with injectInto default behavior" )
    public function testConfigureWithInjectIntoDefaultBehavior() : Void
    {
		var statefulService = new MockStatefulService();
		this._mappingConfiguration.addMapping( IStatefulService, statefulService );
		var injector = new MockInjectorForInjectInto();
		this._mappingConfiguration.configure( injector, null, null );
		
		Assert.isNull( injector.target, "injector should map the service type" );
	}
	
	@Test( "Test configure with stateless service named" )
    public function testConfigureWithSingletonNamed() : Void
    {
		this._mappingConfiguration.addMapping( IStatelessService, MockStatelessService, "myServiceName", true );
		var injector = new MockInjectorForMapAsSingletonTest();
		this._mappingConfiguration.configure( injector, null, null );
		
		Assert.equals( IStatelessService, injector.clazz, "injector should map the service class" );
		Assert.equals( injector.type, MockStatelessService, "injector should map the service type" );
		Assert.equals( "myServiceName", injector.name, "injector should map the service name" );
	}
	
	@Test( "Test configure with stateful service unnnamed" )
    public function testConfigureWithStatefulServiceUnnamed() : Void
    {
		var dispatcher = new Dispatcher();
		
		var statefulService = new MockStatefulService();
		this._mappingConfiguration.addMapping( IStatefulService, statefulService );
		var injector = new MockInjectorForMapToValueTest();
		this._mappingConfiguration.configure( injector, dispatcher, null );
		
		Assert.equals( IStatefulService, injector.clazz, "injector should map the class" );
		Assert.equals( statefulService, injector.value, "injector should map the service instance" );
		Assert.equals( "", injector.name, "injector should map the service name" );
		
		var mt = new MessageType( "test" );
		var listener = new MockServiceListener();
		dispatcher.addHandler( mt, listener, listener.onTest );
		statefulService.dispatch( mt, [statefulService] );
		
		Assert.equals( statefulService, listener.lastDataReceived, "event should be received by sub-dispatcher listener" );
		Assert.equals( 1, listener.eventReceivedCount, "event should be received by sub-dispatcher listener once" );
	}
	
	@Test( "Test configure with stateful service named" )
    public function testConfigureWithStatefulServiceNamed() : Void
    {
		var dispatcher = new Dispatcher();
		
		var statefulService = new MockStatefulService();
		this._mappingConfiguration.addMapping( IStatefulService, statefulService, "myServiceName" );
		var injector = new MockInjectorForMapToValueTest();
		this._mappingConfiguration.configure( injector, dispatcher, null );
		
		Assert.equals( IStatefulService, injector.clazz, "injector should map the class" );
		Assert.equals( statefulService, injector.value, "injector should map the service instance" );
		Assert.equals( "myServiceName", injector.name, "injector should map the service name" );
		
		var mt = new MessageType( "test" );
		var listener = new MockServiceListener();
		dispatcher.addHandler( mt, listener, listener.onTest );

		statefulService.dispatch( mt, [statefulService] );
		
		Assert.equals( statefulService, listener.lastDataReceived, "event should be received by sub-dispatcher listener" );
		Assert.equals( 1, listener.eventReceivedCount, "event should be received by sub-dispatcher listener once" );
	}
}

private class MockInjectorForMapAsSingletonTest extends MockDependencyInjector
{
	public var clazz	: Class<Dynamic>;
	public var type		: Class<Dynamic>;
	public var name		: String;
	
	override public function mapToSingleton( clazz : Class<Dynamic>, type : Class<Dynamic>, name : String = '' ) : Void 
	{
		this.clazz 	= clazz;
		this.type 	= type;
		this.name 	= name;
	}
}

private class MockInjectorForMapToTypeTest extends MockDependencyInjector
{
	public var clazz	: Class<Dynamic>;
	public var type		: Class<Dynamic>;
	public var name		: String;
	
	override public function mapToType( clazz : Class<Dynamic>, type : Class<Dynamic>, name : String = '' ) : Void 
	{
		this.clazz 	= clazz;
		this.type 	= type;
		this.name 	= name;
	}
}

private class MockInjectorForMapToValueTest extends MockDependencyInjector
{
	public var clazz	: Class<Dynamic>;
	public var value	: Dynamic;
	public var name		: String;
	
	override public function mapToValue( clazz : Class<Dynamic>, value : Dynamic, ?name : String = '' ) : Void 
	{
		this.clazz 	= clazz;
		this.value 	= value;
		this.name 	= name;
	}
}

private class MockInjectorForInjectInto extends MockDependencyInjector
{
	public var target : Dynamic;
	
	override public function injectInto( target : Dynamic ) : Void
	{
		this.target = target;
	}
}

private class MockServiceListener
{
	public var lastDataReceived 	: MockStatefulService;
	public var eventReceivedCount 	: Int = 0;
	
	public function new()
	{
		
	}
	
	public function onTest( service : MockStatefulService ) : Void
	{
		this.lastDataReceived = service;
		this.eventReceivedCount++;
	}
}