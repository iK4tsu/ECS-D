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


	template AddComponent(T)
	{
		public void AddComponent(EntityId id, ComponentType index)
		{
			if (HasEntity(id))
				_mEntities[id].AddComponent!(T)(index);
		}
	}

	public void RemoveComponent(EntityId id, ComponentType index)
	{
		if (HasEntity(id))
			_mEntities[id].RemoveComponent(index);
	}

	template GetComponent(T)
	{
		public T GetComponent(EntityId id, ComponentType index)
		{
			return HasEntity(id) ? _mEntities[id].GetComponent!(T)(index) : null;
		}
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

	manager.AddComponent!(PositionComponent)(eid, Position);

	assert(manager.HasComponent(eid, Position));
	assert(is(typeof(manager.GetComponent!(PositionComponent)(eid, Position)) == PositionComponent));

	manager.RemoveComponent(eid, Position);

	assert(!manager.HasComponent(eid, Position));
	assert(manager.GetComponent!(PositionComponent)(eid, Position) is null);

}

unittest
{
	EntityManager manager = new EntityManager();

	assert(!manager.HasEntity(0));
	assert(!manager.HasComponent(0, Position));
}