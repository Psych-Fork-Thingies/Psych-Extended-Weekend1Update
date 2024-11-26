package psychlua;

import FunkinLua;
import tjson.TJSON as Json;
import debug.FPSCounter;

class CustomFunctions
{
	public static function implement(funk:FunkinLua)
	{
	    var lua:State = funk.lua;
	    
	    Lua_helper.add_callback(lua, "saveScore", function():Void
		{
			PlayState.instance.saveScore();
		});
		
		Lua_helper.add_callback(lua, "saveWeekScore", function():Void
		{
			PlayState.instance.saveWeekScore();
		});
		
		Lua_helper.add_callback(lua, "showPopUp", function(message:String, title:String):Void
		{
			CoolUtil.showPopUp(message, title);
		});
		
		Lua_helper.add_callback(lua, "parseJson", function(directory:String, ?ignoreMods:Bool = false):Dynamic //For Vs Steve Bedrock Edition Psych Port -Useless
		{
            final funnyPath:String = directory + '.json';
            final jsonContents:String = Paths.getTextFromFile(funnyPath, ignoreMods);
            final realPath:String = (ignoreMods ? '' : Paths.modFolders(Paths.currentModDirectory)) + '/' + funnyPath;
            final jsonExists:Bool = Paths.fileExists(realPath, null, ignoreMods);
            if (jsonContents != null || jsonExists) return Json.parse(jsonContents);
            else if (!jsonExists && PlayState.chartingMode) debugPrintFunction('parseJson: "' + realPath + '" doesn\'t exist!', 0xff0000);
            return null;
		});
		
		Lua_helper.add_callback(lua, "CloseGame", function():Void
		{
			lime.system.System.exit(1);
		});
	}
	
	public static function debugPrintFunction(text1:Dynamic = '', text2:Dynamic = '', text3:Dynamic = '', text4:Dynamic = '', text5:Dynamic = '')
	{
	    if (text1 == null) text1 = '';
		if (text2 == null) text2 = '';
		if (text3 == null) text3 = '';
		if (text4 == null) text4 = '';
		if (text5 == null) text5 = '';
		FunkinLua.luaTrace('' + text1 + text2 + text3 + text4 + text5, true, false);
	}
}