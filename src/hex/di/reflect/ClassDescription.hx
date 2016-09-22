package hex.di.reflect;

/**
 * ...
 * @author Francis Bourre
 */
typedef ClassDescription =
{
	//constructorInjection
	public var c : ConstructorInjection;
	
	//properties
	public var p : Array<PropertyInjection>;
	
	//methods
	public var m : Array<MethodInjection>;
	
	//postConstruct
	public var pc : Array<OrderedInjection>;
	
	//preDestroy
	public var pd : Array<OrderedInjection>;
}