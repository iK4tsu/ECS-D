module ecs.entityManager;

import ecs.entity;
import ecs.icomponent;
import ecs.componentManager;
import ecs.hub;


import ecs.exceptions.entity;


final class EntityManager
{
	private Entity[EntityId] _mEntities;
	//private EntityType[EntityId] _mTypes;
	private EntityId[] _deletedEntities;
	public Hub hub;
	public ComponentManager component;


	public this() { this(null, null); }
	public this(Hub _hub, ComponentManager _component)
	{
		hub = _hub;
		component = _component;
	}


	public Entity create()
	{
		Entity e = _deletedEntities.length > 0 ?
			new Entity(this, popDeletedId) :
			new Entity(this, 0);

		_mEntities[e._id] = e;

		if (hub !is null)
			hub.system.addEntity(e);

		return e;
	}


	public EntityId popDeletedId()
	{
		EntityId eid = _deletedEntities[0];
		_deletedEntities = _deletedEntities.length > 1 ? _deletedEntities[1 .. $] : null;
		return eid;
	}


	public void kill(EntityId eid)
	{
		if (exists(eid))
		{
			destroy(_mEntities[eid]);
			_mEntities.remove(eid);
			_deletedEntities ~= eid;
			return;
		}

		throw new EntityDoesNotExistException(eid, 
			"Cannot destroy entity!", "You should check " ~
			"if an entity exists before killing it.");
	}


	public bool exists(EntityId eid)
	{
		return (eid in _mEntities) !is null;
	}


	public Entity get(EntityId eid)
	{
		if (exists(eid))
			return _mEntities[eid];

		throw new EntityDoesNotExistException(
			eid, "Cannot get entity!", "You should verify if an entity exists " ~
			"before getting it.");
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


	public EntityId[] getDeletedIds()
	{
		return _deletedEntities;
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