package hex.di.mock.owner;

import hex.di.mapping.MappingDefinition;
import hex.di.mapping.IDependencyOwner;

class DependencyOwnerWithoutDependency implements IDependencyOwner
{
	public var codeShouldBeExecuted : Bool;
	public var mapping : MappingDefinition;
	public var uselessArg : Int;
	public var mappings : Array<MappingDefinition>;

	public function new( mapping : MappingDefinition, uselessArg : Int, mappings : Array<MappingDefinition> )
	{
		this.mapping = mapping;
		this.uselessArg = uselessArg;
		this.mappings = mappings;
		this.codeShouldBeExecuted = true;
	}

	public function getInjector() : IDependencyInjector return null;
}
