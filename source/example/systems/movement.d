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
 *     void init(System _system)                      it's used to comunicate with components and all available entities
 *     void update()                                it's used to update entities
 */
@system pure final class MovementSystem : ISystem
{
	// Don't forget to add a System aswell;
	private System system;

	// temporary components for better access
	private Position position;
	private Movable movable;
	private Input input;
	public bool manual = false;

	public bool ismanual() { return manual; }

	@safe pure public void init(System _system)
	{
		system = _system;
	}

	// all the game logic you need
	public void update()
	{
		foreach(e; system.entities)
		{
			if (e.hasComponents!(Position, Movable, Input))
			{
				position = e.getComponent!Position;
				movable = e.getComponent!Movable;
				input = e.getComponent!Input;

				move;
			}
		}
	}

	private void move()
	{
		position.oldY = position.y;
		position.oldX = position.x;

		switch (input.word)
		{
			case "up":
			case "w":
				position.y -= movable.speed;
				break;
			case "down":
			case "s":
				position.y += movable.speed;
				break;
			case "right":
			case "d":
				position.x += movable.speed;
				break;
			case "left":
			case "a":
				position.x -= movable.speed;
				break;
			default:
		}
	}
}