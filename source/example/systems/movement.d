module example.systems.movement;

// always import these two
import ecs.isystem;
import ecs.hub;


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
	private Hub _hub;

	// Component ids
	private ComponentTypeId positionId;
	private ComponentTypeId movableId;

	// temporary components for better access
	private Position position;
	private Movable movable;

	public void init(ref Hub hub)
	{
		_hub = hub;
		positionId = _hub.componentGetType!Position;
		movableId = _hub.componentGetType!Movable;
	}

	// all the game logic you need
	public void update(EntityId eid)
	{
		if (_hub.entityHasComponents(eid, [positionId, movableId]))
		{
			position = _hub.entityGetComponent!Position(eid);
			movable = _hub.entityGetComponent!Movable(eid);

			move;
		}
	}

	private void move()
	{
		position.x += movable.speed;
	}
}