module ecs.hub;

import ecs.entity;
import ecs.icomponent;
import ecs.entityManager;
import ecs.componentManager;
import ecs.system;

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
		_entityManager = new EntityManager();
		_componentManager = new ComponentManager();
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

	public void setDescription(EntityId eid, const string description)
	{
		_entityManager.setDescription(eid, description);
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