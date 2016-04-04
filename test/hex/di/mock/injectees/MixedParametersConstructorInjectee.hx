package hex.di.mock.injectees;

import hex.di.IInjectorContainer;
import hex.di.mock.types.Clazz;
import hex.di.mock.types.Interface;

/**
 * ...
 * @author Francis Bourre
 */
class MixedParametersConstructorInjectee implements IInjectorContainer
{
	var m_dependency 	: Clazz;
	var m_dependency2 	: Clazz;
	var m_dependency3 	: Interface;
	
	@Inject( "namedDep", null, "namedDep2" )
	public function new( dependency : Clazz, dependency2 : Clazz, dependency3 : Interface )
	{
		this.m_dependency 	= dependency;
		this.m_dependency2 	= dependency2;
		this.m_dependency3 	= dependency3;
	}
	
	public function getDependency() : Clazz
	{
		return this.m_dependency;
	}
	
	public function getDependency2() : Clazz
	{
		return this.m_dependency2;
	}
	
	public function getDependency3() : Interface
	{
		return this.m_dependency3;
	}
}