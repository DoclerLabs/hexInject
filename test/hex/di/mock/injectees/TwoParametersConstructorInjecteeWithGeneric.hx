package hex.di.mock.injectees;

import hex.di.IInjectorContainer;
import hex.di.mock.types.ClazzWithGeneric;
import hex.di.mock.types.InterfaceWithGeneric;

/**
 * ...
 * @author Francis Bourre
 */
class TwoParametersConstructorInjecteeWithGeneric implements IInjectorContainer
{
	var m_dependency 	: ClazzWithGeneric<String>;
	var m_dependency2 	: InterfaceWithGeneric<Int>;

	@Inject
	public function new( dependency : ClazzWithGeneric<String>, dependency2 : InterfaceWithGeneric<Int> )
	{
		this.m_dependency 	= dependency;
		this.m_dependency2 	= dependency2;
	}
	
	public function getDependency() : ClazzWithGeneric<String>
	{
		return this.m_dependency;
	}
	
	public function getDependency2() : InterfaceWithGeneric<Int>
	{
		return this.m_dependency2;
	}
}