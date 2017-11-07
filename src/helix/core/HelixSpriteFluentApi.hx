package helix.core;

import flixel.FlxBasic;
import flixel.FlxCamera.FlxCameraFollowStyle;
import flixel.FlxG;
import flixel.effects.FlxFlicker;
import flixel.input.mouse.FlxMouseEventManager;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.input.keyboard.FlxKey;

class HelixSpriteFluentApi
{
    private static inline var DEFAULT_FONT_SIZE:Int = 16;

    // Collide with an object (detect overlap). Doesn't resolve the collision.
    // If you want resolution/displacement, use collideResolve() instead.
    public static function collide(sprite:HelixSprite, objectOrGroup:FlxBasic, callback:Dynamic->Dynamic->Void)
    {
        sprite.collisionTargets.push(objectOrGroup);
        sprite.collisionCallbacks.set(objectOrGroup, callback);
    }

    // Collide with an object, and push it out of the way! If you don't want to resolve the
    // collision, use collide() instead. (Remember to call collisionImmovable() on your sprites if
    // you don't want them to move when collided.)
    public static function collideResolve(sprite:HelixSprite, objectOrGroup:FlxBasic, ?callback:Dynamic->Dynamic->Void = null)
    {
        sprite.collideAndResolveTargets.push(objectOrGroup);
        sprite.collisionCallbacks.set(objectOrGroup, callback);
    }

    // Sets to immovable for collisions
    public static function collisionImmovable(sprite:HelixSprite):HelixSprite
    {
        sprite.immovable = true;
        return sprite;
    }

    public static function flicker(sprite:HelixSprite, durationSeconds:Float):HelixSprite
    {
        FlxFlicker.flicker(sprite, durationSeconds);
        return sprite;
    }

    public static function onClick(sprite:HelixSprite, callback:Void->Void):HelixSprite
    {
        FlxMouseEventManager.add(sprite, function(me:HelixSprite):Void
        {
            callback();
        });
        return sprite;
    }

    public static function move(sprite:HelixSprite, x:Float, y:Float):HelixSprite
    {
        sprite.x = x;
        sprite.y = y;
        return sprite;
    }

    public static function moveWithKeyboard(sprite:HelixSprite, keyboardMoveSpeed:Float):HelixSprite
    {
        sprite.keyboardMoveSpeed = keyboardMoveSpeed;
        return sprite;
    }

    public static function trackWithCamera(sprite:HelixSprite):HelixSprite
    {
        FlxG.camera.follow(sprite, FlxCameraFollowStyle.LOCKON, 1);
        return sprite;
    }

    // TODO: accept a format
    public static function text(sprite:HelixSprite, message:String, ?colour:FlxColor):HelixSprite
    {
        if (colour == null)
        {
            colour = FlxColor.WHITE;
        }

        if (sprite.textField != null)
        {
            sprite.textField.destroy();
        }

        sprite.textField = new FlxText(sprite.x, sprite.y, FlxG.width, message);
        sprite.textField.setFormat(null, DEFAULT_FONT_SIZE, colour);
        HelixState.current.add(sprite.textField);
        return sprite;
    }

    public static function onKeyDown(sprite:HelixSprite, callback:Array<FlxKey>->Void):HelixSprite
    {
        sprite.keypressCallbacks.push(callback);
        return sprite;
    }
}