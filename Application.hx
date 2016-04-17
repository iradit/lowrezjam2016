import ash.core.*;
import gengine.*;
import gengine.components.*;
import gengine.math.*;
import systems.*;
import components.*;

class Application
{
    public static var windowSize:IntVector2;
    public static function init()
    {
        trace("Application.init()");

        untyped __js__("
            if(typeof $ !== 'undefined') {
                this.windowSize = new Module.IntVector2(64, 64);
            }
            else {
                this.windowSize = new Module.IntVector2(640, 640);
            }
        ");

        Gengine.setWindowSize(windowSize);
        Gengine.setWindowTitle("Chamosqui - lowrezjam2016");
    }

    public static function start(engine:Engine)
    {
        trace("Application.start()");

        untyped __js__("
            if(typeof $ !== 'undefined') {
                $('#gui').remove();
                $('canvas').css('width', 320);
                $('canvas').css('height', 320);
                $('canvas').css('image-rendering', 'optimizeSpeed');
                $('canvas').css('image-rendering', '-moz-crisp-edges');
                $('canvas').css('image-rendering', '-webkit-optimize-contrast');
                $('canvas').css('image-rendering', '-o-crisp-edges');
                $('canvas').css('image-rendering', 'crisp-edges');
                $('canvas').css('image-rendering', 'pixelated');
                $('canvas').css('-ms-interpolation-mode', 'nearest-neighbor');
            }
        ");

        engine.addSystem(new AttackSystem(), 2);
        engine.addSystem(new GameSystem(), 3);
        engine.addSystem(new CollisionSystem(), 3);

        var entity:Entity;

        entity = new Entity();
        entity.add(new Transform(new Vector3(0, 0, 0)));
        entity.add(new AnimatedSprite2D(Gengine.getResourceCache().getAnimationSet2D('bg.scml', true), "light"));
        entity.get(AnimatedSprite2D).setLayer(0);
        engine.addEntity(entity);

        entity = new Entity();
        entity.add(new Transform(new Vector3(20, 10, 0)));
        entity.add(new AnimatedSprite2D(Gengine.getResourceCache().getAnimationSet2D('tail.scml', true), "idle"));
        entity.add(new Tail());
        entity.get(AnimatedSprite2D).setLayer(0);
        engine.addEntity(entity);

        entity = new Entity();
        entity.add(new Transform(new Vector3(0, 0, 0)));
        entity.add(new StaticSprite2D(Gengine.getResourceCache().getSprite2D('body.png', true)));
        entity.get(StaticSprite2D).setLayer(1);
        engine.addEntity(entity);

        entity = new Entity();
        entity.add(new Transform(new Vector3(-20, 10, 0)));
        entity.add(new AnimatedSprite2D(Gengine.getResourceCache().getAnimationSet2D('head.scml', true), "idle", 2));
        entity.add(new Head());
        entity.get(AnimatedSprite2D).setLayer(5);
        engine.addEntity(entity);
    }
}
