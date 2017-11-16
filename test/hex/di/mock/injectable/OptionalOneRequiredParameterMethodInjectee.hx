package hex.di.mock.injectable;

import hex.di.mock.types.Interface;

/**
 * ...
 * @author Francis Bourre
 */
class OptionalOneRequiredParameterMethodInjectee implements IInjectable
{
	var m_dependency : Interface;

	@Inject
	@Optional( true )
	public function setDependency( ?dependency : Interface ) : Void
	{
		this.m_dependency = dependency;
	}
	
	public function getDependency() : Interface
	{
		return this.m_dependency;
	}

	public function new() 
	{
		
	}
}