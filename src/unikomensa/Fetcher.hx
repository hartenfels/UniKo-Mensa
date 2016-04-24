package unikomensa;

import haxe.Http;
import openfl.net.SharedObject;
import unikomensa.Parser;

using DateTools;

typedef FetchCallback = {
    ymd : String,
    func: Array<Menu> -> Void,
};


class Fetcher
{

    static inline var SHARED_OBJECT = "unikoxml";
    static inline var API_URL =
      #if flash
        "https://enigmatic-badlands-73446.herokuapp.com/"
      #else
        "http://www.studierendenwerk-koblenz.de/api/speiseplan/speiseplan.xml"
      #end;

    var so:Dynamic;
    var callbacks = new Array<FetchCallback>();

    public function new()
    {
        try {
            so = SharedObject.getLocal(SHARED_OBJECT);
        } catch (e:Dynamic) {
            trace(e);
            // Punt to non-persistent object.
            so = {data: {}, flush: function (minDiskSpace:Int = 0) {}};
        }
    }


    function remember(map:MenuMap):Void
    {
        for (key in Reflect.fields(so.data))
            Reflect.deleteField(so.data, key);

        for (ymd in map.keys())
            Reflect.setField(so.data, ymd, map[ymd]);

        so.flush(0);
    }

    function callCallbacks():Void
    {
        for (cb in callbacks)
            cb.func(Reflect.field(so.data, cb.ymd));
        callbacks = [];
    }

    function callError(e:Dynamic):Void
    {
        var errorMenu = [{
            type : "rip",
            title: "Fehler",
            text : 'Die Menüdaten konnten nicht geladen werden.\n\n$e',
        }];

        for (cb in callbacks)
            cb.func(errorMenu);

        callbacks = [];
    }

    function onData(data:String):Void
    {
        try {
            remember(Parser.parse(data));
        } catch (e:Dynamic) {
            callError(e);
            return;
        }
        callCallbacks();
    }

    function onError(error:String):Void
    {
        callError(error);
    }

    function fetchMenus(callback:FetchCallback):Void
    {
        callbacks.push(callback);
        if (callbacks.length != 1)
            return;

        var http = new Http(API_URL);
      #if js
        http.async = true;
      #end
        http.onData  = onData;
        http.onError = onError;
        http.request();
    }


    public function getMenusFor(date:Date, callback:Array<Menu> -> Void):Void
    {
        var ymd = date.format("%Y-%m-%d");
        if (Reflect.hasField(so.data, ymd)) {
            var menus:Array<Menu> = Reflect.field(so.data, ymd);
            callback(menus);
        } else {
            fetchMenus({ymd: ymd, func: callback});
        }
    }

}
