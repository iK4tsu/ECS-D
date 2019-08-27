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
			if (!ExistsSystem!T)
			{
				T t = new T();
				_systems[T.stringof] = t;
				t.SetHub(_hub);
			}
		}
	}

	template GetSystem(T)
	{
		public T GetSystem()
		{
			if (ExistsSystem!T)
			{
				return cast(T)(_systems[T.stringof]);
			}
		}
	}

	template ExistsSystem(T)
	{
		public bool ExistsSystem()
		{
			return (((T.stringof in _systems) !is null) ? true : false); 
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