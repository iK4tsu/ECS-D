module ecs.system;

import ecs.isystem;
import ecs.entity;
import ecs.hub;


import std.traits;

alias SystemName = string;

final class System
{
	private Hub hub;
	private ISystem[] systems;
	private Entity[] entities;


	@safe pure
	public this(Hub _hub)
	{
		hub = _hub;
	}


	public void create(T)()
	{
		if (!exists!T)
		{
			T t = new T();
			systems ~= t;
			t.init(hub);
		}
	}


	@safe pure
	public T get(T)()
	{
		foreach(system; systems)
			if (cast(T) system !is null)
				return cast(T) system;

		return null;
	}


	@safe pure
	public bool exists(T)()
	{
		foreach(system; systems)
			if (cast(T) system !is null)
				return true;

		return false; 
	}


	@safe pure
	public void addEntity(Entity e)
	{
		entities ~= e;
	}


	@safe pure
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
	hub.component.create!Foo;
	hub.system.create!FooSys;

	assert(hub.system.exists!FooSys);
	assert(cast(FooSys) hub.system.get!FooSys !is null);
}