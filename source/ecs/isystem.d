module ecs.isystem;

import ecs.entity;
import ecs.hub;

public interface ISystem
{
	public void update(EntityId eid);
	public void init(ref Hub hub);
}


import ecs.icomponent;
version(unittest)
{
	class FooSys : ISystem
	{
		private Hub _hub;
		private Foo foo;
		private ComponentTypeId fooID;

		public void init(ref Hub hub)
		{
			_hub = hub;
			fooID = _hub.componentGetType!Foo;
		}

		public void update(EntityId eid)
		{
			foo = _hub.entityGetComponent!Foo(eid);
			if (foo !is null)
				foo.someData++;
		}
	}
}