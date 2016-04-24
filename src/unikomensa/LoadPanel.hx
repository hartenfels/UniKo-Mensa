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
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;

class LoadPanel extends SpriteContainer
{

    var icon      = new Sprite();
    var textField = new TextField();

    public function new()
    {
        super();
        percentWidth  = 100;
        percentHeight = 100;

        var asset = Assets.getBitmapData("assets/spinner.png");

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
        rotate();

        var format   = new TextFormat();
        format.font  = Assets.getFont("assets/Roboto-Medium.ttf").fontName;
        format.size  = 20;
        format.color = 0x333333;
        format.align = TextFormatAlign.CENTER;

        textField.defaultTextFormat = format;
        textField.wordWrap          = true;
        textField.text              = "Making the Mensa\nApp Great Again...";
        childSprite.addChild(textField);

        addEventListener(UIEvent.RESIZE, function (_) { resize(); });
        resize();
    }

    function resize():Void
    {
        icon.x = width  / 2;
        icon.y = height / 2 - 25;

        textField.width = width;
        textField.y     = height * 0.5 + 50;
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
