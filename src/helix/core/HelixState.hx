package helix.core;

import flixel.FlxG;
import flixel.FlxState;
import flixel.input.FlxInput.FlxInputState;
import flixel.input.keyboard.FlxKey;
import flixel.text.FlxText;

import helix.GameTime;
import helix.core.HelixSprite;
import helix.core.HelixText;

class HelixState extends FlxState
{
    public static var current(default, null):HelixState;

    public var width(get, null):Int;
    public var height(get, null):Int;
    public var movesToKeyboard:HelixSprite;

    public function new()
    {
        super();
        HelixState.current = this;
    }

    override public function update(elapsedSeconds:Float):Void
    {
        super.update(elapsedSeconds);
        GameTime.update(elapsedSeconds);
    }

    // https://stackoverflow.com/questions/43792751/flxg-collide-not-working-when-x648
    // Track collisions outside of screen space
    public function setCollisionBounds(x:Float, y:Float, width:Float, height:Float):Void
    {
        FlxG.worldBounds.set(x, y, width, height);
    }

    public function isKeyPressed(keyCode:Int):Bool
    {
        #if FLX_NO_KEYBOARD
        return false;
        #else
        return FlxG.keys.checkStatus(keyCode, FlxInputState.PRESSED);
        #end
    }

    public function wasJustPressed(keyCode:Int):Bool
    {
        #if FLX_NO_KEYBOARD
        return false;
        #else        
        return FlxG.keys.checkStatus(keyCode, FlxInputState.JUST_PRESSED);
        #end
    }
    
    private function get_width():Int
    {
        return FlxG.stage.stageWidth;
    }

    private function get_height():Int
    {
        return FlxG.stage.stageHeight;
    }
}