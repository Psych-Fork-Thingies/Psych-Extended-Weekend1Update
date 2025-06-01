package scripting.substate;

import openfl.utils.Assets as OpenFlAssets;
import flixel.util.FlxSave;

import Character;

import options.*;
import editors.*;

import flixel.addons.display.FlxRuntimeShader;
import openfl.filters.ShaderFilter;

#if VIDEOS_ALLOWED
import vlc.MP4Handler as VideoHandler;
#end

#if SCRIPTING_ALLOWED
import scripting.substate.HScript.HScriptInfos;
import crowplexus.iris.Iris;
import crowplexus.hscript.Expr.Error as IrisError;
import crowplexus.hscript.Printer;
import scripting.substate.HScript;
import scripting.state.ScriptState;

class ScriptSubstate extends MusicBeatSubstate
{
	public static var targetFileName:String; 

	public function new(scriptName:String) 
	{
		super();

		targetFileName = scriptName;
	}

	public var runtimeShaders:Map<String, Array<String>> = new Map<String, Array<String>>();

	public static var instance:ScriptSubstate;

	private var luaDebugGroup:FlxTypedGroup<DebugLuaText>;

	public var modchartTweens:Map<String, FlxTween> = new Map<String, FlxTween>();
	public var modchartSprites:Map<String, ModchartSprite> = new Map<String, ModchartSprite>();
	public var modchartTimers:Map<String, FlxTimer> = new Map<String, FlxTimer>();
	public var modchartSounds:Map<String, FlxSound> = new Map<String, FlxSound>();
	public var modchartTexts:Map<String, FlxText> = new Map<String, FlxText>();
	public var modchartSaves:Map<String, FlxSave> = new Map<String, FlxSave>();

	public var hscriptArray:Array<HScript> = [];

	public static var variables:Map<String, Dynamic> = new Map<String, Dynamic>();

	var keysPressed:Array<Int> = [];
	private var keysArray:Array<String>;

	override public function create()
	{
		instance = this;

		Paths.clearUnusedMemory();

		luaDebugGroup = new FlxTypedGroup<DebugLuaText>();
		add(luaDebugGroup);

		Iris.warn = function(x, ?pos:haxe.PosInfos) {
			Iris.logLevel(WARN, x, pos);
			var newPos:HScriptInfos = cast pos;
			if (newPos.showLine == null) newPos.showLine = true;
			var msgInfo:String = (newPos.funcName != null ? '(${newPos.funcName}) - ' : '')  + '${newPos.fileName}:';
			if (newPos.showLine == true) {
				msgInfo += '${newPos.lineNumber}:';
			}
			msgInfo += ' $x';
			ScriptSubstate.instance.addTextToDebug('WARNING: $msgInfo', FlxColor.YELLOW);
		}
		Iris.error = function(x, ?pos:haxe.PosInfos) {
			Iris.logLevel(ERROR, x, pos);
			var newPos:HScriptInfos = cast pos;
			if (newPos.showLine == null) newPos.showLine = true;
			var msgInfo:String = (newPos.funcName != null ? '(${newPos.funcName}) - ' : '')  + '${newPos.fileName}:';
			if (newPos.showLine == true) {
				msgInfo += '${newPos.lineNumber}:';
			}
			msgInfo += ' $x';
			ScriptSubstate.instance.addTextToDebug('ERROR: $msgInfo', FlxColor.RED);
		}
		Iris.fatal = function(x, ?pos:haxe.PosInfos) {
			Iris.logLevel(FATAL, x, pos);
			var newPos:HScriptInfos = cast pos;
			if (newPos.showLine == null) newPos.showLine = true;
			var msgInfo:String = (newPos.funcName != null ? '(${newPos.funcName}) - ' : '')  + '${newPos.fileName}:';
			if (newPos.showLine == true) {
				msgInfo += '${newPos.lineNumber}:';
			}
			msgInfo += ' $x';
			ScriptSubstate.instance.addTextToDebug('FATAL: $msgInfo', 0xFFBB0000);
		}
		startHScriptsNamed('custom_substates/' + targetFileName + '.hx');
		callOnScripts('onCreatePost');
		super.create();
	}

	override public function update(elapsed:Float)
	{
		callOnScripts('onUpdate', [elapsed]);

		if (FlxG.sound.music != null && FlxG.sound.music.looped) FlxG.sound.music.onComplete = fixMusic.bind();

		callOnScripts('onUpdatePost', [elapsed]);

		super.update(elapsed);
	}

	var lastStepHit:Int = -1;

	override function stepHit()
	{
		super.stepHit();

		if(curStep >= lastStepHit) {
			return;
		}

		lastStepHit = curStep;
		setOnScripts('curStep', curStep);
		callOnScripts('onStepHit');
	}

	var lastBeatHit:Int = -1;

	override function beatHit()
	{
		if(lastBeatHit >= curBeat) {
			return;
		}

		super.beatHit();

		lastBeatHit = curBeat;

		setOnScripts('curBeat', curBeat);
		callOnScripts('onBeatHit');
	}

	var lastSectionHit:Int = -1;

	/*
	override function sectionHit()
	{
		if (lastSectionHit >= curSection)
		{
			return;
		}

		super.sectionHit();

		setOnScripts('curSection', curSection);
		callOnScripts('onSectionHit');
	}
	*/

	function fixMusic()
	{
		MusicBeatState.instance.resetMusicVars();

		lastStepHit = -1;
		lastBeatHit = -1;
		lastSectionHit = -1;
	}

	public function addTextToDebug(text:String, color:FlxColor) 
	{
		var newText:DebugLuaText = luaDebugGroup.recycle(DebugLuaText);
		newText.text = text;
		newText.color = color;
		newText.disableTime = 6;
		newText.alpha = 1;
		newText.setPosition(10, 8 - newText.height);

		luaDebugGroup.forEachAlive(function(spr:DebugLuaText) {
			spr.y += newText.height + 2;
		});
		luaDebugGroup.cameras = [FlxG.cameras.list[FlxG.cameras.list.length-1]]; //fix camera issue
		newText.cameras = [FlxG.cameras.list[FlxG.cameras.list.length-1]]; //fix camera issue 2
		luaDebugGroup.add(newText);

		Sys.println(text);
	}

	public function getLuaObject(tag:String, text:Bool=true):FlxSprite
		return variables.get(tag);

	public static var inCutscene:Bool;

	public function startVideo(name:String)
	{
		#if VIDEOS_ALLOWED
		inCutscene = true;

		var filepath:String = Paths.video(name);
		#if sys
		if(!FileSystem.exists(filepath))
		#else
		if(!OpenFlAssets.exists(filepath))
		#end
		{
			FlxG.log.warn('Couldnt find video file: ' + name);
			return;
		}

		var video:VideoHandler = new VideoHandler();
			#if (hxCodec >= "3.0.0")
			// Recent versions
			video.play(filepath);
			video.onEndReached.add(function()
			{
				video.dispose();
				inCutscene = false;
				return;
			}, true);
			#else
			// Older versions
			video.playVideo(filepath);
			video.finishCallback = function()
			{
				inCutscene = false;
				return;
			}
			#end
		#else
		FlxG.log.warn('Platform not supported!');
		return;
		#end
	}

	override public function close()
	{
		super.close();

		instance = null;

		for (script in hscriptArray)
			if(script != null)
			{
				if(script.exists('onDestroy')) script.call('onDestroy');
				else if (script.exists('destroy')) script.call('destroy');
				script.destroy();
			}

		hscriptArray = null;
	}

	public function startHScriptsNamed(scriptFile:String)
	{
		#if MODS_ALLOWED
		var scriptToLoad:String = Paths.modFolders('scripts/' + scriptFile);
		if(!FileSystem.exists(scriptToLoad))
			scriptToLoad = Paths.getScriptPath(scriptFile);
		#else
		var scriptToLoad:String = Paths.getScriptPath(scriptFile);
		#end

		if(FileSystem.exists(scriptToLoad))
		{
			if (Iris.instances.exists(scriptToLoad)) return false;

			initHScript(scriptToLoad);
			return true;
		}
		return false;
	}

	public function initHScript(file:String)
	{
		var newScript:HScript = null;
		try
		{
			(newScript = new HScript(null, file)).setParent(this);
			if (newScript.exists('onCreate')) newScript.call('onCreate');
			else if (newScript.exists('create')) newScript.call('create');
			trace('initialized hscript interp successfully: $file');
			hscriptArray.push(newScript);
		}
		catch(e:IrisError)
		{
			var pos:HScriptInfos = cast {fileName: file, showLine: false};
			Iris.error(Printer.errorToString(e, false), pos);
			var newScript:HScript = cast (Iris.instances.get(file), HScript);
			if(newScript != null)
				newScript.destroy();
		}
	}

	public function callOnScripts(funcToCall:String, args:Array<Dynamic> = null, ignoreStops = false, exclusions:Array<String> = null, excludeValues:Array<Dynamic> = null):Dynamic {
		return callOnHScript(funcToCall, args, ignoreStops, exclusions, excludeValues);
	}

	public function callOnHScript(funcToCall:String, args:Array<Dynamic> = null, ?ignoreStops:Bool = false, exclusions:Array<String> = null, excludeValues:Array<Dynamic> = null):Dynamic {
		var returnVal:Dynamic = FunkinLua.Function_Continue;

		if(exclusions == null) exclusions = new Array();
		if(excludeValues == null) excludeValues = new Array();
		excludeValues.push(FunkinLua.Function_Continue);

		var len:Int = hscriptArray.length;
		if (len < 1)
			return returnVal;

		for(script in hscriptArray)
		{
			@:privateAccess
			if(script == null || !script.exists(funcToCall) || exclusions.contains(script.origin))
				continue;

			var callValue = script.call(funcToCall, args);
			if(callValue != null)
			{
				var myValue:Dynamic = callValue.returnValue;

				if((myValue == FunkinLua.Function_StopHScript || myValue == FunkinLua.Function_StopAll) && !excludeValues.contains(myValue) && !ignoreStops)
				{
					returnVal = myValue;
					break;
				}

				if(myValue != null && !excludeValues.contains(myValue))
					returnVal = myValue;
			}
		}

		switch (funcToCall) //Codename Engine Functions (if you're using `update` function in your code, Don't add `onUpdate`)
		{
			case 'onCreate': callOnScripts('create', args, ignoreStops, exclusions, excludeValues);
			case 'onCreatePost': callOnScripts('postCreate', args, ignoreStops, exclusions, excludeValues);
			case 'onUpdate': callOnScripts('update', args, ignoreStops, exclusions, excludeValues);
			case 'onUpdatePost': callOnScripts('postUpdate', args, ignoreStops, exclusions, excludeValues);
			case 'onDestroy': callOnScripts('destroy', args, ignoreStops, exclusions, excludeValues);
			case 'onCloseSubState': callOnScripts('closeSubState', args, ignoreStops, exclusions, excludeValues);
			case 'onCloseSubStatePost': callOnScripts('postCloseSubState', args, ignoreStops, exclusions, excludeValues);
		}

		return returnVal;
	}

	public function setOnScripts(variable:String, arg:Dynamic, exclusions:Array<String> = null) {
		if(exclusions == null) exclusions = [];
		setOnHScript(variable, arg, exclusions);
	}

	public function setOnHScript(variable:String, arg:Dynamic, exclusions:Array<String> = null) {
		if(exclusions == null) exclusions = [];
		for (script in hscriptArray) {
			if(exclusions.contains(script.origin))
				continue;

			script.set(variable, arg);
		}
	}

	public function resetScriptState(?doTransition:Bool = false)
	{
		FlxTransitionableState.skipNextTransIn = !doTransition;
		FlxTransitionableState.skipNextTransOut = !doTransition;
		MusicBeatState.switchState(new ScriptState(targetFileName));
	}
}
#else
class ScriptSubstate extends MusicBeatSubstate
{
	public function new(scriptName:String) 
	{
		super();

		targetFileName = scriptName;
	}
}
#end