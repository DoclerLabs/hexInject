package hex.di.mapping;

import hex.di.mock.injectees.Clazz;
import hex.di.mock.owner.DependencyOwnerWithoutDependency;
import hex.di.mock.owner.DependencyOwnerWithoutMapping;
import hex.di.mock.owner.DependencyOwnerAfterMapping.DependencyOwnerWithOutAfterMapping;
import hex.di.mock.owner.DependencyOwnerAfterMapping.DependencyOwnerWithAfterMapping;
import hex.di.mock.owner.DependencyOwnerAfterMapping.DependencyOwnerChildWithOutAfterMapping;
import hex.di.mock.owner.DependencyOwnerAfterMapping.DependencyOwnerChildWithAfterMapping;
import hex.di.mock.owner.DependencyOwnerAfterMapping.DependencyOwnerChildWithAfterMappingWrapped;
import hex.di.mock.owner.DependencyOwnerAfterMapping.DependencyOwnerChildWithAfterMappingCapturated;
import hex.di.mock.owner.DependencyOwnerChild.DependencyOwnerChild;
import hex.di.mock.owner.DependencyOwnerChild.DependencyOwnerChildTwice;
import hex.di.error.MissingMappingException;
import hex.di.mock.owner.DependencyOwner;
import hex.di.mock.types.Clazz2;
import hex.di.mock.types.ClazzWithGeneric;
import hex.di.mock.types.Interface;
import hex.unittest.assertion.Assert;

/**
 * ...
 * @author Francis Bourre
 */
class DependencyOwnerTest 
{
	@Test
	public function testDependencyFilter() : Void
	{
		var f1 = function() return 'hello';
		var f2 = function() {};
		
		var mapping : MappingDefinition = { fromType: "String", toValue: "test" };
		var mappings : Array<MappingDefinition> = [
			{ fromType: "hex.di.mock.types.Interface", toClass: Clazz, withName: "id" },
			{ fromType: "hex.di.mock.types.Interface", toClass: Clazz2, withName: "id2", asSingleton: true },
			{ fromType: "hex.di.mock.types.InterfaceWithGeneric<String>", toClass: ClazzWithGeneric, withName: "name" },
		];
		
		var filtered = MappingChecker.filter( DependencyOwner, [mapping] );
		Assert.deepEquals( mapping, filtered[0] );
		
		//Test entries are kept during filtering
		filtered = MappingChecker.filter( DependencyOwner, mappings );
		Assert.deepEquals( mappings, filtered );
		
		//Test latest entry is removed during filtering
		mappings.push( { fromType: "Void->String", toValue: f1 } );
		filtered = MappingChecker.filter( DependencyOwner, mappings );
		Assert.notDeepEquals( mappings, filtered );
		mappings.pop();
		
		//Test latest entry is kept during filtering
		mappings.push( { fromType: "Void->Void", toValue: f2, withName:hex.di.mock.MockConstants.NAME_ONE } );
		filtered = MappingChecker.filter( DependencyOwner, mappings );
		Assert.deepEquals( mappings, filtered );
	}
	
	@Test
	public function testMatch() : Void
	{
		var f1 = function() return 'hello';
		var f2 = function() { };
		
		var mappings : Array<MappingDefinition> = [
			{ fromType: "String", toValue: "test" },
			{ fromType: "hex.di.mock.types.Interface", toClass: Clazz, withName: "id" },
			{ fromType: "hex.di.mock.types.Interface", toClass: Clazz2, withName: "id2", asSingleton: true },
			{ fromType: "hex.di.mock.types.InterfaceWithGeneric<String>", toClass: ClazzWithGeneric, withName: "name" },
			{ fromType: "Void->Void", toValue: f2, withName:hex.di.mock.MockConstants.NAME_ONE }
		];
		
		Assert.isTrue( MappingChecker.match( DependencyOwner, mappings ) );
		
		mappings.push( { fromType: "Void->String", toValue: f1 } );
		Assert.isFalse( MappingChecker.match( DependencyOwner, mappings ),
			"This checking should mismatch, DependencyOwner class doesn't have `Void->String` dependency annotated" );
	}
	
	@Test
	public function testDependencyOwnerGotRightMappings() : Void
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

		var dependencyOwner = new DependencyOwner( mapping, 3, mappings );
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
			"This mapping should have been filtered by the dependency checker");
	}

	@Test
	public function testDependencyOwnerWithoutDependency() : Void
	{
		var mapping : MappingDefinition = { fromType: "Int", toValue: 4 };
		var mappings : Array<MappingDefinition> = [
			{ fromType: "hex.di.mock.types.Interface", toClass: Clazz, withName: "id" }
		];

		var dependencyOwner = new DependencyOwnerWithoutDependency(mapping, 99, mappings);

		Assert.equals( mapping, dependencyOwner.mapping );
		Assert.equals( 99, dependencyOwner.uselessArg );
		Assert.deepEquals( mappings, dependencyOwner.mappings );
		Assert.isTrue( dependencyOwner.codeShouldBeExecuted, "DependencyOwner should be instancied without Dependency and mapping" );
		Assert.isNull( dependencyOwner.getInjector() );
	}

	@Test
	public function testDependencyOwnerWithoutMapping() : Void
	{
		var dependencyOwner = new DependencyOwnerWithoutMapping();
		Assert.isTrue( dependencyOwner.codeShouldBeExecuted, "should be instancied without @Dependency and mapping in constructor" );
		Assert.isNull( dependencyOwner.getInjector() );
	}

	@Test
	public function testDependencyOwnerWithOutAfterMapping() : Void
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

		var dependencyOwner = new DependencyOwnerWithOutAfterMapping( mapping, 3, mappings );
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
		"This mapping should have been filtered by the dependency checker");

		Assert.isNull( dependencyOwner.id );
		Assert.isNull( dependencyOwner.id2 );
		Assert.isNull( dependencyOwner.str );
		Assert.isNull( dependencyOwner.name );
		Assert.isNull( dependencyOwner.one );
	}

	@Test
	public function testDependencyOwnerWithAfterMapping() : Void
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

		var dependencyOwner = new DependencyOwnerWithAfterMapping( mapping, 3, mappings );
		var injector = dependencyOwner.getInjector();
		var str = injector.getInstance( String );
		Assert.equals( "test", str );

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

		Assert.isInstanceOf( dependencyOwner.id, Clazz );
		Assert.notEquals( dependencyOwner.id, clazzInstance1 );
		Assert.equals( dependencyOwner.id2, clazz2Instance1 );
		Assert.equals( dependencyOwner.str, str );
		Assert.isInstanceOf( dependencyOwner.name, ClazzWithGeneric );
		Assert.notEquals( dependencyOwner.name, clazzInstance );
		Assert.equals( dependencyOwner.one, f2 );

		Assert.methodCallThrows( MissingMappingException, injector, injector.getInstanceWithClassName, [ "Void->String" ],
		"This mapping should have been filtered by the dependency checker");
	}

	@Test
	public function testDependencyOwnerChildWithOutAfterMapping() : Void
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

		var dependencyOwner = new DependencyOwnerChildWithOutAfterMapping( mapping, 3, mappings );
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
		"This mapping should have been filtered by the dependency checker");

		Assert.isNull( dependencyOwner.id );
		Assert.isNull( dependencyOwner.id2 );
		Assert.isNull( dependencyOwner.str );
		Assert.isNull( dependencyOwner.name );
		Assert.isNull( dependencyOwner.one );
	}

	@Test
	public function testDependencyOwnerChildWithAfterMapping() : Void
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

		var dependencyOwner = new DependencyOwnerChildWithAfterMapping( mapping, 3, mappings );
		var injector = dependencyOwner.getInjector();
		var str = injector.getInstance( String );
		Assert.equals( "test", str );

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

		Assert.isInstanceOf( dependencyOwner.id, Clazz );
		Assert.notEquals( dependencyOwner.id, clazzInstance1 );
		Assert.equals( dependencyOwner.id2, clazz2Instance1 );
		Assert.equals( dependencyOwner.str, str );
		Assert.isInstanceOf( dependencyOwner.name, ClazzWithGeneric );
		Assert.notEquals( dependencyOwner.name, clazzInstance );
		Assert.equals( dependencyOwner.one, f2 );

		Assert.methodCallThrows( MissingMappingException, injector, injector.getInstanceWithClassName, [ "Void->String" ],
		"This mapping should have been filtered by the dependency checker");
	}

	@Test
	public function testDependencyOwnerChildWithAfterMappingWrapped() : Void
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

		var dependencyOwner = new DependencyOwnerChildWithAfterMappingWrapped( mapping, 3, mappings );
		var injector = dependencyOwner.getInjector();
		var str = injector.getInstance( String );
		Assert.equals( "test", str );

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

		Assert.isInstanceOf( dependencyOwner.id, Clazz );
		Assert.notEquals( dependencyOwner.id, clazzInstance1 );
		Assert.equals( dependencyOwner.id2, clazz2Instance1 );
		Assert.equals( dependencyOwner.str, str );
		Assert.isInstanceOf( dependencyOwner.name, ClazzWithGeneric );
		Assert.notEquals( dependencyOwner.name, clazzInstance );
		Assert.equals( dependencyOwner.one, f2 );

		Assert.methodCallThrows( MissingMappingException, injector, injector.getInstanceWithClassName, [ "Void->String" ],
		"This mapping should have been filtered by the dependency checker");
	}

	@Test
	public function testDependencyOwnerChildWithAfterMappingCapturated() : Void
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

		var dependencyOwner = new DependencyOwnerChildWithAfterMappingCapturated( mapping, 3, mappings );
		var injector = dependencyOwner.getInjector();

		Assert.methodCallThrows( MissingMappingException, injector, injector.getInstance, [ String ]);
		Assert.methodCallThrows( MissingMappingException, injector, injector.getInstance, [ Interface, "id" ]);
		Assert.methodCallThrows( MissingMappingException, injector, injector.getInstanceWithClassName, [ "hex.di.mock.types.InterfaceWithGeneric<String>", "name" ]);
		Assert.methodCallThrows( MissingMappingException, injector, injector.getInstanceWithClassName, [ "Void->Void", hex.di.mock.MockConstants.NAME_ONE ]);

		Assert.methodCallThrows( MissingMappingException, injector, injector.getInstanceWithClassName, [ "Void->String" ],
		"This mapping should have been filtered by the dependency checker");

		Assert.isNull( dependencyOwner.id );
		Assert.isNull( dependencyOwner.id2 );
		Assert.isNull( dependencyOwner.str );
		Assert.isNull( dependencyOwner.name );
		Assert.isNull( dependencyOwner.one );
	}

	@Test
	public function testDependencyOwnerChildMappingsGotRightMappings() : Void
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

		var dependencyOwner = new DependencyOwnerChild( mapping, 3, mappings );
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
		"This mapping should have been filtered by the dependency checker");
	}

	@Test
	public function testDependencyOwnerChildTwiceGotRightMappings() : Void
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

		var dependencyOwner = new DependencyOwnerChildTwice( mapping, 3, mappings );
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
		"This mapping should have been filtered by the dependency checker");
	}
}