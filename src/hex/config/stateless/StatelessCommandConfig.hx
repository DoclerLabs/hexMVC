package hex.config.stateless;

import hex.config.stateless.IStatelessConfig;
import hex.control.IFrontController;
import hex.control.command.ICommand;
import hex.control.command.ICommandMapping;
import hex.di.IInjectorContainer;
import hex.error.VirtualMethodException;
import hex.event.MessageType;

/**
 * ...
 * @author Francis Bourre
 */
class StatelessCommandConfig implements IStatelessConfig implements IInjectorContainer
{
	@Inject
	public var frontController : IFrontController;

	public function new() 
	{
		
	}
	
	/**
     * Configure will be invoked after dependencies have been supplied
     */
	public function configure() : Void 
	{
		throw new VirtualMethodException();
	}
	
	/**
	 * Pair event type to a command class for future calls.
	 * @param	eventType 	The event type to bind to command class
	 * @param	command 	The command class to be associated to event type
	 * @return
	 */
	public function map( messageType : MessageType, commandClass : Class<ICommand> ) : ICommandMapping
	{
		return this.frontController.map( messageType, commandClass );
	}
}