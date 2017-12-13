package helix.random;

import flixel.math.FlxRandom;

import helix.GameTime;

// Triggers a callback on a random interval, uniformly, between min and max time.
class IntervalRandomTimer
{
    private var minIntervalSeconds:Float = 0;
    private var maxIntervalSeconds:Float = 0;
    private var random = new FlxRandom();
    private var callback:Void->Void;

    private var createdOn:GameTime;
    private var nextCallbackTime:GameTime;

    public function new(minIntervalSeconds:Float, maxIntervalSeconds:Float, callback:Void->Void)
    {
        this.minIntervalSeconds = minIntervalSeconds;
        this.maxIntervalSeconds = maxIntervalSeconds;
        this.callback = callback;
        this.createdOn = GameTime.totalGameTimeSeconds;
        this.nextCallbackTime = this.createdOn; // Don't spawn immediately
        this.pickNextInterval();
    }

    public function update(elapsedSeconds:Float):Void
    {
        if (GameTime.totalGameTimeSeconds >= this.nextCallbackTime)
        {
            this.callback();
            this.pickNextInterval();
        }
    }

    private function pickNextInterval():Void
    {
        // Convert from seconds to milliseconds
        this.nextCallbackTime += random.float(minIntervalSeconds, maxIntervalSeconds);
    }
}