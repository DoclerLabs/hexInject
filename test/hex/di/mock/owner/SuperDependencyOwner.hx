package hex.di.mock.owner;

import hex.di.Injector;
import hex.di.mapping.IDependencyOwner;

class SuperDependencyOwner implements IDependencyOwner
{
	var _injector : Injector;

	public function new()
	{
		_injector = new Injector();
	}

	public function getInjector() : IDependencyInjector return _injector;
}
