package hex.di.reflect;

import hex.di.reflect.ArgumentInjectionVO;

/**
 * ...
 * @author Francis Bourre
 */
typedef ConstructorInjection =
{
	public var methodName( default, null ) : String;
    public var args( default, null ) : Array<ArgumentInjectionVO>;
}
