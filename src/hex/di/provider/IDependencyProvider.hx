package hex.di.provider;

/**
 * ...
 * @author Francis Bourre
 */
interface IDependencyProvider
{
    function getResult( injector : Injector ) : Dynamic;
	function destroy() : Void;
}
