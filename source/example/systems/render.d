module example.systems.render;

import ecs;


import example.components.area2d;
import example.components.position;
import example.components.sprite;

@system pure final class RenderSystem : ISystem
{
	private System system;
	private Area2D area2d;
	private Position position;
	private Sprite sprite;

	@safe pure public void init(System _system)
	{
		system = _system;
	}

	public void update()
	{
		foreach(e; system.entities)
		{
			if (e.hasComponent!Area2D)
			{
				area2d = e.getComponent!Area2D;

				foreach(entity; area2d.entities)
				{
					position = entity.getComponent!Position;
					sprite = entity.getComponent!Sprite;

					checkPosition;

					area2d.area[position.y][position.x] = sprite.img;
				}

				drawMap;
				resetMap;
			}
			//import std.stdio;
			//writeln(e.getComponents);
		}
	}

	public void checkPosition()
	{
		if (position.x > area2d.dimensionX - 1)
			position.x = area2d.dimensionX - 1;
		else if (position.x < 0)
			position.x = 0;

		if (position.y > area2d.dimensionY - 1)
			position.y = area2d.dimensionY - 1;
		else if (position.y < 0)
			position.y = 0;
	}

	public void drawMap()
	{
		import std.stdio;
		for (uint i = 0; i < area2d.dimensionY; i++)
		{
			writeln(area2d.area[i]);
		}
	}

	public void resetMap()
	{
		for (uint i = 0; i < area2d.dimensionY; i++)
			for (uint j = 0; j < area2d.dimensionX; j++)
			area2d.area[i][j] = "";
	}
}