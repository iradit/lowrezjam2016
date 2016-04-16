import ash.core.*;
import gengine.*;
import gengine.components.*;
import gengine.math.*;

class GameSystem extends System
{
    public function new()
    {
        super();
    }

    override public function update(dt:Float):Void
    {
        if(Gengine.getInput().getScancodePress(41))
        {
            trace('Escaped just pressed.');
            Gengine.exit();
        }

        if(Gengine.getInput().getMouseButtonDown(1))
        {
            var p = Gengine.getInput().getMousePosition();
            trace('Mouse position : ' + p.x + ', ' + p.y);
        }
    }
}

class Application
{
    public static function init()
    {
        trace("Application.init()");

        untyped __js__("$('#gui').remove();");

        Gengine.setWindowSize(new IntVector2(64, 64));
        Gengine.setWindowTitle("Chamosqui - lowrezjam2016");
    }

    public static function start(engine:Engine)
    {
        trace("Application.start()");

        untyped __js__("$('canvas').css('width', 512);");
        untyped __js__("$('canvas').css('height', 512);");
        untyped __js__("$('canvas').css('image-rendering', 'pixelated');");

        engine.addSystem(new GameSystem(), 2);

        var gameEntity:Entity = new Entity();
        gameEntity.add(new Transform());
        gameEntity.add(new StaticSprite2D(Gengine.getResourceCache().getSprite2D('mockup.png', true)));

        engine.addEntity(gameEntity);
    }
}
