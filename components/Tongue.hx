package components;

import nodes.*;

class Tongue
{
    public var xScale:Float = 0.6;
    public var yScale:Float = 0.5;
    public var openingDuration:Float = 0.2;
    public var openedDuration:Float = 0.5;
    public var closingDuration:Float = 0.5;

    public var catchedFlies:Array<FlyNode> = [];

    public function new()
    {
    }
}
