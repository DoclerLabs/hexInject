package hex.di.reflect;

import hex.di.reflect.IClassDescriptionProvider;
import hex.error.NullPointerException;

/**
 * ...
 * @author Francis Bourre
 */
class FastClassDescriptionProvider implements IClassDescriptionProvider
{
    public function new()
    {
    }

    inline public function getClassDescription( type : Class<Dynamic> ) : ClassDescription
    {
		#if debug
		if ( type == null )
		{
			throw new NullPointerException( '' );
		}
		return Reflect.getProperty( type, "__INJECTION_DATA" );
		#else
		return Reflect.getProperty( type, "__INJECTION_DATA" );
		#end
    }
}