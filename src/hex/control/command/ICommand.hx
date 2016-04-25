package hex.control.command;

import hex.control.payload.ExecutionPayload;
import hex.log.ILogger;
import hex.module.IModule;

/**
 * ...
 * @author Francis Bourre
 */
interface ICommand
{
	var executeMethodName( default, null ) : String;

    function getResult() : Array<Dynamic>;
	
	function getReturnedExecutionPayload() : Array<ExecutionPayload>;

    function getLogger() : ILogger;
	
    function getOwner() : IModule;

    function setOwner( owner : IModule ) : Void;
}
