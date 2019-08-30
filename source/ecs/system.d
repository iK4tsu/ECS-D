module ecs.system;

import ecs.isystem;
import ecs.entity;
import ecs.hub;


import std.traits;

alias SystemName = string;

class System
{
	private Hub _hub;
	private ISystem[SystemName] _systems;
	private EntityId[] _eids;


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
		return existsSystem!T ? cast(T)(_systems[__traits(identifier, T)]) : null;
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


@System unittest
{
	System system = new System(new Hub());
	system.createSystem!FooSys;

	assert(system.existsSystem!FooSys);
	assert(cast(FooSys) system.getSystem!FooSys !is null);
}