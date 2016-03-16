package hex.di.annotation.mock;

import hex.di.ISpeedInjectorContainer;
import hex.domain.Domain;
import hex.log.ILogger;

/**
 * ...
 * @author Francis Bourre
 */
class MockSpeedInjectorContainer implements ISpeedInjectorContainer
{
	@Inject( "name0" )
	public var property0 : ILogger;
	
	@Inject
	@Optional( false )
	public var property1 : Domain;
	
	@Inject( "name2" )
	@Optional( true )
	public var property2 : String;
	
	@Inject( "name0", null, "name2" )
	@Optional( false, null, true )
	public function new( a0 : ILogger, a1 : Domain, a2 : String = "hello" ) 
	{
		
	}
	
	@PostConstruct( 2 )
	public function beforeInit( ) : Void
	{
		
	}
	
	@Inject
	@PostConstruct( 0 )
	public function preInit( domain : Domain ) : Void
	{
		
	}
	
	@Inject( "name0", null, "name2" )
	@PostConstruct( 1 )
	@Optional( false, null, true )
	public function init( a0 : ILogger, a1 : Domain, a2 : String = "hello" ) : Void
	{
		
	}
	
	@Inject
	public function setLogger( logger : ILogger ) : Void
	{
		
	}
	
	@Inject( "name" )
	public function setDomain( logger : Domain ) : Void
	{
		
	}
	
	@PreDestroy( 2 )
	public function beforeDestroy() : Void
	{
		
	}
	
	@Inject
	@PreDestroy( 1 )
	public function preDestroy( domain : Domain ) : Void
	{
		
	}
	
	@Inject( "name0", null, "name2" )
	@PreDestroy( 0 )
	@Optional( false, false, true )
	public function destroy( a0 : ILogger, a1 : Domain, a2 : String = "hello" ) : Void
	{
		
	}
	
	@PreDestroy
	public function testDestroy() : Void
	{
		
	}
	
	@PostConstruct
	public function testConstruct() : Void
	{
		
	}
}