module example.systems.physics;

import ecs;


import example.components.position;
import example.components.movable;
import example.components.explosive;
import example.components.conection;
import example.components.area2d;

@system pure final class PhysicsSystem : ISystem
{
	private System system;
	private Position positionA;
	private Position positionB;
	public bool manual = false;

	public bool ismanual() { return manual; }

	@safe pure public void init(System _system)
	{
		system = _system;
	}

	public void update()
	{
		for (uint i = 0; i < system.entities.length - 1; i++)
		{
			for (uint j = i + 1; j < system.entities.length; j++)
			{
				Entity a = system.entities[i];
				Entity b = system.entities[j];

				if (a != b && a.hasComponent!Position && b.hasComponent!Position)
				{
					positionA = a.getComponent!Position;
					positionB = b.getComponent!Position;

					if (checkColision)
					{
						if (a.hasComponent!Explosive || b.hasComponent!Explosive)
							explosion(a, b);
						else
							fixPosition(a, b);
						break;
					}
				}
			}
		}
	}

	public bool checkColision()
	{
		return (positionA.x == positionB.x && positionA.y == positionB.y);
	}

	public void fixPosition(ref Entity a, ref Entity b)
	{
		if (a.hasComponent!Movable && !b.hasComponent!Movable)
		{
			positionA.x = positionA.oldX;
			positionA.y = positionA.oldY;
		}
		else
		{
			positionB.x = positionB.oldX;
			positionB.y = positionB.oldY;
		}
	}

	public void explosion(ref Entity a, ref Entity b)
	{
		kill(a);
		kill(b);
	}

	public void kill(Entity e)
	{
		import std.algorithm : countUntil, remove;

		Entity conection = e.getComponent!Conection.singular;
		Area2D area = conection.getComponent!Area2D;

		size_t index = countUntil(area.eids , e._id);
		area.eids = area.eids.remove(index);
		area.entities = area.entities.remove(index);

		e.kill;
	}
}