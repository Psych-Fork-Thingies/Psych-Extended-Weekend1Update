package extras;

class CustomSwitchState //Now You Can Add and Remove Custom Menus More Easier Than Old One
{
    public static function switchMenus(Type:String, ?skipTrans:Bool = false, ?skipTransCustom:String = '')
	{
	    FunkinLua.FPSCounterText = null;
	    if (skipTransCustom == 'TransIn' || skipTrans) FlxTransitionableState.skipNextTransIn = true;
        if (skipTransCustom == 'TransOut' || skipTrans) FlxTransitionableState.skipNextTransOut = true;
        
        var FileName:String = Type + 'State';
      //Check
      if (FileSystem.exists(Paths.getScriptPath('states/' + FileName + '.hx'))) MusicBeatState.switchState(new ScriptState(FileName));
	  else
	  {
    	//OMG 😱 Rewrited?
    	switch (Type)
		{
		    case 'Freeplay':
		        if (ClientPrefs.data.FreeplayStyle == 'NF') MusicBeatState.switchState(new FreeplayStateNF());
                else if (ClientPrefs.data.FreeplayStyle == 'NovaFlare') MusicBeatState.switchState(new FreeplayStateNOVA());
                else MusicBeatState.switchState(new FreeplayState());
            case 'MainMenu':
                if (ClientPrefs.data.MainMenuStyle == '0.6.3' || ClientPrefs.data.MainMenuStyle == 'Extended') MusicBeatState.switchState(new MainMenuStateOld());
                else if (ClientPrefs.data.MainMenuStyle == 'NovaFlare') MusicBeatState.switchState(new MainMenuStateNOVA());
                else MusicBeatState.switchState(new MainMenuState());
            case 'StoryMenu':
                MusicBeatState.switchState(new StoryMenuState());
            case 'Options':
                LoadingState.loadAndSwitchState(new options.OptionsState());
            case 'Credits':
                MusicBeatState.switchState(new CreditsState());
            case 'Title':
                MusicBeatState.switchState(new TitleState());
            case 'MasterEditor':
                MusicBeatState.switchState(new editors.MasterEditorMenu());
            case 'NoteOffset':
                MusicBeatState.switchState(new options.NoteOffsetState());
            case 'ModsMenu':
                MusicBeatState.switchState(new ModsMenuState());
            case 'AchievementsMenu':
                LoadingState.loadAndSwitchState(new AchievementsMenuState());
        }
      }
	}
}