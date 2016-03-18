# hexSpeedInject

[![TravisCI Build Status](https://travis-ci.org/DoclerLabs/hexSpeedInject.svg?branch=master)](https://travis-ci.org/DoclerLabs/hexSpeedInject)
Fast annotation driven IOC solution for Haxe based on hexAnnotation (annotation parsing at compile time)

## Dependencies

* [hexCore](https://github.com/DoclerLabs/hexCore)
* [hexAnnotation](https://github.com/DoclerLabs/hexAnnotation)


## Features

- Injections configurable by standardized annotations.
- Injections allowed for properties, methods and constructors.
- Injections can be optional.
- Mapping by type and optionally by name.
- Value, class instance or singleton can satisfy dependencies.
- Injectors chaining.
- Object live-cycle management.
- Event-driven.
- Exception handling.
- Supports ordered post-constructor methods.
- Supports ordered pre-destroy methods.


## Simple example
```haxe
var injector = new SpeedInjector;

//create a basic mapping:
injector.map( Model ).toType( Model );

//map to another class:
injector.map( Model ).toType( BetterModel );

//map an interface to a value:
injector.map( IEventDispatcher ).toValue( new EventDispatcher() );

//map an interface to a singleton:
injector.map( IEventDispatcher ).toSingleton( EventDispatcher );
```


## Properties injection
```haxe
class MockClass implements ISpeedInjectorContainer
{
	@Inject
	public var property1 : Interface;

	@Inject( "name" )
	public var property2 : Interface;

	public function new()
	{

	}
}
```

## Constructor injections with one named and optional
```haxe
class MockClass implements ISpeedInjectorContainer
{
	var m_dependency 	: IModel;
	var m_dependency2 	: String;

	@Inject( null, "namedDependency2" )
	@Optional( false, true )
	public function new( dependency : IModel, dependency2 : String = "hello world" )
	{
		this.m_dependency 	= dependency;
		this.m_dependency2 	= dependency2;
	}
}
```