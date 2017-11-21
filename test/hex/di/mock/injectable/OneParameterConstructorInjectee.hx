package hex.di.mock.injectable;

/**
 * ...
 * @author Francis Bourre
 */
class OneParameterConstructorInjectee implements IInjectable
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