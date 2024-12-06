package extras;

class CustomSwitchState //Now You Can Add and Remove Custom Menus More Easier Than Old One
{
    public static function switchMenus(Type:String)
	{
	    FunkinLua.FPSCounterText = null;
	    if (Type == 'Freeplay') //Freeplay
	    {
	        if (ClientPrefs.data.FreeplayStyle == 'NF')
                MusicBeatState.switchState(new FreeplayStateNF());
            else if (ClientPrefs.data.FreeplayStyle == 'NovaFlare')
                MusicBeatState.switchState(new FreeplayStateNOVA());
            else
                MusicBeatState.switchState(new FreeplayState());
        }
        else if (Type == 'MainMenu') //MainMenu
        {
            if (ClientPrefs.data.MainMenuStyle == '0.6.3' || ClientPrefs.data.MainMenuStyle == 'Extended')
            	MusicBeatState.switchState(new MainMenuStateOld());
            else if (ClientPrefs.data.MainMenuStyle == 'NovaFlare')
                MusicBeatState.switchState(new MainMenuStateNOVA());
            else
            	MusicBeatState.switchState(new MainMenuState());
        }
        else if (Type == 'StoryMenu') //StoryMenu
            MusicBeatState.switchState(new StoryMenuState());
        else if (Type == 'Options') //Options
            LoadingState.loadAndSwitchState(new options.OptionsState());
        else if (Type == 'Credits') //Credits
            MusicBeatState.switchState(new CreditsState());
        else if (Type == 'Title') //Title
            MusicBeatState.switchState(new TitleState());
        else if (Type == 'MasterEditor') //Mastee Editor
            MusicBeatState.switchState(new editors.MasterEditorMenu());
        else if (Type == 'NoteOffset') //Note Offset
            MusicBeatState.switchState(new options.NoteOffsetState());
        else if (Type == 'ModsMenu') //Mods Menu
            MusicBeatState.switchState(new ModsMenuState());
        else if (Type == 'AchievementsMenu') //Achievements Menu
            LoadingState.loadAndSwitchState(new AchievementsMenuState());
	}
}