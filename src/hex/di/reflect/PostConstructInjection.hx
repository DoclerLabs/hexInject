package hex.di.reflect;
import hex.di.reflect.ArgumentInjectionVO;

/**
 * ...
 * @author Francis Bourre
 */
class PostConstructInjection extends MethodInjection
{
    public var order( default, null ) : Int;

    public function new( methodName : String, args : Array<ArgumentInjectionVO>, order : Int )
    {
        super( methodName, args );
        this.order = order;
    }
}
