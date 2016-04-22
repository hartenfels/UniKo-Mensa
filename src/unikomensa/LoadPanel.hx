package unikomensa;

import haxe.ui.toolkit.containers.SpriteContainer;
import haxe.ui.toolkit.events.UIEvent;
import motion.Actuate;
import motion.easing.Cubic;
import motion.easing.Elastic;
import openfl.Assets;
import openfl.display.Sprite;
import openfl.geom.Matrix;
import openfl.Lib;

class LoadPanel extends SpriteContainer
{

    var icon = new Sprite();

    public function new()
    {
        super();
        percentWidth  = 100;
        percentHeight = 100;

        var asset = Assets.getBitmapData("assets/menu1.png");

        var tx = -0.5 * asset.width;
        var ty = -0.5 * asset.height;
        var m  = new Matrix();
        m.tx   = tx;
        m.ty   = ty;

        icon.graphics.beginBitmapFill(asset, m, false, true);
        icon.graphics.drawRect(tx, ty, asset.width, asset.height);
        icon.graphics.endFill();

        childSprite = new Sprite();
        childSprite.addChild(icon);

        icon.scaleX = icon.scaleY = 0.0;
        Actuate.tween(icon, 1, {scaleX: 1.0, scaleY: 1.0})
               .delay(0.2)
               .ease(Elastic.easeOut)
               .onComplete(rotate);

        addEventListener(UIEvent.RESIZE, function(_) { resize(); });
        resize();
    }

    function resize():Void
    {
        icon.x = width  / 2;
        icon.y = height / 2;
    }

    function rotate()
    {
        icon.rotation = 0;
        Actuate.tween(icon, 2, {rotation : 360 * 3})
               .ease(Cubic.easeInOut)
               .onComplete(rotate);
    }


    override public function dispose():Void
    {
        Actuate.stop(icon);
        super.dispose();
    }


}
