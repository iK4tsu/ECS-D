module ecs.system;

import ecs.isystem;
import ecs.entity;
import ecs.hub;


import std.traits;

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


	public void createSystem(T)()
	{
		if (!existsSystem!T)
		{
			T t = new T;
			_systems[__traits(identifier, T)] = t;
			t.init(_hub);
		}
	}

	public T getSystem(T)()
	{
		if (ExistsSystem!T)
		{
			return cast(T)(_systems[__traits(identifier, T)]);
		}
	}

	public bool existsSystem(T)()
	{
		return (T.stringof in _systems) !is null; 
	}

	public void addEid(EntityId eid)
	{
		_eids ~= eid;
	}

	public void removeEid(EntityId eid)
	{
		import std.algorithm : remove;
		remove!(a => a = eid)(_eids);
	}

	public void update()
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