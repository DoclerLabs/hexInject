package hex.di.mock.injectable;

/**
 * ...
 * @author Francis Bourre
 */
class OneNamedParameterConstructorInjectee implements IInjectable
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