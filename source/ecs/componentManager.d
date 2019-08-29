module ecs.componentManager;

import ecs.icomponent;

alias ComponentName = string;
alias ComponentTypeId = uint;

static ComponentTypeId next_id = 1;


class ComponentManager
{
	private IComponent[ComponentTypeId] _components;


	public ComponentTypeId createComponent(T)()
	{
		if (!hasComponent!T)
			_components[next_id++] = new T();
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


@safe unittest
{
	ComponentManager manager = new ComponentManager();
	manager.createComponent!Foo;

	assert(manager.hasComponent!Foo);
	assert(!manager.hasComponent!Goo);

	assert(cast(Foo) manager.getComponent!Foo !is null);
	assert(cast(Goo) manager.getComponent!Goo is null);

	assert(manager.getType!Foo == 1);
	assert(manager.getType!Goo == 0);
}

@safe unittest
{
	ComponentManager manager = new ComponentManager();

	assert(manager.createComponent!Foo == 1);
	assert(manager.createComponent!Goo == 2);

	assert(manager.createComponent!Foo == 1);
}