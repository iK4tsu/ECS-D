module ecs.entityManager;

import ecs.entity;
import ecs.icomponent;
import ecs.componentManager;
import ecs.hub;


import ecs.exceptions.entity;


class EntityManager
{
	private Entity[EntityId] _mEntities;
	private EntityType[EntityId] _mTypes;
	private EntityId[] _deletedEntities;
	public Hub _hub;


	public this() { this(null); }
	public this(Hub hub)
	{
		_hub = hub;
	}


	public EntityId createEntity(const string name, const EntityType type)
	{
		Entity e = _deletedEntities.length > 0 ?
			new Entity(this, pullDeletedId, name, type) :
			new Entity(this, 0, name, type);
		_mEntities[e._id] = e;
		_mTypes[e._id] = type;
		return e._id;
	}


	public EntityId pullDeletedId()
	{
		EntityId eid = _deletedEntities[0];
		_deletedEntities = _deletedEntities.length > 1 ? _deletedEntities[1 .. $] : null;
		return eid;
	}


	public void killEntity(EntityId eid)
	{
		if (hasEntity(eid))
		{
			destroy(_mEntities[eid]);
			_mEntities.remove(eid);
			_deletedEntities ~= eid;
			return;
		}

		throw new EntityDoesNotExistException(eid, 
			"Cannot destroy entity!", "You should check " ~
			"if an entity exists before killing it.");
	}


	public T addComponent(T)(EntityId eid, ComponentTypeId id)
	{
		if (hasEntity(eid))
			return _mEntities[eid].addComponent!(T)(id);
		
		throw new EntityDoesNotExistException(
			eid, "Cannot add the component '" ~ _hub.componentGetName(id) ~
			"' to the entity!", "You should verify if an entity exists " ~
			"before adding a component to it.");
	}


	public void removeComponent(EntityId eid, ComponentTypeId id)
	{
		if (hasEntity(eid))
		{
			_mEntities[eid].removeComponent(id);
			return;
		}

		throw new EntityDoesNotExistException(
			eid, "Cannot remove the component '" ~ _hub.componentGetName(id) ~
			"' to the entity!", "You should verify if an entity exists " ~
			"before remoing a component from it.");
	}


	public T getComponent(T)(EntityId eid)
	{
		if (hasEntity(eid))
			return _mEntities[eid].getComponent!T;
		
		throw new EntityDoesNotExistException(
			eid, "Cannot get the component '" ~ _hub.componentGetName!T ~
			"' to the entity!", "You should verify if an entity exists " ~
			"before getting a component from it.");
	}


	public void enableComponent(EntityId eid, ComponentTypeId id)
	{
		if (hasEntity(eid))
		{
			_mEntities[eid].enableComponent(id);
			return;
		}

		throw new EntityDoesNotExistException(
			eid, "Cannot enable the component '" ~ _hub.componentGetName(id) ~
			"' in the entity!", "You should verify if an entity exists " ~
			"before enabling a component in it.");
	}

	public void disableComponent(EntityId eid, ComponentTypeId id)
	{
		if (hasEntity(eid))
		{
			_mEntities[eid].disableComponent(id);
			return;
		}

		throw new EntityDoesNotExistException(
			eid, "Cannot disable the component '" ~ _hub.componentGetName(id) ~
			"' in the entity!", "You should verify if an entity exists " ~
			"before disabling a component in it.");
	}

	public bool isComponentDisabled(EntityId eid, ComponentTypeId id)
	{
		if (hasEntity(eid))
			return _mEntities[eid].isComponentDisabled(id);

		throw new EntityDoesNotExistException(
			eid, "Cannot check if the component '" ~ _hub.componentGetName(id) ~
			"' is disabled in the entity!", "You should verify if an entity exists " ~
			"before checking a component's status.");
	}

	public IComponent[] getComponents(EntityId eid)
	{
		if (hasEntity(eid))
			return _mEntities[eid].getComponents;
		
		throw new EntityDoesNotExistException(
			eid, "Cannot get the components from the entity!",
			"You should verify if an entity exists " ~ "before getting components from it.");
	}

	public ComponentTypeId[] getComponentTypes(EntityId eid)
	{
		if (hasEntity(eid))
			return _mEntities[eid].getComponentTypes;

		throw new EntityDoesNotExistException(
			eid, "Cannot get the components ids from the entity",
			"You should verify if an entity exists before getting components ids.");
	}

	public bool hasComponent(EntityId eid, ComponentTypeId id)
	{
		if (hasEntity(eid))
			return _mEntities[eid].hasComponent(id);

		throw new EntityDoesNotExistException(
			eid, "Cannot check if the entity contains the component '" ~ _hub.componentGetName(id) ~
			"'!", "You should verify if an entity exists before checking it's existance.");
	}

	public bool hasComponents(EntityId eid, ComponentTypeId[] indices)
	{
		if (hasEntity(eid))
			return _mEntities[eid].hasComponents(indices);

		throw new EntityDoesNotExistException(
			eid, "Cannot check if the entity has the components!",
			"You should verify if an entity exists before checking the existance of a set of components.");
	}

	public bool hasAnyComponent(EntityId eid, ComponentTypeId[] indices)
	{
		if (hasEntity(eid))
			return _mEntities[eid].hasAnyComponent(indices);

		throw new EntityDoesNotExistException(
			eid, "Cannot check if the entity has any of the components!",
			"You should verify if an entity exists before checking the existance of any component.");
	}

	public bool hasEntity(EntityId eid)
	{
		return (eid in _mEntities) !is null;
	}

	public Entity getEntity(EntityId eid)
	{
		if (hasEntity(eid))
			return _mEntities[eid];

		throw new EntityDoesNotExistException(
			eid, "Cannot get entity!", "You should verify if an entity exists " ~
			"before getting it.");
	}

	public string getName(EntityId eid)
	{
		if (hasEntity(eid))
			return _mEntities[eid].getName;

		throw new EntityDoesNotExistException(
			eid, "Cannot get the entity's name!", "You should verify if an " ~
			"entity exists before getting it's name.");
	}

	public string getDescription(EntityId eid)
	{
		if (hasEntity(eid))
			return _mEntities[eid].getDescription;

		throw new EntityDoesNotExistException(
			eid, "Cannot get the entity's description!", "You should verify if " ~
			"an entity exists before getting it's description.");
	}

	public EntityType getType(EntityId eid)
	{
		if (hasEntity(eid))
			return _mEntities[eid].getType;

		throw new EntityDoesNotExistException(
			eid, "Cannot get entity's type!", "You should verify if an " ~
			"entity exists before getting it's type.");
	}

	public void setDescription(EntityId eid, const string description)
	{
		if (hasEntity(eid))
		{
			_mEntities[eid].setDescription(description);
			return;
		}

		throw new EntityDoesNotExistException(
			eid, "Cannot set entity's description!", "You should verify if an " ~
			"entity exists before setting it's description.");
	}

	public Entity getEntity(EntityType type)
	{
		foreach(id, _type; _mTypes)
			if (_type == type)
				return getEntity(id);

		throw new EntityDoesNotExistException(
			-1, "Cannot get entity!", "You should verify if an entity exists " ~
			"before getting it.");
	}

	public EntityId[] getDeletedEntities()
	{
		return _deletedEntities;
	}

	public EntityId getEntityId(Entity e)
	{
		import std.algorithm : canFind;
		if (canFind(_mEntities.values, e))
			return e._id;

		throw new EntityDoesNotExistException(
			-1, "Cannot get entity id!", "You should verify if an entity exists " ~
			"before getting it's id.");
	}

	public EntityId getEntityId(EntityType type)
	{
		if (typeExists(type))
			return getId(getEntity(type));

		throw new EntityDoesNotExistException(
			-1, "Cannot get entity's type!", "You should verify if an entity " ~
			"exists before getting it's type.");
	}

	public bool typeExists(EntityType type)
	{
		import std.algorithm : canFind;
		return canFind(_mTypes.values, type);
	}
}


@system unittest
{
	EntityManager manager = new EntityManager();
	EntityId eid = manager.createEntity("Am I just a number?", "Math");

	assert(manager.hasEntity(eid));
	assert(!manager.hasEntity(++eid));
}

@system unittest
{
	EntityManager manager = new EntityManager();
	EntityId eid = manager.createEntity("Should I worry", "Sad");

	assert(manager.getEntity(eid) == manager.getEntity("Sad"));
	assert(manager.getDeletedEntities.length == 0);
	
	manager.killEntity(eid);

	assert(manager.getDeletedEntities.length == 1);
	assert(manager.getDeletedEntities[0] == eid);
	assert(!manager.hasEntity(eid));
}

@system unittest
{
	EntityManager manager = new EntityManager();
	EntityId eid1 = manager.createEntity("I'm gonna die", "Dead");
	EntityId eid2 = manager.createEntity("I'm subject number 2!", "Guinea Pig");

	assert(eid1 == 1);
	assert(eid2 == 2);

	manager.killEntity(eid1);
	eid1 = manager.createEntity("Wait I revived?", "Blessing");

	assert(manager.getDeletedEntities.length == 0);
	assert(eid1 == 1);

	EntityId eid3 = manager.createEntity("I'm subject number 3!", "Guinea Pig");
	
	assert(eid3 == 3);
}