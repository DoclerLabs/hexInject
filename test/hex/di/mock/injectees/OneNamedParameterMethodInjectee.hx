package hex.di.mock.injectees;

import hex.di.ISpeedInjectorContainer;
import hex.di.mock.types.Clazz;

/**
 * ...
 * @author Francis Bourre
 */
class OneNamedParameterMethodInjectee implements ISpeedInjectorContainer
{
	var m_dependency : Clazz;
		
	@Inject( "namedDep" )
	public function setDependency( dependency : Clazz ) : Void
	{
		this.m_dependency = dependency;
	}
	public function getDependency() : Clazz
	{
		return this.m_dependency;
	}

	public function new() 
	{
		
	}
}