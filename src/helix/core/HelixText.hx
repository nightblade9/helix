package helix.core;

import flixel.input.mouse.FlxMouseEventManager;
import flixel.text.FlxText;

class HelixText extends FlxText
{
    public static var defaultFont:String = "Arial"; // safe cross-OS font
    
    public var fontSize(get, null):Int;

    // 0 maxWidth = autosize
    public function new(x:Int, y:Int, content:String, fontSize:Int, maxWidth:Int = 0)
    {
        super(x, y, maxWidth, content, fontSize, false);
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
