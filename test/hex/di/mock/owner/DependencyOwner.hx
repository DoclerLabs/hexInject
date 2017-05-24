package hex.di.mock.owner;

import hex.di.mapping.IDependencyOwner;
import hex.di.mapping.MappingDefinition;
import hex.di.mock.types.Interface;
import hex.di.mock.types.InterfaceWithGeneric;

/**
 * ...
 * @author Francis Bourre
 */
@Dependency( var _:Interface, "id" )
@Dependency( var _:Interface, "id2" )
@Dependency( var _:String )
@Dependency( var name:InterfaceWithGeneric<String> )
@Dependency( var _:Void->Void, hex.di.mock.MockConstants.NAME_ONE )
class DependencyOwner implements IDependencyOwner
{
	public var codeShouldBeExecuted : Bool;
	
	var _injector = new Injector();
	
	public function new( mapping : MappingDefinition, uselessArg : Int, mappings : Array<MappingDefinition> )
	{
		this.codeShouldBeExecuted = true;
	}
	
	public function getInjector() : IDependencyInjector return this._injector;
}