module example.componentFactory;

import ecs.componentType;
import ecs.icomponent;
import ecs.hub;


void generateComponents(ref Hub hub)
{
	/*
	 * generate all your components
	 * this components are the ones use to build new ones for your entities
	 * when you add a component to an entity, one of the same type will get pulled from the parent array
	 * and then it will generate a new one based on the same type
	 */
	hub.componentCreate!(PositionComponent);
	hub.componentCreate!(MovableComponent);
}