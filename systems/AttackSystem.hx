package systems;

import ash.core.Engine;
import ash.core.NodeList;
import ash.core.System;

import gengine.nodes.*;
import gengine.Gengine;
import nodes.*;

class AttackSystem extends System
{
    private var headNode:HeadNode;
    private var engine:Engine;

    public function new()
    {
        super();
    }

    override public function addToEngine(_engine:Engine):Void
    {
        engine = _engine;
        engine.getNodeList(HeadNode).nodeAdded.add(onNodeAdded);
    }

    override public function update(dt:Float):Void
    {
        if(Gengine.getInput().getScancodePress(41))
        {
            Gengine.exit();
        }

        if(Gengine.getInput().getScancodePress(44))
        {
            headNode.animatedSprite2D.setAnimation("close", 2);
        }
    }

    private function onNodeAdded(node:HeadNode):Void
    {
        trace('Head node added!');

        headNode = node;
    }
}
