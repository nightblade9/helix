package helix.core;

import flixel.input.mouse.FlxMouseEventManager;
import flixel.text.FlxText;

class HelixText extends FlxText
{
    private static inline var DEFAULT_FIELD_WIDTH:Int = 0;
    public static var defaultFont:String = "Arial"; // safe cross-OS font
    
    public var fontSize(get, null):Int;

    public function new(x:Int, y:Int, content:String, fontSize:Int)
    {
        super(x, y, DEFAULT_FIELD_WIDTH, content, fontSize, false);
        HelixState.current.add(this);
        this.font = HelixText.defaultFont;
    }

    /**
    A callback to invoke when the user clicks on this text.
    NB: the bounding box of the text is used (it's not pixel-perfect).
    **/
    public function onClick(callback:Void->Void):HelixText
    {
        FlxMouseEventManager.add(this, function(me:HelixText):Void
        {
            callback();
        }, null, null, null, false, true, false);
        return this;
    }

    /** Alias for "size." **/
    public function get_fontSize():Int
    {
        return this.size;
    }
}
