module ecs.componentManager;


import ecs.icomponent;
import ecs.hub;
import ecs.exceptions.component;


import std.traits;


alias ComponentName = string;
alias ComponentTypeId = uint;
static ComponentTypeId next_id = 1;


final class ComponentManager
{
	private IComponent[ComponentTypeId] components;
	private ComponentName[ComponentTypeId] componentNames;


	public T create(T)()
	{
		if (!exists!T)
		{
			T t = new T();
			ComponentTypeId id = next_id++;
			components[id] = t;
			componentNames[id] = __traits(identifier, T);
			return t;
		}

		throw new ComponentAlreadyExistsException(
			"Cannot create the component!", "You should check if a component " ~
			"exists before creating it.");
	}


	@safe pure
	public bool exists(T)()
	{
		foreach(component; components)
			if (cast(T) component !is null)
				return true;

		return false;
	}


	@safe pure
	public bool exists(ComponentTypeId id)
	{
		return (id in components) !is null;
	}


	public T get(T)()
	{
		if (exists!T)
			return cast(T)(components[idOf!T]);
		else
			return create!T;
	}


	public ComponentName name(ComponentTypeId id)
	{
		if (exists(id))
			return componentNames[id];

		throw new ComponentDoesNotExistException(
			"Cannot get the component's name!", "You should check if a component " ~
			"exists before getting it's name.");
	}


	public ComponentName name(T)()
	{
		if (exists!T)
			return componentNames[getComponentTypeId!T];

		throw new ComponentDoesNotExistException(
			"Cannot get the component's name!", "You should check if a component " ~
			"exists before getting it's name.");
	}


	public ComponentTypeId idOf(T)()
	{
		if (exists!T)
			foreach(key, component; components)
				if (cast(T)(component) !is null)
					return key;

		throw new ComponentDoesNotExistException(
			"Cannot get the component's id!", "You should check if a component " ~
			"exists before getting it's id.");
	}


	public ComponentTypeId[] idsOf(T...)()
	{
		import std.algorithm : canFind;
		ComponentTypeId[] ids;

		foreach(t; T)
		{
			ComponentTypeId id = idOf!t;
			if (!canFind(ids, id))
				ids ~= id;
		}

		return ids;
	}
}



@system unittest
{
	ComponentManager manager = new ComponentManager();
	manager.create!Foo;

	assert(manager.exists!Foo);
	assert(!manager.exists!Goo);

	assert(cast(Foo) manager.get!Foo !is null);

	assert(manager.idOf!Foo == 1);
}

@system unittest
{
	ComponentManager manager = new ComponentManager();
	manager.create!Foo;
	manager.create!Goo;

	assert(manager.idOf!Foo == 1);
	assert(manager.idOf!Goo == 2);
}