package hex.di.reflect;

import hex.collection.HashMap;
import hex.di.IInjectable;
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
			var injectable : Array<IInjectable> = [];
			for ( prop in classAnnotationData.props )
			{
				injectable.push( new PropertyInjection( prop.name, prop.type, prop.key, prop.isOpt ) );
			}

			for ( method in classAnnotationData.methods )
			{
				var arguments : Array<ArgumentInjectionVO> = [];
				for ( arg in method.args )
				{
					arguments.push( new ArgumentInjectionVO( Type.resolveClass( arg.type ), arg.key, arg.isOpt ) );
				}
				injectable.push( new MethodInjection( method.name, arguments ) );
			}

			var ctor = classAnnotationData.ctor;
			var ctorArguments : Array<ArgumentInjectionVO> = [];
			for ( arg in ctor.args )
			{
				ctorArguments.push( new ArgumentInjectionVO( Type.resolveClass( arg.type ), arg.key, arg.isOpt ) );
			}
			var constructorInjection = new ConstructorInjection( ctorArguments );
			
			

			var classDescription : ClassDescription = new ClassDescription( injectable, constructorInjection );
			return classDescription;
		}
		else
		{
			return null;
		}
    }
}

