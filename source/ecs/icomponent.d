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


unittest
{
	HealthComponent _health = new HealthComponent();

	assert(_health.hp == int.init);
}