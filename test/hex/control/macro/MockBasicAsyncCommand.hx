package hex.control.macro;

import haxe.Timer;
import hex.control.async.AsyncCommand;

/**
 * ...
 * @author Francis Bourre
 */
class MockBasicAsyncCommand extends AsyncCommand
{
	override public function execute() : Void
	{
		Timer.delay( this._handleComplete, 50 );
	}
}