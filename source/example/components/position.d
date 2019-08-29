module example.components.position;

import ecs.icomponent;


/*
 * Generic Position component
 *
 * Every component must implement the IComponent interface
 */
class Position : IComponent
{
	int x;
	int y;
}