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
	template AddComponent(T)
	{
		public void AddComponent(EntityId id, ComponentType index)
		{
			if (ComponentExists(index))
			{
				_entityManager.AddComponent!(T)(id, index);
			}
		}
	}

	public void RemoveComponent(EntityId id, ComponentType index)
	{
		_entityManager.RemoveComponent(id, index);
	}

	template GetComponent(T)
	{
		public T GetComponent(EntityId id, ComponentType index)
		{
			return _entityManager.GetComponent!(T)(id, index);
		}
	}

	public EntityId CreateEntity()
	{
		return _entityManager.CreateEntity;
	}


	/********************************************* COMPONENT MANAGER FUNCTIONS *********************************************/
	template CreateComponent(T)
	{
		public void CreateComponent(ComponentType index)
		{
			_componentManager.CreateComponent!(T)(index);
		}
	}

	public bool ComponentExists(ComponentType index)
	{
		return _componentManager.HasComponent(index);
	}


	/*************************************************** SYSTEM FUNCTIONS **************************************************/
	public void UpdateSystems()
	{
		_system.Update();
	}

	template CreateSystem(T)
	{
		public void CreateSystem()
		{
			_system.CreateSystem!(T);
		}
	}
}


unittest
{
	Hub mHub = new Hub();

	mHub.CreateComponent!(PositionComponent)(Position);

	assert(is(typeof(mHub._componentManager.GetComponent!(PositionComponent)(Position)) == PositionComponent));
}