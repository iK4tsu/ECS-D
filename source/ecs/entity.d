module ecs.entity;

import ecs.icomponent;
import ecs.ientity;
import ecs.componentManager;


import std.typecons;

alias EntityId = uint;
static EntityId next_id = 1;

alias EntityType = string;

class Entity : IEntity
{
	public EntityId _id;
	private IComponent[ComponentTypeId] _components;
	private IComponent[ComponentTypeId] _disabledComponents;
	private const EntityType _type;
	private const string _name;
	private string _description;
	


	public this(const string name, const EntityType type) { this(0, name, type); }
	public this(EntityId id, const string name, const EntityType type)
	{
		if (!id)
			_id = next_id++;
		else
			_id = id;
		_type = type;
		_name = name;
	}


	/*
	 * Add a component to the refered index
	 * Each component has a an unique index based on it's type
	 * Use it's type instead of manual inserting an index
	 */
	public T addComponent(T)(ComponentTypeId id)
	{
		if (!hasComponent(id))
			_components[id] = new T;
		return getComponent!T;
	}


	/*
	 * Removes a component from the respective index
	 * Each component has an unique index based on it's type
	 * Use it's type instead of manual inserting an index 
	 */
	public bool removeComponent(ComponentTypeId id)
	{
		if (hasComponent(id))
		{
			destroy(_components[id]);
			_components.remove(id);
			return true;
		}
		return false;
	}


	/*
	 * Moves an existing component to the disbled component array
	 * Only use this function if the entity needs the component in the future
	 * If the entity doesn't need it anymore use the 'RemoveComponent' function
	 */
	public void disableComponent(ComponentTypeId id)
	{
		if (hasComponent(id))
		{
			_disabledComponents[id] = _components[id];
			_components.remove(id);
		}
	}


	/*
	 * Enables a component if this is disabled
	 */
	public void enableComponent(ComponentTypeId id)
	{
		if (isComponentDisabled(id))
		{
			_components[id] = _disabledComponents[id];
			_disabledComponents.remove(id);
		}
	}


	/*
	 * Get a component from the respective index
	 * Each component has an unique index based on it's type
	 * Use it's type instead of manual inserting an index 
	 */
	public T getComponent(T)()
	{
		const ComponentTypeId id = getComponentType!T;
		if (hasComponent(id))
			return cast(T)(_components[id]);
		return null;
	}


	/*
	 * Get all components
	 * If possible use the GetComponent template, as it returns the respective type
	 */
	public IComponent[] getComponents()
	{
		IComponent[] ret;
		foreach(component; _components)
			ret ~= component;
		return ret;
	}


	/*
	 * Get all component types
	 */
	public ComponentTypeId[] getComponentTypes()
	{
		ComponentTypeId[] ret;
		foreach(key, component; _components)
			ret ~= key;
		return ret;
	}


	/*
	 * Returns true if the component in the respective index exists
	 * Every component has an unique index based on it's type
	 * Use it's type instead of manual inserting an index
	 */
	public bool hasComponent(ComponentTypeId id)
	{
		return (id in _components) !is null;
	}


	/*
	 * Returns true if all of the components in the respective indices exist
	 * Every component has an unique index based on it's type
	 * Use it's type instead of manual inserting an index
	 */
	public bool hasComponents(ComponentTypeId[] ids)
	{
		foreach(id; ids)
		{
			if (!hasComponent(id))
				return false;
		}
		return true;
	}


	/*
	 * Returns true there's at least one of the component in the respective indices exist
	 * Every component has an unique index based on it's type
	 * Use it's type instead of manual inserting an index
	 */
	public bool hasAnyComponent(ComponentTypeId[] ids)
	{
		foreach(id; ids)
		{
			if (hasComponent(id))
				return true;
		}
		return false;
	}


	/*
	 * Returns if a component is disabled
	 * It doesn't return any info about the existance of the component
	 * If the entity doesn't contain the component neither in '_components' nor '_disabledComponents' it will just return false
	 * For that reason it is recomended not to use this function
	 */
	public bool isComponentDisabled(ComponentTypeId id)
	{
		return (id in _disabledComponents) !is null;
	}


	public ComponentTypeId getComponentType(T)()
	{
		foreach(key, component; _components)
		{
			if (cast(T)(component) !is null)
				return key;
		}
		return 0;
	}


	public string getName() { return _name; }
	public string getDescription() { return _description; }
	public EntityType getType() { return _type; }

	public void setDescription(const string description) { _description = description; }
}


@system unittest
{
	Entity e = new Entity("I'm alive", "Group");

	assert(e._id == 1);
	
	ComponentTypeId fooID = 1;
	ComponentTypeId gooID = 2;
	e.addComponent!Foo(fooID);

	assert(e.hasAnyComponent([fooID, gooID]));
	assert(e.hasComponent(fooID));

	assert(!e.hasComponent(gooID));

	assert(cast(Foo) e.getComponent!Foo !is null);
	assert(cast(Goo) e.getComponent!Goo is null);
}

@system unittest
{
	Entity e = new Entity("I'm also alive", "Alive");

	ComponentTypeId fooID = 1;
	ComponentTypeId gooID = 2;
	e.addComponent!Foo(fooID);

	assert(!e.isComponentDisabled(fooID));
	assert(!e.isComponentDisabled(gooID));

	e.disableComponent(fooID);

	assert(e.isComponentDisabled(fooID));
	assert(!e.hasComponent(fooID));

	e.enableComponent(fooID);
	e.removeComponent(fooID);

	assert(!e.hasComponent(fooID));
}

@system unittest
{
	Entity e = new Entity("Just e it", "e");

	assert(e.getName == "Just e it");
	assert(e.getType == "e");

	e.setDescription("Feel the e");

	assert(e.getDescription == "Feel the e");
}