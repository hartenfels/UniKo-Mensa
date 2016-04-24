package unikomensa;

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

}
