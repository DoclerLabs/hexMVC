package hex.view.viewhelper;

import hex.event.MessageType;
import hex.log.ILogger;
import hex.module.IModule;

/**
 * @author Francis Bourre
 */
interface IViewHelper<ViewType:IView>  
{
	var view( get, set ) : ViewType;
	
	function getOwner() : IModule;
	
	function setOwner( owner : IModule ) : Void;
	
	function getLogger() : ILogger;
	
	function show() : Void;
	
	function hide() : Void;
	
	var visible( get, set ) : Bool;
	
	function release() : Void;
	
	function addHandler( messageType : MessageType, callback : haxe.Constraints.Function ) : Void;
	
	function removeHandler( messageType : MessageType, callback : haxe.Constraints.Function ) : Void;
}