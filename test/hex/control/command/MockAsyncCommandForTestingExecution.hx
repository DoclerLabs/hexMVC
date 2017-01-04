package hex.control.command;

import hex.control.Request;
import hex.control.async.AsyncCommand;
import hex.module.IModule;

/**
 * ...
 * @author Francis Bourre
 */
class MockAsyncCommandForTestingExecution extends AsyncCommand
{
	static public var executeCallCount 		: Int = 0;
	static public var preExecuteCallCount 	: Int = 0;
	
	static public var request 				: Request;
	static public var owner 				: IModule;
	
	static public var completeHandlers 		: Array<AsyncCommand->Void> = [];
	static public var failHandlers 			: Array<AsyncCommand->Void> = [];
	static public var cancelHandlers 		: Array<AsyncCommand->Void> = [];
	
	override public function setOwner( owner : IModule ) : Void 
	{
		MockAsyncCommandForTestingExecution.owner = owner;
	}
	
	override public function preExecute( ?request : Request ) : Void 
	{
		MockAsyncCommandForTestingExecution.preExecuteCallCount++;
	}
	
	public function execute( ?request : Request ) : Void 
	{
		MockAsyncCommandForTestingExecution.executeCallCount++;
		MockAsyncCommandForTestingExecution.request = request;
	}
	
	override public function addCompleteHandler( callback : AsyncCommand->Void ) : Void
	{
		MockAsyncCommandForTestingExecution.completeHandlers.push( callback );
	}
	
	override public function addFailHandler( callback : AsyncCommand->Void ) : Void
	{
		MockAsyncCommandForTestingExecution.failHandlers.push( callback );
	}
	
	override public function addCancelHandler( callback : AsyncCommand->Void ) : Void
	{
		MockAsyncCommandForTestingExecution.cancelHandlers.push( callback );
	}
}