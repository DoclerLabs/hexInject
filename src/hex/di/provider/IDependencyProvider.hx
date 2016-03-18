package hex.di.provider;

/**
 * ...
 * @author Francis Bourre
 */
interface IDependencyProvider
{
    function getResult( injector : SpeedInjector ) : Dynamic;
	function destroy() : Void;
}
