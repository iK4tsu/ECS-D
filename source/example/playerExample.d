module example.playerExample;


import ecs.entity;
import ecs.hub;
import ecs.icomponent;
import ecs.componentType;


public static EntityId createPlayerExample(ref Hub hub)
{
	EntityId playerExample = hub.CreateEntity;

	hub.AddComponent!(PositionComponent)(playerExample, Position);
	hub.AddComponent!(MovableComponent)(playerExample, Movable);

	hub.GetComponent!(MovableComponent)(playerExample, Movable).moveX = 4;

	return playerExample;
}