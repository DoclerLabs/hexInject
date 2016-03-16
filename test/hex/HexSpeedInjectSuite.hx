package hex;

import hex.di.DISuite;
import hex.di.annotation.AnnotationSuite;

/**
 * ...
 * @author Francis Bourre
 */
class HexSpeedInjectSuite
{
	@Suite( "HexSpeedInject suite" )
    public var list : Array<Class<Dynamic>> = [ AnnotationSuite, DISuite ];
}