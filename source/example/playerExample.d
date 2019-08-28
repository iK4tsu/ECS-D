module example.playerExample;


import ecs.entity;
import ecs.hub;
import ecs.icomponent;
import ecs.componentType;


public static EntityId createPlayerExample(ref Hub hub)
{
	EntityId playerExample = hub.entityCreate;

	hub.entityAddComponent!PositionComponent(playerExample);
	hub.entityAddComponent!MovableComponent(playerExample);

	hub.entityGetComponent!MovableComponent(playerExample).moveX = 4;

	return playerExample;
}