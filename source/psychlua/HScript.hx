package psychlua;

import flixel.FlxBasic;
import psychlua.FunkinLua;
import psychlua.CustomSubstate;

#if (!flash && sys)
import flixel.addons.display.FlxRuntimeShader;
#end

#if hscript
import hscript.Parser;
import hscript.Interp;
import hscript.Expr;
import haxe.Exception;
#end

#if (HSCRIPT_ALLOWED && SScript >= "3.0.0")
import tea.SScript;
class HScript extends SScript
{
	public var parentLua:FunkinLua;
	
	public static function initHaxeModule(parent:FunkinLua)
	{
		#if (SScript >= "3.0.0")
		if(parent.hscript == null)
		{
			trace('initializing haxe interp for: ${parent.scriptName}');
			parent.hscript = new HScript(parent);
		}
		#end
	}

	public static function initHaxeModuleCode(parent:FunkinLua, code:String)
	{
		#if (SScript >= "3.0.0")
		if(parent.hscript == null)
		{
			trace('initializing haxe interp for: ${parent.scriptName}');
			parent.hscript = new HScript(parent, code);
		}
		#end
	}
	public var origin:String;
	override public function new(?parent:FunkinLua, ?file:String)
	{
		if (file == null)
			file = '';
	
		super(file, false, false);
		parentLua = parent;
		if (parent != null)
			origin = parent.scriptName;
		if (scriptFile != null && scriptFile.length > 0)
			origin = scriptFile;
		preset();
		execute();
	}

	override function preset()
	{
		#if (SScript >= "3.0.0")
		super.preset();

		// Some very commonly used classes
		set('FlxG', flixel.FlxG);
		set('FlxMath', flixel.math.FlxMath);
		set('FlxSprite', flixel.FlxSprite);
		set('FlxText', flixel.text.FlxText);
		set('FlxCamera', flixel.FlxCamera);
		set('PsychCamera', backend.PsychCamera);
		set('FlxTimer', flixel.util.FlxTimer);
		set('FlxTween', flixel.tweens.FlxTween);
		set('FlxEase', flixel.tweens.FlxEase);
		set('FlxColor', CustomFlxColor);
		set('Countdown', backend.BaseStage.Countdown);
		set('PlayState', PlayState);
		set('Paths', Paths);
		set('Conductor', Conductor);
		set('ClientPrefs', ClientPrefs);
		#if ACHIEVEMENTS_ALLOWED
		set('Achievements', Achievements);
		#end
		set('Character', Character);
		set('Alphabet', Alphabet);
		set('Note', Note);
		set('CustomSubstate', psychlua.CustomSubstate);
		#if (!flash && sys)
		set('FlxRuntimeShader', flixel.addons.display.FlxRuntimeShader);
		#end
		set('ShaderFilter', openfl.filters.ShaderFilter);
		set('StringTools', StringTools);
		#if flxanimate
		set('FlxAnimate', FlxAnimate);
		#end

		// Functions & Variables
		set('setVar', function(name:String, value:Dynamic)
		{
			PlayState.instance.variables.set(name, value);
		});
		set('getVar', function(name:String)
		{
			var result:Dynamic = null;
			if(PlayState.instance.variables.exists(name)) result = PlayState.instance.variables.get(name);
			return result;
		});
		set('removeVar', function(name:String)
		{
			if(PlayState.instance.variables.exists(name))
			{
				PlayState.instance.variables.remove(name);
				return true;
			}
			return false;
		});
		set('debugPrint', function(text:String, ?color:FlxColor = null) {
			if(color == null) color = FlxColor.WHITE;
			PlayState.instance.addTextToDebug(text, color);
		});

		// For adding your own callbacks

		// not very tested but should work
		set('createGlobalCallback', function(name:String, func:Dynamic)
		{
			#if LUA_ALLOWED
			for (script in PlayState.instance.luaArray)
				if(script != null && script.lua != null && !script.closed)
					Lua_helper.add_callback(script.lua, name, func);
			#end
			FunkinLua.customFunctions.set(name, func);
		});
		
		set('addHScriptVirtualPad', function(?DPad:FlxDPadMode, ?Action:FlxActionMode):Void
		{
		    MusicBeatState.instance.addVirtualPad(DPad, Action);
		});
		
		set('addHScriptVirtualPadCamera', function():Void
		{
			MusicBeatState.instance.addVirtualPadCamera();
		});

		// tested
		set('createCallback', function(name:String, func:Dynamic, ?funk:FunkinLua = null)
		{
			if(funk == null) funk = parentLua;
			
			if(parentLua != null) Lua_helper.add_callback(funk.lua, name, func);
			else FunkinLua.luaTrace('createCallback ($name): 3rd argument is null', false, false, FlxColor.RED);
		});

		set('addHaxeLibrary', function(libName:String, ?libPackage:String = '') {
			try {
				var str:String = '';
				if(libPackage.length > 0)
					str = libPackage + '.';

				set(libName, Type.resolveClass(str + libName));
			}
			catch (e:Dynamic) {
				var msg:String = e.message.substr(0, e.message.indexOf('\n'));
				if(parentLua != null)
				{
					FunkinLua.lastCalledScript = parentLua;
					msg = origin + ":" + parentLua.lastCalledFunction + " - " + msg;
				}
				else msg = '$origin - $msg';
				FunkinLua.luaTrace(msg, parentLua == null, false, FlxColor.RED);
			}
		});
		#if LUA_ALLOWED
		set('parentLua', parentLua);
		#else
		set('parentLua', null);
		#end
		set('this', this);
		set('game', FlxG.state);
		set('controls', Controls);

		set('buildTarget', FunkinLua.getBuildTarget());
		set('customSubstate', CustomSubstate.instance);
		set('customSubstateName', CustomSubstate.name);

		set('Function_Stop', FunkinLua.Function_Stop);
		set('Function_Continue', FunkinLua.Function_Continue);
		set('Function_StopLua', FunkinLua.Function_StopLua); //doesnt do much cuz HScript has a lower priority than Lua
		set('Function_StopHScript', FunkinLua.Function_StopHScript);
		set('Function_StopAll', FunkinLua.Function_StopAll);
		
		set('add', function(obj:FlxBasic) PlayState.instance.add(obj));
		set('insert', function(pos:Int, obj:FlxBasic) PlayState.instance.insert(pos, obj));
		set('remove', function(obj:FlxBasic, ?splice:Bool = false) PlayState.instance.remove(obj, splice));
		
		set('addBehindGF', function(obj:FlxBasic) PlayState.instance.addBehindGF(obj));
		set('addBehindDad', function(obj:FlxBasic) PlayState.instance.addBehindDad(obj));
		set('addBehindBF', function(obj:FlxBasic) PlayState.instance.addBehindBF(obj));
		#end
	}

	public function executeCode(?funcToRun:String = null, ?funcArgs:Array<Dynamic> = null):SCall
	{
		if (funcToRun != null)
		{
		    if(!exists(funcToRun))
			{
				FunkinLua.luaTrace(origin + ' - No HScript function named: $funcToRun', false, false, FlxColor.RED);
				return null;
			}
			var callValue = call(funcToRun, funcArgs);
			if (callValue.succeeded)
				return callValue;
			else
			{
				var e = callValue.exceptions[0];
				if (e != null)
				{
					var msg:String = e.toString();
					if(parentLua != null) msg = origin + ":" + parentLua.lastCalledFunction + " - " + msg;
					else msg = '$origin - $msg';
					FunkinLua.luaTrace(msg, parentLua == null, false, FlxColor.RED);
				}
				return null;
			}
		}
		return null;
	}

	public function executeFunction(funcToRun:String = null, funcArgs:Array<Dynamic>):SCall
	{
		if (funcToRun == null)
			return null;

		return call(funcToRun, funcArgs);
	}

	public static function implement(funk:FunkinLua)
	{
	    var lua:State = funk.lua;
	    if (ClientPrefs.data.hscriptversion == 'SScript')
	    {
		#if LUA_ALLOWED
		Lua_helper.add_callback(lua, "runHaxeCode", function(codeToRun:String, ?varsToBring:Any = null, ?funcToRun:String = null, ?funcArgs:Array<Dynamic> = null):Dynamic {
			var retVal:SCall = null;
			#if (SScript >= "3.0.0")
			initHaxeModuleCode(funk, codeToRun);
			if(varsToBring != null)
			{
				for (key in Reflect.fields(varsToBring))
				{
					//trace('Key $key: ' + Reflect.field(varsToBring, key));
					funk.hscript.set(key, Reflect.field(varsToBring, key));
				}
			}
			retVal = funk.hscript.executeCode(funcToRun, funcArgs);
			if (retVal != null)
			{
				if(retVal.succeeded)
					return (retVal.returnValue == null || LuaUtils.isOfTypes(retVal.returnValue, [Bool, Int, Float, String, Array])) ? retVal.returnValue : null;
				var e = retVal.exceptions[0];
				if (e != null)
					FunkinLua.luaTrace(funk.hscript.origin + ":" + funk.lastCalledFunction + " - " + e, false, false, FlxColor.RED);
				return null;
			}
			else if (funk.hscript.returnValue != null)
				return funk.hscript.returnValue;
			#else
			FunkinLua.luaTrace("runHaxeCode: HScript isn't supported on this platform!", false, false, FlxColor.RED);
			#end

			return null;
		});
		
		Lua_helper.add_callback(lua, "runHaxeFunction", function(funcToRun:String, ?funcArgs:Array<Dynamic> = null) {
			#if (SScript >= "3.0.0")
			var callValue = funk.hscript.executeFunction(funcToRun, funcArgs);
			if (!callValue.succeeded)
			{
				var e = callValue.exceptions[0];
				if (e != null)
					FunkinLua.luaTrace('ERROR (${funk.hscript.origin}: ${callValue.calledFunction}) - ' + e.message.substr(0, e.message.indexOf('\n')), false, false, FlxColor.RED);
				return null;
			}
			else
				return callValue.returnValue;
			#else
			FunkinLua.luaTrace("runHaxeFunction: HScript isn't supported on this platform!", false, false, FlxColor.RED);
			#end
		});
		// This function is unnecessary because import already exists in SScript as a native feature
		Lua_helper.add_callback(lua, "addHaxeLibrary", function(libName:String, ?libPackage:String = '') {
			var str:String = '';
			if(libPackage.length > 0)
				str = libPackage + '.';
			else if(libName == null)
				libName = '';

			var c = Type.resolveClass(str + libName);
			#if (SScript >= "3.0.3")
			if (c != null)
				SScript.globalVariables[libName] = c;
			#end
			#if (SScript >= "3.0.0")
			if (funk.hscript != null)
			{
				try {
					if (c != null)
						funk.hscript.set(libName, c);
				}
				catch (e:Dynamic) {
					FunkinLua.luaTrace(funk.hscript.origin + ":" + funk.lastCalledFunction + " - " + e, false, false, FlxColor.RED);
				}
			}
			#else
			FunkinLua.luaTrace("addHaxeLibrary: HScript isn't supported on this platform!", false, false, FlxColor.RED);
			#end
		});
		#end
		}
	}
	
	#if (SScript >= "3.0.3")
	override public function destroy()
	{
		origin = null;
		parentLua = null;
		super.destroy();
	}
	#end
}
#end

#if hscript
class HScript_New
{
	#if hscript
	public static var parser:Parser = new Parser();
	public var interp:Interp;

	public var variables(get, never):Map<String, Dynamic>;
	public var parentLua:FunkinLua;

	public function get_variables()
	{
		return interp.variables;
	}
	
	public static function initHaxeModule(parent:FunkinLua)
	{
		#if hscript
		if(parent.hscript_new == null)
		{
			trace('initializing haxe interp for: ${parent.scriptName}');
			parent.hscript_new = new HScript_New(parent);
		}
		#end
	}

	public function new(parent:FunkinLua)
	{
		interp = new Interp();
		parentLua = parent;
		interp.variables.set('FlxG', flixel.FlxG);
		interp.variables.set('FlxSprite', flixel.FlxSprite);
		interp.variables.set('FlxCamera', flixel.FlxCamera);
		interp.variables.set('FlxTimer', flixel.util.FlxTimer);
		interp.variables.set('FlxTween', flixel.tweens.FlxTween);
		interp.variables.set('FlxEase', flixel.tweens.FlxEase);
		interp.variables.set('PlayState', PlayState);
		interp.variables.set('game', PlayState.instance);
		interp.variables.set('Paths', Paths);
		interp.variables.set('Conductor', Conductor);
		interp.variables.set('ClientPrefs', ClientPrefs.data);
		interp.variables.set('Character', Character);
		interp.variables.set('Alphabet', Alphabet);
		interp.variables.set('CustomSubstate', CustomSubstate);
		#if (!flash && sys)
		interp.variables.set('FlxRuntimeShader', flixel.addons.display.FlxRuntimeShader);
		#end
		interp.variables.set('ShaderFilter', openfl.filters.ShaderFilter);
		interp.variables.set('StringTools', StringTools);

		interp.variables.set('setVar', function(name:String, value:Dynamic)
		{
			PlayState.instance.variables.set(name, value);
		});
		interp.variables.set('getVar', function(name:String)
		{
			var result:Dynamic = null;
			if(PlayState.instance.variables.exists(name)) result = PlayState.instance.variables.get(name);
			return result;
		});
		interp.variables.set('removeVar', function(name:String)
		{
			if(PlayState.instance.variables.exists(name))
			{
				PlayState.instance.variables.remove(name);
				return true;
			}
			return false;
		});
		interp.variables.set('debugPrint', function(text:String, ?color:FlxColor = null) {
			if(color == null) color = FlxColor.WHITE;
			FunkinLua.luaTrace(text, true, false, color);
		});
		// For adding your own callbacks
		
		// not very tested
		interp.variables.set('createGlobalCallback', function(name:String, func:Dynamic) Lua_helper.add_callback(parentLua.lua, name, func));
		
		// tested
		interp.variables.set('createCallback', function(name:String, func:Dynamic, ?funk:FunkinLua = null)
		{
		    var lua:State = funk.lua;
			if(funk == null) funk = parentLua;
			Lua_helper.add_callback(lua, name, func);
		});
		
		interp.variables.set('addHaxeLibrary', function(libName:String, ?libPackage:String = '') {
			try {
				var str:String = '';
				if(libPackage.length > 0)
					str = libPackage + '.';
				interp.variables.set(libName, Type.resolveClass(str + libName));
			}
			catch (e:Dynamic) {
				FunkinLua.luaTrace(parentLua.scriptName + ":" + parentLua.lastCalledFunction + " - " + e, false, false, FlxColor.RED);
			}
		});
		interp.variables.set('parentLua', parentLua);
	}

	public function execute(codeToRun:String, ?funcToRun:String = null, ?funcArgs:Array<Dynamic>):Dynamic
	{
		@:privateAccess
		HScript_New.parser.line = 1;
		HScript_New.parser.allowTypes = true;
		var expr:Expr = HScript_New.parser.parseString(codeToRun);
		try {
			var value:Dynamic = interp.execute(HScript_New.parser.parseString(codeToRun));
			return (funcToRun != null) ? executeFunction(funcToRun, funcArgs) : value;
		}
		catch(e:Exception)
		{
			FunkinLua.luaTrace(parentLua.scriptName + ":" + parentLua.lastCalledFunction + " - " + e, false, false, FlxColor.RED);
			return null;
		}
	}
	
	public function executeFunction(funcToRun:String = null, funcArgs:Array<Dynamic>)
	{
		if(funcToRun != null)
		{
			//trace('Executing $funcToRun');
			if(interp.variables.exists(funcToRun))
			{
				//trace('$funcToRun exists, executing...');
				if(funcArgs == null) funcArgs = [];
				try {
					return Reflect.callMethod(null, interp.variables.get(funcToRun), funcArgs);
				}
				catch(e) FunkinLua.luaTrace(parentLua.scriptName + ":" + parentLua.lastCalledFunction + " - " + e, false, false, FlxColor.RED);
			}
		}
		return null;
	}
	#if LUA_ALLOWED
	public static function implement(funk:FunkinLua)
	{
	    var lua:State = funk.lua;
	    if (ClientPrefs.data.hscriptversion == 'HScript New')
	    {
		Lua_helper.add_callback(lua, "runHaxeCode", function(codeToRun:String, ?varsToBring:Any = null, ?funcToRun:String = null, ?funcArgs:Array<Dynamic> = null) {
			var retVal:Dynamic = null;
			#if hscript
			initHaxeModule(funk);
			try {
				if(varsToBring != null)
				{
					for (key in Reflect.fields(varsToBring))
					{
						//trace('Key $key: ' + Reflect.field(varsToBring, key));
						funk.hscript_new.interp.variables.set(key, Reflect.field(varsToBring, key));
					}
				}
				retVal = funk.hscript_new.execute(codeToRun, funcToRun, funcArgs);
			}
			catch (e:Dynamic) {
				FunkinLua.luaTrace(funk.scriptName + ":" + funk.lastCalledFunction + " - " + e, false, false, FlxColor.RED);
			}
			#else
			FunkinLua.luaTrace("runHaxeCode: HScript isn't supported on this platform!", false, false, FlxColor.RED);
			#end
			if(retVal != null && !LuaUtils.isOfTypes(retVal, [Bool, Int, Float, String, Array])) retVal = null;
			return retVal;
		});
		
		Lua_helper.add_callback(lua, "runHaxeFunction", function(funcToRun:String, ?funcArgs:Array<Dynamic> = null) {
			try {
				return funk.hscript_new.executeFunction(funcToRun, funcArgs);
			}
			catch(e:Exception)
			{
				FunkinLua.luaTrace(Std.string(e));
				return null;
			}
		});
		Lua_helper.add_callback(lua, "addHaxeLibrary", function(libName:String, ?libPackage:String = '') {
			#if hscript
			initHaxeModule(funk);
			try {
				var str:String = '';
				if(libPackage.length > 0)
					str = libPackage + '.';
				funk.hscript_new.variables.set(libName, Type.resolveClass(str + libName));
			}
			catch (e:Dynamic) {
				FunkinLua.luaTrace(funk.scriptName + ":" + funk.lastCalledFunction + " - " + e, false, false, FlxColor.RED);
			}
			#end
		});
		#end
		}
	}
	#end
}
#end

#if hscript
class HScript_Old
{
	public static var parser:Parser = new Parser();
	public var interp:Interp;

	public var variables(get, never):Map<String, Dynamic>;
	public var parentLua:FunkinLua;

	public function get_variables()
	{
		return interp.variables;
	}
	
	#if hscript
	public static function initHaxeModule(parent:FunkinLua)
	{
		if(FunkinLua.hscript_old == null)
		{
			//trace('initializing haxe interp for: $parent.scriptName');
			FunkinLua.hscript_old = new HScript_Old(parent); //TO DO: Fix issue with 2 scripts not being able to use the same variable names
		}
	}
	#end

	public function new(parent:FunkinLua)
	{
		interp = new Interp();
		parentLua = parent;
		interp.variables.set('FlxG', FlxG);
		interp.variables.set('FlxSprite', FlxSprite);
		interp.variables.set('FlxCamera', FlxCamera);
		interp.variables.set('FlxTimer', FlxTimer);
		interp.variables.set('FlxTween', FlxTween);
		interp.variables.set('FlxEase', FlxEase);
		interp.variables.set('PlayState', PlayState);
		interp.variables.set('game', PlayState.instance);
		interp.variables.set('Paths', Paths);
		interp.variables.set('Conductor', Conductor);
		interp.variables.set('ClientPrefs', ClientPrefs);
		interp.variables.set('Character', Character);
		interp.variables.set('Alphabet', Alphabet);
		interp.variables.set('CustomSubstate', CustomSubstate);
		#if (!flash && sys)
		interp.variables.set('FlxRuntimeShader', FlxRuntimeShader);
		#end
		interp.variables.set('ShaderFilter', openfl.filters.ShaderFilter);
		interp.variables.set('StringTools', StringTools);

		interp.variables.set('setVar', function(name:String, value:Dynamic)
		{
			PlayState.instance.variables.set(name, value);
		});
		interp.variables.set('getVar', function(name:String)
		{
			var result:Dynamic = null;
			if(PlayState.instance.variables.exists(name)) result = PlayState.instance.variables.get(name);
			return result;
		});
		interp.variables.set('removeVar', function(name:String)
		{
			if(PlayState.instance.variables.exists(name))
			{
				PlayState.instance.variables.remove(name);
				return true;
			}
			return false;
		});
		interp.variables.set('debugPrint', function(text:String, ?color:FlxColor = null) {
			if(color == null) color = FlxColor.WHITE;
			FunkinLua.luaTrace(text, true, false, color);
		});
		// For adding your own callbacks
		interp.variables.set('createCallback', function(name:String, func:Dynamic, ?funk:FunkinLua = null)
		{
			if(funk == null) funk = parentLua;
			Lua_helper.add_callback(funk.lua, name, func);
		});
		interp.variables.set('addHaxeLibrary', function(libName:String, ?libPackage:String = '') {
			try {
				var str:String = '';
				if(libPackage.length > 0)
					str = libPackage + '.';
				interp.variables.set(libName, Type.resolveClass(str + libName));
			}
			catch (e:Dynamic) {
				FunkinLua.luaTrace(parentLua.scriptName + ":" + parentLua.lastCalledFunction + " - " + e, false, false, FlxColor.RED);
			}
		});
		interp.variables.set('parentLua', parentLua);
	}

	public function execute(codeToRun:String):Dynamic
	{
		@:privateAccess
		HScript_Old.parser.line = 1;
		HScript_Old.parser.allowTypes = true;
		return interp.execute(HScript_Old.parser.parseString(codeToRun));
	}
	
	public static function implement(funk:FunkinLua)
	{
	    if (ClientPrefs.data.hscriptversion == 'HScript Old')
	    {
	    var lua:State = funk.lua;
	    Lua_helper.add_callback(lua, "runHaxeCode", function(codeToRun:String) {
			var retVal:Dynamic = null;

			#if hscript
			HScript_Old.initHaxeModule(funk);
			try {
				retVal = FunkinLua.hscript_old.execute(codeToRun);
			}
			catch (e:Dynamic) {
				FunkinLua.luaTrace(funk.scriptName + ":" + funk.lastCalledFunction + " - " + e, false, false, FlxColor.RED);
			}
			#else
			FunkinLua.luaTrace("runHaxeCode: HScript isn't supported on this platform!", false, false, FlxColor.RED);
			#end

			if(retVal != null && !LuaUtils.isOfTypes(retVal, [Bool, Int, Float, String, Array])) retVal = null;
			if(retVal == null) Lua.pushnil(lua);
			return retVal;
		});

		Lua_helper.add_callback(lua, "addHaxeLibrary", function(libName:String, ?libPackage:String = '') {
			#if hscript
			HScript_Old.initHaxeModule(funk);
			try {
				var str:String = '';
				if(libPackage.length > 0)
					str = libPackage + '.';

				FunkinLua.hscript_old.variables.set(libName, Type.resolveClass(str + libName));
			}
			catch (e:Dynamic) {
				FunkinLua.luaTrace(funk.scriptName + ":" + funk.lastCalledFunction + " - " + e, false, false, FlxColor.RED);
			}
			#end
		});
		}
	}
}
#end

class CustomFlxColor
{
	public static var TRANSPARENT(default, null):Int = FlxColor.TRANSPARENT;
	public static var BLACK(default, null):Int = FlxColor.BLACK;
	public static var WHITE(default, null):Int = FlxColor.WHITE;
	public static var GRAY(default, null):Int = FlxColor.GRAY;
	public static var GREEN(default, null):Int = FlxColor.GREEN;
	public static var LIME(default, null):Int = FlxColor.LIME;
	public static var YELLOW(default, null):Int = FlxColor.YELLOW;
	public static var ORANGE(default, null):Int = FlxColor.ORANGE;
	public static var RED(default, null):Int = FlxColor.RED;
	public static var PURPLE(default, null):Int = FlxColor.PURPLE;
	public static var BLUE(default, null):Int = FlxColor.BLUE;
	public static var BROWN(default, null):Int = FlxColor.BROWN;
	public static var PINK(default, null):Int = FlxColor.PINK;
	public static var MAGENTA(default, null):Int = FlxColor.MAGENTA;
	public static var CYAN(default, null):Int = FlxColor.CYAN;
	public static function fromRGB(Red:Int, Green:Int, Blue:Int, Alpha:Int = 255):Int
	{
		return cast FlxColor.fromRGB(Red, Green, Blue, Alpha);
	}
	public static function fromRGBFloat(Red:Float, Green:Float, Blue:Float, Alpha:Float = 1):Int
	{	
		return cast FlxColor.fromRGBFloat(Red, Green, Blue, Alpha);
	}
	public static function fromHSB(Hue:Float, Sat:Float, Brt:Float, Alpha:Float = 1):Int
	{	
		return cast FlxColor.fromHSB(Hue, Sat, Brt, Alpha);
	}
	public static function fromHSL(Hue:Float, Sat:Float, Light:Float, Alpha:Float = 1):Int
	{	
		return cast FlxColor.fromHSL(Hue, Sat, Light, Alpha);
	}
	public static function fromString(str:String):Int
	{
		return cast FlxColor.fromString(str);
	}
}