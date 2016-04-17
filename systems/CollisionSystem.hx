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

class CollisionSystem extends System
{
    private var engine:Engine;
    private var flyNodes:NodeList<FlyNode>;
    private var tongueNodes:NodeList<TongueNode>;

    public function new()
    {
        super();
    }
    override public function addToEngine(_engine:Engine):Void
    {
        engine = _engine;
        flyNodes = engine.getNodeList(FlyNode);
        tongueNodes = engine.getNodeList(TongueNode);
    }

    override public function update(dt:Float):Void
    {
        for(tongueNode in tongueNodes)
        {
            var tonguePosition = tongueNode.transform.position;
            var tongueDirection = tongueNode.transform.getRight();
            var tongueScale = tongueNode.transform.scale.x;
            var tongueEnd = new Vector2(tonguePosition.x + tongueDirection.x * 64 * tongueScale, tonguePosition.y + tongueDirection.y * 64 * tongueScale);

            for(flyNode in flyNodes)
            {
                var position = flyNode.fly.position;
                var r = getIntersections(tonguePosition, tongueEnd, position, 3);
                if(r)
                {
                    flyNode.fly.velocity.x = 0;
                    flyNode.fly.velocity.y = 0;
                    flyNode.fly.catched = true;
                    flyNode.transform.setParent(tongueNode.transform);
                    flyNode.transform.setWorldPosition(new Vector3(position.x, position.y, 0));
                    tongueNode.tongue.catchedFlies.push(flyNode);
                    //engine.removeEntity(flyNode.entity);
                }
            }
        }
    }

    private function getIntersections(from:Vector3, to:Vector2, circleCenter:Vector2, circleRadius:Float):Bool
    {
        untyped __js__("
            var a = [from.x, from.y];
            var b = [to.x, to.y];
            var c = [circleCenter.x, circleCenter.y, circleRadius];
            var eDistAtoB = Math.sqrt( Math.pow(b[0]-a[0], 2) + Math.pow(b[1]-a[1], 2) );
            var d = [ (b[0]-a[0])/eDistAtoB, (b[1]-a[1])/eDistAtoB ];
            var t = (d[0] * (c[0]-a[0])) + (d[1] * (c[1]-a[1]));

            var e = {coords:[], onLine:false};
            e.coords[0] = (t * d[0]) + a[0];
            e.coords[1] = (t * d[1]) + a[1];

            var eDistCtoE = Math.sqrt( Math.pow(e.coords[0]-c[0], 2) + Math.pow(e.coords[1]-c[1], 2) );

            if( eDistCtoE < c[2] ) {
                var dt = Math.sqrt( Math.pow(c[2], 2) - Math.pow(eDistCtoE, 2));
                var f = {coords:[], onLine:false};
                f.coords[0] = ((t-dt) * d[0]) + a[0];
                f.coords[1] = ((t-dt) * d[1]) + a[1];
                f.onLine = this.is_on(a,b,f.coords);
                var g = {coords:[], onLine:false};
                g.coords[0] = ((t+dt) * d[0]) + a[0];
                g.coords[1] = ((t+dt) * d[1]) + a[1];
                g.onLine = this.is_on(a,b,g.coords);

                return f.onLine || g.onLine;
            }
        ");

        return false;
    }

    function distance(a,b)
    {
        return Math.sqrt(Math.pow(a[0]-b[0], 2) + Math.pow(a[1]-b[1], 2));
    }

    function is_on(a, b, c)
    {
        return this.distance(a,c) + this.distance(c,b) == this.distance(a,b);
    }
}
