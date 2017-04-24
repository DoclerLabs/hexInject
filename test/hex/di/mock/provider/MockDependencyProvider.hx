package hex.di.mock.provider;

import hex.di.IDependencyInjector;
import hex.di.provider.IDependencyProvider;

/**
 * ...
 * @author ...
 */
class MockDependencyProvider<T> implements IDependencyProvider<T> 
{
	var instance:T;

	public var target:Class<Dynamic>;
	public var injector:IDependencyInjector;
	
	public var className:String;
	
	public function new(instance:T) 
	{
		this.instance = instance;
		
	}
	
	
	/* INTERFACE hex.di.provider.IDependencyProvider.IDependencyProvider<T> */
	
	public function getResult(injector:IDependencyInjector, target:Class<Dynamic>):T 
	{
		this.injector = injector;
		this.target = target;
		if(target != null)
		{
			this.className = Type.getClassName(target);
		}
		return instance;
	}
	
	public function destroy():Void 
	{
		
	}
	
}