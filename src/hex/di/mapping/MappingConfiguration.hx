package hex.di.mapping;

import hex.collection.HashMap;
import hex.collection.Locator;
import hex.config.stateful.IStatefulConfig;
import hex.di.IDependencyInjector;
import hex.event.CompositeDispatcher;
import hex.event.IDispatcher;
import hex.module.IModule;
import hex.service.stateful.IStatefulService;

/**
 * ...
 * @author Francis Bourre
 */
class MappingConfiguration extends Locator<String, Helper> implements IStatefulConfig
{
	var _mapping = new HashMap<Class<Dynamic>, Dynamic>();
	
	public function new() 
	{
		super();
	}
	
	public function configure( injector : IDependencyInjector, dispatcher : IDispatcher<{}>, module : IModule ) : Void
	{
		var keys = this.keys();
        for ( className in keys )
        {
			var separatorIndex 	: Int = className.indexOf( "#" );
			var classKey : Class<Dynamic>;

			if ( separatorIndex != -1 )
			{
				classKey = Type.resolveClass( className.substr( separatorIndex+1 ) );
			}
			else
			{
				classKey = Type.resolveClass( className );
			}

			var helper : Helper = this.locate( className );
			var mapped : Dynamic = helper.value;

			if ( Std.is( mapped, Class ) )
			{
				if ( helper.isSingleton )
				{
					injector.mapToSingleton( classKey, mapped, helper.mapName );
				}
				else
				{
					injector.mapToType( classKey, mapped, helper.mapName );
				}
			}
			else
			{
				if ( Std.is( mapped, IStatefulService ) )
				{
					var serviceDispatcher : CompositeDispatcher = ( cast mapped ).getDispatcher();
					if ( serviceDispatcher != null )
					{
						serviceDispatcher.add( dispatcher );
					}
				}

				if ( helper.injectInto )
				{
					injector.injectInto( mapped );
				}
				
				injector.mapToValue( classKey, mapped, helper.mapName );
			}
			
			this._mapping.put( classKey, mapped );
		}
	}
	
	public function addMapping( type : Class<Dynamic>, value : Dynamic, ?mapName : String = "", ?asSingleton : Bool = false, ?injectInto : Bool = false ) : Bool
	{
		return this._registerMapping( type, new Helper( value, mapName, asSingleton, injectInto ), mapName );
	}
	
	public function getMapping() : HashMap<Class<Dynamic>, Dynamic>
	{
		return this._mapping;
	}
	
	function _registerMapping( type : Class<Dynamic>, helper : Helper, ?mapName : String = "" ) : Bool
	{
		var className : String = ( mapName != "" ? mapName + "#" : "" ) + Type.getClassName( type );
		return this.register( className, helper );
	}
}

private class Helper
{
	public var value		: Dynamic;
	public var mapName		: String;
	public var isSingleton	: Bool;
	public var injectInto	: Bool;

	public function new( value : Dynamic, mapName : String, ?isSingleton : Bool, injectInto : Bool )
	{
		this.value 			= value;
		this.mapName 		= mapName;
		this.isSingleton 	= isSingleton;
		this.injectInto 	= injectInto;
	}
	
	public function toString() : String
	{
		return 'Helper( value:$value, mapName:$mapName, isSingleton:$isSingleton, injectInto:$injectInto )';
	}
}