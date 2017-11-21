package hex.di.mapping;

import hex.di.IInjectorContainer;
import hex.di.Injector;
import hex.di.error.MissingMappingException;
import hex.di.mock.injectees.Clazz;
import hex.di.mock.owner.DependencyOwner;
import hex.di.mock.types.Clazz2;
import hex.di.mock.types.ClazzWithGeneric;
import hex.di.mock.types.Interface;
import hex.di.mock.types.InterfaceWithGeneric;
import hex.unittest.assertion.Assert;

using hex.di.util.MappingDefinitionUtil;

/**
 * ...
 * @author Francis Bourre
 */
class MappingDefinitionTest 
{

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
		[mapping].concat( mappings ).addToInjector(dependencyOwner.getInjector(), dependencyOwner);
		
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
	
	@Test("test order of operations")
	public function testInjectIntoHappensAtLast()
	{
		var value = new Injectee();
		var mappings : Array<MappingDefinition> = [
			{ fromType: "hex.di.mapping.MappingDefinitionTest.Injectee", toValue: value, injectInto: true },
			{ fromType: "hex.di.mock.types.Interface", toClass: Clazz2, asSingleton: true }
		];
		
		var injector = new Injector();
		mappings.addToInjector(injector);
		Assert.isNotNull(value.something);
		Assert.equals(injector.getInstance(Interface), value.something);
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

class Injectee implements IInjectorContainer
{
	@Inject
	@Optional(true)
	public var something:Interface;
	
	public function new() { }
}