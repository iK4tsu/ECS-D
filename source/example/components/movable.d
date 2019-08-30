module example.components.movable;


import ecs;

/*
 * This component exists only to tell if an entity can move or not
 * If an entity doesn't have the component it wont be able to move
 */
class Movable : IComponent
{
	uint speed;
}