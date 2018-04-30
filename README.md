# hexInject [![TravisCI Build Status](https://travis-ci.org/DoclerLabs/hexInject.svg?branch=master)](https://travis-ci.org/DoclerLabs/hexInject)

Fast annotation driven IOC solution for Haxe based on hexAnnotation (annotation parsing at compile time)

*Find more information about hexMachina on [hexmachina.org](http://hexmachina.org/)*

## Dependencies

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
var injector = new Injector;

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
class MockClass implements IInjectorContainer
{
    @Inject
    public var property1 : Interface;

    @Inject( "name" )
    public var property2 : Interface;

    public function new() {}
}
```


## Constructor injections with one named and optional
```haxe
class MockClass implements IInjectorContainer
{
    var m_dependency 	: IModel;
    var m_dependency2 	: String;

    @Inject( null, "name" )
    @Optional( false, true )
    public function new( dependency : IModel, dependency2 : String = "hello world" )
    {
        this.m_dependency 	= dependency;
        this.m_dependency2 	= dependency2;
    }
}
```


## Method injections with named dependencies
```haxe
class MockClass implements IInjectorContainer
{
    var m_dependency 	: IModel;
    var m_dependency2 	: String;

    public function new() {}

    @Inject( "name1", "name2" ) : Void
    public function setDependencies( dependency : IModel, dependency2 : String )
    {
        this.m_dependency 	= dependency;
        this.m_dependency2 	= dependency2;
    }
}
```


## Postconstruct methods
```haxe
class MockClass implements IInjectorContainer
{
    public function new() {}

    @PostConstruct( 0 )
    public function doSomething() : Void
    {
        //this method will be called after constructor
    }

    @PostConstruct( 1 )
    public function doSomethingMore() : Void
    {
        //this method will be called after 'doSomething' call
    }
}
```


## Predestroy methods
```haxe
class MockClass implements IInjectorContainer
{
    public function new() {}

    @PreDestroy( 0 )
    public function doSomething() : Void
    {
        //this method will be called when this instance will be destroyed
    }

    @PreDestroy( 1 )
    public function doSomethingMore() : Void
    {
        //this method will be called after 'doSomething' call
    }
}
```
