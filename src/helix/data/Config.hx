package helix.data;

import openfl.Assets;

class Config
{
    public static var values:Map<String, Any>;

    ///
    // There's no easy way to access a field by field name in Haxe.
    // Using reflection gives us deplorable runtime. So, cache.
    ///
    // Use of "Any" has less performance penalty than Dynamic on static targets
    public static function get<Any>(key:String):Any
    {
        if (values == null)
        {
            loadAndCacheJson();
        }

        var toReturn:Any = values.get(key);
        return toReturn;
    }

    public static function getBool(key:String):Bool
    {
        if (values == null)
        {
            loadAndCacheJson();
        }

        var toReturn:Bool = values.get(key);
        return toReturn;
    }

    public static function getInt(key:String):Int
    {
        if (values == null)
        {
            loadAndCacheJson();
        }

        var toReturn:Int = values.get(key);
        return toReturn;
    }

    public static function getFloat(key:String):Float
    {
        if (values == null)
        {
            loadAndCacheJson();
        }

        var toReturn:Float = values.get(key);
        return toReturn;
    }

    public static function getString(key:String):String
    {
        if (values == null)
        {
            loadAndCacheJson();
        }

        var toReturn:String = values.get(key);
        return toReturn;
    }

    public static function set(key:String, value:Any):Void
    {
        if (values == null)
        {
            loadAndCacheJson();
        }

        values.set(key, value);
    }

    private static function loadAndCacheJson():Void
    {
        values = new Map<String, Any>();
        var text = openfl.Assets.getText("assets/data/config.json");

        // Remove comments
        var regex = new EReg("//.*", "g");
        text = regex.replace(text, "");

        var json = haxe.Json.parse(text);
        // Inspired by JsonPrinter.objString
        // Track fields => values
        var fields = Reflect.fields(json);
        for (i in 0 ... fields.length)
        {
            var name:String = fields[i];
			var value = Reflect.field(json, name);
            values.set(name, value);
        }
    }
}