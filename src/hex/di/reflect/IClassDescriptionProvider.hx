package hex.di.reflect;

/**
 * ...
 * @author Francis Bourre
 */
interface IClassDescriptionProvider
{
    function getClassDescription( type : Class<Dynamic> ) : ClassDescription;
}
