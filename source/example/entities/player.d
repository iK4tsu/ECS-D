module example.entities.player;


import ecs;

import example.components.position;
import example.components.movable;
import example.components.hero;
import example.components.sprite;
import example.components.input;


public Entity createPlayer(ref Hub hub)
{
	Entity e = hub.entity.create();

	e.addComponent!Hero;
	e.addComponent!Position;
	e.addComponent!Input;
	e.addComponent(new Movable(1));
	e.addComponent(new Sprite("@"));


	assert(e.getComponent!Position.x == int.init);
	assert(e.getComponent!Position.y == int.init);
	assert(e.getComponent!Movable.speed == 1);
	assert(e.getComponent!Sprite.img == "@");

	return e;
}