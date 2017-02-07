package hex.di.mapping;

import hex.event.MessageType;
import hex.service.stateful.StatefulService;

/**
 * ...
 * @author Francis Bourre
 */
class MockStatefulService extends StatefulService
{
	public function new()
	{
		super();
	}
	
	public function dispatch( messageType : MessageType, data : Array<Dynamic> ) : Void
	{
		this._compositeDispatcher.dispatch( messageType, data );
	}
}