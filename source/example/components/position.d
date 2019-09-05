module example.components.position;

import ecs;


/*
 * Generic 2D Position component
 *
 * Every component must implement the IComponent interface
 *
 *
 * This component tells if an entity has a position in an area or not
 * This means that if you have Position atached to an entity, the same
 *     is on an area's position
 */
@safe pure final class Position : IComponent
{
	@safe pure this(int _x = int.init, int _y = int.init) { x = _x; y = _y;}

	int x;
	int y;
	int oldX;
	int oldY;
}