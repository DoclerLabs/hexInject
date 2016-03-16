/*
 * Copyright (c) 2012 the original author or authors
 *
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package hex.di;

import hex.di.IDependencyInjector;
import hex.event.BasicEvent;

@:keepSub
class InjectionEvent extends BasicEvent
{
	public inline static var POST_INSTANTIATE		: String = "onPostInstantiate";
	public inline static var PRE_CONSTRUCT			: String = "onPreConstruct";
	public inline static var POST_CONSTRUCT			: String = "onPostConstruct";

	public var instance 							: Dynamic;
	public var instanceType							: Class<Dynamic>;

	public function new( type : String, target : IDependencyInjector, instance : Dynamic, instanceType : Class<Dynamic> )
	{
		super( type, target );
		
		this.instance 		= instance;
		this.instanceType 	= instanceType;
	}

	override public function clone() : BasicEvent
	{
		return new InjectionEvent( type, target, instance, instanceType );
	}
}