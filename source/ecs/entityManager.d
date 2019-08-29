module ecs.entityManager;

import ecs.entity;
import ecs.icomponent;
import ecs.componentManager;


class EntityManager
{
	private Entity[EntityId] _mEntities;
	private EntityId[EntityType] _mTypes;
	private EntityId[] _deletedEntities;

	public this() {}


	public EntityId createEntity(const string name, const EntityType type)
	{
		Entity e = new Entity(name, type);
		_mEntities[e._id] = e;
		_mTypes[type] = e._id;
		return e._id;
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
		return (type in _mTypes) ? getEntity(_mTypes[type]) : null;
	}
}