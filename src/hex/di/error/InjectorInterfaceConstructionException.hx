package hex.di.error;

import haxe.PosInfos;

/**
 * ...
 * @author Francis Bourre
 */
class InjectorInterfaceConstructionException extends InjectorException
{
	public function new ( message : String, ?posInfos : PosInfos )
    {
        super( message, posInfos );
    }
}