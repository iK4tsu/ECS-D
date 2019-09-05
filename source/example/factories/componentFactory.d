module example.factories.componentFactory;

import ecs;

import example.components;


void generateComponents(ref Hub hub)
{
	/*
	 * Generate all your components
	 * This will be the ones used to build new components of the same type for your entities
	 */
	hub.component.create!Position;
	hub.component.create!Movable;
	hub.component.create!Hero;
	hub.component.create!Area2D;
	hub.component.create!Sprite;
	hub.component.create!Input;
	hub.component.create!Explosive;
	hub.component.create!Conection;
}