package hex.di.util;

import hex.di.Dependency;
import hex.di.IDependencyInjector;
import hex.di.IInjectorListener;
import hex.di.error.MissingMappingException;
import hex.di.mapping.MappingDefinition;
import hex.di.mock.owner.DependencyOwner;
import hex.di.mock.types.Clazz;
import hex.di.mock.types.Clazz2;
import hex.di.mock.types.ClazzWithGeneric;
import hex.di.mock.types.Interface;
import hex.di.mock.types.InterfaceWithGeneric;
import hex.di.mock.types.MockEnum;
import hex.di.mock.types.MockModuleWithTypes.InternalTypedef;
import hex.di.mock.types.MockTypedef;
import hex.di.mock.types.MockTypedefImplementation;
import hex.di.provider.IDependencyProvider;
import hex.structures.Point;
import hex.structures.Size;
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
	
	@Test( "test addDefinition" )
	public function testAddDefinitionWithChecking() : Void
	{
		var f1 = function() return 'hello';
		var f2 = function() {};
		
		var mapping : MappingDefinition = { fromType: "String", toValue: "test" };
		var mappings : Array<MappingDefinition> = [
			{ fromType: "hex.di.mock.types.Interface", toClass: Clazz, withName: "id" },
			{ fromType: "hex.di.mock.types.Interface", toClass: Clazz2, withName: "id2", asSingleton: true },
			{ fromType: "hex.di.mock.types.InterfaceWithGeneric<String>", toClass: ClazzWithGeneric, withName: "name" },
			{ fromType: "Void->String", toValue: f1 },
			{ fromType: "Void->Void", toValue: f2, withName:hex.di.mock.MockConstants.NAME_ONE }
		];
		
		var dependencyOwner = new DependencyOwner();
		dependencyOwner.addDefinition( [mapping].concat( mappings ) );
		
		var injector = dependencyOwner.getInjector();
		Assert.equals( "test", injector.getInstance( String ) );
		
		var clazzInstance1 = injector.getInstance( Interface, "id" );
		var clazzInstance2 = injector.getInstance( Interface, "id" );
		Assert.isInstanceOf( clazzInstance1, Clazz );
		Assert.isInstanceOf( clazzInstance2, Clazz );
		Assert.notEquals( clazzInstance1, clazzInstance2 );
		
		var clazz2Instance1 = injector.getInstance( Interface, "id2" );
		var clazz2Instance2 = injector.getInstance( Interface, "id2" );
		Assert.isInstanceOf( clazz2Instance1, Clazz2 );
		Assert.isInstanceOf( clazz2Instance2, Clazz2 );
		Assert.equals( clazz2Instance1, clazz2Instance2 );
		
		var clazzInstance = injector.getInstanceWithClassName( "hex.di.mock.types.InterfaceWithGeneric<String>", "name" );
		Assert.isInstanceOf( clazzInstance, ClazzWithGeneric );
		
		Assert.equals( f2, injector.getInstanceWithClassName( "Void->Void", hex.di.mock.MockConstants.NAME_ONE ) );
		
		Assert.methodCallThrows( MissingMappingException, injector, injector.getInstanceWithClassName, [ "Void->String" ],
			"This mapping should have been filtered by the dependency checker" );
	}
	
	@Test( "test addDefinition" )
	public function testAddDefinitionWithoutChecking() : Void
	{
		var f1 = function() return 'hello';
		var f2 = function() {};
		
		var mapping : MappingDefinition = { fromType: "String", toValue: "test" };
		var mappings : Array<MappingDefinition> = [
			{ fromType: "hex.di.mock.types.Interface", toClass: Clazz, withName: "id" },
			{ fromType: "hex.di.mock.types.Interface", toClass: Clazz2, withName: "id2", asSingleton: true },
			{ fromType: "hex.di.mock.types.InterfaceWithGeneric<String>", toClass: ClazzWithGeneric, withName: "name" },
			{ fromType: "Void->String", toValue: f1 },
			{ fromType: "Void->Void", toValue: f2, withName:hex.di.mock.MockConstants.NAME_ONE }
		];
		
		var dependencyOwner = new DependencyOwner();
		dependencyOwner.addDefinition( [mapping].concat( mappings ), false );
		
		var injector = dependencyOwner.getInjector();
		Assert.equals( "test", injector.getInstance( String ) );
		
		var clazzInstance1 = injector.getInstance( Interface, "id" );
		var clazzInstance2 = injector.getInstance( Interface, "id" );
		Assert.isInstanceOf( clazzInstance1, Clazz );
		Assert.isInstanceOf( clazzInstance2, Clazz );
		Assert.notEquals( clazzInstance1, clazzInstance2 );
		
		var clazz2Instance1 = injector.getInstance( Interface, "id2" );
		var clazz2Instance2 = injector.getInstance( Interface, "id2" );
		Assert.isInstanceOf( clazz2Instance1, Clazz2 );
		Assert.isInstanceOf( clazz2Instance2, Clazz2 );
		Assert.equals( clazz2Instance1, clazz2Instance2 );
		
		var clazzInstance = injector.getInstanceWithClassName( "hex.di.mock.types.InterfaceWithGeneric<String>", "name" );
		Assert.isInstanceOf( clazzInstance, ClazzWithGeneric );
		
		Assert.equals( f2, injector.getInstanceWithClassName( "Void->Void", hex.di.mock.MockConstants.NAME_ONE ) );
		
		Assert.equals( f1, injector.getInstanceWithClassName( "Void->String" ),
			"This mapping should NOT have been filtered by the dependency checker" );
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
		Assert.equals( "hex.di.mock.types.InternalTypedef", mapping.className );
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
}

@Dependency( var _:Interface, "id" )
@Dependency( var _:Interface, "id2" )
@Dependency( var _:String )
@Dependency( var name:InterfaceWithGeneric<String> )
@Dependency( var _:Void->Void, hex.di.mock.MockConstants.NAME_ONE )
class DependencyOwner implements hex.di.mapping.IDependencyOwner
{
	public var codeShouldBeExecuted : Bool;
	
	var _injector = new Injector();
	
	public function new()
	{
		
	}
	
	public function getInjector() : IDependencyInjector return this._injector;
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
	
	public function getInstance<T>( type : Class<T>, name : String = '', targetType : Class<Dynamic> = null ) : T 
	{
		return null;
	}
	
	public function getInstanceWithClassName<T>( className : String, name : String = '', targetType : Class<Dynamic> = null ) : T
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

	public function addListener( listener : IInjectorListener ) : Bool
	{
		return false;
	}

	public function removeListener( listener : IInjectorListener ) : Bool
	{
		return false;
	}
	
	public function getProvider<T>( className : String, name : String = '' ) : IDependencyProvider<T>
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