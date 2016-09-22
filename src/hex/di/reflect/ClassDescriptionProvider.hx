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
		var classAnnotationData : InjectorClassVO = this._classAnnotationDataProvider.getClassAnnotationData( type );

		if ( classAnnotationData != null )
		{
			var properties 	= [ 
				for ( prop in classAnnotationData.props ) 
						{ p: prop.name, t: prop.type, n: prop.key, o: prop.isOpt } 
				];
			
			var methods 		: Array<MethodInjection> 	= [];
			var postConstruct 	: Array<OrderedInjection> 	= [];
			var preDestroy 		: Array<OrderedInjection> 	= [];
			
			for ( method in classAnnotationData.methods )
			{
				var arguments = [ for ( arg in method.args ) { t: arg.type, n: arg.key, o: arg.isOpt } ];
				
				if ( method.isPost )
				{
					postConstruct.push( { m: method.name, a: arguments, o: method.order } );
				}
				else if ( method.isPre )
				{
					preDestroy.push( { m: method.name, a: arguments, o: method.order } );
				}
				else
				{
					methods.push( { m: method.name, a: arguments } );
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
			var ctorArguments = [ for ( arg in ctor.args ) { t: arg.type, n: arg.key, o: arg.isOpt } ];
			var constructorInjection = { a: ctorArguments };
			return { c: constructorInjection, p: properties, m: methods, pc: postConstruct, pd: preDestroy };
		}
		else
		{
			return null;
		}
    }
	
	inline static function _sort( a : OrderedInjection, b : OrderedInjection ) : Int
	{
		return  a.o - b.o;
	}
}

