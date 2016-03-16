package hex.di.error;

import haxe.PosInfos;

/**
 * ...
 * @author Francis Bourre
 */
class MissingMappingException extends InjectorException
{
	public function new( message : String, ?posInfos : PosInfos )
    {
        super( message, posInfos );
    }
}