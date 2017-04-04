package hex.di;

import hex.collection.HashMap;
import hex.di.IDependencyInjector;
import hex.di.IInjectorListener;
import hex.di.error.InjectorException;
import hex.di.error.MissingClassDescriptionException;
import hex.di.error.MissingMappingException;
import hex.di.mapping.InjectionMapping;
import hex.di.provider.IDependencyProvider;
import hex.di.reflect.ClassDescription;
import hex.di.reflect.FastClassDescriptionProvider;
import hex.di.reflect.IClassDescriptionProvider;
import hex.di.reflect.InjectionUtil;
import hex.error.NullPointerException;
import hex.event.ITrigger;
import hex.event.ITriggerOwner;
import hex.log.LogManager;
import hex.util.ClassUtil;

/**
 * ...
 * @author Francis Bourre
 */
class Injector 
	#if !macro
	implements ITriggerOwner
	#end
	implements IDependencyInjector
{
	var _mapping				: Map<String,InjectionMapping<Dynamic>>;
	var _processedMapping 		: Map<String,Bool>;
	var _managedObjects			: HashMap<Dynamic, Dynamic>;
	var _parentInjector			: Injector;
	var _classDescriptor		: IClassDescriptionProvider;
	
    public var trigger ( default, never ) : ITrigger<IInjectorListener>;
	
	public function new() 
	{
		this._classDescriptor	= new FastClassDescriptionProvider();

		this._mapping 			= new Map();
		this._processedMapping 	= new Map();
		this._managedObjects 	= new HashMap();
	}

	public function createChildInjector() : Injector
	{
		var injector = new Injector();
		injector.setParent( this );
		return injector;
	}
	
	//TODO write test
	public function setParent( injector : Injector ) : Void
	{
		this._parentInjector = injector;
	}

	//
	public function addListener( listener: IInjectorListener ) : Bool
	{
		return this.trigger.connect( listener );
	}
	
	public function removeListener( listener: IInjectorListener ) : Bool
	{
		return this.trigger.disconnect( listener );
	}

	public function mapToValue<T>( clazz : Class<T>, value : T, ?name : String = '' ) : Void
	{
		this.map( clazz, name ).toValue( value );
	}

	public function mapToType<T>( clazz : Class<T>, type : Class<T>, name:String = '' ) : Void
	{
		this.map( clazz, name ).toType( type );
	}

	public function mapToSingleton<T>( clazz : Class<T>, type : Class<T>, name:String = '' ) : Void
	{
		this.map( clazz, name ).toSingleton( type );
	}

    public function getInstance<T>( type : Class<T>, name : String = '' ) : T
	{
		var mappingID = this._getMappingID( type, name );
		var mapping = this._mapping[ mappingID ];

		if ( mapping != null )
		{
			return mapping.getResult( type );
		}
		else if ( this._parentInjector != null )
		{
			return this._parentInjector.getInstance( type, name );
		}
		else
		{
			throw new MissingMappingException( 	"Injector is missing a mapping to get instance with type '" +
												Type.getClassName( type ) + "'. Target dependency: '" + mappingID + "'" );
		}
	}
	
	public function getInstanceWithClassName<T>( className : String, name : String = '' ) : T
	{
		var mappingID = className + '|' + name;
		var mapping = cast this._mapping[ mappingID ];
		
		if ( mapping != null )
		{
			return mapping.getResult( Type.getClass( className.split( '<' )[ 0 ]  ) );
		}
		else if ( this._parentInjector != null )
		{
			return this._parentInjector.getInstanceWithClassName( className, name );
		}
		else
		{
			throw new MissingMappingException( 	"Injector is missing a mapping to get instance with type '" +
												className + "'. Target dependency: '" + mappingID + "'" );
		}
	}
	
	public function getProvider<T>( className : String, name : String = '' ) : IDependencyProvider<T>
	{
		var mappingID = className + '|' + name;
		var mapping = cast this._mapping[ mappingID ];

		if ( mapping != null )
		{
			return mapping.provider;
		}
		else if ( this._parentInjector != null )
		{
			return this._parentInjector.getInstance( Type.resolveClass( className.split( '<' )[ 0 ] ), name );
		}
		else
		{
			return null;
		}
	}

    public function instantiateUnmapped<T>( type : Class<T> ) : T
	{
		if ( type == null )
		{
			throw new NullPointerException( 'class description cannot be null' );
		}
		
		var classDescription = this._classDescriptor.getClassDescription( type );
		
		var instance : T; 
		if ( classDescription != null && classDescription.c != null )
		{
			instance = InjectionUtil.applyConstructorInjection( type, this, classDescription.c.a, type );
			this._applyInjection( instance, type, classDescription );
		}
		else
		{
			instance = Type.createInstance( type, [] );
		}

		return instance;
	}

    public function getOrCreateNewInstance<T>( type : Class<T> ) : T
	{
		return this.satisfies( type ) ? this.getInstance( type ) : this.instantiateUnmapped( type );
	}
	
	public function hasMapping<T>( type : Class<T>, name : String = '' ) : Bool
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
	
	public function unmap<T>( type : Class<T>, name : String = '' ) : Void
	{
		this._unmap( this._getMappingID( type, name ) );
	}
	
	public function unmapClassName( className : String, name : String = '' ) : Void
	{
		this._unmap( className + '|' + name );
	}
	
	public function hasDirectMapping( type : Class<Dynamic>, name : String = '' ) : Bool
	{
		return this._mapping[ this._getMappingID( type, name ) ] != null;
	}

    public function satisfies( type : Class<Dynamic>, name : String = '' ) : Bool
	{
		var mappingID = this._getMappingID( type, name );
		var mapping = cast this._mapping[ mappingID ];

		if ( mapping != null )
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
		var mapping = cast this._mapping[ mappingID ];
		
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
		var classDescription = this._classDescriptor.getClassDescription( targetType );
		if ( classDescription != null )
		{
			this._applyInjection( target, targetType, classDescription );
		}
		else
		{
			throw new MissingClassDescriptionException( "Injector is missing a class description to inject into an instance of '" +
														ClassUtil.getClassName( target ) + 
														"'. This class should implement IInjectorContainer" );
		}
	}

    public function destroyInstance( instance : Dynamic ) : Void
	{
		if( !Reflect.isFunction( instance ) )
		{
			this._managedObjects.remove( instance );

			var classDescription = this._classDescriptor.getClassDescription( Type.getClass( instance ) );
			if ( classDescription != null )
			{
				for ( preDestroy in classDescription.pd )
				{
					InjectionUtil.applyMethodInjection( instance, this, Type.getClass( instance ), preDestroy.a, preDestroy.m );
				}
			}
		}
	}

	public function map<T>( type : Class<T>, name : String = '' ) : InjectionMapping<T>
	{
		var mappingID = this._getMappingID( type, name );

		if ( this._mapping[ mappingID ] != null )
		{
			return cast this._mapping[ mappingID ];
		}
		else
		{
			return this._createMapping( name, mappingID );
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
		
		#if !macro
		this.trigger.disconnectAll();
		#end
	}
	
	public function mapClassName<T>( className : String, name : String = '' ) : InjectionMapping<T>
	{
		var mappingID = className + '|' + name;
		
		if ( this._mapping[ mappingID ] != null )
		{
			return cast this._mapping[ mappingID ];
		}
		else
		{
			return this._createMapping( name, mappingID );
		}
	}
	
	public function mapClassNameToValue<T>( className : String, value : T, ?name : String = '' ) : Void
	{
		this.mapClassName( className, name ).toValue( value );
	}

    public function mapClassNameToType<T>( className : String, type : Class<T>, name:String = '' ) : Void
	{
		this.mapClassName( className, name ).toType( type );
	}

    public function mapClassNameToSingleton<T>( className : String, type : Class<T>, name:String = '' ) : Void
	{
		this.mapClassName( className, name ).toSingleton( type );
	}
	
	//
	inline function _unmap( mappingID : String ): Void
	{
		var mapping = this._mapping[ mappingID ];

		#if debug
		if ( mapping == null )
		{
			LogManager.getLoggerByInstance(this).warn( "Unmap failed with mapping named '" + mappingID + 
					"'. Maybe this mapping was overridden previously." );
		}
		#end

		if ( mapping != null )
		{
			mapping.provider.destroy();
			this._mapping.remove( mappingID );
		}
	}

	function _createMapping<T>( name : String, mappingID : String ) : InjectionMapping<T>
	{
		if ( this._processedMapping[ mappingID ] )
		{
			throw new InjectorException( "Mapping named '" + mappingID + "' is already processing" );
		}

		this._processedMapping[ mappingID ] = true;

		var mapping = new InjectionMapping( this, mappingID );
		this._mapping[ mappingID ] = mapping;
		this._processedMapping.remove( mappingID );

		return mapping;
	}
	
	function _applyInjection( target : Dynamic, targetType : Class<Dynamic>, classDescription : ClassDescription ) : Void
	{
		#if !macro
		this.trigger.onPreConstruct( this, target, targetType );
		#end

		InjectionUtil.applyClassInjection( target, this, classDescription, targetType );
		if ( classDescription.pd.length > 0  && !Reflect.isFunction(target) )
		{
			this._managedObjects.put( target,  target );
		}
		
		#if !macro
		this.trigger.onPostConstruct( this, target, targetType );
		#end
	}
	
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