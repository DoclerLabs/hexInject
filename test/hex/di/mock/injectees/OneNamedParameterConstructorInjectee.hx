package hex.di.mock.injectees;

import hex.di.ISpeedInjectorContainer;
import hex.di.mock.types.Clazz;

/**
 * ...
 * @author Francis Bourre
 */
class OneNamedParameterConstructorInjectee implements ISpeedInjectorContainer
{
	var m_dependency : Clazz;

	@Inject( "namedDependency" )
	public function new( dependency : Clazz )
	{
		this.m_dependency = dependency;
	}
	
	public function getDependency() : Clazz
	{
		return m_dependency;
	}
}