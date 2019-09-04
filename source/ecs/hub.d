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
		component = new ComponentManager();
		system = new System(this);
		entity = new EntityManager(this, component);
	}


	public void update()
	{
		system.update;
	}
}



@system unittest
{
	Hub hub = new Hub();

	hub.component.create!Foo;
	hub.component.create!Goo;
	hub.system.create!FooSys;

	Entity e = hub.entity.create();
	e.addComponent!Foo;
	
	assert(e.getComponent!Foo.someData == int.init);
	assert(e.hasComponent!Foo);
	assert(hub.system.exists!FooSys);

	hub.update;

	assert(e.getComponent!Foo.someData == 1);

	e.disableComponent!Foo;
	hub.update;
	e.enableComponent!Foo;

	assert(e.getComponent!Foo.someData == 1);
}