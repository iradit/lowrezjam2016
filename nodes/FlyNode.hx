package nodes;

import ash.core.Node;
import components.*;
import gengine.components.*;

class FlyNode extends Node<FlyNode>
{
    public var transform:Transform;
    public var fly:Fly;
    public var sprite:AnimatedSprite2D;
}
