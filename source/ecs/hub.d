module ecs.hub;

import ecs.entity;
import ecs.icomponent;
import ecs.componentType;
import ecs.entityManager;
import ecs.componentManager;
import ecs.system;


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
	public void entityAddComponent(T)(EntityId id)
	{
		if (componentExists!T)
			_entityManager.addComponent!(T)(id, componentGetType!T);
	}

	public void entityRemoveComponent(EntityId id, ComponentType index)
	{
		_entityManager.removeComponent(id, index);
	}

	public T entityGetComponent(T)(EntityId id)
	{
		return _entityManager.getComponent!(T)(id);
	}

	public EntityId entityCreate()
	{
		return _entityManager.createEntity;
	}

	public void entityEnableComponent(EntityId id, ComponentType index)
	{
		_entityManager.enableComponent(id, index);
	}

	public void entityDisableComponent(EntityId id, ComponentType index)
	{
		_entityManager.disableComponent(id, index);
	}


	/********************************************* COMPONENT MANAGER FUNCTIONS *********************************************/
	public void componentCreate(T)()
	{
		_componentManager.createComponent!T;
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
		_system.update();
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


unittest
{
	Hub mHub = new Hub();

	mHub.componentCreate!(PositionComponent);

	assert(mHub.componentExists!PositionComponent);
	assert(!mHub.componentExists!MovableComponent);
}

unittest
{
	Hub hub = new Hub();

	hub.componentCreate!(PositionComponent);

	EntityId e = hub.entityCreate;

	hub.entityAddComponent!PositionComponent(e);
	
	assert(cast(PositionComponent)(hub.entityGetComponent!PositionComponent(e)) !is null);
}