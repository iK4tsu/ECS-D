module ecs.hub;

import ecs.entity;
import ecs.icomponent;
import ecs.componentType;
import ecs.entityManager;
import ecs.componentManager;


class Hub
{
	public EntityManager _entityManager;
	public ComponentManager _componentManager;

	public this()
	{
		_entityManager = new EntityManager();
		_componentManager = new ComponentManager();
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
}


unittest
{
	Hub _hub = new Hub();

	_hub.CreateComponent!(PositionComponent)(Position);

	assert(is(typeof(_hub._componentManager.GetComponent!(PositionComponent)(Position)) == PositionComponent));
}