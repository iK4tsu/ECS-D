module example.components.conection;

import ecs;


@safe pure final class Conection : IComponent
{
	@safe pure this(Entity e = null)
	{
		singular = e;
	}

	Entity singular;
}