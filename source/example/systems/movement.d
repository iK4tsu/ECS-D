module example.systems.movement;

import ecs;


// imports of the necessary components needed for this system
import example.components.position;
import example.components.movable;


/*
 * Movement system updates the position on a movable entity
 *
 * When creating a new system, you have to implement the ISystem interface
 * 
 * This interface has some functions:
 *     setHub(Hub hub)                    it's used to comunicate with with all the entity components
 *     update(EntityId id)                it's used to update a specific entity
 */
class Movement : ISystem
{
	// Don't forget to add a Hub aswell;
	private Hub hub;

	// Component ids
	private ComponentTypeId positionId;
	private ComponentTypeId movableId;

	// temporary components for better access
	private Position position;
	private Movable movable;

	public void init(ref Hub _hub)
	{
		hub = _hub;
		positionId = hub.component.idOf!Position;
		movableId = hub.component.idOf!Movable;
	}

	// all the game logic you need
	public void update(Entity e)
	{
		if (e.hasComponents([positionId, movableId]))
		{
			position = e.getComponent!Position;
			movable = e.getComponent!Movable;

			move;
		}
	}

	private void move()
	{
		position.x += movable.speed;
	}
}