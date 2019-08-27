module ecs.system;

import ecs.isystem;
import ecs.entity;
import ecs.hub;

alias SystemName = string;

class System
{
	public Hub _hub;
	public ISystem[SystemName] _systems;
	public EntityId[] _eids;


	public this(Hub hub)
	{
		_hub = hub;
	}


	template CreateSystem(T)
	{
		public void CreateSystem()
		{
			string name = T.stringof;
			import std.stdio;
			writeln(name);
			if (name !in _systems)
			{
				T t = new T();
				_systems[name] = t;
				t.SetHub(_hub);
			}
		}
	}

	public void SetEids(EntityId[] eids)
	{
		_eids = eids;
	}

	public void Update()
	{
		foreach(eid; _eids)
		{
			foreach(system; _systems)
			{
				system.Update(eid);
			}
		}
	}
}