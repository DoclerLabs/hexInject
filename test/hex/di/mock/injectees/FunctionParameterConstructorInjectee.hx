package hex.di.mock.injectees;

/**
 * ...
 * @author Francis Bourre
 */
class FunctionParameterConstructorInjectee implements IInjectorContainer
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