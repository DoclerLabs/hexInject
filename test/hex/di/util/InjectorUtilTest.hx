package hex.di.util;

import hex.di.Dependency;
import hex.di.IDependencyInjector;
import hex.di.IInjectorListener;
import hex.di.Injector;
import hex.di.mapping.InjectionMapping;
import hex.di.mock.types.MockEnum;
import hex.di.mock.types.MockModuleWithTypes.InternalTypedef;
import hex.di.mock.types.MockTypedef;
import hex.di.mock.types.MockTypedefImplementation;
import hex.di.provider.IDependencyProvider;
import hex.structures.Point;
import hex.structures.Size;
import hex.unittest.assertion.Assert;

using hex.di.util.InjectorUtil;

/**
 * ...
 * @author Francis Bourre
 */
class InjectorUtilTest 
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
	
	@Test( "test map dependency" )
	public function testMapDependency() : Void
	{
		var o = new MockClassWithTypeParams<String, MockClassWithTypeParams<String, Int>>( "hello", new MockClassWithTypeParams<String, Int>( "yo", 3 ) );
		
		var injector = new ReportingInjector();
		injector.mapDependency( new Dependency<MockClassWithTypeParams<String,MockClassWithTypeParams<String, Int>>>() );
		
		Assert.equals( "hex.di.util.MockClassWithTypeParams<String,hex.di.util.MockClassWithTypeParams<String,Int>>", injector.mappedClassName );
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
	
	@Test( "test map dependency to method" )
	public function testMapDependencyToMethod() : Void
	{
		var f = function ( s : String, a : Array<Int> ) : Bool { return true; };
		this._injector.mapDependencyToValue( new Dependency<String->Array<Int>->Bool>(), f );
		
		var mapping = this._injector.mappedValue;
		Assert.equals( "String->Array<Int>->Bool", mapping.className );
		Assert.equals( f, mapping.value );
		Assert.equals( "", mapping.name );
	}
	
	@Test( "test map dependency to Boolean" )
	public function testMapDependencyToBoolean() : Void
	{
		var o = true;
		this._injector.mapDependencyToValue( new Dependency<Bool>(), o );
		
		var mapping = this._injector.mappedValue;
		Assert.equals( "Bool", mapping.className );
		Assert.isTrue( mapping.value );
		Assert.equals( "", mapping.name );
	}
	
	@Test( "test map dependency to enum" )
	public function testMapDependencyToEnum() : Void
	{
		var item = MockEnum.MockItemWithBool( true );
		this._injector.mapDependencyToValue( new Dependency<MockEnum>(), item );
		
		var mapping = this._injector.mappedValue;
		Assert.equals( "hex.di.mock.types.MockEnum", mapping.className );
		Assert.equals( item, mapping.value );
		Assert.equals( "", mapping.name );
	}
	
	@Test( "test map value to abstract" )
	public function testMapValueToAbstract() : Void
	{
		var p = new Point( 3, 4 );
		this._injector.mapDependencyToValue( new Dependency<Point>(), p );
		
		var mapping = this._injector.mappedValue;
		Assert.equals( "hex.structures.Point", mapping.className );
		Assert.equals( p, mapping.value );
		Assert.equals( "", mapping.name );
	}
	
	@Test( "test map type to abstract" )
	public function testMapTypeToAbstract() : Void
	{
		this._injector.mapDependencyToType( 
			new Dependency<Point>(), 
			new Dependency<Size>() 
		);
		
		var mapping = this._injector.mappedType;
		Assert.equals( "hex.structures.Point", mapping.className );
		Assert.equals( Size, mapping.type );
		Assert.equals( "", mapping.name );
	}
	
	@Test( "test map dependency to internal typedef" )
	public function testMapDependencyToInternalTypedef() : Void
	{
		this._injector.mapDependencyToType( 
			new Dependency<InternalTypedef>(), 
			new Dependency<MockTypedefImplementation>()
		);
		
		var mapping = this._injector.mappedType;
		Assert.equals( "hex.di.mock.types.MockModuleWithTypes.InternalTypedef", mapping.className );
		Assert.equals( MockTypedefImplementation, mapping.type );
		Assert.equals( "", mapping.name );
	}
	
	@Test( "test map dependency to type with typedef" )
	public function testMapDependencyToTypeWithTypedef() : Void
	{
		this._injector.mapDependencyToType( 
			new Dependency<MockTypedef>(), 
			new Dependency<MockTypedefImplementation>()
		);
		
		var mapping = this._injector.mappedType;
		Assert.equals( "hex.di.mock.types.MockTypedef", mapping.className );
		Assert.equals( MockTypedefImplementation, mapping.type );
		Assert.equals( "", mapping.name );
	}
	
	@Test( "test map dependency to typedef" )
	public function testMapDependencyToTypedef() : Void
	{
		var o = new MockTypedefImplementation();
		this._injector.mapDependencyToValue( new Dependency<MockTypedef>(), o );
		
		var mapping = this._injector.mappedValue;
		Assert.equals( "hex.di.mock.types.MockTypedef", mapping.className );
		Assert.equals( o, mapping.value );
		Assert.equals( "", mapping.name );
	}
	
	@Test( "test map typedef to singleton" )
	public function testMapTypedefToSingleton() : Void
	{
		this._injector.mapDependencyToSingleton( 
			new Dependency<MockTypedef>(), 
			new Dependency<MockTypedefImplementation>()
		);
		
		var mapping = this._injector.mappedSingleton;
		Assert.equals( "hex.di.mock.types.MockTypedef", mapping.className );
		Assert.equals( MockTypedefImplementation, mapping.type );
		Assert.equals( "", mapping.name );
	}
	
	@Test( "test unmap dependency" )
	public function testUnmapDependency() : Void
	{
		this._injector.unmapDependency( new Dependency<String>(), 'test' );
		
		var mapping = this._injector.instanceWithClassName;
		Assert.equals( "String", mapping.className );
		Assert.equals( "test", mapping.name );
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
	
	public function hasMapping<T>( type : ClassRef<T>, ?name : MappingName ) : Bool
	{
		return false;
	}
	
	public function hasDirectMapping<T>( type : ClassRef<T>, ?name : MappingName) : Bool
	{
		return false;
	}
	
	public function satisfies<T>( type : ClassRef<T>, ?name : MappingName ) : Bool
	{
		return false;
	}
	
	public function injectInto( target : IInjectorAcceptor ) : Void
	{
		
	}
	
	public function getInstance<T>( type : ClassRef<T>, ?name : MappingName, targetType : Class<Dynamic> = null ) : T
	{
		return null;
	}
	
	public function getInstanceWithClassName<T>( className : ClassName, ?name : MappingName, targetType : Class<Dynamic> = null, shouldThrowAnError : Bool = true ) : T
	{
		this.instanceWithClassName = { className: className, name: name };
		return null;
	}
	
	public function getOrCreateNewInstance<T>( type : Class<T> ) : T
	{
		return null;
	}
	
	public function instantiateUnmapped<T>( type : Class<T> ) : T
	{
		return null;
	}
	
	public function destroyInstance<T>( instance : T ) : Void
	{
		
	}
	
	public function mapToValue<T>( clazz : ClassRef<T>, value : T, ?name : MappingName ) : Void
	{
		
	}
	
	public function mapToType<T>( clazz : ClassRef<T>, type : Class<T>, ?name : MappingName ) : Void
	{
		
	}
	
	public function mapToSingleton<T>( clazz : ClassRef<T>, type : Class<T>, ?name : MappingName ) : Void
	{
		
	}
	
	public function unmap<T>( type : ClassRef<T>, ?name : MappingName ) : Void 
	{
		
	}

	public function addListener( listener: IInjectorListener ) : Bool
	{
		return false;
	}

	public function removeListener( listener: IInjectorListener ) : Bool
	{
		return false;
	}
	
	public function getProvider<T>( className : ClassName, ?name : MappingName ) : IDependencyProvider<T>
	{
		return null;
	}
	
	public function mapClassNameToValue<T>( className : ClassName, value : T, ?name : MappingName ) : Void
	{
		this.mappedValue = { className: className, value: value, name: name };
	}

    public function mapClassNameToType<T>( className : ClassName, type : Class<T>, ?name : MappingName ) : Void
	{
		this.mappedType = { className: className, type: type, name: name };
	}

    public function mapClassNameToSingleton<T>( className : ClassName, type : Class<T>, ?name : MappingName ) : Void
	{
		this.mappedSingleton = { className: className, type: type, name: name };
	}
	
	public function unmapClassName( className : ClassName, ?name : MappingName ) : Void
	{
		this.instanceWithClassName = { className : className, name : name };
	}
}

class ReportingInjector extends Injector
{
	public var mappedClassName:String;
	
	override public function mapClassName<T>( className : ClassName, ?name : MappingName ) : InjectionMapping<T>
	{
		mappedClassName = className;
		return super.mapClassName( className, name );
	}
}