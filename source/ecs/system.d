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


	public void CreateSystem(ISystem system)
	{
		import std.conv : to;
		SystemName name = to!(string)(system);
		
		if (name !in _systems)
		{
			_systems[name] = system;
			system.SetHub(_hub);
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
				system.update(eid);
			}
		}
	}
}