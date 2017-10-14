package helix.core;

import flixel.FlxBasic;
import flixel.FlxCamera.FlxCameraFollowStyle;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.effects.FlxFlicker;
import flixel.input.FlxInput.FlxInputState;
import flixel.input.keyboard.FlxKey;
import flixel.input.mouse.FlxMouseEventManager;
import flixel.math.FlxPoint;

class HelixSprite extends FlxSprite
{
    public var keyboardMoveSpeed(default, null):Float = 0;
    private var componentVelocities = new Map<String, FlxPoint>();
    // collide
    private var collisionTargets = new Array<FlxBasic>();
    // collideResolve
    private var collideAndResolveTargets = new Array<FlxBasic>();
    // Both for collide-and-move and regular ol' collisions
    private var collisionCallbacks = new Map<FlxBasic, Dynamic->Dynamic->Void>();

    public function new(filename:String):Void
    {
        super();
        this.loadGraphic(filename);
        HelixState.current.add(this);
    }

    override public function update(elapsedSeconds:Float):Void
    {
        super.update(elapsedSeconds);
        var state = HelixState.current;

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

    /// Start: fluent API
    // Collide with an object (detect overlap). Doesn't resolve the collision.
    // If you want resolution/displacement, use collideResolve() instead.
    public function collide(objectOrGroup:FlxBasic, callback:Dynamic->Dynamic->Void)
    {
        this.collisionTargets.push(objectOrGroup);
        this.collisionCallbacks.set(objectOrGroup, callback);
    }

    // Collide with an object, and push it out of the way! If you don't want to resolve the
    // collision, use collide() instead. (Remember to call collisionImmovable() on your sprites if
    // you don't want them to move when collided.)
    public function collideResolve(objectOrGroup:FlxBasic, ?callback:Dynamic->Dynamic->Void = null)
    {
        this.collideAndResolveTargets.push(objectOrGroup);
        this.collisionCallbacks.set(objectOrGroup, callback);
    }

    // Sets to immovable for collisions
    public function collisionImmovable():HelixSprite
    {
        this.immovable = true;
        return this;
    }

    public function flicker(durationSeconds:Float):HelixSprite
    {
        FlxFlicker.flicker(this, durationSeconds);
        return this;
    }

    public function onClick(callback:Void->Void):HelixSprite
    {
        FlxMouseEventManager.add(this, function(me:HelixSprite):Void
        {
            callback();
        });
        return this;
    }

    public function move(x:Float, y:Float):HelixSprite
    {
        this.x = x;
        this.y = y;
        return this;
    }

    public function moveWithKeyboard(keyboardMoveSpeed:Float):HelixSprite
    {
        this.keyboardMoveSpeed = keyboardMoveSpeed;
        return this;
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

    public function trackWithCamera():HelixSprite
    {
        FlxG.camera.follow(this, FlxCameraFollowStyle.LOCKON, 1);
        return this;
    }

    /// End: fluent API
}