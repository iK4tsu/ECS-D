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


	public void createSystem(T)()
	{
		if (!existsSystem!T)
		{
			T t = new T();
			_systems[T.stringof] = t;
			t.setHub(_hub);
		}
	}

	public T getSystem(T)()
	{
		if (ExistsSystem!T)
		{
			return cast(T)(_systems[T.stringof]);
		}
	}

	public bool existsSystem(T)()
	{
		return (T.stringof in _systems) !is null; 
	}

	public void setEids(EntityId[] eids)
	{
		_eids = eids;
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