module example.systemFactory;

import ecs.hub;

// import your systems
import example.systems.movement;

void generateSystems(ref Hub hub)
{
	/*
	 * generate all of your systems through the hub;
	 * the order you add your systems is the order they will get updated
	 * so the systems who needs to be updated first should be added in the first position
	 * for example, the render system should be one the last being added
	 */ 
	hub.systemCreate!Movement;
}