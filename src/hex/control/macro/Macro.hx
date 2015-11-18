package hex.control.macro;

import hex.control.async.AsyncCommand;
import hex.control.async.IAsyncCommand;
import hex.control.async.IAsyncCommandListener;
import hex.control.command.ICommand;
import hex.control.command.ICommandMapping;
import hex.error.NullPointerException;
import hex.error.VirtualMethodException;
import hex.event.BasicEvent;
import hex.event.IEvent;
import hex.log.Stringifier;

/**
 * ...
 * @author Francis Bourre
 */
class Macro extends AsyncCommand implements IAsyncCommandListener
{
	private var _event 				: IEvent;
	private var _isAtomic 			: Bool = true;
    private var _isSequenceMode 	: Bool = true;
	
	@inject
	public var macroExecutor 		: IMacroExecutor;

	public function new() 
	{
		super();
		
		this.isAtomic 			= true;
		this.isInSequenceMode 	= true;
	}
	
	private function _prepare() : Void
	{
		throw new VirtualMethodException( this + ".execute must be overridden" );
	}
	
	override public function preExecute() : Void
	{
		if ( this.macroExecutor != null )
		{
			this.macroExecutor.setAsyncCommandListener( this );
		}
		else
		{
			throw new NullPointerException( "macroExecutor can't be null in '" + Stringifier.stringify( this ) + "'" );
		}
		
		this._prepare();
		super.preExecute();
	}
	
	@:final 
	override public function execute( ?e : IEvent ) : Void
	{
		!this.isRunning && this._throwExecutionIllegalStateError();
		this._event = e;
		this._executeNextCommand();
	}
	
	public function add( commandClass : Class<ICommand> ) : ICommandMapping
	{
		return this.macroExecutor.add( commandClass );
	}
	
	public function addMapping( mapping : ICommandMapping ) : ICommandMapping
	{
		return this.macroExecutor.addMapping( mapping );
	}
	
	private function _executeCommand() : Void
	{
		var command : ICommand = this.macroExecutor.executeNextCommand( this._event );
		
		if ( command != null )
		{
			var isAsync : Bool = Std.is( command, IAsyncCommand );
			
			if ( !isAsync || this.isInParallelMode )
			{
				this._executeNextCommand();
			}
		}
	}
	
	private function _executeNextCommand() : Void
	{
		if ( this.macroExecutor.hasNextCommandMapping )
		{
			this._executeCommand();
		}
		else if ( this.macroExecutor.hasRunEveryCommand )
		{
			this._handleComplete();
		}
	}
	
	@:isVar public var isAtomic( get, set ) : Bool;
	function get_isAtomic() : Bool
	{
		return this.isAtomic;
	}
	
	function set_isAtomic( value : Bool ) : Bool
	{
		this.isAtomic = value;
		return value;
	}
	
	@:isVar public var isInSequenceMode( get, set ) : Bool;
	function get_isInSequenceMode() : Bool
	{
		return this.isInSequenceMode;
	}
	
	function set_isInSequenceMode( value : Bool ) : Bool
	{
		this.isInSequenceMode = value;
		return value;
	}
	
	public var isInParallelMode( get, set ) : Bool;
	function get_isInParallelMode() : Bool
	{
		return !this.isInSequenceMode;
	}
	
	function set_isInParallelMode( value : Bool ) : Bool
	{
		this.isInSequenceMode = !value;
		return this.isInSequenceMode;
	}
	
	public function onAsyncCommandComplete( e : BasicEvent ) : Void
	{
		this.macroExecutor.asyncCommandCalled( cast e.target );
		this._executeNextCommand();
	}

	public function onAsyncCommandFail( e : BasicEvent ) : Void
	{
		// I have to check if it's not null because the macroexecutor calls out when a guard protected the run of a command. Then it handles itself the callNotification - Duke
		if ( e != null && e.target != null )
		{
			this.macroExecutor.asyncCommandCalled( cast e.target );
		}
		
		if ( this.isAtomic )
		{
			if ( this.isRunning )
			{
				this._handleFail();
			}
		}
		else
		{
			this._executeNextCommand();
		}
	}

	public function onAsyncCommandCancel( e : BasicEvent ) : Void
	{
		this.macroExecutor.asyncCommandCalled( cast e.target );
		
		if ( this.isAtomic )
		{
			this.cancel();
		}
		else
		{
			this._executeNextCommand();
		}
	}
	
	public function toString() : String
	{
		return Stringifier.stringify( this );
	}
}