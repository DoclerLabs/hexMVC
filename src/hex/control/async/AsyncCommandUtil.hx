package hex.control.async;

import haxe.Constraints.Function;
import hex.error.PrivateConstructorException;

/**
 * ...
 * @author Francis Bourre
 */
class AsyncCommandUtil
{
	/** @private */
	function new() 
	{
		throw new PrivateConstructorException();
	}
	
	static public function addListenersToAsyncCommand( handlers : Array<IAsyncCommand->Void>, methodToAddListener : ( IAsyncCommand->Void )->Void ) : Void
    {
        for ( handler in handlers )
        {
            methodToAddListener( handler );
        }
    }
}