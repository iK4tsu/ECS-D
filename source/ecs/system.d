module ecs.system;

import ecs.isystem;
import ecs.entity;
import ecs.hub;
import ecs.entityManager;


import std.traits;

alias SystemName = string;

final class System
{
	public EntityManager entity;
	public Entity[] entities;
	private EntityId[] eids;
	private ISystem[] systems;


	@safe pure
	public this(ref EntityManager _entity)
	{
		entity = _entity;
	}


	public void create(T)()
	{
		if (!exists!T)
		{
			T t = new T();
			systems ~= t;
			t.init(this);
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
		eids ~= e._id;
	}


	@safe pure
	public void removeEntity(Entity e)
	{
		import std.algorithm : countUntil, remove;
		import std.conv : to;
		size_t index = countUntil(eids, e._id);
		entities = entities.remove(index);
		eids = eids.remove(index);
	}


	public void update()
	{
		foreach(system; systems)
		{
			if (!system.ismanual)
				system.update;
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