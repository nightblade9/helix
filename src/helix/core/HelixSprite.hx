package helix.core;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.input.keyboard.FlxKey;
import flixel.input.mouse.FlxMouseEventManager;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class HelixSprite extends FlxSprite
{    
    // Setter is public for the fluent API
    public var keyboardMoveSpeed(default, default):Float = 0;
    
    /////
    // Internal fields that are used for the fluent API support.
    // TODO: create simple setters for these so they can be better encapsulated.
    // For the ones that require getters, leave them as-is.
    public var componentVelocities = new Map<String, FlxPoint>();
    // collide
    public var collisionTargets = new Array<FlxBasic>();
    // collideResolve
    public var collideAndResolveTargets = new Array<FlxBasic>();
    // Both for collide-and-move and regular ol' collisions
    public var collisionCallbacks = new Map<FlxBasic, Dynamic->Dynamic->Void>();
    public var textField:FlxText;
    public var keypressCallback(default, default):Array<FlxKey>->Void;
    // End internal fields    
    /////

    private var filename:String;

    /**
     *  Creates a new sprite with the given image. If you just want to use a coloured
     *  rectangle, pass in null for the filename and fill out the other parameters.
     */
    public function new(?filename:String, ?colourDetails:ColourDetails):Void
    {
        super();

        if (filename != null && colourDetails == null)
        {
            this.loadGraphic(filename);
        }
        else if (colourDetails != null && filename == null)
        {
            this.makeGraphic(colourDetails.width, colourDetails.height, colourDetails.colour, true);
        }
        else
        {
            throw "Please specify an image file OR colour details (but not both).";
        }

        this.filename = filename;
        HelixState.current.add(this);
    }

    override public function update(elapsedSeconds:Float):Void
    {
        super.update(elapsedSeconds);
        var state = HelixState.current;

        this.processKeybinds();

         // Move to keyboard if specified
        if (keyboardMoveSpeed > 0)
        {
            var vx:Float = 0;
            var vy:Float = 0;
            var isMoving:Bool = false;

            if (state.isKeyPressed(FlxKey.LEFT) || state.isKeyPressed(FlxKey.A))
            {
                vx = -this.keyboardMoveSpeed;
                isMoving = true;
            }
            else if (state.isKeyPressed(FlxKey.RIGHT) || state.isKeyPressed(FlxKey.D))
            {
                vx = this.keyboardMoveSpeed;
                isMoving = true;
            }
                
            if (state.isKeyPressed(FlxKey.UP) || state.isKeyPressed(FlxKey.W))            
            {
                vy = -this.keyboardMoveSpeed;
                isMoving = true;
            }
            else if (state.isKeyPressed(FlxKey.DOWN) || state.isKeyPressed(FlxKey.S))
            {
                vy = this.keyboardMoveSpeed;
                isMoving = true;
            }

            if (isMoving)
            {
                this.setComponentVelocity("Movement", vx, vy);
            }
            else
            {
                this.setComponentVelocity("Movement", 0, 0);
            }
        }

        for (target in this.collisionTargets)
        {
            FlxG.overlap(this, target, this.collisionCallbacks.get(target));
        }

        // Collide with specified targets
        for (target in this.collideAndResolveTargets)
        {
            FlxG.collide(this, target, this.collisionCallbacks.get(target));
        }
    }

    
    public function hasComponentVelocity(name:String):Bool
    {
        return this.componentVelocities.exists(name);
    }

    override public function destroy():Void
    {
        if (this.textField != null)
        {
            this.textField.destroy();
        }

        super.destroy();
    }

    override public function clone():HelixSprite
    {
        return new HelixSprite(this.filename);
    }

    // Text makes things complicated
    override public function set_x(x:Float):Float
    {
        super.x = x;
        if (this.textField != null)
        {
            this.textField.x = x;
        }
        return x;
    }

    override public function set_y(y:Float):Float
    {
        super.y = y;
        if (this.textField != null)
        {
            this.textField.y = y;
        }
        return y;
    }

     /**
    A callback to invoke when the user clicks on this sprite.
    **/
    public function onClick(callback:Void->Void):HelixSprite
    {
        FlxMouseEventManager.add(this, function(me:HelixSprite):Void
        {
            callback();
        }, null, null, null, false, true, false);
        return this;
    }

    private function processKeybinds():Void
    {
        #if !FLX_NO_KEYBOARD
        if (this.keypressCallback != null)
        {
            var pressedKeys = [
                for (flxinput in FlxG.keys.getIsDown())
                    flxinput.ID
            ];

            this.keypressCallback(pressedKeys);
        }
        #end
    }

    private function setComponentVelocity(name:String, vx:Float, vy:Float):HelixSprite
    {
        if (vx == 0 && vy == 0)
        {
            this.componentVelocities.remove(name);
        }
        else
        {
            this.componentVelocities.set(name, new FlxPoint(vx, vy));
        }

        // Cached so accessing velocity is blazing fast (120FPS? no problem!)
        var total = new FlxPoint();
        for (v in this.componentVelocities)
        {
            total.add(v.x, v.y);
        }

        this.velocity.copyFrom(total);

        return this;
    }
}

typedef ColourDetails ={
    width: Int,
    height: Int,
    colour: FlxColor
}