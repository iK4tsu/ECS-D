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


	template AddComponent(T)
	{
		public void AddComponent(EntityId id, ComponentType index)
		{
			if (_componentManager.HasComponent(index))
			{
				_entityManager.AddComponent(id, index, new T());
			}
		}
	}


	template CreateComponent(T)
	{
		public void CreateComponent(ComponentType index)
		{
			_componentManager.CreateComponent!(T)(index);
		}
	}

	template GetComponent(T)
	{
		public T GetComponent(ComponentType index)
		{
			return _componentManager.GetComponent!(T)(index);
		}
	}

	public bool ComponentExists(ComponentType index)
	{
		return _componentManager.HasComponent(index);
	}

	public void UpdateSystems()
	{
		_system.Update();
	}
}


unittest
{
	Hub _hub = new Hub();

	_hub.CreateComponent!(PositionComponent)(Position);

	assert(is(typeof(_hub.GetComponent!(PositionComponent)(Position)) == PositionComponent));
}