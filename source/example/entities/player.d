module example.entities.player;


import ecs.hub;

import example.components.position;
import example.components.movable;


public EntityId createPlayer(ref Hub hub)
{
	EntityId eid = hub.entityCreate;

	Position position = hub.entityAddComponent!Position(eid);
	Movable movable = hub.entityAddComponent!Movable(eid);

	movable.speed = 4;

	return eid; 
}