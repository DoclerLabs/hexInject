package hex.di.provider;

/**
 * ...
 * @author Francis Bourre
 */
class ClassProvider implements IDependencyProvider
{
    var _type : Class<Dynamic>;

    public function new( type : Class<Dynamic> )
    {
        this._type = type;
    }

    inline public function getResult( injector : Injector ) : Dynamic
    {
        return injector.instantiateUnmapped( this._type );
    }
	
	public function destroy() : Void
	{
		//do nothing
	}
}
