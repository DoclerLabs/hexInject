package hex.di.reflect;

import hex.di.IInjectable;
import hex.di.SpeedInjector;
import hex.di.reflect.ArgumentInjectionVO;
import hex.di.error.MissingMappingException;
import hex.log.Stringifier;

/**
 * ...
 * @author Francis Bourre
 */
class MethodInjection implements IInjectable
{
    public var methodName( default, null ) : String;
    public var args( default, null ) : Array<ArgumentInjectionVO>;

    public function new( methodName : String, args : Array<ArgumentInjectionVO> )
    {
        this.methodName = methodName;
        this.args = args;
    }

    public function applyInjection( target : Dynamic, injector : SpeedInjector ) : Dynamic
    {
        Reflect.callMethod( target, Reflect.field( target, this.methodName ), this._gatherArgs( target, injector ) );
        return target;
    }

    function _gatherArgs( target : Dynamic, injector : SpeedInjector ) : Array<Dynamic>
    {
        var args = [];
        for ( arg in this.args )
        {
			var provider = injector.getProvider( arg.type, arg.injectionName );

			if ( provider != null )
			{
				args.push( provider.getResult( injector ) );
			}
			else if ( !arg.isOptional )
			{
				this._throwMissingMappingException( target, arg.type, arg.injectionName, injector );
			}
		}
			
		return args;
    }

    function _throwMissingMappingException( target : Dynamic, type : Class<Dynamic>, injectionName : String, injector : SpeedInjector ) : Void
    {
        throw new MissingMappingException( "'" + Stringifier.stringify( injector ) +
        "' is missing a mapping to inject argument into method named '" +
        this.methodName + "' with type '" + Type.getClassName( type ) +
        "' inside instance of '" + Stringifier.stringify( target ) +
        "'. Target dependency: '" + Type.getClassName( type )
        + "|" + injectionName + "'" );
    }
}
