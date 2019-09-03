module example.entities.player;


import ecs;

import example.components.position;
import example.components.movable;


public Entity createPlayer(ref Hub hub)
{
	Entity e = hub.entity.create();

	Position position = e.addComponent!Position;
	Movable movable = e.addComponent(new Movable(4));

	return e;
}