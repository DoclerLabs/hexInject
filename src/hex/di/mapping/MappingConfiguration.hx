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
	var _mapping = new HashMap<String, Dynamic>();
	
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
			var classKey : String;

			if ( separatorIndex != -1 )
			{
				classKey = className.substr( separatorIndex+1 );
			}
			else
			{
				classKey = className;
			}

			var helper : Helper = this.locate( className );
			var mapped : Dynamic = helper.value;

			if ( Std.is( mapped, Class ) )
			{
				if ( helper.isSingleton )
				{
					injector.mapClassNameToSingleton( classKey, mapped, helper.mapName );
				}
				else
				{
					injector.mapClassNameToType( classKey, mapped, helper.mapName );
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
				
				injector.mapClassNameToValue( classKey, mapped, helper.mapName );
			}
			
			this._mapping.put( classKey, mapped );
		}
	}
	
	public function addMapping( type : Class<Dynamic>, value : Dynamic, ?mapName : String = "", ?asSingleton : Bool = false, ?injectInto : Bool = false ) : Bool
	{
		return this._registerMapping( Type.getClassName( type ), new Helper( value, mapName, asSingleton, injectInto ), mapName );
	}
	
	public function addMappingWithClassName( className : String, value : Dynamic, ?mapName : String = "", ?asSingleton : Bool = false, ?injectInto : Bool = false ) : Bool
	{
		return this._registerMapping( className, new Helper( value, mapName, asSingleton, injectInto ), mapName );
	}
	
	public function getMapping() : HashMap<String, Dynamic>
	{
		return this._mapping;
	}
	
	function _registerMapping( className : String, helper : Helper, ?mapName : String = "" ) : Bool
	{
		var className : String = ( mapName != "" ? mapName + "#" : "" ) + className;
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