package hex.di.mock.injectees;

import hex.di.IInjectorContainer;
import hex.di.mock.types.Clazz;

/**
 * ...
 * @author Francis Bourre
 */
class OneParameterMethodInjectee implements IInjectorContainer
{
	var m_dependency : Clazz;
		
	@Inject
	public function setDependency( dependency : Clazz ) : Void
	{
		this.m_dependency = dependency;
	}
	
	public function getDependency() : Clazz
	{
		return m_dependency;
	}
		
	public function new() 
	{
		
	}
}