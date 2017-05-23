package hex.di.mock.injectees;

import hex.di.IInjectorContainer;
import hex.di.mock.types.Clazz;
import hex.di.mock.types.Interface;
import hex.di.mock.types.MockConstants;

/**
 * ...
 * @author Francis Bourre
 */
class MixedParametersConstructorInjectee implements IInjectorContainer
{
	var m_dependency 	: Clazz;
	var m_dependency2 	: Clazz;
	var m_dependency3 	: Interface;
	
	@Inject( "namedDep", null, "namedDep2" )
	public function new( dependency : Clazz, dependency2 : Clazz, dependency3 : Interface )
	{
		this.m_dependency 	= dependency;
		this.m_dependency2 	= dependency2;
		this.m_dependency3 	= dependency3;
	}
	
	public function getDependency() : Clazz
	{
		return this.m_dependency;
	}
	
	public function getDependency2() : Clazz
	{
		return this.m_dependency2;
	}
	
	public function getDependency3() : Interface
	{
		return this.m_dependency3;
	}
}

class MixedParametersConstructorInjecteeConst implements IInjectorContainer
{
	static inline var NAMED_DEP = "namedDep";
	static inline var NAMED_DEP_2 = "namedDep2";
	
	var m_dependency 	: Clazz;
	var m_dependency2 	: Clazz;
	var m_dependency3 	: Interface;
	
	@Inject( NAMED_DEP, null, NAMED_DEP_2 )
	public function new( dependency : Clazz, dependency2 : Clazz, dependency3 : Interface )
	{
		this.m_dependency 	= dependency;
		this.m_dependency2 	= dependency2;
		this.m_dependency3 	= dependency3;
	}
	
	public function getDependency() : Clazz
	{
		return this.m_dependency;
	}
	
	public function getDependency2() : Clazz
	{
		return this.m_dependency2;
	}
	
	public function getDependency3() : Interface
	{
		return this.m_dependency3;
	}
}

class MixedParametersConstructorInjecteeConstOutside implements IInjectorContainer
{
	var m_dependency 	: Clazz;
	var m_dependency2 	: Clazz;
	var m_dependency3 	: Interface;
	
	@Inject( MockConstants.NAMED_DEP, null, MockConstants.NAMED_DEP_2 )
	public function new( dependency : Clazz, dependency2 : Clazz, dependency3 : Interface )
	{
		this.m_dependency 	= dependency;
		this.m_dependency2 	= dependency2;
		this.m_dependency3 	= dependency3;
	}
	
	public function getDependency() : Clazz
	{
		return this.m_dependency;
	}
	
	public function getDependency2() : Clazz
	{
		return this.m_dependency2;
	}
	
	public function getDependency3() : Interface
	{
		return this.m_dependency3;
	}
}

class MixedParametersConstructorInjecteeConstOutsideFQCN implements IInjectorContainer
{
	var m_dependency 	: Clazz;
	var m_dependency2 	: Clazz;
	var m_dependency3 	: Interface;
	
	@Inject( hex.di.mock.types.MockConstants.NAMED_DEP, null, hex.di.mock.types.MockConstants.NAMED_DEP_2 )
	public function new( dependency : Clazz, dependency2 : Clazz, dependency3 : Interface )
	{
		this.m_dependency 	= dependency;
		this.m_dependency2 	= dependency2;
		this.m_dependency3 	= dependency3;
	}
	
	public function getDependency() : Clazz
	{
		return this.m_dependency;
	}
	
	public function getDependency2() : Clazz
	{
		return this.m_dependency2;
	}
	
	public function getDependency3() : Interface
	{
		return this.m_dependency3;
	}
}