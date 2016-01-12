package hex.control.async;

import hex.control.command.ICommand;

interface IAsyncCommand extends ICommand
{
    function preExecute() : Void;

    function cancel() : Void;

    /**
     * Event system
     */
    function addAsyncCommandListener( listener : IAsyncCommandListener ) : Void;

    function removeAsyncCommandListener( listener : IAsyncCommandListener ) : Void;

    function addCompleteHandler( scope : Dynamic, callback : AsyncCommand->Void ) : Void;

    function removeCompleteHandler( scope : Dynamic, callback : AsyncCommand->Void ) : Void;

    function addFailHandler( scope : Dynamic, callback : AsyncCommand->Void ) : Void;

    function removeFailHandler( scope : Dynamic, callback : AsyncCommand->Void ) : Void;

    function addCancelHandler( scope : Dynamic, callback : AsyncCommand->Void ) : Void;

    function removeCancelHandler( scope : Dynamic, callback : AsyncCommand->Void ) : Void;


    /**
     * State system
     */
	var wasUsed( get, null ) : Bool;
	
	var isRunning( get, null ) : Bool;

	var hasCompleted( get, null ) : Bool;

	var hasFailed( get, null ) : Bool;

	var isCancelled( get, null ) : Bool;
}
