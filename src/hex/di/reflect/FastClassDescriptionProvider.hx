package hex.di.reflect;

import hex.di.reflect.IClassDescriptionProvider;
import hex.error.NullPointerException;

/**
 * ...
 * @author Francis Bourre
 */
class FastClassDescriptionProvider implements IClassDescriptionProvider
{
	private var _data : Map<String, ClassDescription>;
	
    public function new()
	{
		var injectionDataClass = Type.resolveClass( "InjectionData" );
		if ( injectionDataClass != null )
		{
			this._data = ( cast injectionDataClass ).data;
		}
	}

    inline public function getClassDescription( type : Class<Dynamic> ) : ClassDescription
    {
		#if debug
		if ( type == null )
		{
			throw new NullPointerException( 'type cannot be null' );
		}
		#end
		
		return this._data.get( Type.getClassName( type ) );
    }
}