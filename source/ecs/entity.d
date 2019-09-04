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
	public EntityType type;
	public string name;
	public string description;
	private IComponent[ComponentTypeId] _components;
	private IComponent[ComponentTypeId] _disabledComponents;
	private EntityManager manager;
	


	@safe public this(EntityId id) {  this(null, id); }
	@safe public this(EntityManager _manager, EntityId id)
	{
		if (!id)
			_id = next_id++;
		else
			_id = id;

		manager = _manager;
	}


	/*
	 * Add a component
	 * Every time you inittialize a new component, an unique id is generated
	 * Use this function only if you want to generate the component with values
	 ***
	 * Example: e.AddComponent(new Foo(value1, value2, ...));
	 */
	public T addComponent(T)(T t)
	{
		if (t is null)
			return t;
		
		ComponentTypeId id = manager.component.idOf!T;

		if (!hasComponent(id))
		{
			_components[id] = t;
			return t;
		}

		throw new EntityAlreadyContainsComponentException(
			id, "Cannot add component '" ~ manager.component.name(id) ~
			"' to '" ~ name ~ "'!", "You should check if an entity " ~
			"contains a component before adding it.");
	}


	/*
	 * Add a component
	 * Use this function only if you want to generate the component with init values
	 ***
	 * Example: e.AddComponent!Foo;
	 */
	public T addComponent(T)()
	{
		return addComponent(new T());
	}


	/*
	 * Removes a component and the respective id from the AA _components
	 * It's called by passing the component's id
	 * Every time you inittialize a new component, an unique id is generated
	 * If you don't know which id you should pass, use the other variant of this function,
	 *     which is the recomended one, as it will get the correct id for you
	 ****
	 * Example: ComponentTypeId fooID = hub.component.idOf!Foo;
	 *          e.removeComponent(fooID);
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
			id, "Cannot remove component '" ~ manager.component.name(id) ~
			"' from '" ~ name ~ "'!", "You should check if an entity has a " ~
			"component before removing it.");
	}


	/*
	 * Removes a component and the respective id from the AA _components
	 * It's recomended to always use this function, as it will do the 'hard work' for you
	 ****
	 * Example: e.removeComponent!Foo;
	 */
	public void removeComponent(T)()
	{
		ComponentTypeId id = manager.component.idOf!T;
		removeComponent(id);
	}


	/*
	 * Moves an existing component to the disabled components array
	 * It is called by passing the component's id
	 * Every time you inittialize a new component, an unique id is generated
	 * Use this function if you're certaint you'll need the component again
	 * If you're unsure, or you do know, the component is not going to be used again,
	 *     use the removeComponent function instead
	 * If you don't know which id you should pass, use the other variant of this function,
	 *     which is the recomended one, as it will get the correct id for you
	 ****
	 * Example: ComponentTypeId fooID = hub.component.idOf!Foo;
	 *          e.disableComponent(fooID);
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
			id, "Cannot disable component '" ~manager.component.name(id) ~
			"' in '" ~ name ~ "'!", "You should check if " ~
			"an entity has a component before disabling it");
	}


	/*
	 * Moves an existing component to the disabled components array
	 * Use this function if you're certaint you'll need the component again
	 * If you're unsure, or you do know, the component is not going to be used again,
	 *     use the removeComponent function instead
	 * It's recomended to always use this function, as it will do the 'hard work' for you
	 ****
	 * Example: e.disableComponent!Foo;
	 */
	public void disableComponent(T)()
	{
		ComponentTypeId id = manager.component.idOf!T;
		disableComponent(id);
	}


	/*
	 * Enables a component if this is disabled
	 * You enable it by using the component's id
	 * Every time you inittialize a new component, an unique id is generated
	 * If you don't know which id you should pass, use the other variant of this function,
	 *     which is the recomended one, as it will get the correct id for you
	 ****
	 * Example: ComponentTypeId fooID = hub.component.idOf!Foo;
	 *          e.enableComponent(fooId);
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
			id, "Cannot disable component '" ~ manager.component.name(id) ~
			"' from '" ~ name ~ "'!", "You should check " ~
			"if a component is disabled beafore enabling it.");
	}


	/*
	 * Enables a component if this is disabled
	 * It's recomended to always use this function, as it will do the 'hard work' for you
	 ****
	 * Example: e.enableComponent(fooId);
	 */
	public void enableComponent(T)()
	{
		ComponentTypeId id = manager.component.idOf!T;
		enableComponent(id);
	}


	/*
	 * Get a specific component of a specific type
	 * You pass a T typeof component and you'll recive the same type if it exists
	 * If it doesn't, it'll return null
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
	 * However if you want to actualy access any of this, this method isn't recomended
	 * Use the template 'getComponent' as it will return the type of that component
	 * Or use 'hasComponent', 'hasAnyComponent', 'hasComponents' if you want to know which components an entity is holding
	 */
	@system pure
	public IComponent[] getComponents()
	{
		return _components.values;
	}


	/*
	 * Get all component types an entity has
	 * This will return an array of component ids
	 */
	@system pure
	public ComponentTypeId[] getComponentTypes()
	{
		return _components.keys;
	}


	/*
	 * Returns true if the component exists
	 * You call this function by passing the component's id
	 * Every time you create a component, it'll generate an unique id
	 * If you don't know which id you should pass, use the other variant of this function,
	 *     which is the recomended one, as it will get the correct id for you
	 ****
	 * Example: ComponentTypeId fooID = hub.component.idOf!Foo;
	 *          e.hasComponent(fooID);
	 */
	@safe pure
	public bool hasComponent(ComponentTypeId id)
	{
		return (id in _components) !is null;
	}


	/*
	 * Returns true if the component exists
	 * It's recomended to always use this function, as it will do the 'hard work' for you
	 ****
	 * Example: e.hasComponent!Foo;
	 */
	public bool hasComponent(T)()
	{
		ComponentTypeId id = manager.component.idOf!T;
		return hasComponent(id);
	}


	/*
	 * Returns true if all the components exist
	 * You call this function by passing an array of the component ids
	 * Every time you create a component, it'll generate an unique id
	 * If you don't know which ids you should pass, use the other variant of this function,
	 *     which is the recomended one, as it will get the correct id for you
	 ****
	 * Example: ComponentTypeId fooID = hub.component.idOf!Foo;
	 *          ComponentTypeId gooID = hub.component.idOf!Goo;
	 *          e.hasComponents([fooID,gooID]);
	 */
	public bool hasComponents(ComponentTypeId[] ids)
	{
		foreach(_id; ids)
			if (!hasComponent(_id))
				return false;

		return true;
	}


	/*
	 * Returns true if all the components exist
	 * It's recomended to always use this function, as it will do the 'hard work' for you
	 ****
	 * Example: e.hasComponents!(Foo, Goo);
	 */
	public bool hasComponents(T...)()
	{
		return hasComponents(manager.component.idsOf!T);
	}


	/*
	 * Returns true if at least one of the components exist
	 * You call this function by passing an array of the component ids
	 * Every time you create a component, it'll generate an unique id
	 * If you don't know which ids you should pass, use the other variant of this function,
	 *     which is the recomended one, as it will get the correct id for you
	 ****
	 * Example: ComponentTypeId fooID = hub.component.idOf!Foo;
	 *          ComponentTypeId gooID = hub.component.idOf!Goo;
	 *          e.hasAnyComponent([fooID,gooID]);
	 */
	public bool hasAnyComponent(ComponentTypeId[] ids)
	{
		foreach(id; ids)
			if (hasComponent(id))
				return true;

		return false;
	}


	/*
	 * Returns true if at least one of the components exist
	 * It's recomended to always use this function, as it will do the 'hard work' for you
	 ****
	 * Example: e.hasAnyComponents!(Foo, Goo);
	 */
	public bool hasAnyComponent(T...)()
	{
		return hasAnyComponent(manager.component.idsOf!T);
	}


	/*
	 * Returns true if a component is disabled
	 * It doesn't return any info about the existance of the component
	 * If the entity doesn't contain the component neither in '_components' nor '_disabledComponents' it will just return false
	 * You call this function by passing the component's id
	 * Every time you create a component, it'll generate an unique id
	 * If you don't know which id you should pass, use the other variant of this function,
	 *     which is the recomended one, as it will get the correct id for you
	 ****
	 * Example: ComponentTypeId fooID = hub.component.idOf!Foo;
	 *          e.isComponentDisabled(fooID);
	 */
	@safe pure
	public bool isComponentDisabled(ComponentTypeId id)
	{
		return (id in _disabledComponents) !is null;
	}


	/*
	 * Returns true if a component is disabled
	 * It doesn't return any info about the existance of the component
	 * If the entity doesn't contain the component neither in '_components' nor '_disabledComponents' it will just return false
	 * It's recomended to always use this function, as it will do the 'hard work' for you
	 ****
	 * Example: e.isComponentDisabled!Foo;
	 */
	public bool isComponentDisabled(T)()
	{
		ComponentTypeId id = manager.component.idOf!T;
		return isComponentDisabled(id);
	}


	/*
	 * Destroys an entity
	 */
	public void kill()
	{
		manager.kill(_id);
	}
}


@safe unittest
{
	Entity e = new Entity(1);

	assert(e._id == 1);
}

@safe unittest
{
	Entity e = new Entity(2);

	e.name = "Just e it";
	e.type = "e";
	e.description = "Feel the e";

	assert("Just e it" == e.name);
	assert("e" == e.type);
	assert("Feel the e" == e.description);
}