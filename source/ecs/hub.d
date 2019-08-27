module ecs.hub;

import ecs.entity;
import ecs.icomponent;
import ecs.componentType;
import ecs.entityManager;
import ecs.componentManager;
import ecs.system;


class Hub
{
	public EntityManager _entityManager;
	public ComponentManager _componentManager;
	public System _system;

	public this()
	{
		_entityManager = new EntityManager();
		_componentManager = new ComponentManager();
		_system = new System(this);
	}


	/********************************************* ENTITY MANAGER FUNCTIONS *********************************************/
	template EntityAddComponent(T)
	{
		public void EntityAddComponent(EntityId id)
		{
			if (ComponentExists!T)
			{
				_entityManager.AddComponent!(T)(id, ComponentGetType!T);
			}
		}
	}

	public void EntityRemoveComponent(EntityId id, ComponentType index)
	{
		_entityManager.RemoveComponent(id, index);
	}

	template EntityGetComponent(T)
	{
		public T EntityGetComponent(EntityId id)
		{
			return _entityManager.GetComponent!(T)(id, ComponentGetType!T);
		}
	}

	public EntityId EntityCreate()
	{
		return _entityManager.CreateEntity;
	}

	public void EntityEnableComponent(EntityId id, ComponentType index)
	{
		_entityManager.EnableComponent(id, index);
	}

	public void EntityDisableComponent(EntityId id, ComponentType index)
	{
		_entityManager.DisableComponent(id, index);
	}


	/********************************************* COMPONENT MANAGER FUNCTIONS *********************************************/
	template ComponentCreate(T)
	{
		public void ComponentCreate(ComponentType index)
		{
			_componentManager.CreateComponent!(T)(index);
		}
	}

	template ComponentExists(T)
	{
		public bool ComponentExists()
		{
			return _componentManager.HasComponent!T;
		}
	}

	template ComponentGet(T)
	{
		public T ComponentGet()
		{
			return _componentManager.GetComponent!T;
		}
	}

	template ComponentGetType(T)
	{
		public ComponentType ComponentGetType()
		{
			return _componentManager.GetType!T;
		}
	}


	/*************************************************** SYSTEM FUNCTIONS **************************************************/
	public void UpdateSystems()
	{
		_system.Update();
	}

	template SystemCreate(T)
	{
		public void SystemCreate()
		{
			_system.CreateSystem!T;
		}
	}

	template SystemGet(T)
	{
		public T SystemGet()
		{
			return _system.GetSystem!T;
		}
	}

	template SystemExists(T)
	{
		public bool SystemExists()
		{
			return _system.ExistsSystem!T;
		}
	}
}


unittest
{
	Hub mHub = new Hub();

	mHub.ComponentCreate!(PositionComponent)(Position);

	assert(mHub.ComponentExists!PositionComponent);
	assert(!mHub.ComponentExists!MovableComponent);
}

unittest
{
	Hub hub = new Hub();

	hub.ComponentCreate!(PositionComponent)(Position);

	EntityId e = hub.EntityCreate;

	hub.EntityAddComponent!PositionComponent(e);
	
	assert(is(typeof(hub.EntityGetComponent!PositionComponent(e)) == PositionComponent));
}