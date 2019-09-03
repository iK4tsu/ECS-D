module ecs.entity;

import ecs.icomponent;
import ecs.ientity;
import ecs.componentManager;
import ecs.entityManager;

import ecs.exceptions.entity;

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
	private EntityManager manager;
	


	public this(const string name, const EntityType type) { this(null, 0, name, type); }
	public this(EntityId id, const string name, const EntityType type) {  this(null, id, name, type); }
	public this(EntityManager _manager, EntityId id, const string name, const EntityType type)
	{
		if (!id)
			_id = next_id++;
		else
			_id = id;

		_type = type;
		_name = name;
		manager = _manager;
	}


	/*
	 * Add a component with a respective key
	 * The key is the component's id
	 * Every time you inittialize a new component, an id is generated
	 * For this reason, you should always use this function through the Hub
	 * As it will get the id internaly
	 * If you decide otherwise, you'll also need to perform other functions manualy
	 */
	public T addComponent(T)(T t)
	{
		if (t is null)
			return t;
		
		ComponentTypeId id = manager.component.getComponentTypeId!T;

		if (!hasComponent(id))
		{
			_components[id] = t;
			return t;
		}

		throw new EntityAlreadyContainsComponentException(
			id, "Cannot add component '" ~
			manager.hub.componentGetName(id) ~
			"' to '" ~ _name ~ "'!", "You should check if an entity " ~
			"contains a component before adding it.");
	}


	public T addComponent(T)()
	{
		addComponent(new T());
	}


	/*
	 * Removes a component and the respective key from the AA _components
	 * The key is the component's id
	 * It's highly recomended you to always use the Hub when accessing this functions
	 * However, if you decide to get the component id first you can use it directly, but not recomended
	 */
	public void removeComponent(ComponentTypeId id)
	{
		if (hasComponent(id))
		{
			destroy(_components[id]);
			_components.remove(id);
			return;
		}

		throw new EntityDoesNotContainComponentException(
			id, "Cannot remove component '" ~
			manager.hub.componentGetName(id) ~ "' from '" ~
			_name ~ "'!", "You should check if an entity has a " ~
			"component before removing it.");
	}


	public void removeComponent(T)()
	{
		ComponentTypeId id = manager.component.getComponentTypeId!T;
		removeComponent(id);
	}


	/*
	 * Moves an existing component to the disabled component array
	 * Use this function if you're certaint you'll need the component again
	 * If you're unsure, or you have the knowledge that the component is not going to be used again
	 * Use the removeComponent function instead
	 * You disable a component by using the AA's keys
	 * The key is the component's id
	 * It's highly recomended you to always use the Hub when accessing this functions
	 * However, if you decide to get the component id first you can use it directly, but not recomended
	 */
	public void disableComponent(ComponentTypeId id)
	{
		if (hasComponent(id))
		{
			_disabledComponents[id] = _components[id];
			_components.remove(id);
			return;
		}

		throw new EntityDoesNotContainComponentException(
			id, "Cannot disable component '" ~
			manager.hub.componentGetName(id) ~
			"' in '" ~ _name ~ "'!", "You should check if " ~
			"an entity has a component before disabling it");
	}


	public void disableComponent(T)()
	{
		ComponentTypeId id = manager.component.getComponentTypeId!T;
		disableComponent(id);
	}


	/*
	 * Enables a component if this is disabled
	 * You enable it by using the AA's keys
	 * The key is the component's id
	 * It's highly recomended you to always use the Hub when accessing this functions
	 * However, if you decide to get the component id first you can use it directly, but not recomended
	 */
	public void enableComponent(ComponentTypeId id)
	{
		if (isComponentDisabled(id))
		{
			_components[id] = _disabledComponents[id];
			_disabledComponents.remove(id);
			return;
		}

		throw new EntityComponentIsNotDisabledException(
			id, "Cannot disable component '" ~
			manager.hub.componentGetName(id) ~
			"' from '" ~ _name ~ "'!", "You should check " ~
			"if a component is disabled beafore enabling it.");
	}


	public void enableComponent(T)()
	{
		ComponentTypeId id = manager.component.getComponentTypeId!T;
		enableComponent(id);
	}


	/*
	 * Get a specific component
	 * You pass a T type of component and you'll recive the same type if it exists
	 * If you do not, you it'll return null
	 * It's highly recomended you to always use the Hub when accessing this functions
	 * However, if you decide otherwise you can do it, but it is not recomended
	 */
	public T getComponent(T)()
	{
		foreach(component; _components)
			if (cast(T) component !is null)
				return cast(T) component;

		return null;
	}


	/*
	 * Get all components
	 * This will return an array of components which are contained in an entity
	 * However if you want to use any of this, it is not recomended calling this function
	 * Use the template 'getComponent' as it will return the type of that component
	 * Or use 'hasComponent', 'hasAnyComponent', 'hasComponents' if you want to know which components an entity is holding
	 * It's highly recomended you to always use the Hub when accessing this functions
	 * However, if you decide otherwise, you can use it directly, but it is not recomended
	 */
	public IComponent[] getComponents()
	{
		return _components.values;
	}


	/*
	 * Get all component types
	 * This will return an array of keys in the AA _components
	 * It's highly recomended you to always use the Hub when accessing this functions
	 * However, if you decide otherwise you can use it directly, but it is not recomended
	 */
	public ComponentTypeId[] getComponentTypes()
	{
		return _components.keys;
	}


	/*
	 * Returns true if the component exists
	 * You check by using the AA _components keys
	 * The key is a components id
	 * It's highly recomended to always use the Hub when accessing this functions
	 * However, if you decide to get the component id first, you can use it directly, but it is not recomended
	 */
	public bool hasComponent(ComponentTypeId id)
	{
		return (id in _components) !is null;
	}


	/*
	 * Returns true if all of the components exist
	 * You check by using an array of the AA _components keys
	 * The key is a components id
	 * It's highly recomended to always use the Hub when accessing this functions
	 * However, if you decide to get the component id first, you can use it directly, but it is not recomended
	 */
	public bool hasComponents(ComponentTypeId[] ids)
	{
		foreach(id; ids)
			if (!hasComponent(id))
				return false;

		return true;
	}


	/*
	 * Returns true if an entity contains at least one of the components
	 * You check by using an array of the AA _components keys
	 * The key is a components id
	 * It's highly recomended to always use the Hub when accessing this functions
	 * However, if you decide to get the component id first, you can use it directly, but it is not recomended
	 */
	public bool hasAnyComponent(ComponentTypeId[] ids)
	{
		foreach(id; ids)
			if (hasComponent(id))
				return true;

		return false;
	}


	/*
	 * Returns true if a component is disabled
	 * It doesn't return any info about the existance of the component
	 * If the entity doesn't contain the component neither in '_components' nor '_disabledComponents' it will just return false
	 * You check by using the AA _components keys
	 * The key is a components id
	 * It's highly recomended to always use the Hub when accessing this functions
	 * However, if you decide to get the component id first, you can use it directly, but it is not recomended
	 */
	public bool isComponentDisabled(ComponentTypeId id)
	{
		return (id in _disabledComponents) !is null;
	}


	public string getName() { return _name; }
	public string getDescription() { return _description; }
	public EntityType getType() { return _type; }

	public void setDescription(const string description) { _description = description; }
}

/*
@system unittest
{
	Entity e = new Entity("I'm alive", "Group");

	assert(e.getId == 1);
	
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
}*/