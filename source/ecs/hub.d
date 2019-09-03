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


final class Hub
{
	public EntityManager entity;
	public ComponentManager component;
	public System system;

	public this()
	{
		component = new ComponentManager(this);
		system = new System(this);
		entity = new EntityManager(this, component);
	}


	/********************************************* ENTITY MANAGER FUNCTIONS *********************************************/
	public T entityAddComponent(T)(EntityId eid)
	{
		return componentExists!T ? entity.addComponent!(T)(eid, componentGetTypeId!T) : null;
	}

	public T entityAddComponent(T)(T t, EntityId eid)
	{
		return componentExists!T ? entity.addComponent!(T)(eid, t, componentGetTypeId!T) : null;
	}

	public void entityRemoveComponent(EntityId eid, ComponentTypeId id)
	{
		entity.removeComponent(eid, id);
	}

	public T entityGetComponent(T)(EntityId id)
	{
		return entity.getComponent!T(id);
	}

	//public Entity entityCreate(const string name, const EntityType type)
	//{
	//	EntityId id = entity.createEntity(name, type);
	//	system.addEid(id);
	//	return id;
	//}

	public void entityKill(EntityId id)
	{
		//system.removeEid(id);
		entity.killEntity(id);
	}

	public Entity entityGetEntity(EntityId id)
	{
		return entity.getEntity(id);
	}

	public Entity entityGetEntity(EntityType type)
	{
		return entity.getEntity(type);
	}

	public void entityEnableComponent(EntityId eid, ComponentTypeId id)
	{
		entity.enableComponent(eid, id);
	}

	public void entityDisableComponent(EntityId eid, ComponentTypeId id)
	{
		entity.disableComponent(eid, id);
	}

	public bool entityIsComponentDisabled(EntityId eid, ComponentTypeId id)
	{
		return entity.isComponentDisabled(eid, id);
	}

	public bool entityHasComponents(EntityId eid, ComponentTypeId[] ids)
	{
		return entity.hasComponents(eid, ids);
	}

	public bool entityHasAnyComponent(EntityId eid, ComponentTypeId[] ids)
	{
		return entity.hasAnyComponent(eid, ids);
	}

	public bool entityHasComponent(EntityId eid, ComponentTypeId id)
	{
		return entity.hasComponent(eid, id);
	}

	public string entityGetName(EntityId eid)
	{
		return entity.getName(eid);
	}

	public string entityGetDescription(EntityId eid)
	{
		return entity.getDescription(eid);
	}

	public EntityType entityGetType(EntityId eid)
	{
		return entity.getType(eid);
	}

	public void entitySetDescription(EntityId eid, const string description)
	{
		entity.setDescription(eid, description);
	}

	public EntityId[] entityGetDeleted()
	{
		return entity.getDeletedEntities;
	}

	public EntityId entityGetId(Entity e)
	{
		return entity.getEntityId(e);
	}

	public EntityId entityGetId(EntityType type)
	{
		return entity.getEntityId(type);
	}

	public bool entityTypeExists(EntityType type)
	{
		return entity.typeExists(type);
	}

	public bool entityExists(EntityId eid)
	{
		return entity.hasEntity(eid);
	}


	/********************************************* COMPONENT MANAGER FUNCTIONS *********************************************/
	public ComponentTypeId componentCreate(T)()
	{
		return component.createComponent!T;
	}

	public bool componentExists(T)()
	{
		return component.hasComponent!T;
	}

	public T componentGet(T)()
	{
		return component.getComponent!T;
	}

	public ComponentName componentGetName(ComponentTypeId id)
	{
		return component.getComponentName(id);
	}

	public ComponentName componentGetName(T)()
	{
		return component.getComponentName!T;
	}

	public ComponentTypeId componentGetTypeId(T)()
	{
		return component.getComponentTypeId!T;
	}


	/*************************************************** SYSTEM FUNCTIONS **************************************************/
	public void updateSystems()
	{
		system.update;
	}

	public void systemCreate(T)()
	{
		system.createSystem!T;
	}

	public T systemGet(T)()
	{
		return system.getSystem!T;
	}

	public bool systemExists(T)()
	{
		return system.existsSystem!T;
	}
}


@system unittest
{
	Hub _hub = new Hub();

	ComponentTypeId fooID = _hub.componentCreate!Foo;
	_hub.componentCreate!Goo;
	_hub.systemCreate!FooSys;
	Entity e = _hub.entity.createEntity("Nobody", "Alone");

	e.addComponent!Foo;
	
	assert(e.getComponent!Foo.someData == int.init);
	assert(e.hasComponent(fooID));
	assert(_hub.systemExists!FooSys);

	_hub.updateSystems;

	assert(e.getComponent!Foo.someData == 1);

	e.disableComponent(fooID);
	_hub.updateSystems;
	e.enableComponent(fooID);

	assert(e.getComponent!Foo.someData == 1);
}