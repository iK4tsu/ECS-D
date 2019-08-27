module example.playerExample;


import ecs.entity;
import ecs.hub;
import ecs.icomponent;
import ecs.componentType;


public static EntityId createPlayerExample(ref Hub hub)
{
	EntityId playerExample = hub.EntityCreate;

	hub.EntityAddComponent!(PositionComponent)(playerExample);
	hub.EntityAddComponent!(MovableComponent)(playerExample);

	hub.EntityGetComponent!(MovableComponent)(playerExample).moveX = 4;

	return playerExample;
}