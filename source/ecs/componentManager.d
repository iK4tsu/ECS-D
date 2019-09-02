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
		return getComponentTypeId!T;
	}


	public bool hasComponent(T)()
	{
		foreach(component; _components)
			if (cast(T) component !is null)
				return true;

		return false;
	}


	public bool hasComponent(ComponentTypeId id)
	{
		return (id in _components) !is null;
	}


	public T getComponent(T)()
	{
		if (hasComponent!T)
			return cast(T)(_components[getComponentTypeId!T]);

		throw new ComponentDoesNotExistException(
			"Cannot get the component!", "You should check if a component " ~
			"exists before getting it.");
	}


	public ComponentName getComponentName(ComponentTypeId id)
	{
		if (hasComponent(id))
			return _componentNames[id];

		throw new ComponentDoesNotExistException(
			"Cannot get the component's name!", "You should check if a component " ~
			"exists before getting it's name.");
	}


	public ComponentName getComponentName(T)()
	{
		if (hasComponent!T)
			return _componentNames[getComponentTypeId!T];

		throw new ComponentDoesNotExistException(
			"Cannot get the component's name!", "You should check if a component " ~
			"exists before getting it's name.");
	}


	public ComponentTypeId getComponentTypeId(T)()
	{
		if (hasComponent!T)
			foreach(key, component; _components)
				if (cast(T)(component) !is null)
					return key;

		throw new ComponentDoesNotExistException(
			"Cannot get the component's id!", "You should check if a component " ~
			"exists before getting it's id.");
	}
}


@system unittest
{
	ComponentManager manager = new ComponentManager();
	manager.createComponent!Foo;

	assert(manager.hasComponent!Foo);
	assert(!manager.hasComponent!Goo);

	assert(cast(Foo) manager.getComponent!Foo !is null);

	assert(manager.getComponentTypeId!Foo == 1);
}

@system unittest
{
	ComponentManager manager = new ComponentManager();
	manager.createComponent!Foo;

	assert(manager.createComponent!Goo == 2);
	assert(manager.createComponent!Foo == 1);
}