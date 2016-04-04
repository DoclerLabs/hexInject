package hex.di.mock.injectees;

import hex.di.IInjectorContainer;
import hex.di.mock.types.Clazz;

/**
 * ...
 * @author Francis Bourre
 */
class OneParameterConstructorInjectee implements IInjectorContainer
{
	var m_dependency : Clazz;
		
	public function getDependency() : Clazz
	{
		return this.m_dependency;
	}
	
	@Inject
	public function new( dependency : Clazz )
	{
		this.m_dependency = dependency;
	}
}