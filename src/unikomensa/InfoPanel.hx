package unikomensa;

import haxe.Timer;
import haxe.ui.toolkit.containers.HBox;
import haxe.ui.toolkit.containers.ScrollView;
import haxe.ui.toolkit.containers.VBox;
import haxe.ui.toolkit.controls.Divider;
import haxe.ui.toolkit.controls.Link;
import haxe.ui.toolkit.controls.Image;
import haxe.ui.toolkit.controls.Text;


class InfoPanel extends Panel
{

    static var setup:Array<{icon:String, texts:Array<Dynamic>}> = [
        {
            icon : "cc",
            texts: [
                {text: "Alle Icons in dieser Applikation sind von Icons8 und sind lizenziert unter CC BY-ND 3.0."},
                {text: "Icons8 im Browser besuchen.",      url: "https://icons8.com/"},
                {text: "Die Lizenz im Browser anschauen.", url: "https://creativecommons.org/licenses/by-nd/3.0/"},
            ],
        },
        {
            icon : "github",
            texts: [
                {text: "Gebaut von Leuten mit Händen, weil man die braucht um Code zu schreiben."},
                {text: "Make the Play Store Great Again.", url: "https://turbopope.github.io/Uni-Koblenz-Mensa/"},
                {text: "Make GitHub Great Again.",         url: "https://github.com/hartenfels/UniKo-Mensa"},
            ],
        }
    ];

    public function new()
    {
        super("About");

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

        for (s in setup) {
            var hbox = new HBox();
            hbox.id           = "menu";
            hbox.percentWidth = 100;
            list.addChild(hbox);

            var image      = new Image();
            image.resource = 'assets/${s.icon}.png';
            image.width    = 80;
            hbox.addChild(image);

            var vbox = new VBox();
            vbox.percentWidth = 100;
            hbox.addChild(vbox);

            for (t in s.texts) {
                var txt:Text;

                if (t.url != null) {
                    var lnk = new Link();
                    lnk.url = t.url;
                    txt     = lnk;
                } else {
                    txt     = new Text();
                }

                txt.text         = t.text;
                txt.percentWidth = 100;
                txt.multiline    = true;
                txt.wrapLines    = true;
                vbox.addChild(txt);
            }

            list.addChild(new Divider());
        }
    }

}
