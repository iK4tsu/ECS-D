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
	public IComponent[ComponentType] _disabledComponents;


	public this()
	{
		_id = next_id++;
	}


	/*
	 * Add a component to the refered index
	 * Each component has a an unique index based on it's type
	 * Use it's type instead of manual inserting an index
	 */
	template AddComponent(T)
	{
		public void AddComponent(ComponentType index)
		{
			if (!HasComponent(index))
			{
				T t = new T();
				_components[index] = t;
			}
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
			destroy(_components[index]);
			_components.remove(index);
		}
	}


	/*
	 * Moves an existing component to the disbled component array
	 * Only use this function if the entity needs the component in the future
	 * If the entity doesn't need it anymore use the 'RemoveComponent' function
	 */
	public void DisableComponent(ComponentType index)
	{
		if (HasComponent(index))
		{
			_disabledComponents[index] = _components[index];
			_components.remove(index);
		}
	}


	/*
	 * Enables a component if this is disabled
	 */
	public void EnableComponent(ComponentType index)
	{
		if (IsComponentDisabled(index))
		{
			_components[index] = _disabledComponents[index];
			_disabledComponents.remove(index);
		}
	}


	/*
	 * Get a component from the respective index
	 * Each component has an unique index based on it's type
	 * Use it's type instead of manual inserting an index 
	 */
	template GetComponent(T)
	{
		public T GetComponent(ComponentType index)
		{
			if (HasComponent(index))
				return cast(T)(_components[index]);
			return null;
		}
	}


	/*
	 * Get all components
	 * If possible use the GetComponent template, as it returns the respective type
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


	/*
	 * Returns if a component is disabled
	 * It doesn't return any info about the existance of the component
	 * If the entity doesn't contain the component neither in '_components' nor '_disabledComponents' it will just return false
	 * For that reason it is recomended not to use this function
	 */
	public bool IsComponentDisabled(ComponentType index)
	{
		return (((index in _disabledComponents) !is null) ? true : false);
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
	Entity e = new Entity();

	e.AddComponent!(PositionComponent)(Position);

	assert(e.HasAnyComponent([Position, Health]));
	assert(e.HasComponent(Position));
	assert(is(typeof(e.GetComponent!(PositionComponent)(Position)) == PositionComponent));

	e.RemoveComponent(Position);

	assert(!e.HasAnyComponent([Position, Health]));
	assert(!e.HasComponent(Position));
	assert(e.GetComponent!(PositionComponent)(Position) is null);
}

unittest
{
	Entity e = new Entity();

	e.AddComponent!(PositionComponent)(Position);

	assert(!e.IsComponentDisabled(Position));

	e.DisableComponent(Position);

	assert(!e.HasComponent(Position));
	assert(e.IsComponentDisabled(Position));
}