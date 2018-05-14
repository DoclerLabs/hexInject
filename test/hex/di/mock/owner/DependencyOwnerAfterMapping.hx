package hex.di.mock.owner;

import hex.di.mapping.IDependencyOwner;
import hex.di.mapping.MappingDefinition;
import hex.di.Injector;
import hex.di.mock.types.Interface;
import hex.di.mock.types.InterfaceWithGeneric;

using tink.CoreApi;

@Dependency( var _:Interface, "id" )
@Dependency( var _:Interface, "id2" )
@Dependency( var _:String )
@Dependency( var name:InterfaceWithGeneric<String> )
@Dependency( var _:Void->Void, hex.di.mock.MockConstants.NAME_ONE )
class DependencyOwnerWithOutAfterMapping implements IDependencyOwner
{
	public var id:Interface;
	public var id2:Interface;
	public var str:String;
	public var name:InterfaceWithGeneric<String>;
	public var one: Void->Void;

	var _injector : Injector;

	public function new( mapping : MappingDefinition, uselessArg : Int, mappings : Array<MappingDefinition> )
	{
		_injector = new Injector();
		id = try _injector.getInstance( Interface, "id" ) catch(e:Error) null;
		id2 = try _injector.getInstance( Interface, "id2" ) catch(e:Error) null;
		str = try _injector.getInstance( String ) catch(e:Error) null;
		name = try _injector.getInstanceWithClassName( "hex.di.mock.types.InterfaceWithGeneric<String>", "name" ) catch(e:Error) null;
		one = try _injector.getInstanceWithClassName( "Void->Void", hex.di.mock.MockConstants.NAME_ONE ) catch(e:Error) null;
	}

	public function getInjector() : IDependencyInjector return _injector;
}

@Dependency( var _:Interface, "id" )
@Dependency( var _:Interface, "id2" )
@Dependency( var _:String )
@Dependency( var name:InterfaceWithGeneric<String> )
@Dependency( var _:Void->Void, hex.di.mock.MockConstants.NAME_ONE )
class DependencyOwnerWithAfterMapping implements IDependencyOwner
{
	public var id:Interface;
	public var id2:Interface;
	public var str:String;
	public var name:InterfaceWithGeneric<String>;
	public var one: Void->Void;

	var _injector : Injector;

	public function new( mapping : MappingDefinition, uselessArg : Int, mappings : Array<MappingDefinition> )
	{
		_injector = new Injector();
		@AfterMapping
		id = try _injector.getInstance( Interface, "id" ) catch(e:Error) null;
		id2 = try _injector.getInstance( Interface, "id2" ) catch(e:Error) null;
		str = try _injector.getInstance( String ) catch(e:Error) null;
		name = try _injector.getInstanceWithClassName( "hex.di.mock.types.InterfaceWithGeneric<String>", "name" ) catch(e:Error) null;
		one = try _injector.getInstanceWithClassName( "Void->Void", hex.di.mock.MockConstants.NAME_ONE ) catch(e:Error) null;
	}

	public function getInjector() : IDependencyInjector return _injector;
}

@Dependency( var _:Interface, "id" )
@Dependency( var _:Interface, "id2" )
@Dependency( var _:String )
@Dependency( var name:InterfaceWithGeneric<String> )
@Dependency( var _:Void->Void, hex.di.mock.MockConstants.NAME_ONE )
class DependencyOwnerChildWithOutAfterMapping extends SuperDependencyOwner
{
	public var id:Interface;
	public var id2:Interface;
	public var str:String;
	public var name:InterfaceWithGeneric<String>;
	public var one: Void->Void;

	public function new( mapping : MappingDefinition, uselessArg : Int, mappings : Array<MappingDefinition> )
	{
		super();
		id = try _injector.getInstance( Interface, "id" ) catch(e:Error) null;
		id2 = try _injector.getInstance( Interface, "id2" ) catch(e:Error) null;
		str = try _injector.getInstance( String ) catch(e:Error) null;
		name = try _injector.getInstanceWithClassName( "hex.di.mock.types.InterfaceWithGeneric<String>", "name" ) catch(e:Error) null;
		one = try _injector.getInstanceWithClassName( "Void->Void", hex.di.mock.MockConstants.NAME_ONE ) catch(e:Error) null;
	}
}

@Dependency( var _:Interface, "id" )
@Dependency( var _:Interface, "id2" )
@Dependency( var _:String )
@Dependency( var name:InterfaceWithGeneric<String> )
@Dependency( var _:Void->Void, hex.di.mock.MockConstants.NAME_ONE )
class DependencyOwnerChildWithAfterMapping extends SuperDependencyOwner
{
	public var id:Interface;
	public var id2:Interface;
	public var str:String;
	public var name:InterfaceWithGeneric<String>;
	public var one: Void->Void;

	public function new( mapping : MappingDefinition, uselessArg : Int, mappings : Array<MappingDefinition> )
	{
		super();
		@AfterMapping
		id = try _injector.getInstance( Interface, "id" ) catch(e:Error) null;
		id2 = try _injector.getInstance( Interface, "id2" ) catch(e:Error) null;
		str = try _injector.getInstance( String ) catch(e:Error) null;
		name = try _injector.getInstanceWithClassName( "hex.di.mock.types.InterfaceWithGeneric<String>", "name" ) catch(e:Error) null;
		one = try _injector.getInstanceWithClassName( "Void->Void", hex.di.mock.MockConstants.NAME_ONE ) catch(e:Error) null;
	}
}

@Dependency( var _:Interface, "id" )
@Dependency( var _:Interface, "id2" )
@Dependency( var _:String )
@Dependency( var name:InterfaceWithGeneric<String> )
@Dependency( var _:Void->Void, hex.di.mock.MockConstants.NAME_ONE )
class DependencyOwnerChildWithAfterMappingWrapped extends SuperDependencyOwner
{
	public var id:Interface;
	public var id2:Interface;
	public var str:String;
	public var name:InterfaceWithGeneric<String>;
	public var one: Void->Void;

	public function new( mapping : MappingDefinition, uselessArg : Int, mappings : Array<MappingDefinition> )
	{
		super();
		var wrapper = function( arg )
		{
			if( arg == 3 )
			{
				@AfterMapping
				var i = 0;
				i++;
				id = try _injector.getInstance( Interface, "id" ) catch(e:Error) null;
				id2 = try _injector.getInstance( Interface, "id2" ) catch(e:Error) null;
			}
			str = try _injector.getInstance( String ) catch(e:Error) null;
			name = try _injector.getInstanceWithClassName( "hex.di.mock.types.InterfaceWithGeneric<String>", "name" ) catch(e:Error) null;
			one = try _injector.getInstanceWithClassName( "Void->Void", hex.di.mock.MockConstants.NAME_ONE ) catch(e:Error) null;
		}
		wrapper(uselessArg);
	}
}

@Dependency( var _:Interface, "id" )
@Dependency( var _:Interface, "id2" )
@Dependency( var _:String )
@Dependency( var name:InterfaceWithGeneric<String> )
@Dependency( var _:Void->Void, hex.di.mock.MockConstants.NAME_ONE )
class DependencyOwnerChildWithAfterMappingCapturated extends SuperDependencyOwner
{
	public var id:Interface;
	public var id2:Interface;
	public var str:String;
	public var name:InterfaceWithGeneric<String>;
	public var one: Void->Void;

	public function new( mapping : MappingDefinition, uselessArg : Int, mappings : Array<MappingDefinition> )
	{
		super();
		if(uselessArg == 0)
		{
			@AfterMapping
			{}
		}
		id = try _injector.getInstance( Interface, "id" ) catch(e:Error) null;
		id2 = try _injector.getInstance( Interface, "id2" ) catch(e:Error) null;
		str = try _injector.getInstance( String ) catch(e:Error) null;
		name = try _injector.getInstanceWithClassName( "hex.di.mock.types.InterfaceWithGeneric<String>", "name" ) catch(e:Error) null;
		one = try _injector.getInstanceWithClassName( "Void->Void", hex.di.mock.MockConstants.NAME_ONE ) catch(e:Error) null;
	}
}