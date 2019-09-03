module ecs.hub;

import ecs.entity;
import ecs.icomponent;
import ecs.entityManager;
import ecs.componentManager;
import ecs.system;
import ecs.isystem;

import ecs.exceptions.entity;


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


	public void update()
	{
		system.update;
	}
}


/*
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
}*/