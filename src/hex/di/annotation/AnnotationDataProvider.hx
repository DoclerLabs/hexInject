package hex.di.annotation;

import haxe.Json;
import haxe.rtti.Meta;
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
        var meta = Reflect.field( Meta.getType( type ), this._metadataName );
        if ( meta != null )
        {
            var classAnnotationData : InjectorClassVO = Json.parse( meta );
            this._annotatedClasses.put( type, classAnnotationData );
            return Json.parse( meta );
        }
        else
        {
            return null;
        }
    }
}