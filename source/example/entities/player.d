module example.entities.player;


import ecs;

import example.components.position;
import example.components.movable;
import example.components.hero;


public Entity createPlayer(ref Hub hub)
{
	Entity e = hub.entity.create();

	e.addComponent!Hero;
	e.addComponent!Position;
	e.addComponent(new Movable(4));


	assert(e.getComponent!Position.x == int.init);
	assert(e.getComponent!Position.y == int.init);
	assert(e.getComponent!Movable.speed == 4);

	return e;
}