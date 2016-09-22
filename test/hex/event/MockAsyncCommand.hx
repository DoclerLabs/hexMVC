package hex.event;

import hex.control.Request;
import hex.control.async.AsyncCommand;
import hex.di.IInjectorContainer;

/**
 * ...
 * @author Francis Bourre
 */
class MockAsyncCommand extends AsyncCommand
{
	@Inject
	public var data : MockValueObject;
	
	public function execute( ?request : Request ) : Void
    {
		this.data.value += "!";
		this._handleComplete();
	}
}
