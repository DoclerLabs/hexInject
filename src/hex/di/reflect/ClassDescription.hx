package hex.di.reflect;

/**
 * ...
 * @author Francis Bourre
 */
typedef ClassDescription =
{
	public var constructorInjection : ConstructorInjection;
	public var properties 			: Array<PropertyInjection>;
	public var methods 				: Array<MethodInjection>;
	public var postConstruct 		: Array<OrderedInjection>;
	public var preDestroy 			: Array<OrderedInjection>;
}