module ecs.system;

import ecs.isystem;
import ecs.entity;
import ecs.hub;


import std.traits;

alias SystemName = string;

final class System
{
	private Hub hub;
	private ISystem[SystemName] systems;
	private Entity[] entities;


	public this(Hub _hub)
	{
		hub = _hub;
	}


	public void createSystem(T)()
	{
		if (!existsSystem!T)
		{
			T t = new T;
			systems[__traits(identifier, T)] = t;
			t.init(hub);
		}
	}

	public T getSystem(T)()
	{
		return existsSystem!T ? cast(T)(systems[__traits(identifier, T)]) : null;
	}

	public bool existsSystem(T)()
	{
		return (T.stringof in systems) !is null; 
	}

	public void addEntity(Entity e)
	{
		entities ~= e;
	}

	public void removeEntity(Entity e)
	{
		import std.algorithm : remove;
		remove!(a => a = e)(entities);
	}

	public void update()
	{
		foreach(e; entities)
		{
			foreach(system; systems)
			{
				system.update(e);
			}
		}
	}
}


import ecs.icomponent;
@System unittest
{
	Hub hub = new Hub();
	hub.componentCreate!Foo;
	hub.systemCreate!FooSys;

	assert(hub.systemExists!FooSys);
	assert(cast(FooSys) hub.systemGet!FooSys !is null);
}