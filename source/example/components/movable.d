module example.components.movable;


import ecs;

/*
 * This component exists only to tell if an entity can move or not
 * If an entity doesn't have the component it wont be able to move
 */
@safe final class Movable : IComponent
{
	this(uint _speed = uint.init) { speed = _speed; }
	uint speed;
}