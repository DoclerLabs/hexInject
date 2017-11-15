package hex.di.annotation;

/**
 * @author Francis Bourre
 */
typedef InjectedDef =
{
	var applyClassInjection : Dynamic->InjectorCall->Dynamic;
	@:optional var applyConstructorInjection : Class<Dynamic>->InjectorCall->Dynamic;
	@:optional var applyPreDestroyInjection : Dynamic->InjectorCall->Dynamic;
}