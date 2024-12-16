package mobile.backend;

import haxe.ds.StringMap;

class Data
{
    public static var instance:Data;
    
    public static var Setuping:Bool = false;
    
	public static var dpadMode:Map<String, FlxDPadMode>;
	public static var actionMode:Map<String, FlxActionMode>;

    /*
	public static function setup()
	{
		for (data in FlxDPadMode.createAll())
			dpadMode.set(data.getName(), data);

		for (data in FlxActionMode.createAll())
			actionMode.set(data.getName(), data);
	}
	*/
	
	public static function setup()
	{
	    Setuping = true;
	    #if LUAVIRTUALPAD_ALLOWED
		// FlxDPadModes
		dpadMode = new Map<String, FlxDPadMode>();
		dpadMode.set("UP_DOWN", UP_DOWN);
		dpadMode.set("LEFT_RIGHT", LEFT_RIGHT);
		dpadMode.set("UP_LEFT_RIGHT", UP_LEFT_RIGHT);
		dpadMode.set("LEFT_FULL", FULL); //1.0 Support
		dpadMode.set("FULL", FULL);
		dpadMode.set("ALL", ALL);
		dpadMode.set("OptionsC", OptionsC);
		dpadMode.set("RIGHT_FULL", RIGHT_FULL);
		dpadMode.set("DUO", DUO);
		dpadMode.set("PAUSE", PAUSE);
		dpadMode.set("CHART_EDITOR", CHART_EDITOR);
		dpadMode.set("NONE", NONE);
			
		actionMode = new Map<String, FlxActionMode>();
		actionMode.set('E', E);
		actionMode.set('A', A);
		actionMode.set('B', B);
		actionMode.set('D', D);
		actionMode.set('P', P);
		actionMode.set('X_Y', X_Y);
		actionMode.set('A_B', A_B);
		actionMode.set('A_C', A_C);
		actionMode.set('A_B_C', A_B_C);
		actionMode.set('A_B_E', A_B_E);
		actionMode.set('A_B_E_C_M', A_B_E_C_M);
		actionMode.set('A_B_X_Y', A_B_X_Y);
		actionMode.set('A_X_Y', A_X_Y);
		actionMode.set('B_X_Y', B_X_Y);
		actionMode.set('A_B_C_X_Y', A_B_C_X_Y);
		actionMode.set('A_B_C_X_Y_Z', A_B_C_X_Y_Z);
		actionMode.set('OptionsC', OptionsC);
		actionMode.set('ALL', ALL);
		actionMode.set('CHART_EDITOR', CHART_EDITOR);
		actionMode.set('controlExtend', controlExtend);
		actionMode.set('B_E', B_E);
		actionMode.set('NONE', NONE);
		#end
	}
}


enum FlxDPadMode {
	UP_DOWN;
	LEFT_RIGHT;
	UP_LEFT_RIGHT;
	FULL;
	ALL;
	OptionsC;
	RIGHT_FULL;
	DUO;
	PAUSE;
	CHART_EDITOR;
	NONE;
}

enum FlxActionMode {
    E;
	A;
	B;
	D;
	P;
	X_Y;
	A_B;
	A_C;
	A_B_C;
	A_B_E;
	A_B_E_C_M;
	A_B_X_Y;	
	A_X_Y;	
	B_X_Y;	
	A_B_C_X_Y;
	A_B_C_X_Y_Z;
	FULL;
	OptionsC;
	ALL;
	CHART_EDITOR;
	controlExtend;
	B_E;
	NONE;
}