package hex.di.mock.injectable;

import hex.di.IInjectable;

/**
 * ...
 * @author Francis Bourre
 */
class FunctionParameterConstructorInjectee implements IInjectable
{
	var m_dependency : String->String;
		
	public function getDependency() : String->String
	{
		return this.m_dependency;
	}
	
	@Inject
	public function new( dependency : String->String )
	{
		this.m_dependency = dependency;
	}
}