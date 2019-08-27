module ecs.componentManager;

import ecs.componentType;
import ecs.icomponent;

alias ComponentName = string;

class ComponentManager
{
	private IComponent[ComponentName] _components;
	private ComponentType[ComponentName] _types;


	public this() {}


	template CreateComponent(T)
	{
		public void CreateComponent(ComponentType index)
		{
			if (!(HasComponent!T))
			{
				_components[T.stringof] = new T();
				_types[T.stringof] = index;
			}
		}
	}

	template HasComponent(T)
	{
		public bool HasComponent()
		{
			return (((T.stringof in _components) !is null) ? true : false);
		}
	}

	template GetComponent(T)
	{
		public T GetComponent()
		{
			if (HasComponent!T)
				return cast(T)(_components[T.stringof]);
			return null;
		}
	}

	template GetType(T)
	{
		public ComponentType GetType()
		{
			return _types[T.stringof];
		}
	}
}


unittest
{
	ComponentManager manager = new ComponentManager();
	manager.CreateComponent!(PositionComponent)(Position);

	assert(manager.HasComponent!PositionComponent);

	PositionComponent position = manager.GetComponent!PositionComponent;

	assert(manager.GetComponent!PositionComponent == position);

	assert((manager.GetType!PositionComponent) == Position);

	//assert(is(typeof(manager.GetComponent!PositionComponent) == PositionComponent));
}