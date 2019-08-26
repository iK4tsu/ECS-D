module ecs.icomponent;


public interface IComponent {}


class HealthComponent : IComponent
{
	int hp;
	int max_hp;
}


class PositionComponent : IComponent
{
	int x;
	int y;
}

class MovableComponent : IComponent
{
	int moveX;
	int moveY;
}


unittest
{
	HealthComponent _health = new HealthComponent();

	assert(_health.hp == int.init);
}

unittest
{
	PositionComponent _position = new PositionComponent();

	_position.x = 4;

	assert(_position.x == 4);
}