module ecs.componentManager;

import ecs.icomponent;
import ecs.hub;

import ecs.exceptions.component;

alias ComponentName = string;
alias ComponentTypeId = uint;

static ComponentTypeId next_id = 1;

import std.traits;

class ComponentManager
{
	private IComponent[ComponentTypeId] _components;
	private ComponentName[ComponentTypeId] _componentNames;
	private Hub _hub;


	public this() { this(null); }
	public this(Hub hub)
	{
		_hub = hub;
	}


	public ComponentTypeId createComponent(T)()
	{
		if (!hasComponent!T)
		{
			ComponentTypeId id = next_id++;
			_components[id] = new T();
			_componentNames[id] = __traits(identifier, T);
		}
		return getType!T;
	}


	public bool hasComponent(T)()
	{
		return getType!T > 0;
	}


	public bool hasComponent(ComponentTypeId id)
	{
		return (id in _components) !is null;
	}


	public T getComponent(T)()
	{
		if (hasComponent!T)
			return cast(T)(_components[getType!T]);

		throw new ComponentDoesNotExistException(
			"Cannot get component!", "You should check if a component " ~
			"exists before getting it.");
	}


	public ComponentName getComponentName(ComponentTypeId id)
	{
		return (id in _componentNames) !is null ? _componentNames[id] : null;
	}


	public ComponentName getComponentName(T)()
	{
		foreach(key, component; _components)
			if (cast(T) component !is null)
				return _componentNames[key];

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


@system unittest
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

@system unittest
{
	ComponentManager manager = new ComponentManager();
	manager.createComponent!Foo;

	assert(manager.createComponent!Goo == 2);
	assert(manager.createComponent!Foo == 1);
}