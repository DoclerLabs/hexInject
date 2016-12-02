package hex.di.util;

import hex.di.Dependency;
import hex.di.IDependencyInjector;
import hex.di.InjectionEvent;
import hex.di.provider.IDependencyProvider;
import hex.unittest.assertion.Assert;

using hex.di.util.InjectionUtil;

/**
 * ...
 * @author Francis Bourre
 */
class InjectionUtilTest 
{
	var _injector : MockDependencyInjector;
	
	@Before
	public function setUp() : Void
	{
		this._injector = new MockDependencyInjector();
	}
	
	@Test( "test get dependency instance" )
	public function testgetDependencyInstance() : Void
	{
		this._injector.getDependencyInstance( new Dependency<MockClassWithTypeParams<String,MockClassWithTypeParams<String, Int>>>() );
	
		var mapping = this._injector.instanceWithClassName;
		Assert.equals( "hex.di.util.MockClassWithTypeParams<String,hex.di.util.MockClassWithTypeParams<String,Int>>", mapping.className );
		Assert.equals( "", mapping.name );
	}
	
	@Test( "test map dependency to value" )
	public function testMapDependencyToValue() : Void
	{
		var o = new MockClassWithTypeParams<String, MockClassWithTypeParams<String, Int>>( "hello", new MockClassWithTypeParams<String, Int>( "yo", 3 ) );
		
		this._injector.mapDependencyToValue( 
			new Dependency<MockClassWithTypeParams<String,MockClassWithTypeParams<String, Int>>>(), 
			o 
		);
		
		var mapping = this._injector.mappedValue;
		Assert.equals( "hex.di.util.MockClassWithTypeParams<String,hex.di.util.MockClassWithTypeParams<String,Int>>", mapping.className );
		Assert.equals( o, mapping.value );
		Assert.equals( "", mapping.name );
	}
	
	@Test( "test map dependency to type" )
	public function testMapDependencyToType() : Void
	{
		this._injector.mapDependencyToType( 
			new Dependency<MockClassWithTypeParams<String,MockClassWithTypeParams<String, Int>>>(), 
			new Dependency<MockClassWithTypeParams<String,MockClassWithTypeParams<String, Int>>>()
		);
		
		var mapping = this._injector.mappedType;
		Assert.equals( "hex.di.util.MockClassWithTypeParams<String,hex.di.util.MockClassWithTypeParams<String,Int>>", mapping.className );
		Assert.equals( MockClassWithTypeParams, mapping.type );
		Assert.equals( "", mapping.name );
	}
	
	@Test( "test map dependency to singleton" )
	public function testMapDependencyToSingleton() : Void
	{
		this._injector.mapDependencyToSingleton( 
			new Dependency<MockClassWithTypeParams<String,MockClassWithTypeParams<String, Int>>>(), 
			new Dependency<MockClassWithTypeParams<String,MockClassWithTypeParams<String, Int>>>()
		);
		
		var mapping = this._injector.mappedSingleton;
		Assert.equals( "hex.di.util.MockClassWithTypeParams<String,hex.di.util.MockClassWithTypeParams<String,Int>>", mapping.className );
		Assert.equals( MockClassWithTypeParams, mapping.type );
		Assert.equals( "", mapping.name );
	}
}

private class MockDependencyInjector implements IDependencyInjector
{
	public var instanceWithClassName 	: { className : String, ?name : String };
	public var mappedValue 				: { className : String, value : Dynamic, ?name : String };
	public var mappedType 				: { className : String, type : Class<Dynamic>, ?name : String };
	public var mappedSingleton 			: { className : String, type : Class<Dynamic>, ?name : String };
	
	public function new() 
	{
		
	}
	
	public function hasMapping( type : Class<Dynamic>, name : String = '' ) : Bool 
	{
		return false;
	}
	
	public function hasDirectMapping( type : Class<Dynamic>, name:String = '' ) : Bool 
	{
		return false;
	}
	
	public function satisfies( type : Class<Dynamic>, name : String = '' ) : Bool 
	{
		return false;
	}
	
	public function injectInto( target : Dynamic ) : Void 
	{
		
	}
	
	public function getInstance<T>( type : Class<T>, name : String = '' ) : T 
	{
		return null;
	}
	
	public function getInstanceWithClassName<T>( className : String, name : String = '' ) : T
	{
		this.instanceWithClassName = { className: className, name: name };
		return null;
	}
	
	public function getOrCreateNewInstance<T>( type : Class<Dynamic> ) : T 
	{
		return null;
	}
	
	public function instantiateUnmapped<T>( type : Class<Dynamic> ) : T 
	{
		return null;
	}
	
	public function destroyInstance( instance : Dynamic ) : Void 
	{
		
	}
	
	public function mapToValue<T>( clazz : Class<T>, value : T, ?name : String = '' ) : Void 
	{
		
	}
	
	public function mapToType<T>( clazz : Class<T>, type : Class<T>, name : String = '' ) : Void 
	{
		
	}
	
	public function mapToSingleton<T>( clazz : Class<T>, type : Class<T>, name : String = '' ) : Void 
	{
		
	}
	
	public function unmap( type : Class<Dynamic>, name : String = '' ) : Void 
	{
		
	}

	public function addEventListener( eventType : String, callback : InjectionEvent->Void ) : Bool
	{
		return false;
	}

	public function removeEventListener( eventType : String, callback : InjectionEvent->Void ) : Bool
	{
		return false;
	}
	
	public function getProvider( className : String, name : String = '' ) : IDependencyProvider
	{
		return null;
	}
	
	public function mapClassNameToValue( className : String, value : Dynamic, ?name : String = '' ) : Void
	{
		this.mappedValue = { className: className, value: value, name: name };
	}

    public function mapClassNameToType( className : String, type : Class<Dynamic>, name:String = '' ) : Void
	{
		this.mappedType = { className: className, type: type, name: name };
	}

    public function mapClassNameToSingleton( className : String, type : Class<Dynamic>, name:String = '' ) : Void
	{
		this.mappedSingleton = { className: className, type: type, name: name };
	}
	
	public function unmapClassName( className : String, name : String = '' ) : Void
	{
		
	}
}