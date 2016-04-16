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
    private var startAngle:Float;
    private var openedAngle:Float;
    private var currentAngle:Float;
    private var rotationSpeed:Float;

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
            if(Gengine.getInput().getMouseButtonPress(1))
            {
                engine.addEntity(tongueEntity);

                startAngle = computeAngle();
                tongueNode.transform.setRotation2D(startAngle);

                headNode.animatedSprite2D.setAnimation("open", 2);
                time = 0;
                state = "opening";
            }
        }
        else if(state == "opening")
        {
            var tongue = tongueNode.tongue;

            time += dt;
            tongueNode.transform.setScale(new Vector3((time / tongue.openingDuration) * tongue.xScale, tongue.yScale, 1));
            openedAngle = computeAngle();
            tongueNode.transform.setRotation2D(openedAngle);

            if(time > tongue.openingDuration)
            {
                time = 0;
                state = "opened";

                var deltaAngle = openedAngle - getClosestAngle(startAngle, openedAngle);
                currentAngle = openedAngle;
                rotationSpeed = deltaAngle / 0.5;
            }
        }
        else if(state == "opened")
        {
            var tongue = tongueNode.tongue;
            time += dt;

            currentAngle += rotationSpeed * dt;
            tongueNode.transform.setRotation2D(currentAngle);

            if(time > tongue.openedDuration)
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
            tongueNode.transform.setScale(new Vector3(((tongue.closingDuration - time) / tongue.closingDuration) * tongue.xScale, tongue.yScale, 1));

            currentAngle += rotationSpeed * dt;
            tongueNode.transform.setRotation2D(currentAngle);

            if(time > tongue.closingDuration)
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

    private function computeAngle():Float
    {
        var mousePosition = Gengine.getInput().getMousePosition();
        var worldPosition = new Vector2(mousePosition.x / Application.windowSize.x, mousePosition.y / Application.windowSize.y);
        worldPosition.x -= 0.5;
        worldPosition.y -= 0.5;
        worldPosition.x *= 64;
        worldPosition.y *= -64;

        var mouthPosition = tongueNode.transform.position;
        var delta = new Vector2(- mouthPosition.x + worldPosition.x, - mouthPosition.y + worldPosition.y);

        var angle = Math.atan2(delta.y, delta.x) * 180/3.14159265;

        return angle;
    }

    private function getClosestAngle(angle:Float, otherAngle:Float):Float
    {
        var
            lowerAngle:Float,
            upperAngle:Float;

        lowerAngle = otherAngle - 180 + 0.001;
        upperAngle = otherAngle + 180;

        while ( angle > upperAngle )
        {
            angle -= 360;
        }

        while ( lowerAngle > angle )
        {
            angle += 360;
        }

        return angle;
    }
}
