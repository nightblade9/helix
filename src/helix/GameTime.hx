package helix;

/* Haxe gives us per-second time granularity on Android. This isn't good enough.
So instead, we leverage the HelixState.update(elapsed) method, which gives us
sub-second granularity; we keep a running total, so that we can measure
sub-second total game-time.
*/
class GameTime
{
    // static class    
    public static var totalGameTimeSeconds(default, null):Float = 0;

    public static function update(elapsedSeconds:Float):Void
    {
        GameTime.totalGameTimeSeconds += elapsedSeconds;
    }
}

typedef TotalGameTime = Float;