package hex.di.mock.injectees;

import hex.log.ILogger;
import hex.log.ILoggerContext;
import hex.log.LogLevel;
import hex.log.message.IMessage;
import hex.log.PosInfos;

/**
 * ...
 * @author 
 */
class MockLogger implements ILogger
{
	public var debugMsg : Dynamic;
	public var debugParams : Dynamic;
	public var infoMsg 	: Dynamic;
	public var infoParams 	: Dynamic;
	public var warnMsg 	: Dynamic;
	public var warnParams 	: Dynamic;
	public var errorMsg : Dynamic;
	public var errorParams : Dynamic;
	public var fatalMsg : Dynamic;
	public var fatalParams : Dynamic;
	
	public function new()
	{
		
	}
	
	public function debug(message:Dynamic, ?params:Array<Dynamic>, ?posInfos:PosInfos):Void 
	{
		debugMsg = message;
		debugParams = params;
	}
	
	public function info(message:Dynamic, ?params:Array<Dynamic>, ?posInfos:PosInfos):Void 
	{
		infoMsg = message;
		infoParams = params;
	}
	
	public function warn(message:Dynamic, ?params:Array<Dynamic>, ?posInfos:PosInfos):Void 
	{
		warnMsg = message;
		warnParams = params;
	}
	
	public function error(message:Dynamic, ?params:Array<Dynamic>, ?posInfos:PosInfos):Void 
	{
		errorMsg = message;
		errorParams = params;
	}
	
	public function fatal(message:Dynamic, ?params:Array<Dynamic>, ?posInfos:PosInfos):Void 
	{
		fatalMsg = message;
		fatalParams = params;
	}
	
	public function debugMessage(message:IMessage, ?posInfos:PosInfos):Void 
	{
		
	}
	
	public function infoMessage(message:IMessage, ?posInfos:PosInfos):Void 
	{
		
	}
	
	public function warnMessage(message:IMessage, ?posInfos:PosInfos):Void 
	{
		
	}
	
	public function errorMessage(message:IMessage, ?posInfos:PosInfos):Void 
	{
		
	}
	
	public function fatalMessage(message:IMessage, ?posInfos:PosInfos):Void 
	{
		
	}
	
	public function log(level:LogLevel, message:Dynamic, ?params:Array<Dynamic>, ?posInfos:PosInfos):Void 
	{
		
	}
	
	public function logMessage(level:LogLevel, message:IMessage, ?posInfos:PosInfos):Void 
	{
		
	}
	
	public function getLevel():LogLevel 
	{
		return LogLevel.OFF;
	}
	
	public function getName():String 
	{
		return null;
	}
	
	public function getContext():ILoggerContext 
	{
		return null;
	}
}
