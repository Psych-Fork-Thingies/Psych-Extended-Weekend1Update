#!/bin/bash
cd ..
echo Installing dependencies...
echo This might take a few moments depending on your internet speed.
haxelib git linc_luajit https://github.com/Sirox228/linc_luajit master --global
haxelib install tjson --global
haxelib install flixel 5.5.0 --global
haxelib install flixel-addons 3.2.2 --global
haxelib install flixel-ui 2.4.0 --global
haxelib git SScript https://github.com/28AloneDark53/SScript-for-Psych-Extended main --global
haxelib install hscript 2.4.0 --global
haxelib git hxCodec https://github.com/Prohack101010/hxCodec-Extended-Better --global
haxelib git hxcpp https://github.com/mcagabe19-stuff/hxcpp master --global
haxelib git lime https://github.com/MobilePorting/lime --global
haxelib install openfl 9.3.3 --global
haxelib git flxanimate https://github.com/ShadowMario/flxanimate.git dev --global
haxelib git funkin.vis https://github.com/beihu235/funkVis-FrequencyFixed main --global
haxelib git grig.audio https://gitlab.com/haxe-grig/grig.audio.git 57f5d47f2533fd0c3dcd025a86cb86c0dfa0b6d2 --global
echo Setting dependencies...
haxelib dev linc_luajit /root/haxelib/linc_luajit/git
haxelib dev tjson /root/haxelib/tjson/1,4,0
haxelib dev flixel /root/haxelib/flixel/git
haxelib dev flixel-addons /root/haxelib/flixel-addons/3,2,2
haxelib dev flixel-ui /root/haxelib/flixel-ui/2,4,0
haxelib dev SScript /root/haxelib/SScript/git
haxelib dev hscript /root/haxelib/hscript/2,4,0
haxelib dev hxCodec /root/haxelib/hxCodec/git
haxelib dev hxcpp /root/haxelib/hxcpp/git
haxelib dev lime /root/haxelib/lime/git
haxelib dev openfl /root/haxelib/openfl/git
haxelib dev flxanimate /root/haxelib/flxanimate/git
haxelib dev funkin.vis /root/haxelib/funkin,vis/git
haxelib dev grig.audio /root/haxelib/grig,audio/git
echo Finished!