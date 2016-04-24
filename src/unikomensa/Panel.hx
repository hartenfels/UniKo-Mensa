package unikomensa;

import haxe.ui.toolkit.controls.Divider;
import haxe.ui.toolkit.containers.ScrollView;
import haxe.ui.toolkit.containers.VBox;


class Panel extends VBox
{

    public function new(?text:String)
    {
        super();
        this.text     = text;
        percentWidth  = 100;
        percentHeight = 100;
    }

    public function wakeUp():Void
    {
        // override in child class if needed
    }

    function createListPanel(callback:VBox -> Void)
    {
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

        callback(list);
        scroll.invalidate();
    }

}
