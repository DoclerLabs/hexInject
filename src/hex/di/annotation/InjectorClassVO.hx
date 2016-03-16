package hex.di.annotation;

/**
 * @author Francis Bourre
 */
typedef InjectorClassVO =
{
	name 	: String,
	ctor 	: InjectorMethodVO,
	props 	: Array<InjectorPropertyVO>,
	methods : Array<InjectorMethodVO>	
}