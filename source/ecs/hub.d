module ecs.hub;

import ecs.entity;
import ecs.icomponent;
import ecs.entityManager;
import ecs.componentManager;
import ecs.system;
import ecs.isystem;

import ecs.exceptions.entity;


import std.traits;

alias EntityId = uint;
alias ComponentTypeId = uint;
alias EntityType = string;

class Hub
{
	public EntityManager _entityManager;
	public ComponentManager _componentManager;
	public System _system;

	public this()
	{
		_entityManager = new EntityManager(this);
		_componentManager = new ComponentManager(this);
		_system = new System(this);
	}


	/********************************************* ENTITY MANAGER FUNCTIONS *********************************************/
	public T entityAddComponent(T)(EntityId id)
	{
		return componentExists!T ? _entityManager.addComponent!(T)(id, componentGetType!T) : null;
	}

	public void entityRemoveComponent(EntityId eid, ComponentTypeId id)
	{
		_entityManager.removeComponent(eid, id);
	}

	public T entityGetComponent(T)(EntityId id)
	{
		return _entityManager.getComponent!(T)(id);
	}

	public EntityId entityCreate(const string name, const EntityType type)
	{
		EntityId id = _entityManager.createEntity(name, type);
		_system.addEid(id);
		return id;
	}

	public void entityKill(EntityId id)
	{
		_system.removeEid(id);
		_entityManager.killEntity(id);
	}

	public Entity entityGetEntity(EntityId id)
	{
		return _entityManager.getEntity(id);
	}

	public Entity entityGetEntity(EntityType type)
	{
		return _entityManager.getEntity(type);
	}

	public void entityEnableComponent(EntityId eid, ComponentTypeId id)
	{
		_entityManager.enableComponent(eid, id);
	}

	public void entityDisableComponent(EntityId eid, ComponentTypeId id)
	{
		_entityManager.disableComponent(eid, id);
	}

	public bool entityIsComponentDisabled(EntityId eid, ComponentTypeId id)
	{
		return _entityManager.isComponentDisabled(eid, id);
	}

	public bool entityHasComponents(EntityId eid, ComponentTypeId[] ids)
	{
		return _entityManager.hasComponents(eid, ids);
	}

	public bool entityHasAnyComponent(EntityId eid, ComponentTypeId[] ids)
	{
		return _entityManager.hasAnyComponent(eid, ids);
	}

	public bool entityHasComponent(EntityId eid, ComponentTypeId id)
	{
		return _entityManager.hasComponent(eid, id);
	}

	public string entityGetName(EntityId eid)
	{
		return _entityManager.getName(eid);
	}

	public string entityGetDescription(EntityId eid)
	{
		return _entityManager.getDescription(eid);
	}

	public EntityType entityGetType(EntityId eid)
	{
		return _entityManager.getType(eid);
	}

	public void entitySetDescription(EntityId eid, const string description)
	{
		_entityManager.setDescription(eid, description);
	}

	public EntityId[] entityGetDeleted()
	{
		return _entityManager.getDeletedEntities;
	}

	public EntityId entityGetId(Entity e)
	{
		return _entityManager.getEntityId(e);
	}

	public EntityId entityGetId(EntityType type)
	{
		return _entityManager.getEntityId(type);
	}


	/********************************************* COMPONENT MANAGER FUNCTIONS *********************************************/
	public ComponentTypeId componentCreate(T)()
	{
		return _componentManager.createComponent!T;
	}

	public bool componentExists(T)()
	{
		return _componentManager.hasComponent!T;
	}

	public T componentGet(T)()
	{
		return _componentManager.getComponent!T;
	}

	public ComponentName componentGetName(ComponentTypeId id)
	{
		return _componentManager.getComponentName(id);
	}

	public ComponentName componentGetName(T)()
	{
		return _componentManager.getComponentName!T;
	}

	public ComponentTypeId componentGetType(T)()
	{
		return _componentManager.getType!T;
	}


	/*************************************************** SYSTEM FUNCTIONS **************************************************/
	public void updateSystems()
	{
		_system.update;
	}

	public void systemCreate(T)()
	{
		_system.createSystem!T;
	}

	public T systemGet(T)()
	{
		return _system.getSystem!T;
	}

	public bool systemExists(T)()
	{
		return _system.existsSystem!T;
	}
}


@system unittest
{
	Hub _hub = new Hub();

	ComponentTypeId fooID = _hub.componentCreate!Foo;
	_hub.componentCreate!Goo;
	_hub.systemCreate!FooSys;
	EntityId eid = _hub.entityCreate("Nobody", "Alone");

	_hub.entityAddComponent!Foo(eid);
	
	assert(_hub.entityGetComponent!Foo(eid).someData == int.init);
	assert(_hub.systemExists!FooSys);

	_hub.updateSystems;

	assert(_hub.entityGetComponent!Foo(eid).someData == 1);

	_hub.entityDisableComponent(eid, fooID);
	_hub.updateSystems;
	_hub.entityEnableComponent(eid, fooID);

	assert(_hub.entityGetComponent!Foo(eid).someData == 1);
}