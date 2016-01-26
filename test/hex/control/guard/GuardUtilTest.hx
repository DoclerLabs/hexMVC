package hex.control.guard;

import hex.control.guard.GuardUtil;
import hex.control.guard.IGuard;
import hex.di.IDependencyInjector;
import hex.unittest.assertion.Assert;

/**
 * ...
 * @author Francis Bourre
 */
class GuardUtilTest
{
	@Test( "Test guard-class approval without injector" )
    public function testGuardClassApproveWithoutInjector() : Void
    {
		var guards : Array<Dynamic> = [ MockApproveGuard ];
        var isApproved : Bool = GuardUtil.guardsApprove( guards );
        Assert.isTrue( isApproved, "'GuardUtil.guardsApprove' property should return true" );
		
		guards = [ MockRefuseGuard ];
        isApproved = GuardUtil.guardsApprove( guards );
        Assert.isFalse( isApproved, "'GuardUtil.guardsApprove' property should return false" );
    }
	
	@Test( "Test guard-class approval with injector" )
    public function testGuardClassApproveWithInjector() : Void
    {
		var injector = new MockDependencyInjectorForTestingGuard();
		
		var guards 		: Array<Dynamic> 	= [ MockApproveGuard ];
        var isApproved 	: Bool 				= GuardUtil.guardsApprove( guards, injector );
        Assert.isTrue( isApproved, "'GuardUtil.guardsApprove' property should return true" );
		
		guards 		= [ MockRefuseGuard ];
        isApproved 	= GuardUtil.guardsApprove( guards, injector );
        Assert.isFalse( isApproved, "'GuardUtil.guardsApprove' property should return false" );
    }
}

private class MockApproveGuard implements IGuard
{
	public function approve() : Bool
	{
		return true;
	}
}

private class MockRefuseGuard implements IGuard
{
	public function approve() : Bool
	{
		return false;
	}
}

private class MockDependencyInjectorForTestingGuard extends MockDependencyInjector
{
	public function new()
	{
		
	}
	
	override public function instantiateUnmapped( type : Class<Dynamic> ) : Dynamic
	{
		return Type.createInstance( type, [] );
	}
}

private class MockDependencyInjector implements IDependencyInjector
{
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