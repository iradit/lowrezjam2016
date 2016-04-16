package systems;

import ash.core.Engine;
import ash.core.NodeList;
import ash.core.System;
import ash.core.*;

import gengine.nodes.*;
import gengine.components.*;
import gengine.Gengine;
import gengine.math.*;
import nodes.*;
import components.*;

class GameSystem extends System
{
    private var engine:Engine;
    private var flyNodes:NodeList<FlyNode>;
    private var flyAnim = Gengine.getResourceCache().getAnimationSet2D('mosquito.scml', true);
    private var timer:Float = 0;

    public function new()
    {
        super();
    }
    override public function addToEngine(_engine:Engine):Void
    {
        engine = _engine;
        flyNodes = engine.getNodeList(FlyNode);
        flyNodes.nodeAdded.add(onNodeAdded);
        flyNodes.nodeRemoved.add(onNodeRemoved);
    }

    override public function update(dt:Float):Void
    {
        timer += dt;

        if(timer > 1.0)
        {
            spawnFly();
            timer = 0;
        }

        for (node in flyNodes)
        {
            var position = node.fly.position;
            var velocity = node.fly.velocity;

            position.x += velocity.x * dt;
            position.y += velocity.y * dt;

            node.transform.setPosition(new Vector3(Math.floor(position.x), Math.floor(position.y), 0));
        }
    }

    private function spawnFly()
    {
        var e = new Entity();
        var position = new Vector3(Math.random() * 32, Math.random() * 32, 0);
        e.add(new Transform(position));
        e.add(new Fly());
        e.add(new AnimatedSprite2D(flyAnim, "fly"));

        e.get(AnimatedSprite2D).setLayer(10);
        e.get(Fly).velocity = new Vector2(Math.random() * 10 - 5, Math.random() * 10 - 5);
        e.get(Fly).position = position;
        engine.addEntity(e);
    }

    private function onNodeAdded(node:FlyNode):Void
    {
    }

    private function onNodeRemoved(node:FlyNode):Void
    {
    }
}
