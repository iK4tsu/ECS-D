module example.components.movable;


import ecs;

/*
 * Generic Movable component
 *
 * Every component must implement IComponent
 *
 *
 * This component is the decider between a motionless entity and a non motionless
 * This means that if an entity contains Movable it'll be able to change it's position
 */
@safe pure final class Movable : IComponent
{
	@safe pure
	this(uint _speed = uint.init) { speed = _speed; }

	uint speed;
}