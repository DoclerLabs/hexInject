package hex.di.mock.injectees;
import hex.di.ISpeedInjectorContainer;

/**
 * ...
 * @author Francis Bourre
 */
class TwoParametersConstructorInjecteeWithConstructorInjectedDependencies implements ISpeedInjectorContainer
{
	private var m_dependency1 : OneParameterConstructorInjectee;
	private var m_dependency2 : TwoParametersConstructorInjectee;
	
	public function getDependency1() : OneParameterConstructorInjectee
	{
		return m_dependency1;
	}
	
	
	public function getDependency2():TwoParametersConstructorInjectee
	{
		return m_dependency2;
	}

	@Inject
	public function new( dependency1 : OneParameterConstructorInjectee, dependency2 : TwoParametersConstructorInjectee )
	{
		m_dependency1 = dependency1;
		m_dependency2 = dependency2;
	}
	
}