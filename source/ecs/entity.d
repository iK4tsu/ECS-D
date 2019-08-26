module ecs.entity;

import ecs.icomponent;
import ecs.ientity;
import ecs.componentType;


alias EntityId = uint;
static EntityId next_id = 0;

class Entity : IEntity
{
	public EntityId _id;
	public IComponent[ComponentType] _components;


	public this()
	{
		_id = next_id++;
	}


	/*
	 * Add a component to the refered index
	 * Each component has a an unique index based on it's type
	 * Use it's type instead of manual inserting an index
	 */
	public void AddComponent(ComponentType index, IComponent component)
	{
		if (!HasComponent(index))
		{
			_components[index] = component;
		}
	}


	/*
	 * Removes a component from the respective index
	 * Each component has an unique index based on it's type
	 * Use it's type instead of manual inserting an index 
	 */
	public void RemoveComponent(ComponentType index)
	{
		if (HasComponent(index))
		{
			_components.remove(index);
		}
	}


	/*
	 * Get a component from the respective index
	 * Each component has an unique index based on it's type
	 * Use it's type instead of manual inserting an index 
	 */
	public IComponent GetComponent(ComponentType index)
	{
		if (HasComponent(index))
			return _components[index];
		return null;
	}


	/*
	 * Get all components
	 */
	public IComponent[] GetComponents()
	{
		IComponent[] ret;
		foreach(component; _components)
		{
			if (component !is null)
				ret ~= component;
		}
		return ret;
	}


	/*
	 * Get all component types
	 */
	public ComponentType[] GetComponentTypes()
	{
		ComponentType[] ret;
		foreach(key, component; _components)
		{
			if (component !is null)
				ret ~= key;
		}
		return ret;
	}


	/*
	 * Returns true if the component in the respective index exists
	 * Every component has an unique index based on it's type
	 * Use it's type instead of manual inserting an index
	 */
	public bool HasComponent(ComponentType index)
	{
		return (((index in _components) !is null) ? true : false);
	}


	/*
	 * Returns true if all of the components in the respective indices exist
	 * Every component has an unique index based on it's type
	 * Use it's type instead of manual inserting an index
	 */
	public bool HasComponents(ComponentType[] indices)
	{
		foreach(index; indices)
		{
			if (!HasComponent(index))
				return false;
		}
		return true;
	}


	/*
	 * Returns true there's at least one of the component in the respective indices exist
	 * Every component has an unique index based on it's type
	 * Use it's type instead of manual inserting an index
	 */
	public bool HasAnyComponent(ComponentType[] indices)
	{
		foreach(index; indices)
		{
			if (HasComponent(index))
				return true;
		}
		return false;
	}
}


unittest
{
	Entity e = new Entity();

	assert(e._id == 0);
	assert(next_id == 1);
}


unittest
{
	class _PositionComponent : IComponent
	{
		int data = 0;
	}

	Entity e = new Entity();

	_PositionComponent position = new _PositionComponent();
	e.AddComponent(Position, position);

	assert(e.HasAnyComponent([Position, Health]));
	assert(e.HasComponent(Position));
	assert(e.GetComponent(Position) == position);

	e.RemoveComponent(Position);

	assert(!e.HasAnyComponent([Position, Health]));
	assert(!e.HasComponent(Position));
	assert(e.GetComponent(Position) is null);
}