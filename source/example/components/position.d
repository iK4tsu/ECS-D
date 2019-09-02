module example.components.position;

import ecs;


/*
 * Generic Position component
 *
 * Every component must implement the IComponent interface
 */
class Position : IComponent
{
	this(int _x = int.init, int _y = int.init) { x = _x; y = _y;}

	int x;
	int y;
}