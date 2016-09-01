package hex.di.reflect;

import hex.di.Injector;

/**
 * @author Francis Bourre
 */
typedef InjectionProcessor =
{
	var applyClassInjection : Dynamic->IDependencyInjector->Dynamic;
	@:optional var applyConstructorInjection : Class<Dynamic>->IDependencyInjector->Dynamic;
	@:optional var applyPreDestroyInjection : Dynamic->IDependencyInjector->Dynamic;
}