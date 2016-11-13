package hex;

import hex.di.DISuite;

/**
 * ...
 * @author Francis Bourre
 */
class HexInjectSuite
{
	@Suite( "HexInject suite" )
    public var list : Array<Class<Dynamic>> = [ DISuite ];
}