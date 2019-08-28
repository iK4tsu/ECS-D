module ecs.componentManager;

import ecs.componentType;
import ecs.icomponent;

alias ComponentName = string;
alias ComponentTypeId = uint;

static uint next_id = 1;

class ComponentManager
{
	private IComponent[ComponentTypeId] _components;


	public this() {}


	public ComponentTypeId createComponent(T)()
	{
		if (!hasComponent!T)
			_components[next_id++] = new T;
		return getType!T;
	}


	public bool hasComponent(T)()
	{
		return getType!T > 0;
	}


	public T getComponent(T)()
	{
		if (hasComponent!T)
			return cast(T)(_components[getType!T]);
		return null;
	}

	public ComponentTypeId getType(T)()
	{
		foreach(key, component; _components)
		{
			if (cast(T)(component) !is null)
				return key;
		}
		return 0;
	}
}


unittest
{
	ComponentManager manager = new ComponentManager();
	manager.createComponent!(PositionComponent);

	assert(manager.hasComponent!PositionComponent);

	PositionComponent position = manager.getComponent!PositionComponent;

	assert(manager.getComponent!PositionComponent == position);

	assert((manager.getType!PositionComponent) == 1);

	assert(cast(PositionComponent)(manager.getComponent!PositionComponent) !is null);
}