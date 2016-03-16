package hex.di.reflect;

import hex.di.SpeedInjector;
import hex.di.reflect.ArgumentInjectionVO;
import hex.di.error.MissingMappingException;
import hex.log.Stringifier;

/**
 * ...
 * @author Francis Bourre
 */
class ConstructorInjection extends MethodInjection
{
    public function new( args : Array<ArgumentInjectionVO> )
    {
        super( "new", args );
    }

    public function createInstance( type : Class<Dynamic>, injector : SpeedInjector ) : Dynamic
    {
        return Type.createInstance( type, this._gatherArgs( type, injector ) );
    }

    override function _throwMissingMappingException( target : Dynamic, type : Class<Dynamic>, injectionName : String, injector : SpeedInjector ) : Void
    {
        throw new MissingMappingException( "'" + Stringifier.stringify( injector ) +
        "' is missing a mapping to inject argument" +
        " with type '" + Type.getClassName( type ) +
        "' into constructor of class '" + Stringifier.stringify( target ) +
        "'. Target dependency: '" + Type.getClassName( type )
        + "|" + injectionName + "'" );
    }
}
