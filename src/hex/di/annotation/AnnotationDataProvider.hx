package hex.di.annotation;

import hex.collection.HashMap;
import hex.di.annotation.InjectorClassVO;

/**
 * ...
 * @author Francis Bourre
 */
class AnnotationDataProvider implements IAnnotationDataProvider
{
	var _metadataName       : String;
    var _annotatedClasses   : HashMap<Class<Dynamic>, InjectorClassVO>;
	
	//TODO refactor to remove useless class type parameter
	public function new( type : Class<Dynamic> )
    {
        this._metadataName      = Type.getClassName( type );
        this._annotatedClasses  = new HashMap();
    }
	
	public function getClassAnnotationData( type : Class<Dynamic> ) : InjectorClassVO
    {
        return this._annotatedClasses.containsKey( type ) ? this._annotatedClasses.get( type ) : this._getClassAnnotationData( type );
    }
	
	function _getClassAnnotationData( type : Class<Dynamic>)  : InjectorClassVO
    {
		//TODO get/store annotation from a place that will never risk to collide
		var field : InjectorClassVO = Reflect.getProperty( type, "__INJECTION_DATA" );
		
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