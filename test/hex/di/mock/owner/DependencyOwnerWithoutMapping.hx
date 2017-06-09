package hex.di.mock.owner;

import hex.di.mapping.IDependencyOwner;

class DependencyOwnerWithoutMapping implements IDependencyOwner
{
	public var codeShouldBeExecuted : Bool;

    public function new()
	{
		this.codeShouldBeExecuted = true;
    }

	public function getInjector() : IDependencyInjector return null;
}