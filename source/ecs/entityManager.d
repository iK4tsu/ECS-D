module ecs.entityManager;

import ecs.entity;
import ecs.icomponent;
import ecs.componentManager;
import ecs.hub;


import ecs.exceptions.entity;


class EntityManager
{
	private Entity[EntityId] _mEntities;
	private EntityType[EntityId] _mTypes;
	private EntityId[] _deletedEntities;
	public Hub _hub;


	public this() { this(null); }
	public this(Hub hub)
	{
		_hub = hub;
	}


	public EntityId createEntity(const string name, const EntityType type)
	{
		Entity e = _deletedEntities.length > 0 ?
			new Entity(this, pullDeletedId, name, type) :
			new Entity(this, 0, name, type);
		_mEntities[e._id] = e;
		_mTypes[e._id] = type;
		return e._id;
	}


	public EntityId pullDeletedId()
	{
		EntityId eid = _deletedEntities[0];
		_deletedEntities = _deletedEntities.length > 1 ? _deletedEntities[1 .. $] : null;
		return eid;
	}


	public void killEntity(EntityId eid)
	{
		if (hasEntity(eid))
		{
			destroy(_mEntities[eid]);
			_mEntities.remove(eid);
			_deletedEntities ~= eid;
		}
	}


	public T addComponent(T)(EntityId eid, ComponentTypeId id)
	{
		return hasEntity(eid) ? _mEntities[eid].addComponent!(T)(id) : null;
	}

	public void removeComponent(EntityId eid, ComponentTypeId id)
	{
		if (hasEntity(eid))
			_mEntities[eid].removeComponent(id);
	}

	public T getComponent(T)(EntityId eid)
	{
		return hasEntity(eid) ? _mEntities[eid].getComponent!T : null;
	}

	public void enableComponent(EntityId eid, ComponentTypeId id)
	{
		if (hasEntity(eid))
			_mEntities[eid].enableComponent(id);
	}

	public void disableComponent(EntityId eid, ComponentTypeId id)
	{
		if (hasEntity(eid))
			_mEntities[eid].disableComponent(id);
	}

	public IComponent[] getComponents(EntityId eid)
	{
		return hasEntity(eid) ? _mEntities[eid].getComponents : null;
	}

	public ComponentTypeId[] getComponentTypes(EntityId eid)
	{
		return hasEntity(eid) ? _mEntities[eid].getComponentTypes : null;
	}

	public bool hasComponent(EntityId eid, ComponentTypeId id)
	{
		return hasEntity(eid) ? _mEntities[eid].hasComponent(id) : false;
	}

	public bool hasComponents(EntityId eid, ComponentTypeId[] indices)
	{
		return hasEntity(eid) ? _mEntities[eid].hasComponents(indices) : false;
	}

	public bool hasAnyComponent(EntityId eid, ComponentTypeId[] indices)
	{
		return hasEntity(eid) ? _mEntities[eid].hasAnyComponent(indices) : false;
	}

	public bool hasEntity(EntityId eid)
	{
		return (eid in _mEntities) !is null;
	}

	public Entity getEntity(EntityId eid)
	{
		return hasEntity(eid) ? _mEntities[eid] : null;
	}

	public string getName(EntityId eid)
	{
		return hasEntity(eid) ? _mEntities[eid].getName : null;
	}

	public string getDescription(EntityId eid)
	{
		return hasEntity(eid) ? _mEntities[eid].getDescription : null;
	}

	public EntityType getType(EntityId eid)
	{
		return hasEntity(eid) ? _mEntities[eid].getType : null;
	}

	public void setDescription(EntityId eid, const string description)
	{
		if (hasEntity(eid))
			_mEntities[eid].setDescription(description);
	}

	public Entity getEntity(EntityType type)
	{
		foreach(id, _type; _mTypes)
			if (_type == type)
				return getEntity(id);
		return null;
	}

	public EntityId[] getDeletedEntities()
	{
		return _deletedEntities;
	}

	public EntityId getId(Entity e)
	{
		import std.algorithm : canFind;
		return canFind(_mEntities.values, e) ? e._id : 0;
	}

	public EntityId getId(EntityType type)
	{
		return getId(getEntity(type));
	}
}


@system unittest
{
	EntityManager manager = new EntityManager();
	EntityId eid = manager.createEntity("Am I just a number?", "Math");

	assert(manager.hasEntity(eid));
	assert(!manager.hasEntity(++eid));
}

@system unittest
{
	EntityManager manager = new EntityManager();
	EntityId eid = manager.createEntity("Should I worry", "Sad");

	assert(manager.getEntity(eid) == manager.getEntity("Sad"));
	assert(manager.getDeletedEntities.length == 0);
	
	manager.killEntity(eid);

	assert(manager.getDeletedEntities.length == 1);
	assert(manager.getDeletedEntities[0] == eid);
	assert(!manager.hasEntity(eid));
	assert(manager.getEntity(eid) is null);
}

@system unittest
{
	EntityManager manager = new EntityManager();
	EntityId eid1 = manager.createEntity("I'm gonna die", "Dead");
	EntityId eid2 = manager.createEntity("I'm subject number 2!", "Guinea Pig");

	assert(eid1 == 1);
	assert(eid2 == 2);

	manager.killEntity(eid1);
	eid1 = manager.createEntity("Wait I revived?", "Blessing");

	assert(manager.getDeletedEntities.length == 0);
	assert(eid1 == 1);

	EntityId eid3 = manager.createEntity("I'm subject number 3!", "Guinea Pig");
	
	assert(eid3 == 3);
}