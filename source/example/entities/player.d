module example.entities.player;


import ecs;

import example.components.position;
import example.components.movable;


public EntityId createPlayer(ref Hub hub)
{
	EntityId eid = hub.entityCreate("Player", "Player");

	Position position = hub.entityAddComponent!Position(eid);
	Movable movable = hub.entityAddComponent(new Movable(4) , eid);

	return eid; 
}