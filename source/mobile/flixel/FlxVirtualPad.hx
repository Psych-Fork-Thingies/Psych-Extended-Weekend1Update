package mobile.flixel;

import flixel.FlxG;
import flixel.graphics.frames.FlxTileFrames;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import flixel.util.FlxDestroyUtil;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.FlxGraphic;
import openfl.display.BitmapData;
import openfl.utils.Assets;

// Lua VirtualPad
import haxe.ds.StringMap;

class FlxVirtualPad extends FlxSpriteGroup {
	//Actions
	public var buttonA:FlxButton;
	public var buttonB:FlxButton;
	public var buttonC:FlxButton;
	public var buttonD:FlxButton;
	public var buttonE:FlxButton;
	public var buttonM:FlxButton;
	public var buttonP:FlxButton;
	public var buttonV:FlxButton;
	public var buttonX:FlxButton;
	public var buttonY:FlxButton;
	public var buttonZ:FlxButton;
	public var buttonF:FlxButton;
	public var buttonG:FlxButton;
	
	//Extra
    public var buttonExtra1:FlxButton;
	public var buttonExtra2:FlxButton;
	public var buttonExtra3:FlxButton;
	public var buttonExtra4:FlxButton;
    
	//DPad
	public var buttonLeft:FlxButton;
	public var buttonUp:FlxButton;
	public var buttonRight:FlxButton;
	public var buttonDown:FlxButton;

	//PAD DUO MODE
	public var buttonLeft2:FlxButton;
	public var buttonUp2:FlxButton;
	public var buttonRight2:FlxButton;
	public var buttonDown2:FlxButton;
    
	public var buttonCEUp:FlxButton;
	public var buttonCEDown:FlxButton;
	public var buttonCEG:FlxButton;
	
	public var dPad:FlxSpriteGroup;
	public var actions:FlxSpriteGroup;
	public var buttonsString:Map<FlxButton, Dynamic>;
	
	/**
	 * Create a gamepad.
	 *
	 * @param   DPadMode     The D-Pad mode. `LEFT_FULL` for example.
	 * @param   ActionMode   The action buttons mode. `A_B_C` for example.
	 */

	public function new(DPad:FlxDPadMode, Action:FlxActionMode) {
		super();

		dPad = new FlxSpriteGroup();
		dPad.scrollFactor.set();

		actions = new FlxSpriteGroup();
		actions.scrollFactor.set();

		buttonA = new FlxButton(0, 0);
		buttonB = new FlxButton(0, 0);
		buttonC = new FlxButton(0, 0);
		buttonD = new FlxButton(0, 0);
		buttonE = new FlxButton(0, 0);
		buttonM = new FlxButton(0, 0);
		buttonP = new FlxButton(0, 0);
		buttonV = new FlxButton(0, 0);
		buttonX = new FlxButton(0, 0);
		buttonY = new FlxButton(0, 0);
		buttonZ = new FlxButton(0, 0);

		buttonLeft = new FlxButton(0, 0);
		buttonUp = new FlxButton(0, 0);
		buttonRight = new FlxButton(0, 0);
		buttonDown = new FlxButton(0, 0);

		buttonLeft2 = new FlxButton(0, 0);
		buttonUp2 = new FlxButton(0, 0);
		buttonRight2 = new FlxButton(0, 0);
		buttonDown2 = new FlxButton(0, 0);
        
		buttonCEUp = new FlxButton(0, 0);
		buttonCEDown = new FlxButton(0, 0);
		buttonCEG = new FlxButton(0, 0);
		
		switch (DPad){
			case UP_DOWN:
				addDPad(buttonUp, 0, FlxG.height - 85 * 3, "up", 0x00FF00);
				addDPad(buttonDown, 0, FlxG.height - 45 * 3, "down", 0x00FFFF);
			case LEFT_RIGHT:
				addDPad(buttonLeft, 0, FlxG.height - 45 * 3, "left", 0xFF00FF);
				addDPad(buttonRight, 42 * 3, FlxG.height - 45 * 3, "right", 0xFF0000);
			case UP_LEFT_RIGHT:
				addDPad(buttonUp, 35 * 3, FlxG.height - 81 * 3, "up", 0x00FF00);
				addDPad(buttonLeft, 0, FlxG.height - 45 * 3, "left", 0xFF00FF);
				addDPad(buttonRight, 69 * 3, FlxG.height - 45 * 3, "right", 0xFF0000);
			case FULL:
				addDPad(buttonUp, 35 * 3, FlxG.height - 116 * 3, "up", 0x00FF00);
				addDPad(buttonLeft, 0, FlxG.height - 81 * 3, "left", 0xFF00FF);
				addDPad(buttonRight, 69 * 3, FlxG.height - 81 * 3, "right", 0xFF0000);
				addDPad(buttonDown, 35 * 3, FlxG.height - 45 * 3, "down", 0x00FFFF);
			case ALL:
				addDPad(buttonUp, 0, FlxG.height - 85 * 3, "up", 0x00FF00);
				addDPad(buttonDown, 0, FlxG.height - 45 * 3, "down", 0x00FFFF);
				addDPad(buttonLeft, 42 * 3, FlxG.height - 85 * 3, "left", 0xFF00FF);
				addDPad(buttonRight, 42 * 3, FlxG.height - 45 * 3, "right", 0xFF0000);
			case OptionsC:
			    addDPad(buttonUp, 0, FlxG.height - 85 * 3, "up", 0x00FF00);
				addDPad(buttonDown, 0, FlxG.height - 45 * 3, "down", 0x00FFFF);
			case RIGHT_FULL:
				addDPad(buttonUp, FlxG.width - 86 * 3, FlxG.height - 66 - 116 * 3, "up", 0x00FF00);
				addDPad(buttonLeft, FlxG.width - 128 * 3, FlxG.height - 66 - 81 * 3, "left", 0xFF00FF);
				addDPad(buttonRight, FlxG.width - 44 * 3, FlxG.height - 66 - 81 * 3, "right", 0xFF0000);
				addDPad(buttonDown, FlxG.width - 86 * 3, FlxG.height - 66 - 45 * 3, "down", 0x00FFFF);
			case DUO:
				addDPad(buttonUp, 35 * 3, FlxG.height - 116 * 3, "up", 0x00FF00);
				addDPad(buttonLeft, 0, FlxG.height - 81 * 3, "left", 0xFF00FF);
				addDPad(buttonRight, 69 * 3, FlxG.height - 81 * 3, "right", 0xFF0000);
				addDPad(buttonDown, 35 * 3, FlxG.height - 45 * 3, "down", 0x00FFFF);
				addDPad(buttonUp2, FlxG.width - 86 * 3, FlxG.height - 66 - 116 * 3, "up", 0x00FF00);
				addDPad(buttonLeft2, FlxG.width - 128 * 3, FlxG.height - 66 - 81 * 3, "left", 0xFF00FF);
				addDPad(buttonRight2, FlxG.width - 44 * 3, FlxG.height - 66 - 81 * 3, "right", 0xFF0000);
				addDPad(buttonDown2, FlxG.width - 86 * 3, FlxG.height - 66 - 45 * 3, "down", 0x00FFFF);
			case PAUSE:	
				addDPad(buttonUp, 0, FlxG.height - 85 * 3, "up", 0x00FF00);
				addDPad(buttonDown, 0, FlxG.height - 45 * 3, "down", 0x00FFFF);
				addDPad(buttonLeft, 42 * 3, FlxG.height - 45 * 3, "left", 0xFF00FF);
				addDPad(buttonRight, 84 * 3, FlxG.height - 45 * 3, "right", 0xFF0000);
			case NONE:
		}

		switch (Action){
		    case E:
				addActions(buttonE, FlxG.width - 44 * 3, FlxG.height - 125 * 3, "modding", -1);
			case A:
				addActions(buttonA, FlxG.width - 44 * 3, FlxG.height - 45 * 3, "a", 0xFF0000);
			case B:
				addActions(buttonB, FlxG.width - 44 * 3, FlxG.height - 45 * 3, "b", 0xFFCB00);
			case A_B:
				addActions(buttonA, FlxG.width - 44 * 3, FlxG.height - 45 * 3, "a", 0xFF0000);
				addActions(buttonB, FlxG.width - 86 * 3, FlxG.height - 45 * 3, "b", 0xFFCB00);
			case A_B_C:
				addActions(buttonC, FlxG.width - 128 * 3, FlxG.height - 45 * 3, "c", 0x44FF00);
				addActions(buttonB, FlxG.width - 86 * 3, FlxG.height - 45 * 3, "b", 0xFFCB00);
				addActions(buttonA, FlxG.width - 44 * 3, FlxG.height - 45 * 3, "a", 0xFF0000);
			case A_B_E:
				addActions(buttonE, FlxG.width - 128 * 3, FlxG.height - 45 * 3, "e", 0xFF7D00);
				addActions(buttonB, FlxG.width - 86 * 3, FlxG.height - 45 * 3, "b", 0xFFCB00);
				addActions(buttonA, FlxG.width - 44 * 3, FlxG.height - 45 * 3, "a", 0xFF0000);
			case A_B_E_C_M:
			    addActions(buttonM, FlxG.width - 86 * 3, FlxG.height - 85 * 3, "m", 0xFFCB00);
				addActions(buttonE, FlxG.width - 44 * 3, FlxG.height - 85 * 3, "e", 0xFF7D00);
				addActions(buttonB, FlxG.width - 86 * 3, FlxG.height - 45 * 3, "b", 0xFFCB00);
				addActions(buttonA, FlxG.width - 44 * 3, FlxG.height - 45 * 3, "a", 0xFF0000);
			    addActions(buttonC, FlxG.width - 44 * 3, FlxG.height - 125 * 3, "c", 0x44FF00);
 			case A_B_X_Y:
				addActions(buttonY, FlxG.width - 170 * 3, FlxG.height - 45 * 3, "y", 0x4A35B9);
				addActions(buttonX, FlxG.width - 128 * 3, FlxG.height - 45 * 3, "x", 0x99062D);
				addActions(buttonB, FlxG.width - 86 * 3, FlxG.height - 45 * 3, "b", 0xFFCB00);
				addActions(buttonA, FlxG.width - 44 * 3, FlxG.height - 45 * 3, "a", 0xFF0000);
			case B_X_Y:
				addActions(buttonY, FlxG.width - 128 * 3, FlxG.height - 45 * 3, "y", 0x4A35B9);
				addActions(buttonX, FlxG.width - 86 * 3, FlxG.height - 45 * 3, "x", 0x99062D);
				addActions(buttonB, FlxG.width - 44 * 3, FlxG.height - 45 * 3, "b", 0xFFCB00);
			case A_B_C_X_Y_Z:
				addActions(buttonX, FlxG.width - 128 * 3, FlxG.height - 85 * 3, "x", 0x99062D);
				addActions(buttonY, FlxG.width - 86 * 3, FlxG.height - 85 * 3, "y", 0x4A35B9);
				addActions(buttonZ, FlxG.width - 44 * 3, FlxG.height - 85 * 3, "z", 0xCCB98E);
				addActions(buttonC, FlxG.width - 128 * 3, FlxG.height - 45 * 3, "c", 0x44FF00);
				addActions(buttonB, FlxG.width - 86 * 3, FlxG.height - 45 * 3, "b", 0xFFCB00);
				addActions(buttonA, FlxG.width - 44 * 3, FlxG.height - 45 * 3, "a", 0xFF0000);
			case FULL:
				addActions(buttonV, FlxG.width - 170 * 3, FlxG.height - 85 * 3, "v", 0x49A9B2);
				addActions(buttonX, FlxG.width - 128 * 3, FlxG.height - 85 * 3, "x", 0x99062D);
				addActions(buttonY, FlxG.width - 86 * 3, FlxG.height - 85 * 3, "y", 0x4A35B9);
				addActions(buttonZ, FlxG.width - 44 * 3, FlxG.height - 85 * 3, "z", 0xCCB98E);
				addActions(buttonD, FlxG.width - 170 * 3, FlxG.height - 45 * 3, "d", 0x0078FF);
				addActions(buttonC, FlxG.width - 128 * 3, FlxG.height - 45 * 3, "c", 0x44FF00);
				addActions(buttonB, FlxG.width - 86 * 3, FlxG.height - 45 * 3, "b", 0xFFCB00);
				addActions(buttonA, FlxG.width - 44 * 3, FlxG.height - 45 * 3, "a", 0xFF0000);
		    case OptionsC:
			    addActions(buttonLeft, FlxG.width - 258, FlxG.height - 85 * 3, "left", 0xFF00FF);
				addActions(buttonRight, FlxG.width - 132, FlxG.height - 85 * 3, "right", 0xFF0000);
			    addActions(buttonC, FlxG.width - 384, FlxG.height - 135, 'c', 0x44FF00);
			    addActions(buttonB, FlxG.width - 258, FlxG.height - 135, 'b', 0xFFCB00);
				addActions(buttonA, FlxG.width - 132, FlxG.height - 135, 'a', 0xFF0000);
			case ALL:
				addActions(buttonV, FlxG.width - 170 * 3, FlxG.height - 85 * 3, "v", 0x49A9B2);
				addActions(buttonX, FlxG.width - 128 * 3, FlxG.height - 85 * 3, "x", 0x99062D);
				addActions(buttonY, FlxG.width - 86 * 3, FlxG.height - 85 * 3, "y", 0x4A35B9);
				addActions(buttonZ, FlxG.width - 44 * 3, FlxG.height - 85 * 3, "z", 0xCCB98E);
				addActions(buttonD, FlxG.width - 170 * 3, FlxG.height - 45 * 3, "d", 0x0078FF);
				addActions(buttonC, FlxG.width - 128 * 3, FlxG.height - 45 * 3, "c", 0x44FF00);
				addActions(buttonB, FlxG.width - 86 * 3, FlxG.height - 45 * 3, "b", 0xFFCB00);
				addActions(buttonA, FlxG.width - 44 * 3, FlxG.height - 45 * 3, "a", 0xFF0000);
				
				addDPad(buttonCEUp, FlxG.width - (44 + 42 * 4) * 3, FlxG.height - 85 * 3, "up", 0x00FF00);
				addDPad(buttonCEDown, FlxG.width - (44 + 42 * 4) * 3, FlxG.height - 45 * 3, "down", 0x00FFFF);
				addDPad(buttonCEG, FlxG.width - (44 + 42 * 1) * 3, 25, "g", 0x00FF00);
				
			case controlExtend:
			    if (Type.getClass(FlxG.state) != PlayState || Type.getClass(FlxG.state) == PlayState && ClientPrefs.data.extraKeys >= 1) addActions(buttonExtra1, FlxG.width * 0.5 - 44 * 3, FlxG.height * 0.5 - 127 * 0.5, "f", 0xFF0000);
				if (Type.getClass(FlxG.state) != PlayState || Type.getClass(FlxG.state) == PlayState && ClientPrefs.data.extraKeys >= 2) addActions(buttonExtra2, FlxG.width * 0.5, FlxG.height * 0.5 - 127 * 0.5, "g", 0xFFFF00);
				if (Type.getClass(FlxG.state) != PlayState || Type.getClass(FlxG.state) == PlayState && ClientPrefs.data.extraKeys >= 3) addActions(buttonExtra3, FlxG.width * 0.5, FlxG.height * 0.5 - 127 * 0.5, "x", 0x99062D);
				if (Type.getClass(FlxG.state) != PlayState || Type.getClass(FlxG.state) == PlayState && ClientPrefs.data.extraKeys >= 4) addActions(buttonExtra4, FlxG.width * 0.5, FlxG.height * 0.5 - 127 * 0.5, "y", 0x4A35B9);
			case B_E:
				addActions(buttonE, FlxG.width - 44 * 3, FlxG.height - 45 * 3, "e", 0xFF7D00);
				addActions(buttonB, FlxG.width - 86 * 3, FlxG.height - 45 * 3, "b", 0xFFCB00);
			case NONE:
		}
	}
	
	//Thanks Cagatay but You Suck because that's doesn't have a VirtualTouchPad Support -_-
	public function addActions(buttonName:FlxButton, x:Float, y:Float, Frames:String, ColorS:Int):Dynamic
	{
	    buttonsString.set(buttonName, createButton(x, y, Frames, ColorS));
        add(buttonsString.get(buttonName));
        actions.add(buttonsString.get(buttonName));
	    return buttonsString.get(buttonName);
	}
	
	public function addDPad(buttonName:FlxButton, x:Float, y:Float, Frames:String, ColorS:Int):Dynamic
	{
        buttonsString.set(buttonName, createButton(x, y, Frames, ColorS));
        add(buttonsString.get(buttonName));
        dPad.add(buttonsString.get(buttonName));
	    return buttonsString.get(buttonName);
	}
	
	/* you can use this for VirtualTouchPad Support but I'm using VirtualPad because I'm lazy, so that's useless
	public function createMobileButton(x:Float, y:Float, Frames:String, ColorS:Int):Dynamic
	{
	    return createButton(x, y, Frames, ColorS);
	}
	*/
	
	public function createButton(x:Float, y:Float, Frames:String, ColorS:Int):FlxButton {
	if (ClientPrefs.data.virtualpadType == 'New')
	{
	    var frames:FlxGraphic;

		final path:String = 'shared:assets/shared/images/virtualpad/' + ClientPrefs.data.VirtualPadSkin + '/$Frames.png';
		#if MODS_ALLOWED
		final modsPath:String = Paths.modsImages('virtualpad/' + ClientPrefs.data.VirtualPadSkin + '/$Frames');
		if(sys.FileSystem.exists(modsPath))
			frames = FlxGraphic.fromBitmapData(BitmapData.fromFile(modsPath));
		else #end if(Assets.exists(path))
			frames = FlxGraphic.fromBitmapData(Assets.getBitmapData(path));
		else
			frames = FlxGraphic.fromBitmapData(Assets.getBitmapData('shared:assets/shared/images/virtualpad/original/default.png'));

		var button:FlxButton = new FlxButton(x, y);
		button.frames = FlxTileFrames.fromGraphic(frames, FlxPoint.get(Std.int(frames.width / 2), frames.height));
		button.solid = false;
		button.immovable = true;
		button.moves = false;
		button.scrollFactor.set();
		if (ColorS != -1 && ClientPrefs.data.coloredvpad) button.color = ColorS;
		button.antialiasing = ClientPrefs.data.antialiasing;
		#if FLX_DEBUG
		button.ignoreDrawDebug = true;
		#end
		return button;
	}
	else // you can still use the old controls if you want
	{
		var button = new FlxButton(x, y);
		button.frames = FlxTileFrames.fromFrame(getFrames().getByName(Frames), FlxPoint.get(132, 127));
		button.resetSizeFromFrame();
		button.solid = false;
		button.immovable = true;
		button.scrollFactor.set();
		if (ColorS != -1 && ClientPrefs.data.coloredvpad) button.color = ColorS;
		button.antialiasing = ClientPrefs.data.antialiasing;
		#if FLX_DEBUG
		button.ignoreDrawDebug = true;
		#end
		return button;
	}
	}

	public static function getFrames():FlxAtlasFrames {
	    final path:String = 'assets/images/mobilecontrols/virtualpad/' + ClientPrefs.data.VirtualPadSkin + '.png';
		#if MODS_ALLOWED
		final modsPath:String = Paths.modsImages('mobilecontrols/virtualpad/' + ClientPrefs.data.VirtualPadSkin);
		if(sys.FileSystem.exists(modsPath))
			return Paths.getPackerAtlas('mobilecontrols/virtualpad/' + ClientPrefs.data.VirtualPadSkin);
		else #end if(Assets.exists(path))
			return Paths.getPackerAtlas('mobilecontrols/virtualpad/' + ClientPrefs.data.VirtualPadSkin);
		else
			return Paths.getPackerAtlas('mobilecontrols/virtualpad/original');
	}
	
	override public function destroy():Void
	{
		super.destroy();
		for (field in Reflect.fields(this))
			if (Std.isOfType(Reflect.field(this, field), FlxButton))
				Reflect.setField(this, field, FlxDestroyUtil.destroy(Reflect.field(this, field)));
	}
}