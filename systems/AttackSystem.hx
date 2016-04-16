package systems;

import ash.core.Engine;
import ash.core.NodeList;
import ash.core.System;
import ash.core.*;

import gengine.nodes.*;
import gengine.components.*;
import gengine.Gengine;
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

        tongueEntity = new Entity();
        tongueEntity.add(new Transform());
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
            if(Gengine.getInput().getScancodePress(44))
            {
                headNode.animatedSprite2D.setAnimation("open", 2);
                time = 0;
                state = "opening";
                engine.addEntity(tongueEntity);
            }
        }
        else if(state == "opening")
        {
            time += dt;
            if(time > 0.5)
            {
                time = 0;
                state = "opened";
            }
        }
        else if(state == "opened")
        {
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
            time += dt;
            if(time > 0.5)
            {
                time = 0;
                state = "closed";
                engine.removeEntity(tongueEntity);
            }
        }
    }

    private function onNodeAdded(node:HeadNode):Void
    {
        headNode = node;
    }

    private function onTongueAdded(node:TongueNode):Void
    {
        tongueNode = node;
        tongueNode.staticSprite2D.setLayer(100);
    }
}
