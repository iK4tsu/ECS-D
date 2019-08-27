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

	EntityId exampleId = hub.EntityCreate;
	
	/*
	 * when adding components, you have to specify wich component, and it's corresponding type
	 */
	hub.EntityAddComponent!(PositionComponent)(exampleId);
	hub.EntityAddComponent!(MovableComponent)(exampleId);

	/*
	 * you can init all your component variables with values you need
	 */
	hub.EntityGetComponent!(MovableComponent)(exampleId).moveX = 4;


	/*
	 * you can also generate them this way
	 */
	import example.playerExample;
	EntityId playerExample = createPlayerExample(hub);
}