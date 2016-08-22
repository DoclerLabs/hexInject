package hex.di.reflect;

import haxe.ds.ArraySort;
import hex.collection.HashMap;
import hex.di.annotation.IAnnotationDataProvider;
import hex.di.annotation.InjectorClassVO;

/**
 * ...
 * @author Francis Bourre
 */
class ClassDescriptionProvider implements IClassDescriptionProvider
{
    var _classAnnotationDataProvider 	: IAnnotationDataProvider;
    var _classDescription   			: HashMap<Class<Dynamic>, ClassDescription>;

    public function new( classAnnotationDataProvider : IAnnotationDataProvider )
    {
        this._classAnnotationDataProvider 	= classAnnotationDataProvider;
        this._classDescription 				= new HashMap();
    }

    public function getClassDescription( type : Class<Dynamic> ) : ClassDescription
    {
        return this._classDescription.containsKey( type ) ? this._classDescription.get( type ) : this._getClassDescription( type );
    }
	
	function _getClassDescription( type : Class<Dynamic>)  : ClassDescription
    {
		/*
		var classDescription = Reflect.getProperty( type, "__INJECTION_DATA" );
		trace( classDescription );
		return classDescription;
		*/
		
		var classAnnotationData : InjectorClassVO = this._classAnnotationDataProvider.getClassAnnotationData( type );

		if ( classAnnotationData != null )
		{
			var properties 	= [ 
				for ( prop in classAnnotationData.props ) 
						{ propertyName: prop.name, propertyType: Type.resolveClass( prop.type ), injectionName: prop.key, isOptional: prop.isOpt } 
				];
			
			var methods 		: Array<MethodInjection> 	= [];
			var postConstruct 	: Array<OrderedInjection> 	= [];
			var preDestroy 		: Array<OrderedInjection> 	= [];
			
			for ( method in classAnnotationData.methods )
			{
				var arguments = [ for ( arg in method.args ) { type: Type.resolveClass( arg.type ), injectionName: arg.key, isOptional: arg.isOpt } ];
				
				if ( method.isPost )
				{
					postConstruct.push( { methodName: method.name, args: arguments, order: method.order } );
				}
				else if ( method.isPre )
				{
					preDestroy.push( { methodName: method.name, args: arguments, order: method.order } );
				}
				else
				{
					methods.push( { methodName: method.name, args: arguments } );
				}
			}
			
			if ( postConstruct.length > 0 )
			{
				ArraySort.sort( postConstruct, ClassDescriptionProvider._sort );
			}
			
			if ( preDestroy.length > 0 )
			{
				ArraySort.sort( preDestroy, ClassDescriptionProvider._sort );
			}

			var ctor = classAnnotationData.ctor;
			var ctorArguments = [ for ( arg in ctor.args ) { type: Type.resolveClass( arg.type ), injectionName: arg.key, isOptional: arg.isOpt } ];
			var constructorInjection = { methodName: 'new', args: ctorArguments };
			return { constructorInjection: constructorInjection, properties: properties, methods: methods, postConstruct: postConstruct, preDestroy: preDestroy };
		}
		else
		{
			return null;
		}
    }
	
	inline static function _sort( a : OrderedInjection, b : OrderedInjection ) : Int
	{
		return  a.order - b.order;
	}
}

