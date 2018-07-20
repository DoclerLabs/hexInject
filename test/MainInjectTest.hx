package;

import hex.HexInjectSuite;
import hex.unittest.runner.ExMachinaUnitCore;

/**
 * ...
 * @author Francis Bourre
 */
class MainInjectTest
{
	static public function main() : Void
	{
		var emu = new ExMachinaUnitCore();

		#if travix
		emu.addListener( new hex.unittest.notifier.TravixNotifier( ) );
		#elseif flash
		emu.addListener( new hex.unittest.notifier.TraceNotifier( flash.Lib.current.loaderInfo, false, true ) );
		#elseif (php && haxe_ver < 4.0)
		emu.addListener( new hex.unittest.notifier.TraceNotifier( ) );
		#else
		emu.addListener( new hex.unittest.notifier.ConsoleNotifier( ) );
		#end
		emu.addListener( new hex.unittest.notifier.ExitingNotifier( ) );
		
        emu.addTest( HexInjectSuite );
        emu.run();
	}
}
