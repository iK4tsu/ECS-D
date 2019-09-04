module ecs.entityManager;

import ecs.entity;
import ecs.icomponent;
import ecs.componentManager;
import ecs.hub;


import ecs.exceptions.entity;


final class EntityManager
{
	private Entity[EntityId] mEntities;
	//private EntityType[EntityId] _mTypes;
	private EntityId[] delEntities;
	private Hub hub;
	public ComponentManager component;


	public this() { this(null, null); }
	public this(Hub _hub, ComponentManager _component)
	{
		hub = _hub;
		component = _component;
	}


	public Entity create()
	{
		Entity e = delEntities.length > 0 ?
			new Entity(this, popDeletedId) :
			new Entity(this, 0);

		mEntities[e._id] = e;

		if (hub !is null)
			hub.system.addEntity(e);

		return e;
	}


	@safe pure
	public EntityId popDeletedId()
	{
		EntityId eid = delEntities[0];
		delEntities = delEntities.length > 1 ? delEntities[1 .. $] : null;
		return eid;
	}


	public void kill(EntityId eid)
	{
		if (exists(eid))
		{
			destroy(mEntities[eid]);
			mEntities.remove(eid);
			delEntities ~= eid;
			return;
		}

		throw new EntityDoesNotExistException(eid, 
			"Cannot destroy entity!", "You should check " ~
			"if an entity exists before killing it.");
	}


	@safe pure
	public bool exists(EntityId eid)
	{
		return (eid in mEntities) !is null;
	}


	public Entity get(EntityId eid)
	{
		if (exists(eid))
			return mEntities[eid];

		throw new EntityDoesNotExistException(
			eid, "Cannot get entity!", "You should verify if an entity exists " ~
			"before getting it.");
	}


	public Entity get(T)()
	{
		foreach(entity; mEntities)
			if (entity.hasComponent!T)
				return entity;
		
		return null;
	}


	public Entity get(T...)()
	{
		foreach(entity; mEntities)
			if (entity.hasComponents!T)
				return entity;
		
		return null;
	}


	public Entity[] getAll(T)()
	{
		Entity[] ret;
		foreach(entity; mEntities)
			if (entity.hasComponent!T)
				ret ~= entity;
		
		return ret;
	}


	public Entity[] getAll(T...)()
	{
		Entity[] ret;
		foreach(entity; mEntities)
			if (entity.hasComponents!T)
				ret ~= entity;
		
		return ret;
	}


	//public Entity get(EntityType type)
	//{
	//	foreach(id, _type; _mTypes)
	//		if (_type == type)
	//			return getEntity(id);
//
	//	throw new EntityDoesNotExistException(
	//		-1, "Cannot get entity!", "You should verify if an entity exists " ~
	//		"before getting it.");
	//}


	@safe pure
	public EntityId[] getDeletedIds()
	{
		return delEntities;
	}


	//public bool existsType(EntityType type)
	//{
	//	import std.algorithm : canFind;
	//	return canFind(_mTypes.values, type);
	//}
}


@system unittest
{
	EntityManager manager = new EntityManager();
	Entity e = manager.create();

	assert(manager.exists(e._id));

	EntityId eid = e._id;
	assert(!manager.exists(++eid));
}


@system unittest
{
	EntityManager manager = new EntityManager();
	Entity e = manager.create();

	assert(manager.getDeletedIds.length == 0);

	ComponentTypeId eid = e._id;
	manager.kill(eid);

	assert(manager.getDeletedIds.length == 1);
	assert(manager.getDeletedIds[0] == eid);
	assert(!manager.exists(eid));
}


@system unittest
{
	EntityManager manager = new EntityManager();
	Entity e1 = manager.create();
	Entity e2 = manager.create();

	assert(e1._id == 1);
	assert(e2._id == 2);

	ComponentTypeId eid = e1._id;
	manager.kill(e1._id);

	assert(manager.getDeletedIds.length == 1);

	Entity e3 = manager.create();

	assert(manager.getDeletedIds.length == 0);
	assert(e3._id == eid);

	Entity e4 = manager.create();
	
	assert(e4._id == 3);
}