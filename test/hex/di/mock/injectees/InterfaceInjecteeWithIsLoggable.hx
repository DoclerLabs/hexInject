package hex.di.mock.injectees;

import hex.di.mock.types.Interface;
import hex.log.IsLoggable;

class InterfaceInjecteeWithIsLoggable implements IInjectorContainerAndIsLoggable
{
	@Inject
	public var property : Interface;
	
	public function new() 
	{
		
	}
}

class ExtendedInjecteeWithIsLoggable extends InterfaceInjecteeWithIsLoggable
{
	public function new() 
	{
		super();
	}
}

class ExtendsAndImplementsIsLoggable 
	extends InterfaceInjecteeWithIsLoggable
	implements IsLoggable
{
	public function new() 
	{
		super();
	}
}

interface IInjectorContainerAndIsLoggable extends IInjectorContainer extends IsLoggable 
{}
/*
//
class InterfaceInjecteeWithIsLoggable implements IsLoggableAndIInjectorContainer
{
	@Inject
	public var property : Interface;
	
	public function new() 
	{
		
	}
}

class ExtendedInjecteeWithIsLoggable extends InterfaceInjecteeWithIsLoggable
{
	public function new() 
	{
		super();
	}
}

class ExtendsAndImplementsIsLoggable 
	extends InterfaceInjecteeWithIsLoggable
	implements IsLoggable
{
	public function new() 
	{
		super();
	}
}

interface IsLoggableAndIInjectorContainer extends IsLoggable extends IInjectorContainer
{}*/