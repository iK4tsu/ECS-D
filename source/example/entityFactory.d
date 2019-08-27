module example.entityFactory;

import ecs.entity;
import ecs.ientity;
import ecs.hub;
import ecs.icomponent;
import ecs.componentType;


void generateEntities(ref Hub hub)
{
	/*
	 * generate all your entities
	 * you should generate all of them and it's components through the hub
	 */

	EntityId exampleId = hub.CreateEntity;
	
	/*
	 * when adding components, you have to specify wich component, and it's corresponding type
	 */
	hub.AddComponent!(PositionComponent)(exampleId, Position);
	hub.AddComponent!(MovableComponent)(exampleId, Movable);

	/*
	 * you can init all your component variables with values you need
	 */
	hub.GetComponent!(MovableComponent)(exampleId, Movable).moveX = 4;


	/*
	 * you can also generate them this way
	 */
	import example.playerExample;
	EntityId playerExample = createPlayerExample(hub);
}