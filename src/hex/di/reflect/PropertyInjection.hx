package hex.di.reflect;

/**
 * ...
 * @author Francis Bourre
 */
typedef PropertyInjection =
{
	var propertyName 	: String;
	var propertyType 	: Class<Dynamic>;
	var injectionName 	: String;
	var isOptional 		: Bool;
}