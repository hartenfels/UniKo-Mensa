package unikomensa;

import haxe.Timer;
import haxe.ui.toolkit.containers.HBox;
import haxe.ui.toolkit.containers.ScrollView;
import haxe.ui.toolkit.containers.VBox;
import haxe.ui.toolkit.controls.Divider;
import haxe.ui.toolkit.controls.Image;
import haxe.ui.toolkit.controls.Text;
import unikomensa.Parser;

using DateTools;


class DayPanel extends VBox
{

    static inline var    SUNDAY = 0;
    static inline var    MONDAY = 1;
    static inline var   TUESDAY = 2;
    static inline var WEDNESDAY = 3;
    static inline var  THURSDAY = 4;
    static inline var    FRIDAY = 5;
    static inline var  SATURDAY = 6;

    static var WEEKDAYS = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"];
    var day    :Int;
    var fetcher:Fetcher;
    var loaded = false;

    public function new(?day:Int, ?fetcher:Fetcher)
    {
        super();
        this.day      = day;
        this.fetcher  = fetcher;
        percentWidth  = 100;
        percentHeight = 100;
        text          = WEEKDAYS[day];
    }

    public static function getStartingDay():Int
    {
        var date = Date.now();
        if (date.getDay() == SATURDAY || date.getDay() == SUNDAY)
            return MONDAY;
        return date.getDay();
    }


    function showLoadingScreen():Void
    {
        Timer.delay(function() {
            if (!loaded) {
                removeAllChildren(true);
                addChild(new LoadPanel());
            }
        }, 200);
    }

    function showMenus(menus:Array<Menu>)
    {
        loaded = true;
        removeAllChildren(true);

        var scroll = new ScrollView();
        scroll.percentWidth  = 100;
        scroll.percentHeight = 100;
        addChild(scroll);

        var list = new VBox();
        list.percentWidth = 100;
        scroll.addChild(list);

        var spacer    = new Divider();
        spacer.id     = "topspacer";
        spacer.height = 10;
        list.addChild(spacer);

        for (menu in menus) {
            var hbox = new HBox();
            hbox.id           = "menu";
            hbox.percentWidth = 100;
            list.addChild(hbox);

            var image      = new Image();
            image.resource = 'assets/${menu.type}.png';
            image.width    = 80;
            hbox.addChild(image);

            var vbox = new VBox();
            vbox.percentWidth = 100;
            hbox.addChild(vbox);

            var heading          = new Text();
            heading.id           = "heading";
            heading.text         = menu.title;
            heading.percentWidth = 100;
            vbox.addChild(heading);

            var description          = new Text();
            description.text         = menu.text;
            description.percentWidth = 100;
            description.multiline    = true;
            description.wrapLines    = true;
            vbox.addChild(description);

            list.addChild(new Divider());
        }
    }


    public function wakeUp():Void
    {
        var date = Date.now();
        if (date.getDay() == SATURDAY || date.getDay() == SUNDAY)
            date = date.delta(7.0.days());

        while (date.getDay() < day)
            date = date.delta(1.0.days());

        while (date.getDay() > day)
            date = date.delta(-1.0.days());

        loaded = false;
        fetcher.getMenusFor(date, showMenus);
        if (!loaded)
            showLoadingScreen();
    }

    public function fallAsleep():Void
    {
    }

}
