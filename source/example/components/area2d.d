module example.components.area2d;

import ecs;


@safe pure final class Area2D : IComponent
{
	@safe pure public this(int _dimensionX = int.init, int _dimensionY = int.init)
	{
		dimensionX = _dimensionX;
		dimensionY = _dimensionY;
		area = new string[][](dimensionY, dimensionX);
	}

	// Your not supposed to have entities in a component like this
	// This is only for an exampe 
	Entity[] entities;
	EntityId[] eids;

	string[][] area;
	int dimensionX;
	int dimensionY;
}