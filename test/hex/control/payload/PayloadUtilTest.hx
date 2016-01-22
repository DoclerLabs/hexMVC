package hex.control.payload;

import hex.control.payload.ExecutionPayload;
import hex.control.payload.PayloadUtil;
import hex.di.IDependencyInjector;
import hex.unittest.assertion.Assert;

/**
 * ...
 * @author Francis Bourre
 */
class PayloadUtilTest
{
	@Test( "Test mapping" )
    public function testMapping() : Void
    {
		var injector 					: MockDependencyInjectorForMapping 	= new MockDependencyInjectorForMapping();
		
		var mockImplementation 			: MockImplementation 				= new MockImplementation( "mockImplementation" );
		var anotherMockImplementation 	: MockImplementation 				= new MockImplementation( "anotherMockImplementation" );
		
		var mockPayload 				: ExecutionPayload 					= new ExecutionPayload( mockImplementation, IMockType, "mockPayload" );
		var stringPayload 				: ExecutionPayload 					= new ExecutionPayload( "test", String, "stringPayload" );
		var anotherMockPayload 			: ExecutionPayload 					= new ExecutionPayload( anotherMockImplementation, IMockType, "anotherMockPayload" );
		
		var payloads 					: Array<ExecutionPayload> 	= [ mockPayload, stringPayload, anotherMockPayload ];
		PayloadUtil.mapPayload( payloads, injector );
		
        Assert.deepEquals( 	[[mockImplementation, IMockType, "mockPayload"], ["test", String, "stringPayload"], [anotherMockImplementation, IMockType, "anotherMockPayload"] ], 
									injector.mappedPayloads,
									"'CommandExecutor.mapPayload' should map right values" );
    }
	
	@Test( "Test unmapping" )
    public function testUnmapping() : Void
    {
		var injector 					: MockDependencyInjectorForMapping 	= new MockDependencyInjectorForMapping();
		
		var mockImplementation 			: MockImplementation 				= new MockImplementation( "mockImplementation" );
		var anotherMockImplementation 	: MockImplementation 				= new MockImplementation( "anotherMockImplementation" );
		
		var mockPayload 				: ExecutionPayload 					= new ExecutionPayload( mockImplementation, IMockType, "mockPayload" );
		var stringPayload 				: ExecutionPayload 					= new ExecutionPayload( "test", String, "stringPayload" );
		var anotherMockPayload 			: ExecutionPayload 					= new ExecutionPayload( anotherMockImplementation, IMockType, "anotherMockPayload" );
		
		var payloads 					: Array<ExecutionPayload> 	= [ mockPayload, stringPayload, anotherMockPayload ];
		PayloadUtil.unmapPayload( payloads, injector );
		
        Assert.deepEquals( 	[[IMockType, "mockPayload"], [String, "stringPayload"], [IMockType, "anotherMockPayload"] ], 
									injector.unmappedPayloads,
									"'CommandExecutor.mapPayload' should unmap right values" );
    }
	
}

private class MockImplementation implements IMockType
{
	public var name : String;
	
	public function new( name : String )
	{
		this.name = name;
	}
}

private interface IMockType
{
	
}

private class MockDependencyInjectorForMapping extends MockDependencyInjector
{
	public var getOrCreateNewInstanceCallCount 		: Int = 0;
	public var getOrCreateNewInstanceCallParameter 	: Class<Dynamic>;
	public var mappedPayloads 						: Array<Array<Dynamic>> = [];
	public var unmappedPayloads 					: Array<Array<Dynamic>> = [];
	
	override public function mapToValue( clazz : Class<Dynamic>, value : Dynamic, ?name : String = '' ) : Void 
	{
		this.mappedPayloads.push( [ value, clazz, name ] );
	}
	
	override public function unmap( type : Class<Dynamic>, name : String = '' ) : Void 
	{
		this.unmappedPayloads.push( [ type, name ] );
	}
	
	override public function getOrCreateNewInstance( type : Class<Dynamic> ) : Dynamic 
	{
		this.getOrCreateNewInstanceCallCount++;
		this.getOrCreateNewInstanceCallParameter = type;
		return Type.createInstance( type, [] );
	}
}

private class MockDependencyInjector implements IDependencyInjector
{
	public function new()
	{
		
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
	
	public function getInstance( type : Class<Dynamic>, name : String = '', targetType : Class<Dynamic> = null ) : Dynamic 
	{
		return null;
	}
	
	public function getOrCreateNewInstance( type : Class<Dynamic> ) : Dynamic 
	{
		return null;
	}
	
	public function instantiateUnmapped( type : Class<Dynamic> ) : Dynamic 
	{
		return null;
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
}