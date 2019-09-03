module ecs.entityManager;

import ecs.entity;
import ecs.icomponent;
import ecs.componentManager;
import ecs.hub;


import ecs.exceptions.entity;


final class EntityManager
{
	private Entity[EntityId] _mEntities;
	private EntityType[EntityId] _mTypes;
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

		_mEntities[e.getId] = e;
		_mTypes[e.getId] = type;

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
		if (hasEntity(eid))
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
		if (hasEntity(eid))
			return _mEntities[eid];

		throw new EntityDoesNotExistException(
			eid, "Cannot get entity!", "You should verify if an entity exists " ~
			"before getting it.");
	}


	public Entity get(EntityType type)
	{
		foreach(id, _type; _mTypes)
			if (_type == type)
				return getEntity(id);

		throw new EntityDoesNotExistException(
			-1, "Cannot get entity!", "You should verify if an entity exists " ~
			"before getting it.");
	}


	public EntityId[] getDeletedIds()
	{
		return _deletedEntities;
	}


	public bool existsType(EntityType type)
	{
		import std.algorithm : canFind;
		return canFind(_mTypes.values, type);
	}
}

/*
@system unittest
{
	EntityManager manager = new EntityManager();
	Entity e = manager.createEntity("Am I just a number?", "Math");

	assert(manager.hasEntity(e.getId));
	EntityId eid = e.getId;
	assert(!manager.hasEntity(++eid));
}

@system unittest
{
	EntityManager manager = new EntityManager();
	Entity e = manager.createEntity("Should I worry", "Sad");

	assert(e == manager.getEntity("Sad"));
	assert(manager.getDeletedEntities.length == 0);
	
	manager.killEntity(e.getId);

	assert(manager.getDeletedEntities.length == 1);
	assert(manager.getDeletedEntities[0] == e.getId);
	assert(!manager.hasEntity(e.getId));
}

@system unittest
{
	EntityManager manager = new EntityManager();
	Entity e1 = manager.createEntity("I'm gonna die", "Dead");
	Entity e2 = manager.createEntity("I'm subject number 2!", "Guinea Pig");

	assert(e1.getId == 1);
	assert(e2.getId == 2);

	manager.killEntity(e1.getId);
	e1 = manager.createEntity("Wait I revived?", "Blessing");

	assert(manager.getDeletedEntities.length == 0);
	assert(e1.getId == 1);

	Entity e3 = manager.createEntity("I'm subject number 3!", "Guinea Pig");
	
	assert(e3.getId == 3);
}*/