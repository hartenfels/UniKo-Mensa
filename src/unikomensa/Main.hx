package unikomensa;

import haxe.ui.toolkit.containers.TabView;
import haxe.ui.toolkit.controls.TabBar;
import haxe.ui.toolkit.core.Root;
import haxe.ui.toolkit.core.RootManager;
import haxe.ui.toolkit.core.Toolkit;
import haxe.ui.toolkit.core.XMLController;
import haxe.ui.toolkit.events.UIEvent.*;
import haxe.ui.toolkit.style.Style;
import haxe.ui.toolkit.style.StyleManager;
import motion.Actuate;
import motion.easing.Quad;
import openfl.Assets;


private class Controller extends XMLController
{
    public function new()
        super("assets/layout.xml");
}


class Main
{

    var fetcher = new Fetcher();


    function pickTab(tabs:TabView)
    {
        var bar    = cast(tabs.getChildAt(0), TabBar);
        var tab    = bar.getTabButton(bar.selectedIndex);
        var pos    = tab.x + (tab.width - bar.width) / 2;
        var scroll = Math.min(pos, bar.hscrollMax);
        var delta  = Math.abs(bar.hscrollPos - scroll);
        Actuate.tween(bar, delta / 500, {hscrollPos: scroll})
               .ease(Quad.easeOut);

        cast(tabs.selectedPage, Panel).wakeUp();
    }

    function setUpTabs(tabs:TabView)
    {
        for (day in 1 ... 6)
            tabs.addChild(new DayPanel(day, fetcher));

        tabs.addChild(new InfoPanel());
        tabs.selectedIndex = DayPanel.getStartingDay() - 1;

        tabs.addEventListener(CHANGE, function (_) { pickTab(tabs); });
        pickTab(tabs);
    }


    public function main()
    {
        Toolkit.init();

        var regular = Assets.getFont("assets/Roboto-Regular.ttf").fontName;
        var medium  = Assets.getFont("assets/Roboto-Medium.ttf" ).fontName;
        var sm      = StyleManager.instance;
        sm.addStyle("Text",          new Style({fontName: regular}));
        sm.addStyle("#heading",      new Style({fontName: medium }));
        sm.addStyle("TabBar Button", new Style({fontName: medium }));

        Toolkit.openFullscreen(function (root:Root) {
            var controller = new Controller();
            root.addChild(controller.view);
            setUpTabs(root.findChild("tabs", TabView, true));
        });
    }

    public function new()
        main();

}
