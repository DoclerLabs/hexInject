package hex.di.mapping;

import hex.di.error.MissingMappingException;
import hex.di.mock.owner.DependencyOwner;
import hex.di.mock.types.Clazz;
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
		var f2 = function() {};
		var mappings : Array<MappingDefinition> = [
			{ fromType: "String", toValue: "test" },
			{ fromType: "hex.di.mock.types.Interface", toClass: Clazz, withName: "id" },
			{ fromType: "hex.di.mock.types.Interface", toClass: Clazz2, withName: "id2", asSingleton: true },
			{ fromType: "hex.di.mock.types.InterfaceWithGeneric<String>", toClass: ClazzWithGeneric, withName: "name" },
			/*{ fromType: "Void->String", toValue: f1 },*/
			{ fromType: "Void->Void", toValue: f2, withName:hex.di.mock.MockConstants.NAME_ONE }
		];
		
		Assert.isTrue( MappingChecker.match( DependencyOwner, mappings ) );
		/*Assert.methodCallThrows( MissingMappingException, injector, injector.getInstanceWithClassName, [ "Void->String" ],
			"This mapping should have been filtered by the dependency checker");*/
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
}