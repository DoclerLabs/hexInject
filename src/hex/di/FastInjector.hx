package hex.di;

import hex.collection.HashMap;
import hex.di.IDependencyInjector;
import hex.di.annotation.AnnotationDataProvider;
import hex.di.error.InjectorException;
import hex.di.error.MissingClassDescriptionException;
import hex.di.error.MissingMappingException;
import hex.di.mapping.InjectionMapping;
import hex.di.provider.IDependencyProvider;
import hex.di.reflect.ClassDescription;
import hex.di.reflect.ClassDescriptionProvider;
import hex.di.reflect.FastClassDescriptionProvider;
import hex.di.reflect.IClassDescriptionProvider;
import hex.di.reflect.InjectionProcessor;
import hex.di.reflect.InjectionUtil;
import hex.event.LightweightClosureDispatcher;
import hex.log.Stringifier;
import hex.util.ClassUtil;

/**
 * ...
 * @author Francis Bourre
 */
class FastInjector implements IDependencyInjector
{
	var _ed						: LightweightClosureDispatcher<InjectionEvent>;
	var _mapping				: Map<String,InjectionMapping>;
	var _processedMapping 		: Map<String,Bool>;
	var _managedObjects			: HashMap<Dynamic, Dynamic>;
	var _parentInjector			: FastInjector;

	public function new() 
	{
		this._ed 				= new LightweightClosureDispatcher();
		this._mapping 			= new Map();
		this._processedMapping 	= new Map();
		this._managedObjects 	= new HashMap();
	}

	public function createChildInjector() : FastInjector
	{
		var injector 				= new FastInjector();
		injector._parentInjector 	= this;
		return injector;
	}

	//
	public function addEventListener( eventType : String, callback : InjectionEvent->Void ) : Bool
	{
		return this._ed.addEventListener( eventType, callback );
	}

	public function removeEventListener( eventType : String, callback : InjectionEvent->Void ) : Bool
	{
		return this._ed.removeEventListener( eventType, callback );
	}

	public function mapToValue( clazz : Class<Dynamic>, value : Dynamic, name : String = '' ) : Void
	{
		this.map( clazz, name ).toValue( value );
	}

	public function mapToType( clazz : Class<Dynamic>, type : Class<Dynamic>, name:String = '' ) : Void
	{
		this.map( clazz, name ).toType( type );
	}

	public function mapToSingleton( clazz : Class<Dynamic>, type : Class<Dynamic>, name:String = '' ) : Void
	{
		this.map( clazz, name ).toSingleton( type );
	}

    public function getInstance<T>( type : Class<T>, name : String = '' ) : T
	{
		var mappingID = this._getMappingID( type, name );
		var mapping : InjectionMapping = this._mapping[ mappingID ];

		if ( this._mapping[ mappingID ] != null )
		{
			return mapping.getResult();
		}
		else if ( this._parentInjector != null )
		{
			return this._parentInjector.getInstance( type, name );
		}
		else
		{
			throw new MissingMappingException( 	"'" + Stringifier.stringify( this ) + "' is missing a mapping to get instance with type '" +
												Type.getClassName( type ) + "' inside instance of '" + Stringifier.stringify( this ) + 
												"'. Target dependency: '" + mappingID + "'" );
		}
	}
	
	public function getProvider( type : Class<Dynamic>, name : String = '' ) : IDependencyProvider
	{
		var mappingID = this._getMappingID( type, name );
		var mapping : InjectionMapping = this._mapping[ mappingID ];

		if ( this._mapping[ mappingID ] != null )
		{
			return mapping.provider;
		}
		else if ( this._parentInjector != null )
		{
			return this._parentInjector.getInstance( type, name );
		}
		else
		{
			return null;
		}
	}
	
	inline function _getClassDescription( type : Class<Dynamic> ) : InjectionProcessor
	{
		return Reflect.getProperty( type, "__INJECTION" );
	}

    public function instantiateUnmapped( type : Class<Dynamic> ) : Dynamic
	{
		var injectionProcessor = this._getClassDescription( type );

		var instance : Dynamic; 
		if ( injectionProcessor != null && injectionProcessor.applyConstructorInjection != null )
		{
			instance = injectionProcessor.applyConstructorInjection( type, this );
		}
		else
		{
			instance = Type.createInstance( type, [] );
		}

		this._ed.dispatchEvent( new InjectionEvent( InjectionEvent.POST_INSTANTIATE, this, instance, type ) );
		
		if ( injectionProcessor != null )
		{
			this._applyInjection( instance, type, injectionProcessor );
		}

		return instance;
	}

    public function getOrCreateNewInstance<T>( type : Class<T> ) : T
	{
		return this.satisfies( type ) ? this.getInstance( type ) : this.instantiateUnmapped( type );
	}
	
	public function hasMapping( type : Class<Dynamic>, name : String = '' ) : Bool
	{
		var mappingID = this._getMappingID( type, name );
		
		if ( this._mapping[ mappingID ] != null )
		{
			return true;
		}
		else if ( this._parentInjector != null )
		{
			return this._parentInjector.hasMapping( type, name );
		}
		else
		{
			return false;
		}
	}
	
	public function unmap( type : Class<Dynamic>, name : String = '' ) : Void
	{
		var mappingID = this._getMappingID( type, name );
		var mapping = this._mapping[ mappingID ];

		#if debug
		if ( mapping == null )
		{
			throw new InjectorException( "unmap failed with mapping named '" + mappingID + "' @" + Stringifier.stringify( this ) );
		}
		#end

		mapping.provider.destroy();
		this._mapping.remove( mappingID );
	}
	
	public function hasDirectMapping( type : Class<Dynamic>, name : String = '' ) : Bool
	{
		return this._mapping[ this._getMappingID( type, name ) ] != null;
	}

    public function satisfies( type : Class<Dynamic>, name : String = '' ) : Bool
	{
		var mappingID = this._getMappingID( type, name );
		var mapping : InjectionMapping = this._mapping[ mappingID ];

		if ( this._mapping[ mappingID ] != null )
		{
			return mapping.provider != null;
		}
		else if ( this._parentInjector != null )
		{
			return this._parentInjector.satisfies( type, name );
		}
		else
		{
			return false;
		}
	}

	public function satisfiesDirectly( type : Class<Dynamic>, name : String = '' ) : Bool
	{
		var mappingID = this._getMappingID( type, name );
		var mapping : InjectionMapping = this._mapping[ mappingID ];
		
		if ( mapping != null )
		{
			return mapping.provider != null;
		}
		else
		{
			return false;
		}
	}

    public function injectInto( target : Dynamic ) : Void
	{
		var targetType : Class<Dynamic> = Type.getClass( target );
		var injectionProcessor = this._getClassDescription( targetType );
		if ( injectionProcessor != null )
		{
			this._applyInjection( target, targetType, injectionProcessor );
		}
		else
		{
			throw new MissingClassDescriptionException( "'" + Stringifier.stringify( this ) + 
														"' is missing a class description to inject into an instance of '" +
														ClassUtil.getClassName( target ) + 
														"'. This class should implement IInjectorContainer" );
		}
	}

    public function destroyInstance( instance : Dynamic ) : Void
	{
		this._managedObjects.remove( instance );

		var injectionProcessor = this._getClassDescription( Type.getClass( instance ) );
		if ( injectionProcessor != null && injectionProcessor.applyPreDestroyInjection != null )
		{
			injectionProcessor.applyPreDestroyInjection( instance, this );
		}
	}

	public function map( type : Class<Dynamic>, name : String = '' ) : InjectionMapping
	{
		var mappingID = this._getMappingID( type, name );

		if ( this._mapping[ mappingID ] != null )
		{
			return this._mapping[ mappingID ];
		}
		else
		{
			return this._createMapping( type, name, mappingID );
		}
	}

	public function teardown() : Void
	{
		for ( mapping in this._mapping )
		{
			mapping.provider.destroy();
		}

		var values = this._managedObjects.getValues();
		for ( value in values )
		{
			this.destroyInstance( value );
		}

		this._mapping 						= new Map();
		this._processedMapping 				= new Map();
		this._managedObjects 				= new HashMap();
		this._ed 							= new LightweightClosureDispatcher();
	}

	function _createMapping( type : Class<Dynamic>, name : String, mappingID : String ) : InjectionMapping
	{
		if ( this._processedMapping[ mappingID ] )
		{
			throw new InjectorException( "Mapping named '" + mappingID + "' is already processing @" + Stringifier.stringify( this ) );
		}

		this._processedMapping[ mappingID ] = true;

		var mapping = new InjectionMapping( this, type, name, mappingID );
		this._mapping[ mappingID ] = mapping;
		this._processedMapping.remove( mappingID );

		return mapping;
	}
	
	function _applyInjection( target : Dynamic, targetType : Class<Dynamic>, injectionProcessor : InjectionProcessor ) : Void
	{
		this._ed.dispatchEvent( new InjectionEvent( InjectionEvent.PRE_CONSTRUCT, this, target, targetType ) );

		injectionProcessor.applyClassInjection( target, this );
		if ( injectionProcessor.applyPreDestroyInjection != null )
		{
			this._managedObjects.put( target,  target );
		}
		
		this._ed.dispatchEvent( new InjectionEvent( InjectionEvent.POST_CONSTRUCT, this, target, targetType ) );
	}
	
	//
	inline function _getMappingID( type : Class<Dynamic>, name : String = '' ) : String
	{
		#if neko
		var className = "";
		try
		{
			className = Type.getClassName( type );
		}
		catch ( e : Dynamic )
		{
			
		}
		return className + '|' + name;
		#else
		return Type.getClassName( type ) + '|' + name;
		#end
	}
}