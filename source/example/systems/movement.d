module example.systems.movement;

import ecs;


// imports of the necessary components needed for this system
import example.components.position;
import example.components.movable;
import example.components.input;


/*
 * MovementSystem updates the position on a movable entity
 *
 * When creating a new system, you have to implement ISystem
 * 
 *
 * The interface has the functions:
 *     void init(ref Hub _hub)                      it's used to comunicate with all the entity components
 *     void update(Entity e)                   it's used to update a specific entity
 */
final class MovementSystem : ISystem
{
	// Don't forget to add a Hub aswell;
	private Hub hub;

	// Component ids
	private ComponentTypeId positionId;
	private ComponentTypeId movableId;

	// temporary components for better access
	private Position position;
	private Movable movable;
	private Input input;

	public void init(ref Hub _hub)
	{
		hub = _hub;
		positionId = hub.component.idOf!Position;
		movableId = hub.component.idOf!Movable;
	}

	// all the game logic you need
	public void update(Entity e)
	{
		if (e.hasComponents!(Position, Movable, Input))
		{
			position = e.getComponent!Position;
			movable = e.getComponent!Movable;
			input = e.getComponent!Input;

			move;
		}
	}

	private void move()
	{
		switch (input.word)
		{
			case "up":
				position.y -= movable.speed;
				break;
			case "down":
				position.y += movable.speed;
				break;
			case "right":
				position.x += movable.speed;
				break;
			case "left":
				position.x -= movable.speed;
				break;
			default:
		}
	}
}