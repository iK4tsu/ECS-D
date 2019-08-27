module example.systemFactory;

import ecs.system;
import ecs.isystem;
import ecs.hub;


void generateSystems(ref Hub hub)
{
	/*
	 * generate all of your systems;
	 * the order you add your systems is the order they will get updated
	 * so the systems who needs to be updated first should be added in the first position
	 * for example, the render system should be one the last being added
	 */ 
	hub.CreateSystem!(MovementSystem);
}