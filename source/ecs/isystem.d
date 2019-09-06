module ecs.isystem;

import ecs.entity;
import ecs.system;
import ecs.hub;

public interface ISystem
{
	public bool ismanual();
	public void update();
	public void init(System _system);
}


import ecs.icomponent;
version(unittest)
{
	class FooSys : ISystem
	{
		private System system;
		private Foo foo;
		private ComponentTypeId fooID;
		private bool manual;

		public bool ismanual() { return manual; }

		public void init(System _system)
		{
			system = _system;
			fooID = system.hub.component.idOf!Foo;
			manual = false;
		}

		public void update()
		{
			foreach(e; system.entities)
			{
				foo = e.getComponent!Foo;
				if (foo !is null)
					foo.someData++;
			}
		}
	}
}