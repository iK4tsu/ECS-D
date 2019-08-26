module ecs.componentManager;

import ecs.componentType;
import ecs.icomponent;


class ComponentManager
{
	private IComponent[ComponentType] _components;


	public this() {}


	template CreateComponent(T)
	{
		public void CreateComponent(ComponentType index)
		{
			T t = new T();
			if (!HasComponent(index))
				_components[index] = t;
		}
	}

	public bool HasComponent(ComponentType index)
	{
		return (((index in _components) != null) ? true : false);
	}


	template GetComponent(T)
	{
		public T GetComponent(ComponentType index)
		{
			if (HasComponent(index))
				return cast(T)(_components[index]);
			return null;
		}
	}
}


unittest
{
	ComponentManager manager = new ComponentManager;
	manager.CreateComponent!(PositionComponent)(Position);

	assert(manager.HasComponent(Position));

	PositionComponent position = manager.GetComponent!(PositionComponent)(Position);

	assert(manager.GetComponent!(PositionComponent)(Position) == position);
}