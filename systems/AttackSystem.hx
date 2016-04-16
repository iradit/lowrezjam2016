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

class AttackSystem extends System
{
    private var headNode:HeadNode;
    private var tongueNode:TongueNode;
    private var tongueEntity:Entity;
    private var engine:Engine;
    private var state = "closed";
    private var time:Float;

    public function new()
    {
        super();
    }

    override public function addToEngine(_engine:Engine):Void
    {
        engine = _engine;
        engine.getNodeList(HeadNode).nodeAdded.add(onNodeAdded);
        engine.getNodeList(TongueNode).nodeAdded.add(onTongueAdded);
        engine.getNodeList(TongueNode).nodeRemoved.add(onTongueRemoved);

        tongueEntity = new Entity();
        tongueEntity.add(new Transform(new Vector3(-100, 0, 0)));
        tongueEntity.add(new Tongue());
        tongueEntity.add(new StaticSprite2D(Gengine.getResourceCache().getSprite2D('tongue-large.png', true)));
    }

    override public function update(dt:Float):Void
    {
        if(Gengine.getInput().getScancodePress(41))
        {
            Gengine.exit();
        }

        if(state == "closed")
        {
            if(Gengine.getInput().getScancodePress(44) || Gengine.getInput().getMouseButtonPress(1))
            {
                headNode.animatedSprite2D.setAnimation("open", 2);
                time = 0;
                state = "opening";
                engine.addEntity(tongueEntity);
            }
        }
        else if(state == "opening")
        {
            var tongue = tongueNode.tongue;

            time += dt;
            tongueNode.transform.setScale(new Vector3((time / 0.5) * tongue.xScale, tongue.yScale, 1));
            if(time > 0.5)
            {
                time = 0;
                state = "opened";
            }
        }
        else if(state == "opened")
        {
            var tongue = tongueNode.tongue;

            time += dt;
            if(time > 0.5)
            {
                time = 0;
                state = "closing";
                headNode.animatedSprite2D.setAnimation("close", 2);
            }
        }
        else if(state == "closing")
        {
            var tongue = tongueNode.tongue;

            time += dt;
            tongueNode.transform.setScale(new Vector3(((0.5 - time) / 0.5) * tongue.xScale, tongue.yScale, 1));
            if(time > 0.5)
            {
                time = 0;
                state = "closed";
                engine.removeEntity(tongueEntity);
            }
        }

        if(tongueNode != null)
        {

        }
    }

    private function onNodeAdded(node:HeadNode):Void
    {
        headNode = node;
    }

    private function onTongueAdded(node:TongueNode):Void
    {
        tongueNode = node;
        tongueNode.transform.setPosition(new Vector3(-10, -2, 0));
        tongueNode.transform.setScale(new Vector3(0, 0, 0));
        tongueNode.staticSprite2D.setLayer(100);
        tongueNode.staticSprite2D.setUseHotSpot(true);
        tongueNode.staticSprite2D.setHotSpot(new Vector2(0, 0.5));
    }

    private function onTongueRemoved(node:TongueNode):Void
    {
        tongueNode = null;
    }
}
