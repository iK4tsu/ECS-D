module ecs.isystem;

import ecs.entity;
import ecs.hub;

public interface ISystem
{
	public void update(Entity e);
	public void init(ref Hub _hub);
}


import ecs.icomponent;
version(unittest)
{
	class FooSys : ISystem
	{
		private Hub hub;
		private Foo foo;
		private ComponentTypeId fooID;

		public void init(ref Hub _hub)
		{
			hub = _hub;
			fooID = hub.component.idOf!Foo;
		}

		public void update(Entity e)
		{
			foo = e.getComponent!Foo;
			if (foo !is null)
				foo.someData++;
		}
	}
}