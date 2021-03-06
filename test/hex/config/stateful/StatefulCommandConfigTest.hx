package hex.config.stateful;

import hex.control.IFrontController;
import hex.control.command.BasicCommand;
import hex.control.command.ICommand;
import hex.control.command.ICommandMapping;
import hex.di.IDependencyInjector;
import hex.di.IInjectorListener;
import hex.di.error.MissingMappingException;
import hex.di.provider.IDependencyProvider;
import hex.event.Dispatcher;
import hex.event.MessageType;
import hex.module.MockModule;
import hex.unittest.assertion.Assert;
import hex.util.MacroUtil;

/**
 * ...
 * @author Francis Bourre
 */
class StatefulCommandConfigTest
{

	@Test( "Test 'configure' throws 'InjectorMissingMappingError'" )
    public function testConfigureThrowsInjectorMissingMappingError() : Void
    {
		var config = new StatefulCommandConfig();
        Assert.methodCallThrows( MissingMappingException, config, config.configure, [ new MockDependencyInjector(), new MockModule() ], "constructor should throw IllegalArgumentException" );
    }
	
	@Test( "Test 'map' behavior" )
    public function testMapBehavior() : Void
    {
		var controller = new MockFrontController();
		var injector = new MockInjectorWithFrontController( controller );
		var config = new StatefulCommandConfig();
		config.configure( injector, new MockModule() );
		
		var messageType = new MessageType( "test" );
		config.map( messageType, BasicCommand );
		
        Assert.deepEquals( [ messageType, BasicCommand ], controller.mapParameters, "parameters should be the same" );
    }

	@Test( "Test class is designed for injection" )
    public function testClassIsDesignedForInjection() : Void
    {
		var b = MacroUtil.classImplementsInterface( hex.config.stateful.StatefulCommandConfig, hex.di.IInjectorContainer );
        Assert.isTrue( b, "'StatefulCommandConfig' class should implement 'IInjectorContainer' interface" );
    }
}

private class MockFrontController implements IFrontController
{
	public var mapParameters : Array<Dynamic>;
	
	public function new()
	{
		
	}
	
	public function map( messageType : MessageType, commandClass : Class<ICommand> ) : ICommandMapping 
	{
		this.mapParameters = [ messageType, commandClass ];
		return null;
	}
	
	public function unmap( messageType : MessageType ) : ICommandMapping
	{
		return null;
	}
}

private class MockInjectorWithFrontController implements IDependencyInjector
{
	var _frontcontroller : IFrontController;
	
	public function new( frontcontroller : IFrontController ) 
	{
		this._frontcontroller = frontcontroller;
	}
	
	public function hasMapping( type : Class<Dynamic>, name : String = '' ) : Bool 
	{
		return false;
	}
	
	public function hasDirectMapping( type : Class<Dynamic>, name:String = '' ) : Bool 
	{
		return false;
	}
	
	public function satisfies( type : Class<Dynamic>, name : String = '' ) : Bool 
	{
		return false;
	}
	
	public function injectInto( target : Dynamic ) : Void 
	{
		
	}
	
	public function getInstance<T>( type : Class<T>, name : String = '', targetType : Class<Dynamic> = null ) : T 
	{
		return cast this._frontcontroller;
	}
	
	public function getInstanceWithClassName<T>( className : String, name : String = '', targetType : Class<Dynamic> = null, shouldThrowAnError : Bool = true ) : T
	{
		return null;
	}
	
	public function getOrCreateNewInstance<T>( type : Class<Dynamic> ) : T 
	{
		return Type.createInstance( type, [] );
	}
	
	public function instantiateUnmapped<T>( type : Class<T> ) : T
	{
		return Type.createInstance( type, [] );
	}
	
	public function destroyInstance( instance : Dynamic ) : Void 
	{
		
	}
	
	public function mapToValue( clazz : Class<Dynamic>, value : Dynamic, ?name : String = '' ) : Void 
	{
		
	}
	
	public function mapToType( clazz : Class<Dynamic>, type : Class<Dynamic>, name : String = '' ) : Void 
	{
		
	}
	
	public function mapToSingleton( clazz : Class<Dynamic>, type : Class<Dynamic>, name : String = '' ) : Void 
	{
		
	}
	
	public function unmap( type : Class<Dynamic>, name : String = '' ) : Void 
	{
		
	}

	public function addListener( listener : IInjectorListener ) : Bool
	{
		return false;
	}

	public function removeListener( listener : IInjectorListener ) : Bool
	{
		return false;
	}
	
	public function getProvider<T>( className : String, name : String = '' ) : IDependencyProvider<T>
	{
		return null;
	}
	
	public function mapClassNameToValue( className : String, value : Dynamic, ?name : String = '' ) : Void
	{
		
	}

    public function mapClassNameToType( className : String, type : Class<Dynamic>, name:String = '' ) : Void
	{
		
	}

    public function mapClassNameToSingleton( className : String, type : Class<Dynamic>, name:String = '' ) : Void
	{
		
	}
	
	public function unmapClassName( className : String, name : String = '' ) : Void
	{
		
	}
}