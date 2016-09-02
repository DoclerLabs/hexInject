package hex.di.annotation;

import hex.collection.HashMap;
import hex.di.annotation.InjectorClassVO;

/**
 * ...
 * @author Francis Bourre
 */
class AnnotationDataProvider implements IAnnotationDataProvider
{
	var _key       			: String;
    var _annotatedClasses   : HashMap<Class<Dynamic>, InjectorClassVO>;
	
	public function new( key : String = "__INJECTION_DATA" )
    {
        this._key      			= key;
        this._annotatedClasses  = new HashMap();
    }
	
	public function getClassAnnotationData( type : Class<Dynamic> ) : InjectorClassVO
    {
        return this._annotatedClasses.containsKey( type ) ? this._annotatedClasses.get( type ) : this._getClassAnnotationData( type );
    }
	
	function _getClassAnnotationData( type : Class<Dynamic>)  : InjectorClassVO
    {
		//TODO get/store annotation from a place that will never risk to collide
		var field : InjectorClassVO = Reflect.getProperty( type, this._key );
		
		if ( field != null )
		{
			this._annotatedClasses.put( type, field );
			return field;
		}
		else
        {
            return null;
        }
    }
}