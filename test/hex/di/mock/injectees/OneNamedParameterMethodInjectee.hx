package hex.di.mock.injectees;

/**
 * ...
 * @author Francis Bourre
 */
class OneNamedParameterMethodInjectee implements IInjectorContainer
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