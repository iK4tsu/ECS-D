module ecs.entityManager;

import ecs.entity;
import ecs.icomponent;
import ecs.componentType;
import ecs.componentManager;


class EntityManager
{
	private Entity[EntityId] _mEntities;
	private EntityId[] _deletedEntities;

	public this() {}


	public EntityId createEntity()
	{
		Entity e = new Entity();
		_mEntities[e._id] = e;
		return e._id;
	}


	public void killEntity(EntityId id)
	{
		if (hasEntity(id))
		{
			destroy(_mEntities[id]);
			_mEntities.remove(id);
			_deletedEntities ~= id;
		}
	}


	public void addComponent(T)(EntityId id, ComponentTypeId index)
	{
		if (hasEntity(id))
			_mEntities[id].addComponent!(T)(index);
	}

	public void removeComponent(EntityId id, ComponentTypeId index)
	{
		if (hasEntity(id))
			_mEntities[id].removeComponent(index);
	}

	public T getComponent(T)(EntityId id)
	{
		return hasEntity(id) ? _mEntities[id].getComponent!T : null;
	}

	public void enableComponent(EntityId id, ComponentTypeId index)
	{
		if (hasEntity(id))
			_mEntities[id].enableComponent(index);
	}

	public void disableComponent(EntityId id, ComponentTypeId index)
	{
		if (hasEntity(id))
			_mEntities[id].disableComponent(index);
	}

	public IComponent[] getComponents(EntityId id)
	{
		return hasEntity(id) ? _mEntities[id].getComponents : null;
	}

	public ComponentTypeId[] getComponentTypes(EntityId id)
	{
		return hasEntity(id) ? _mEntities[id].getComponentTypes : null;
	}

	public bool hasComponent(EntityId id, ComponentTypeId index)
	{
		return hasEntity(id) ? _mEntities[id].hasComponent(index) : false;
	}

	public bool hasComponents(EntityId id, ComponentTypeId[] indices)
	{
		return hasEntity(id) ? _mEntities[id].hasComponents(indices) : false;
	}

	public bool hasAnyComponent(EntityId id, ComponentTypeId[] indices)
	{
		return hasEntity(id) ? _mEntities[id].hasAnyComponent(indices) : false;
	}

	public bool hasEntity(EntityId id)
	{
		return (id in _mEntities) !is null;
	}

	public Entity getEntity(EntityId id)
	{
		return hasEntity(id) ? _mEntities[id] : null;
	}
}


unittest
{
	EntityManager manager = new EntityManager();

	EntityId eid = manager.createEntity();

	assert(manager.hasEntity(eid));
}


unittest
{
	EntityManager manager = new EntityManager();
	EntityId eid = manager.createEntity();

	manager.addComponent!(PositionComponent)(eid, Position);

	assert(manager.hasComponent(eid, Position));
	assert(cast(PositionComponent)(manager.getComponent!(PositionComponent)(eid)) !is null);

	manager.removeComponent(eid, Position);

	assert(!manager.hasComponent(eid, Position));
	assert(manager.getComponent!(PositionComponent)(eid) is null);

}

unittest
{
	EntityManager manager = new EntityManager();

	assert(!manager.hasEntity(0));
	assert(!manager.hasComponent(0, Position));
}