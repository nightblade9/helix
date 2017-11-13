package helix;

/* Haxe gives us per-second time granularity on Android. This isn't good enough.
So instead, we leverage the HelixState.update(elapsed) method, which gives us
sub-second granularity; we keep a running total, so that we can measure
sub-second total game-time.
*/
class GameTime
{
    private static var totalElapsedSeconds(default, null):Float = 0;
    public var elapsedSeconds(default, null):Float = 0;

    public static function now():GameTime
    {
        return new GameTime(totalElapsedSeconds);
    }

    public static function update(elapsedSeconds:Float):Void
    {
        GameTime.totalElapsedSeconds += elapsedSeconds;
    }

    public function new(elapsedSeconds:Float = 0)
    {
        this.elapsedSeconds = elapsedSeconds;
    }
}