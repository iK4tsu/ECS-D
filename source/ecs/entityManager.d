module ecs.entityManager;

import ecs.entity;
import ecs.icomponent;
import ecs.componentType;


class EntityManager
{
	private Entity[EntityId] _mEntities;
	private EntityId[] _deletedEntities;

	public this() {}


	public EntityId CreateEntity()
	{
		Entity e = new Entity();
		_mEntities[e._id] = e;
		return e._id;
	}


	public void KillEntity(EntityId id)
	{
		if (HasEntity(id))
		{
			destroy(_mEntities[id]);
			_mEntities.remove(id);
			_deletedEntities ~= id;
		}
	}


	public void AddComponent(EntityId id, ComponentType index, IComponent component)
	{
		if (HasEntity(id))
			_mEntities[id].AddComponent(index, component);
	}

	public void RemoveComponent(EntityId id, ComponentType index)
	{
		if (HasEntity(id))
			_mEntities[id].RemoveComponent(index);
	}

	public IComponent GetComponent(EntityId id, ComponentType index)
	{
		return HasEntity(id) ? _mEntities[id].GetComponent(index) : null;
	}

	public IComponent[] GetComponents(EntityId id, ComponentType index)
	{
		return HasEntity(id) ? _mEntities[id].GetComponents : null;
	}

	public ComponentType[] GetComponentTypes(EntityId id, ComponentType index)
	{
		return HasEntity(id) ? _mEntities[id].GetComponentTypes : null;
	}

	public bool HasComponent(EntityId id, ComponentType index)
	{
		return HasEntity(id) ? _mEntities[id].HasComponent(index) : false;
	}

	public bool HasComponents(EntityId id, ComponentType[] indices)
	{
		return HasEntity(id) ? _mEntities[id].HasComponents(indices) : false;
	}

	public bool HasAnyComponent(EntityId id, ComponentType[] indices)
	{
		return HasEntity(id) ? _mEntities[id].HasAnyComponent(indices) : false;
	}

	public bool HasEntity(EntityId id)
	{
		return (((id in _mEntities) != null) ? true : false);
	}
}


unittest
{
	EntityManager manager = new EntityManager();

	EntityId eid = manager.CreateEntity();

	assert(manager.HasEntity(eid));
}


unittest
{
	EntityManager manager = new EntityManager();
	EntityId eid = manager.CreateEntity();
	PositionComponent position = new PositionComponent();

	manager.AddComponent(eid, Position, position);

	assert(manager.HasComponent(eid, Position));
	assert(manager.GetComponent(eid, Position) == position);

	manager.RemoveComponent(eid, Position);

	assert(!manager.HasComponent(eid, Position));
	assert(manager.GetComponent(eid, Position) is null);

}

unittest
{
	EntityManager manager = new EntityManager();

	assert(!manager.HasEntity(0));
	assert(!manager.HasComponent(0, Position));
}