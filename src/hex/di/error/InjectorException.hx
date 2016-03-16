package hex.di.error;

import hex.error.Exception;
import haxe.PosInfos;

/**
 * ...
 * @author Francis Bourre
 */
class InjectorException extends Exception
{
	public function new( message : String, ?posInfos : PosInfos )
    {
        super( message, posInfos );
    }
}