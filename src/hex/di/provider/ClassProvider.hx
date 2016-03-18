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

    public function getResult( injector : SpeedInjector ) : Dynamic
    {
        return injector.instantiateUnmapped( this._type );
    }
	
	public function destroy() : Void
	{
		//do nothing
	}
}
