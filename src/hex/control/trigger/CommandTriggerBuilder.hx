package hex.control.trigger;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Expr.Access;
import haxe.macro.Expr.Field;
import haxe.macro.Expr.Position;
import hex.control.payload.ExecutionPayload;
import hex.control.trigger.Command;
import hex.error.PrivateConstructorException;
import hex.util.MacroUtil;

using haxe.macro.Context;
using haxe.macro.Tools;

/**
 * ...
 * @author Francis Bourre
 */
@:final 
class CommandTriggerBuilder
{
	public static inline var MapAnnotation = "Map";
	
	/** @private */
    function new()
    {
        throw new PrivateConstructorException( "This class can't be instantiated." );
    }
	
	macro static public function build() : Array<Field> 
	{
		var fields 					= Context.getBuildFields();
		var CommandClassType 		= MacroUtil.getClassType( Type.getClassName( Command ) );
		var MacroCommandClassType 	= MacroUtil.getClassType( Type.getClassName( MacroCommand ) );
		
		for ( f in fields )
		{
			switch( f.kind )
			{ 
				case FFun( func ) :
				{
					var m = f.meta.filter( function ( m ) { return m.name == CommandTriggerBuilder.MapAnnotation; } );
					var isMapped = m.length > 0;
					
					if ( isMapped )
					{
						var className = Context.getLocalModule();
						
						if ( m.length > 1 )
						{
							Context.error(  "'" + f.name + "' method defines more than one command mapping (with '@" + 
											CommandTriggerBuilder.MapAnnotation + "' annotation) in '" + className + "' class", m[ 1 ].pos );
						}
						
						var meta = m[ 0 ];
						f.meta.remove( meta );
						
						var command : { name: String, pos: Position } = { name: null, pos: meta.pos };
						
						for ( param in meta.params )
						{
							switch( param.expr )
							{
								case EConst( c ):
									switch ( c )
									{
										case CIdent( v ):
											try
											{
												command.name = hex.util.MacroUtil.getClassNameFromExpr( param );
											}
											catch ( e : Dynamic )
											{
												Context.error( "Invalid class name mapped (with '@" + CommandTriggerBuilder.MapAnnotation + 
													"' annotation) to '" + f.name + "' method in '" + className + "' class", param.pos );
											}
											
											command.pos = param.pos;

										case _: 
									}
									
								case EField( e, field ):
									command.name = ( haxe.macro.ExprTools.toString( e ) + "." + field );
									command.pos = param.pos;

								case _: 
							}
						}
						
						if ( command.name == null )
						{
							Context.error( "Invalid class name mapped (with '@" + CommandTriggerBuilder.MapAnnotation + 
								"' annotation) to '" + f.name + "' method in '" + className + "' class", command.pos );
						}
						

						var typePath = MacroUtil.getTypePath( command.name, command.pos );

						if ( !MacroUtil.isSubClassOf( MacroUtil.getClassType( command.name ), CommandClassType ) )
						{
							Context.error( "'" + className + "' is mapped as a command class (with '@" + CommandTriggerBuilder.MapAnnotation + 
								"' annotation), but it doesn't extend '" + CommandClassType.module + "' class", command.pos );
						}


						var arguments :Array<Expr> = [];
						for ( arg in func.args )
						{
							var value = macro $i{arg.name};
							var typeName = getMetaValue( arg.meta, 'Type');
							if ( typeName == '' ) typeName = arg.type.toType().toString().split(' ').join('');
							var mapName = getMetaValue( arg.meta, 'Name');
							var isIgnored = hasMetaValue( arg.meta, 'Ignore');
							var typeName2 = getMetaValue( arg.meta, 'Type');

							arg.meta = [];

							if ( !isIgnored )
							{
								var fields = 
								[
									{field: "value", expr: macro $i { arg.name }}, 
									{field: "className", expr: macro $v { typeName }},
									{field: "mapName", expr: macro $v { mapName }}
								];
								arguments.push( { expr: EObjectDecl( fields ), pos: Context.currentPos() } );
							}
							
						}

						var className = MacroUtil.getPack( command.name );
						
						if ( MacroUtil.isSubClassOf( MacroUtil.getClassType( command.name ), MacroCommandClassType ) )
						{
							func.expr = macro 
							{
								var injections : Array<{value:Dynamic, className:String, mapName:String}> = $a { arguments };
								var payloads = [];
								for ( injected in injections )
								{
									payloads.push( new hex.control.payload.ExecutionPayload( injected.value, null, injected.mapName ).withClassName( injected.className ) );
								}

								this.injector.mapClassNameToValue( 'Array<hex.control.payload.ExecutionPayload>', payloads );
								
								hex.control.payload.PayloadUtil.mapPayload( payloads, this.injector );
								var command = this.injector.getOrCreateNewInstance( $p { className } );
								hex.control.payload.PayloadUtil.unmapPayload( payloads, this.injector );
								
								command.setOwner( this.module );
								command.execute();
								
								this.injector.unmapClassName( 'Array<hex.control.payload.ExecutionPayload>' );
								
								return command;
							};
						}
						else
						{
							func.expr = macro 
							{
								var injections : Array<{value:Dynamic, className:String, mapName:String}> = $a { arguments };
								var payloads = [];
								for ( injected in injections )
								{
									payloads.push( new hex.control.payload.ExecutionPayload( injected.value, null, injected.mapName ).withClassName( injected.className ) );
								}
								
								hex.control.payload.PayloadUtil.mapPayload( payloads, this.injector );
								var command = this.injector.getOrCreateNewInstance( $p { className } );
								hex.control.payload.PayloadUtil.unmapPayload( payloads, this.injector );
								
								command.setOwner( this.module );
								command.execute();
								
								
								
								return command;
							};
						}
					}
					else
					{
						CommandTriggerBuilder._searchForInjection( func.expr );
					}
				}
				
				case _:
			}
		}
		
		fields.push({ 
				kind: FVar(TPath( { name: "IModule", pack:  [ "hex", "module" ], params: [] } ), null ), 
				meta: [ { name: "Inject", params: [], pos: Context.currentPos() }, { name: ":noCompletion", params: [], pos: Context.currentPos() } ], 
				name: "module", 
				access: [ Access.APublic ],
				pos: Context.currentPos()
			});
			
		fields.push({ 
				kind: FVar(TPath( { name: "IDependencyInjector", pack:  [ "hex", "di" ], params: [] } ), null ), 
				meta: [ { name: "Inject", params: [], pos: Context.currentPos() }, { name: ":noCompletion", params: [], pos: Context.currentPos() } ], 
				name: "injector", 
				access: [ Access.APublic ],
				pos: Context.currentPos()
			});
			
		return fields;
	}
	
	static function _searchForInjection( expr : Expr ) : Void
	{
		switch( expr )
		{
			case macro {$a { args }} :
				
				for ( arg in args )
				{
					switch( arg.expr )
					{
						case EMeta( s, _.expr => EVars( vars ) ) if ( s.name == "Inject" ):
								
								var varName = vars[0].name;
								var typeName = vars[0].type.toString();
								var className = Context.getType( typeName.split('<')[0] );

								var classPack = switch( className ) 
								{ 
									case TInst( t, params ): t.toString().split('.');
									case TAbstract( t, params ): t.toString().split('.');
									case TType( t, params ): t.toString().split('.');
									case _: Context.error( 'Injection type cannot be retrieved', expr.pos );
								}
								
								if ( classPack.length > 1 ) classPack.pop();
								typeName = classPack.join('.') + '.' + typeName;

								var varType = vars[0].type;
								arg.expr = (macro var $varName : $varType = this.injector.getInstanceWithClassName( $v { typeName } )).expr;
						
						case _:
							CommandTriggerBuilder._searchForInjection( arg );
					}
				}
			case _:
		}
	}
	
	static function hasMetaValue( meta, metaName : String )
	{
		var meta = Lambda.find( meta, function(m) return m.name == metaName );
		return ( meta != null );
	}
	
	static function getMetaValue( meta : Null<Metadata>, metaName : String )
	{
		var meta : MetadataEntry = Lambda.find( meta, function(m) return m.name == metaName );
		return ( meta != null ) ?
			switch( meta.params[0].expr ) { case EConst(CString(id)): id; case _: null; }
			: '';
	}
}